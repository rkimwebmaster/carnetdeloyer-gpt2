<?php

namespace App\Service;

use App\Entity\Contrat;
use App\Entity\Echeance;
use Doctrine\DBAL\LockMode;
use Doctrine\ORM\EntityManagerInterface;
use Psr\Clock\ClockInterface;

/**
 * R-21 : échéances mensuelles générées automatiquement sur 12 mois glissants,
 * jamais au-delà de la date de fin du contrat.
 */
final class Echeancier
{
    public const HORIZON_MOIS = 12;

    public function __construct(
        private readonly EntityManagerInterface $em,
        private readonly ClockInterface $clock,
    ) {
    }

    /**
     * @return int nombre d'échéances créées
     */
    public function generer(Contrat $contrat): int
    {
        if (!$contrat->isActif()) {
            return 0;
        }
        $aujourdhui = Calendrier::jour($this->clock->now());
        $horizon = Calendrier::ajouterMois($aujourdhui, self::HORIZON_MOIS);
        $existantes = $this->echeances($contrat);
        $i = \count($existantes);
        $crees = 0;

        while (true) {
            $debut = Calendrier::ajouterMois($contrat->getDateDebut(), $i);
            if ($debut > $horizon || (null !== $contrat->getDateFin() && $debut > $contrat->getDateFin())) {
                break;
            }
            $fin = Calendrier::ajouterMois($contrat->getDateDebut(), $i + 1)->modify('-1 day');
            $this->em->persist(new Echeance($contrat, $debut, $fin, $contrat->getLoyer()));
            ++$i;
            ++$crees;
        }
        if ($crees > 0) {
            $this->em->flush();
        }

        return $crees;
    }

    /**
     * Verrouille le contrat pour la transaction en cours et recharge ses échéances.
     * Toute écriture sur les échéances d'un contrat (paiement, annulation, clôture,
     * réimputation) passe par ce verrou : deux saisies simultanées ne peuvent pas
     * écraser le montant payé l'une de l'autre. Ordre des verrous : contrat, puis espace (reçu).
     */
    public function verrouiller(Contrat $contrat): void
    {
        if (!$this->em->getConnection()->isTransactionActive()) {
            throw new \LogicException('Le verrou d\'un contrat exige une transaction.');
        }
        $this->em->lock($contrat, LockMode::PESSIMISTIC_WRITE);
        foreach ($this->echeances($contrat) as $echeance) {
            $this->em->refresh($echeance);
        }
    }

    /**
     * @return list<Echeance> triées de la plus ancienne à la plus récente
     */
    public function echeances(Contrat $contrat): array
    {
        if (null === $contrat->getId()) {
            return [];
        }

        return $this->em->getRepository(Echeance::class)->findBy(['contrat' => $contrat], ['periodeDebut' => 'ASC']);
    }

    /** Somme restant due sur les échéances générées (non annulées). */
    public function restantDu(Contrat $contrat): int
    {
        return array_sum(array_map(static fn (Echeance $e) => $e->getRestantDu(), $this->echeances($contrat)));
    }

    /** Montant en retard (échéances exigibles non soldées). */
    public function enRetard(Contrat $contrat): int
    {
        $aujourdhui = Calendrier::jour($this->clock->now());
        $total = 0;
        foreach ($this->echeances($contrat) as $e) {
            if ($e->getDateExigible() < $aujourdhui) {
                $total += $e->getRestantDu();
            }
        }

        return $total;
    }

    /** R-24 : prochaine échéance due (la plus ancienne non soldée). */
    public function prochaineDue(Contrat $contrat): ?Echeance
    {
        foreach ($this->echeances($contrat) as $e) {
            if ($e->getRestantDu() > 0) {
                return $e;
            }
        }

        return null;
    }
}
