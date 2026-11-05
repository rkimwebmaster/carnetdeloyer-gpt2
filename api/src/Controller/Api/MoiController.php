<?php

namespace App\Controller\Api;

use App\Api\Dto\ModificationProfil;
use App\Api\Dto\ProfilEntreprise;
use App\Api\ErreurMetier;
use App\Api\Presentateur;
use App\Entity\PaysApi;
use App\Entity\VilleApi;
use App\Enum\ModeUtilisateur;
use App\Service\Espaces;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpKernel\Attribute\MapRequestPayload;
use Symfony\Component\Routing\Attribute\Route;

#[Route('/api/v1/moi')]
final class MoiController extends ApiController
{
    public function __construct(
        private readonly EntityManagerInterface $em,
        private readonly Presentateur $p,
        private readonly Espaces $espaces,
    ) {
    }

    #[Route('', methods: ['GET'])]
    public function profil(): JsonResponse
    {
        $moi = $this->moi();

        return $this->json($this->p->utilisateur($moi, $this->espaces->de($moi)));
    }

    /** R-161 : choix du mode par défaut ; R-17 : pays modifiable. */
    #[Route('', methods: ['PATCH'])]
    public function modifier(#[MapRequestPayload] ModificationProfil $dto): JsonResponse
    {
        $moi = $this->moi();
        if (null !== $dto->nom) {
            $moi->setNom(trim($dto->nom));
        }
        if (null !== $dto->email) {
            $moi->setEmail('' === $dto->email ? null : $dto->email);
        }
        if (null !== $dto->modePrefere) {
            $moi->setModePrefere(ModeUtilisateur::from($dto->modePrefere));
        }
        if (null !== $dto->paysId) {
            $pays = $this->em->find(PaysApi::class, $dto->paysId);
            if (null === $pays || !$pays->isActive()) {
                throw ErreurMetier::champ('paysId', 'PAYS_INCONNU', 'Pays inconnu.');
            }
            $moi->setPays($pays);
            if (null !== $moi->getVille() && $moi->getVille()->getPays() !== $pays) {
                $moi->setVille(null);
            }
        }
        if (null !== $dto->villeId) {
            $ville = $this->em->find(VilleApi::class, $dto->villeId);
            if (null === $ville || !$ville->isActive() || $ville->getPays()->getId() !== $moi->getPays()?->getId()) {
                throw ErreurMetier::champ('villeId', 'VILLE_INCONNUE', 'Ville inconnue pour ce pays.');
            }
            $moi->setVille($ville);
        }
        $this->em->flush();

        return $this->json($this->p->utilisateur($moi, $this->espaces->de($moi)));
    }

    /** R-123 : export des données de l'utilisateur (contrats, paiements, reçus). */
    #[Route('/export', methods: ['GET'])]
    public function export(): JsonResponse
    {
        $moi = $this->moi();
        $espace = $this->espaces->de($moi);
        $contratsBailleur = null === $espace ? [] : $this->em->createQueryBuilder()->select('c')->from(\App\Entity\Contrat::class, 'c')
            ->join('c.unite', 'u')->join('u.propriete', 'p')->where('p.espace = :e')->setParameter('e', $espace)->getQuery()->getResult();
        $contratsLocataire = $this->em->createQueryBuilder()->select('c')->from(\App\Entity\Contrat::class, 'c')
            ->join('c.locataire', 'l')->where('l.utilisateur = :u')->setParameter('u', $moi)->getQuery()->getResult();
        $detail = fn (\App\Entity\Contrat $c) => $this->p->contratDetail($c, $this->em->getRepository(\App\Entity\Paiement::class)->findBy(['contrat' => $c], ['datePaiement' => 'ASC']));

        $reponse = $this->json([
            'exporteLe' => Presentateur::dateHeure(new \DateTimeImmutable()),
            'profil' => $this->p->utilisateur($moi, $espace),
            'contratsBailleur' => array_map($detail, $contratsBailleur),
            'contratsLocataire' => array_map($detail, $contratsLocataire),
        ]);
        $reponse->headers->set('Content-Disposition', 'attachment; filename="carnetdeloyer-export.json"');

        return $reponse;
    }

    /**
     * R-122 : suppression du compte. Données personnelles anonymisées ; contrats,
     * paiements et reçus conservés (R-06).
     */
    #[Route('', methods: ['DELETE'])]
    public function supprimer(): JsonResponse
    {
        $moi = $this->moi();
        foreach ($this->em->getRepository(\App\Entity\Contact::class)->findBy(['utilisateur' => $moi]) as $contact) {
            $contact->changerTelephone(null, null);
        }
        $moi->anonymiser();
        $this->em->createQuery('DELETE FROM App\Entity\RefreshToken r WHERE r.username = :u')->setParameter('u', (string) $moi->getId())->execute();
        $this->em->flush();

        return $this->json(['supprime' => true]);
    }

    /** R-164 : profil entreprise facultatif. */
    #[Route('/espace', methods: ['PATCH'])]
    public function modifierEspace(#[MapRequestPayload] ProfilEntreprise $dto): JsonResponse
    {
        $espace = $this->espaces->obtenir($this->moi());
        $espace->setRaisonSociale($dto->raisonSociale ?: null)
            ->setNumeroRccm($dto->numeroRccm ?: null)
            ->setAdresse($dto->adresse ?: null);
        $this->em->flush();

        return $this->json($this->p->espace($espace));
    }
}
