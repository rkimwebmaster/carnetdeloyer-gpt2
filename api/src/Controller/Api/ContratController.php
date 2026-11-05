<?php

namespace App\Controller\Api;

use App\Api\Dto\Cloture;
use App\Api\Dto\ModificationContact;
use App\Api\Dto\NouveauContrat;
use App\Api\ErreurMetier;
use App\Api\Presentateur;
use App\Entity\Contact;
use App\Entity\Contrat;
use App\Entity\Devise;
use App\Entity\Paiement;
use App\Enum\StatutContrat;
use App\Enum\StatutGarantie;
use App\Securite\Acces;
use App\Securite\Chiffreur;
use App\Securite\Telephone;
use App\Service\Contrats;
use App\Service\Echeancier;
use App\Service\Espaces;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpKernel\Attribute\MapRequestPayload;
use Symfony\Component\Routing\Attribute\Route;

#[Route('/api/v1')]
final class ContratController extends ApiController
{
    public function __construct(
        private readonly EntityManagerInterface $em,
        private readonly Presentateur $p,
        private readonly Acces $acces,
        private readonly Contrats $contrats,
        private readonly Echeancier $echeancier,
        private readonly Espaces $espaces,
        private readonly Chiffreur $chiffreur,
    ) {
    }

    /** ?statut=actif|cloture, ?enRetard=1 */
    #[Route('/contrats', methods: ['GET'])]
    public function liste(Request $request): JsonResponse
    {
        $espace = $this->espaces->de($this->moi());
        $qb = $this->em->createQueryBuilder()->select('c')->from(Contrat::class, 'c')
            ->join('c.unite', 'u')->join('u.propriete', 'p')
            ->where('p.espace = :e')->setParameter('e', $espace)
            ->orderBy('c.createdAt', 'DESC');
        $statut = StatutContrat::tryFrom((string) $request->query->get('statut', ''));
        if (null !== $statut) {
            $qb->andWhere('c.statut = :s')->setParameter('s', $statut);
        }
        if ($request->query->getBoolean('enRetard')) {
            $qb->andWhere('EXISTS (SELECT e.id FROM App\Entity\Echeance e WHERE e.contrat = c AND e.annulee = false AND e.montantPaye < e.montantDu AND e.dateExigible < CURRENT_DATE())');
        }

        return $this->page($request, $qb, $this->p->contratResume(...));
    }

    /** Pré-remplissage du formulaire de contrat (R-16, R-17). */
    #[Route('/unites/{id<\d+>}/contrat/proposition', methods: ['GET'])]
    public function proposition(int $id): JsonResponse
    {
        $moi = $this->moi();
        $unite = $this->acces->unite($moi, $id);
        $devise = $this->contrats->deviseProposee($unite, $moi);

        return $this->json([
            'devise' => null === $devise ? null : $this->p->devise($devise),
            'loyer' => $unite->getDeviseIndicative() === $devise ? $unite->getLoyerIndicatif() : null,
        ]);
    }

