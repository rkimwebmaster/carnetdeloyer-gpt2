<?php

namespace App\Controller\Api;

use App\Api\Dto\PaiementAbonnementDemande;
use App\Api\ErreurMetier;
use App\Api\Presentateur;
use App\Entity\PaiementAbonnement;
use App\Entity\Unite;
use App\Enum\StatutContrat;
use App\Securite\Acces;
use App\Service\Abonnements;
use App\Service\Espaces;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpKernel\Attribute\MapRequestPayload;
use Symfony\Component\Routing\Attribute\Route;

/** Section 6 : abonnements par unité. */
#[Route('/api/v1')]
final class AbonnementController extends ApiController
{
    public function __construct(
        private readonly EntityManagerInterface $em,
        private readonly Presentateur $p,
        private readonly Acces $acces,
        private readonly Abonnements $abonnements,
        private readonly Espaces $espaces,
    ) {
    }

    /** Unités louées avec l'état de leur abonnement. */
    #[Route('/abonnements', methods: ['GET'])]
    public function liste(): JsonResponse
    {
        $espace = $this->espaces->de($this->moi());
        $unites = $this->em->createQueryBuilder()->select('u')->from(Unite::class, 'u')
            ->join('u.propriete', 'p')->where('p.espace = :e')->setParameter('e', $espace)
            ->andWhere('EXISTS (SELECT c.id FROM App\Entity\Contrat c WHERE c.unite = u AND c.statut = :actif)')
            ->setParameter('actif', StatutContrat::Actif)
            ->orderBy('u.abonnementFin', 'ASC')->getQuery()->getResult();

        return $this->json(array_map(fn (Unite $u) => $this->p->unite($u), $unites));
    }

    /** R-68 : montant exact avant de payer. */
    #[Route('/unites/{id<\d+>}/abonnement', methods: ['GET'])]
    public function voir(int $id): JsonResponse
    {
        $unite = $this->acces->unite($this->moi(), $id);
        $devis = null;
        $raison = null;
        try {
            $d = $this->abonnements->devis($unite);
            $devis = [
                'pourcentage' => $d['pourcentage'], 'montantDevise' => $d['montantDevise'], 'devise' => $d['deviseCode'],
                'tauxUsd' => $d['tauxUsd'], 'montantUsd' => $d['montantUsd'],
                'periodeDebut' => Presentateur::date($d['periodeDebut']), 'periodeFin' => Presentateur::date($d['periodeFin']),
            ];
        } catch (ErreurMetier $e) {
            $raison = $e->codeMetier;
        }
        $historique = $this->em->getRepository(PaiementAbonnement::class)->findBy(['unite' => $unite], ['createdAt' => 'DESC']);

        return $this->json([
            'uniteId' => $unite->getId(),
            'etat' => $this->abonnements->etat($unite)->value,
            'fin' => Presentateur::date($this->abonnements->finPeriode($unite)),
            'gratuiteJusquAu' => Presentateur::date($unite->getGratuiteJusquAu()),
            'devis' => $devis,
            'devisIndisponible' => $raison,
            'paiements' => array_map($this->p->paiementAbonnement(...), $historique),
        ]);
    }

    #[Route('/unites/{id<\d+>}/abonnement/paiements', methods: ['POST'])]
    public function payer(int $id, #[MapRequestPayload] PaiementAbonnementDemande $dto): JsonResponse
    {
        $moi = $this->moi();
        $unite = $this->acces->unite($moi, $id);
        if ('wallet' === $dto->source) {
            $pa = $this->abonnements->payerParWallet($unite, $moi);
        } else {
            if (null === $dto->referenceTransaction || '' === trim($dto->referenceTransaction)) {
                throw ErreurMetier::champ('referenceTransaction', 'REFERENCE_REQUISE', 'Saisissez la référence de la transaction mobile money.');
            }
            $pa = $this->abonnements->declarerPaiementManuel($unite, $moi, trim($dto->referenceTransaction));
        }

        return $this->json($this->p->paiementAbonnement($pa), 201);
    }
}
