<?php

namespace App\Controller\Api;

use App\Api\Dto\Motif;
use App\Api\Dto\NouveauPaiement;
use App\Api\Dto\Reimputation;
use App\Api\Presentateur;
use App\Entity\DeclarationPaiement;
use App\Entity\Paiement;
use App\Enum\MoyenPaiement;
use App\Enum\StatutDeclaration;
use App\Enum\TypePaiement;
use App\Securite\Acces;
use App\Service\Declarations;
use App\Service\Echeancier;
use App\Service\Espaces;
use App\Service\Imputations;
use App\Service\Paiements;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpKernel\Attribute\MapRequestPayload;
use Symfony\Component\Routing\Attribute\Route;

/** Onglet Paiements (mode bailleur). */
#[Route('/api/v1')]
final class PaiementController extends ApiController
{
    public function __construct(
        private readonly EntityManagerInterface $em,
        private readonly Presentateur $p,
        private readonly Acces $acces,
        private readonly Paiements $paiements,
        private readonly Imputations $imputations,
        private readonly Declarations $declarations,
        private readonly Espaces $espaces,
        private readonly Echeancier $echeancier,
    ) {
    }

    /**
     * R-137 : 201 à la création, 200 si la clé d'idempotence a déjà été reçue.
     */
    #[Route('/contrats/{id<\d+>}/paiements', methods: ['POST'])]
    public function encaisser(int $id, #[MapRequestPayload] NouveauPaiement $dto): JsonResponse
    {
        $moi = $this->moi();
        $contrat = $this->acces->contrat($moi, $id);
        [$paiement, $cree] = $this->paiements->encaisser(
            $contrat, $moi, (int) $dto->montant, self::dateDepuis($dto->datePaiement),
            MoyenPaiement::from($dto->moyen), strtolower($dto->cleIdempotence), $dto->reference, TypePaiement::from($dto->type),
        );

        return $this->json($this->p->paiement($paiement), $cree ? 201 : 200);
    }

    #[Route('/paiements', methods: ['GET'])]
    public function liste(Request $request): JsonResponse
    {
        $espace = $this->espaces->de($this->moi());
        $qb = $this->em->createQueryBuilder()->select('pa')->from(Paiement::class, 'pa')
            ->join('pa.contrat', 'c')->join('c.unite', 'u')->join('u.propriete', 'p')
            ->where('p.espace = :e')->setParameter('e', $espace)
            ->orderBy('pa.datePaiement', 'DESC')->addOrderBy('pa.id', 'DESC');
        if ($contratId = $request->query->getInt('contratId')) {
            $qb->andWhere('c.id = :c')->setParameter('c', $contratId);
        }

        return $this->page($request, $qb, $this->p->paiement(...));
    }

    #[Route('/paiements/{id<\d+>}', methods: ['GET'])]
    public function voir(int $id): JsonResponse
    {
        return $this->json($this->p->paiement($this->acces->paiement($this->moi(), $id)));
    }

    #[Route('/paiements/{id<\d+>}/annulation', methods: ['POST'])]
    public function annuler(int $id, #[MapRequestPayload] Motif $dto): JsonResponse
    {
        $moi = $this->moi();
        $paiement = $this->acces->paiement($moi, $id);
        $this->paiements->annuler($paiement, $moi, $dto->motif);

        return $this->json($this->p->paiement($paiement));
    }

    /** R-27 : correction manuelle de l'imputation. */
    #[Route('/paiements/{id<\d+>}/imputations', methods: ['PUT'])]
    public function reimputer(int $id, #[MapRequestPayload] Reimputation $dto): JsonResponse
    {
        $paiement = $this->acces->paiement($this->moi(), $id);
        $repartition = [];
        foreach ($dto->imputations as $ligne) {
            $repartition[$ligne['echeanceId']] = ($repartition[$ligne['echeanceId']] ?? 0) + $ligne['montant'];
        }
        $this->em->wrapInTransaction(function () use ($paiement, $repartition): void {
            $this->echeancier->verrouiller($paiement->getContrat());
            $this->imputations->imputerManuellement($paiement, $repartition);
        });

        return $this->json($this->p->paiement($paiement));
    }

    /** R-40 : déclarations des locataires ; ?statut=en_attente par défaut. */
    #[Route('/declarations', methods: ['GET'])]
    public function declarations(Request $request): JsonResponse
    {
        $espace = $this->espaces->de($this->moi());
        $statut = StatutDeclaration::tryFrom((string) $request->query->get('statut', 'en_attente')) ?? StatutDeclaration::EnAttente;
        $qb = $this->em->createQueryBuilder()->select('d')->from(DeclarationPaiement::class, 'd')
            ->join('d.contrat', 'c')->join('c.unite', 'u')->join('u.propriete', 'p')
            ->where('p.espace = :e AND d.statut = :s')->setParameter('e', $espace)->setParameter('s', $statut)
            ->orderBy('d.createdAt', 'DESC');

        return $this->page($request, $qb, $this->p->declaration(...));
    }

    #[Route('/declarations/{id<\d+>}/validation', methods: ['POST'])]
    public function valider(int $id): JsonResponse
    {
        $moi = $this->moi();
        $declaration = $this->acces->declaration($moi, $id);
        $this->declarations->valider($declaration, $moi);

        return $this->json($this->p->declaration($declaration));
    }

    #[Route('/declarations/{id<\d+>}/refus', methods: ['POST'])]
    public function refuser(int $id, #[MapRequestPayload] Motif $dto): JsonResponse
    {
        $moi = $this->moi();
        $declaration = $this->acces->declaration($moi, $id);
        $this->declarations->refuser($declaration, $moi, $dto->motif);

        return $this->json($this->p->declaration($declaration));
    }
}