    #[Route('/contrats', methods: ['POST'])]
    public function creer(#[MapRequestPayload] NouveauContrat $dto): JsonResponse
    {
        $moi = $this->moi();
        $unite = $this->acces->unite($moi, (int) $dto->uniteId);
        $locataire = $this->locataire($dto, $unite->getEspace());
        $devise = null;
        if (null !== $dto->devise) {
            $devise = $this->em->getRepository(Devise::class)->findOneBy(['code' => strtoupper($dto->devise)])
                ?? throw ErreurMetier::champ('devise', 'DEVISE_INCONNUE', 'Devise inconnue.');
        }
        $contrat = $this->contrats->creer(
            $moi, $unite, $locataire, $devise, (int) $dto->loyer,
            self::dateDepuis($dto->dateDebut), null === $dto->dateFin ? null : self::dateDepuis($dto->dateFin), $dto->garantie,
        );

        return $this->json($this->detail($contrat), 201);
    }

    #[Route('/contrats/{id<\d+>}', methods: ['GET'])]
    public function voir(int $id): JsonResponse
    {
        $contrat = $this->acces->contrat($this->moi(), $id);
        $this->echeancier->generer($contrat);

        return $this->json($this->detail($contrat));
    }

    /**
     * R-24, R-25 : « Encaisser » propose la prochaine échéance due et son montant ;
     * le loyer mensuel permet l'aperçu « loyer × nombre de mois » (R-135).
     */
    #[Route('/contrats/{id<\d+>}/encaissement', methods: ['GET'])]
    public function encaissement(int $id): JsonResponse
    {
        $contrat = $this->acces->contrat($this->moi(), $id);
        $this->echeancier->generer($contrat);
        $prochaine = $this->echeancier->prochaineDue($contrat);
        $echeancesDues = array_values(array_filter($this->echeancier->echeances($contrat), static fn ($e) => $e->getRestantDu() > 0));

        return $this->json([
            'contratId' => $contrat->getId(),
            'devise' => $this->p->devise($contrat->getDevise()),
            'loyer' => $contrat->getLoyer(),
            'prochaineEcheance' => null === $prochaine ? null : $this->p->echeance($prochaine),
            'montantPropose' => $prochaine?->getRestantDu() ?? 0,
            'restantDu' => $this->echeancier->restantDu($contrat),
            'moisMaximum' => \count($echeancesDues),
            'garantieAttendue' => StatutGarantie::Attendue === $contrat->getGarantieStatut() ? $contrat->getGarantieMontant() : null,
        ]);
    }

    #[Route('/contrats/{id<\d+>}/cloture', methods: ['POST'])]
    public function cloturer(int $id, #[MapRequestPayload] Cloture $dto): JsonResponse
    {
        $moi = $this->moi();
        $contrat = $this->acces->contrat($moi, $id);
        $resultat = $this->contrats->cloturer(
            $contrat, $moi, self::dateDepuis($dto->dateSortie), $dto->montantDerniereEcheance,
            null === $dto->garantie ? null : StatutGarantie::from($dto->garantie), $dto->montantRetenu, $dto->motif,
        );

        return $this->json(['contrat' => $this->detail($contrat)] + $resultat);
    }

    #[Route('/contacts', methods: ['GET'])]
    public function contacts(Request $request): JsonResponse
    {
        $espace = $this->espaces->de($this->moi());
        $qb = $this->em->createQueryBuilder()->select('c')->from(Contact::class, 'c')
            ->where('c.espace = :e')->setParameter('e', $espace)->orderBy('c.nom', 'ASC');

        return $this->page($request, $qb, $this->p->contact(...));
    }

    /** R-72 : changer le numéro retire l'accès à l'ancien titulaire. */
    #[Route('/contacts/{id<\d+>}', methods: ['PATCH'])]
    public function modifierContact(int $id, #[MapRequestPayload] ModificationContact $dto): JsonResponse
    {
        $contact = $this->acces->contact($this->moi(), $id);
        if (null !== $dto->nom) {
            $contact->setNom(trim($dto->nom));
        }
        if (null !== $dto->telephone) {
            [$tel, $empreinte] = $this->telephone($dto->telephone, 'telephone');
            $contact->changerTelephone($tel, $empreinte);
        }
        $this->em->flush();

        return $this->json($this->p->contact($contact));
    }

    private function locataire(NouveauContrat $dto, \App\Entity\EspaceBailleur $espace): Contact
    {
        if (null !== $dto->contactId) {
            return $this->acces->contact($this->moi(), $dto->contactId);
        }
        if (null === $dto->locataireNom || '' === trim($dto->locataireNom)) {
            throw ErreurMetier::champ('locataireNom', 'LOCATAIRE_REQUIS', 'Indiquez le nom du locataire.');
        }
        $contact = new Contact($espace, trim($dto->locataireNom));
        if (null !== $dto->locataireTelephone && '' !== trim($dto->locataireTelephone)) {
            [$tel, $empreinte] = $this->telephone($dto->locataireTelephone, 'locataireTelephone');
            $contact->changerTelephone($tel, $empreinte);
        }
        $this->em->persist($contact);

        return $contact;
    }

    /** @return array{?string, ?string} */
    private function telephone(string $saisie, string $champ): array
    {
        if ('' === trim($saisie)) {
            return [null, null];
        }
        $tel = Telephone::normaliser($saisie) ?? throw ErreurMetier::champ($champ, 'TELEPHONE_INVALIDE', 'Numéro de téléphone invalide (format international).');

        return [$tel, $this->chiffreur->empreinte($tel)];
    }

    private function detail(Contrat $contrat): array
    {
        $paiements = $this->em->getRepository(Paiement::class)->findBy(['contrat' => $contrat], ['datePaiement' => 'DESC', 'id' => 'DESC']);

        return $this->p->contratDetail($contrat, $paiements);
    }
}
