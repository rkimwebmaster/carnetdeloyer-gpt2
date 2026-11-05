<?php

namespace App\Service;

use App\Api\ErreurMetier;
use App\Entity\Contrat;
use App\Entity\Echeance;
use App\Entity\Imputation;
use App\Entity\Paiement;
use App\Enum\StatutPaiement;
use App\Enum\TypePaiement;
use Doctrine\ORM\EntityManagerInterface;

/**
 * R-27 : un paiement solde d'abord l'échéance impayée la plus ancienne, puis les
 * suivantes. Le bailleur peut corriger l'imputation à la main.
 * Les imputations ne sont jamais effacées : elles sont désactivées.
 */
final class Imputations
{
    public function __construct(
        private readonly EntityManagerInterface $em,
        private readonly Echeancier $echeancier,
    ) {
    }

    /**
     * @return int montant non imputé (trop-perçu)
     */
    public function imputerAutomatiquement(Paiement $paiement): int
    {
        return $this->repartir($paiement, $this->echeancier->echeances($paiement->getContrat()));
    }

    /**
     * R-27 : correction manuelle. $repartition = [idEcheance => montant].
     *
     * @param array<int, int> $repartition
     */
    public function imputerManuellement(Paiement $paiement, array $repartition): void
    {
        if (!$paiement->isValide() || TypePaiement::Loyer !== $paiement->getType()) {
            throw new ErreurMetier('IMPUTATION_IMPOSSIBLE', 'Seul un paiement de loyer valide peut être réimputé.', 422);
        }
        if (array_sum($repartition) !== $paiement->getMontant()) {
            throw ErreurMetier::champ('imputations', 'IMPUTATION_TOTAL_INCORRECT', 'La répartition doit égaler le montant du paiement.');
        }
        $echeances = [];
        foreach ($this->echeancier->echeances($paiement->getContrat()) as $e) {
            $echeances[$e->getId()] = $e;
        }

        $this->desactiver($this->actives(paiement: $paiement));
        $this->recalculerMontantsPayes($paiement->getContrat());

        foreach ($repartition as $idEcheance => $montant) {
            $echeance = $echeances[$idEcheance] ?? throw ErreurMetier::champ('imputations', 'ECHEANCE_INCONNUE', 'Échéance inconnue pour ce contrat.');
            if ($montant <= 0) {
                continue;
            }
            if ($montant > $echeance->getRestantDu()) {
                throw ErreurMetier::champ('imputations', 'IMPUTATION_SUPERIEURE_AU_DU', 'Le montant dépasse le restant dû de l\'échéance.');
            }
            $this->ajouter($paiement, $echeance, $montant);
        }
        $paiement->marquerImputationManuelle();
        $this->em->flush();
    }

    /**
     * R-34 : recalcul après annulation ou clôture. Les imputations manuelles des
     * paiements valides sont conservées ; les autres paiements sont réimputés dans
     * l'ordre chronologique.
     *
     * @return int total non imputé (trop-perçu)
     */
    public function recalculer(Contrat $contrat): int
    {
        $aDesactiver = [];
        foreach ($this->actives(contrat: $contrat) as $imp) {
            $p = $imp->getPaiement();
            if (!$p->isValide() || !$p->isImputationManuelle() || $imp->getEcheance()->isAnnulee()) {
                $aDesactiver[] = $imp;
            }
        }
        $this->desactiver($aDesactiver);
        $this->recalculerMontantsPayes($contrat);

        $paiements = $this->em->getRepository(Paiement::class)->findBy(
            ['contrat' => $contrat, 'statut' => StatutPaiement::Valide, 'type' => TypePaiement::Loyer],
            ['datePaiement' => 'ASC', 'id' => 'ASC'],
        );
        $echeances = $this->echeancier->echeances($contrat);
        $tropPercu = 0;
        foreach ($paiements as $p) {
            // L'état en mémoire fait foi (un paiement peut être annulé mais pas encore écrit).
            if (!$p->isValide()) {
                continue;
            }
            if ($p->isImputationManuelle()) {
                $dejaImpute = array_sum(array_map(static fn (Imputation $i) => $i->getMontant(), $this->actives(paiement: $p)));
                $tropPercu += max(0, $p->getMontant() - $dejaImpute);
                continue;
            }
            $tropPercu += $this->repartir($p, $echeances);
        }
        $this->em->flush();

        return $tropPercu;
    }

    /**
     * @param list<Echeance> $echeances
     */
    private function repartir(Paiement $paiement, array $echeances, ?int $montant = null): int
    {
        $reste = $montant ?? $paiement->getMontant();
        foreach ($echeances as $echeance) {
            if ($reste <= 0) {
                break;
            }
            $part = min($reste, $echeance->getRestantDu());
            if ($part > 0) {
                $this->ajouter($paiement, $echeance, $part);
                $reste -= $part;
            }
        }

        return $reste;
    }

    private function ajouter(Paiement $paiement, Echeance $echeance, int $montant): void
    {
        $this->em->persist(new Imputation($paiement, $echeance, $montant));
        $echeance->setMontantPaye($echeance->getMontantPaye() + $montant);
    }

    /**
     * @param list<Imputation> $imputations
     */
    private function desactiver(array $imputations): void
    {
        foreach ($imputations as $imp) {
            $imp->desactiver();
        }
    }

    private function recalculerMontantsPayes(Contrat $contrat): void
    {
        $totaux = [];
        foreach ($this->actives(contrat: $contrat) as $imp) {
            if (!$imp->isActive()) {
                continue;
            }
            $id = spl_object_id($imp->getEcheance());
            $totaux[$id] = ($totaux[$id] ?? 0) + $imp->getMontant();
        }
        foreach ($this->echeancier->echeances($contrat) as $e) {
            $e->setMontantPaye($totaux[spl_object_id($e)] ?? 0);
        }
    }

    /**
     * Imputations actives (y compris celles pas encore écrites en base).
     *
     * @return list<Imputation>
     */
    public function actives(?Contrat $contrat = null, ?Paiement $paiement = null): array
    {
        $qb = $this->em->createQueryBuilder()->select('i')->from(Imputation::class, 'i')
            ->join('i.paiement', 'p')->where('i.active = true');
        if (null !== $contrat) {
            $qb->andWhere('p.contrat = :c')->setParameter('c', $contrat);
        }
        if (null !== $paiement) {
            $qb->andWhere('i.paiement = :p')->setParameter('p', $paiement);
        }
        $enBase = $qb->getQuery()->getResult();

        // Inclure les imputations persistées mais non encore écrites.
        foreach ($this->em->getUnitOfWork()->getScheduledEntityInsertions() as $entite) {
            if ($entite instanceof Imputation
                && (null === $contrat || $entite->getPaiement()->getContrat() === $contrat)
                && (null === $paiement || $entite->getPaiement() === $paiement)) {
                $enBase[] = $entite;
            }
        }

        return array_values(array_filter($enBase, static fn (Imputation $i) => $i->isActive()));
    }
}
