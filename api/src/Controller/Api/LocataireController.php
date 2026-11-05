<?php

namespace App\Controller\Api;

use App\Api\Dto\NouvelleDeclaration;
use App\Api\ErreurMetier;
use App\Api\Presentateur;
use App\Entity\Contact;
use App\Entity\Contrat;
use App\Entity\DeclarationPaiement;
use App\Entity\Paiement;
use App\Enum\StatutPaiement;
use App\Securite\Acces;
use App\Securite\Chiffreur;
use App\Service\Declarations;
use App\Service\Contrats;
use App\Service\Echeancier;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpKernel\Attribute\MapRequestPayload;
use Symfony\Component\Routing\Attribute\Route;

/** Mode locataire : « Mes locations », reçus et « J'ai payé ». */
#[Route('/api/v1/locataire')]
final class LocataireController extends ApiController
{
    public function __construct(
        private readonly EntityManagerInterface $em,
        private readonly Presentateur $p,
        private readonly Acces $acces,
        private readonly Chiffreur $chiffreur,
        private readonly Echeancier $echeancier,
        private readonly Declarations $declarations,
        private readonly Contrats $serviceContrats,
    ) {
    }

    /** R-72 : contrats créés avec mon numéro, en attente de ma confirmation. */
    #[Route('/rattachements', methods: ['GET'])]
    public function aRattacher(): JsonResponse
    {
        $contacts = $this->contactsARattacher();
        $resultat = [];
        foreach ($contacts as $contact) {
            $contrats = $this->em->getRepository(Contrat::class)->findBy(['locataire' => $contact, 'locataireConfirmeLe' => null, 'locataireRefuseLe' => null], ['createdAt' => 'DESC']);
            if ([] === $contrats) {
                continue;
            }
            $resultat[] = [
                'contactId' => $contact->getId(),
                'bailleur' => $contact->getEspace()->nomAffiche(),
                'contrats' => array_map(static fn (Contrat $c) => ['id' => $c->getId(), 'unite' => $c->getUnite()->getNom(), 'propriete' => $c->getUnite()->getPropriete()->getNom(), 'statut' => $c->getStatut()->value], $contrats),
            ];
        }
        return $this->json($resultat);
    }

    #[Route('/rattachements/{contactId<\d+>}', methods: ['POST'])]
    public function rattacher(int $contactId): JsonResponse
    {
        $moi = $this->moi();
        foreach ($this->contactsARattacher() as $contact) {
            if ($contact->getId() === $contactId) {
                $contrats = $this->em->getRepository(Contrat::class)->findBy(['locataire' => $contact, 'locataireConfirmeLe' => null, 'locataireRefuseLe' => null]);
                if (1 !== \count($contrats)) {
                    throw new ErreurMetier('CONFIRMATION_PAR_CONTRAT_REQUISE', 'Choisissez le contrat à confirmer.', 409);
                }
                $this->serviceContrats->confirmerLocataire($contrats[0], $moi);

                return $this->json(['rattache' => true]);
            }
        }
        throw ErreurMetier::introuvable('Rattachement');
    }

    #[Route('/contrats/{id<\d+>}/confirmation', methods: ['POST'])]
    public function confirmer(int $id): JsonResponse
    {
        $contrat = $this->em->find(Contrat::class, $id) ?? throw ErreurMetier::introuvable('Rattachement');
        $this->serviceContrats->confirmerLocataire($contrat, $this->moi());

        return $this->json(['confirme' => true]);
    }

    #[Route('/contrats/{id<\d+>}/refus', methods: ['POST'])]
    public function refuser(int $id): JsonResponse
    {
        $contrat = $this->em->find(Contrat::class, $id) ?? throw ErreurMetier::introuvable('Rattachement');
        $this->serviceContrats->refuserLocataire($contrat, $this->moi());

        return $this->json(['refuse' => true]);
    }

    #[Route('/contrats', methods: ['GET'])]
    public function contrats(Request $request): JsonResponse
    {
        $qb = $this->em->createQueryBuilder()->select('c')->from(Contrat::class, 'c')
            ->join('c.locataire', 'l')->where('l.utilisateur = :u AND c.locataireConfirmeLe IS NOT NULL AND c.locataireRefuseLe IS NULL')->setParameter('u', $this->moi())
            ->orderBy('c.statut', 'ASC')->addOrderBy('c.createdAt', 'DESC');

        return $this->page($request, $qb, $this->p->contratResume(...));
    }

    #[Route('/contrats/{id<\d+>}', methods: ['GET'])]
    public function contrat(int $id): JsonResponse
    {
        $contrat = $this->acces->contratLocataire($this->moi(), $id);
        $this->echeancier->generer($contrat);
        // Le locataire voit ses reçus, y compris annulés (R-56 : il garde ses reçus).
        $paiements = $this->em->getRepository(Paiement::class)->findBy(['contrat' => $contrat], ['datePaiement' => 'DESC', 'id' => 'DESC']);
        $detail = $this->p->contratDetail($contrat, $paiements);
        $detail['locataire']['telephone'] = null;
        $detail['declarations'] = array_map($this->p->declaration(...), $this->em->getRepository(DeclarationPaiement::class)->findBy(['contrat' => $contrat], ['createdAt' => 'DESC']));
        $propriete = $contrat->getUnite()->getPropriete();
        // R-88 : position exacte visible par le locataire rattaché.
        $detail['adresse'] = ['adresse' => $propriete->getAdresse(), 'quartier' => $propriete->getQuartier(), 'ville' => $propriete->getVille()?->getNom(), 'latitude' => $propriete->getLatitude(), 'longitude' => $propriete->getLongitude()];
        $detail['bailleur']['telephone'] = $contrat->getEspace()->getProprietaire()->getTelephone();

        return $this->json($detail);
    }

    /** R-39 : « J'ai payé ». */
    #[Route('/contrats/{id<\d+>}/declarations', methods: ['POST'])]
    public function declarer(int $id, #[MapRequestPayload] NouvelleDeclaration $dto): JsonResponse
    {
        $moi = $this->moi();
        $contrat = $this->acces->contratLocataire($moi, $id);
        $declaration = $this->declarations->declarer($contrat, $moi, (int) $dto->montant, self::dateDepuis($dto->datePaiement), $dto->reference);

        return $this->json($this->p->declaration($declaration), 201);
    }

    /** Paiements et reçus du locataire, tous contrats confondus. */
    #[Route('/paiements', methods: ['GET'])]
    public function paiements(Request $request): JsonResponse
    {
        $qb = $this->em->createQueryBuilder()->select('pa')->from(Paiement::class, 'pa')
            ->join('pa.contrat', 'c')->join('c.locataire', 'l')
            ->where('l.utilisateur = :u AND c.locataireConfirmeLe IS NOT NULL AND c.locataireRefuseLe IS NULL')->setParameter('u', $this->moi())
            ->orderBy('pa.datePaiement', 'DESC')->addOrderBy('pa.id', 'DESC');
        if ($request->query->getBoolean('validesSeulement')) {
            $qb->andWhere('pa.statut = :s')->setParameter('s', StatutPaiement::Valide);
        }

        return $this->page($request, $qb, $this->p->paiement(...));
    }

    /** @return list<Contact> */
    private function contactsARattacher(): array
    {
        $moi = $this->moi();
        $telephone = $moi->getTelephone();
        if (null === $telephone) {
            return [];
        }

        return $this->em->getRepository(Contact::class)->findBy(['telephoneEmpreinte' => $this->chiffreur->empreinte($telephone)]);
    }
}
