<?php

namespace App\Service;

use App\Entity\EspaceBailleur;
use App\Entity\Paiement;
use App\Entity\Recu;
use Doctrine\DBAL\LockMode;
use Doctrine\ORM\EntityManagerInterface;
use Psr\Clock\ClockInterface;

/**
 * R-33 : numérotation séquentielle par espace bailleur, sans trou
 * (ex. CDL-2026-000123). Le compteur est verrouillé dans la transaction du
 * paiement : un échec annule aussi l'incrément.
 */
final class Recus
{
    public function __construct(
        private readonly EntityManagerInterface $em,
        private readonly ClockInterface $clock,
        private readonly string $urlPublique,
    ) {
    }

    public function emettre(Paiement $paiement): Recu
    {
        if (!$this->em->getConnection()->isTransactionActive()) {
            throw new \LogicException('Un reçu doit être émis dans une transaction.');
        }
        $espace = $paiement->getContrat()->getEspace();
        $this->em->refresh($espace, LockMode::PESSIMISTIC_WRITE);

        $sequence = $espace->prochainNumeroRecu();
        $numero = \sprintf('CDL-%s-%06d', $this->clock->now()->format('Y'), $sequence);
        $recu = new Recu($paiement, $espace, $sequence, $numero, bin2hex(random_bytes(24)));
        $this->em->persist($recu);

        return $recu;
    }

    public function pour(Paiement $paiement): ?Recu
    {
        return $this->em->getRepository(Recu::class)->findOneBy(['paiement' => $paiement]);
    }

    /** R-75 : lien public non devinable. */
    public function lienPublic(Recu $recu): string
    {
        return rtrim($this->urlPublique, '/').'/r/'.$recu->getJeton();
    }

    public function messagePartage(Recu $recu, string $lien): string
    {
        $contrat = $recu->getPaiement()->getContrat();
        $devise = $contrat->getDevise();
        $montant = number_format($recu->getPaiement()->getMontant() / 10 ** $devise->getDecimales(), $devise->getDecimales(), ',', ' ');

        return \sprintf(
            "Bonjour %s,\nVotre reçu %s de %s %s (%s) est disponible : %s\n%s\nConfidentialité : %s",
            $contrat->getLocataire()->getNom(), $recu->getNumero(), $montant, $devise->getSymbole(),
            $contrat->getUnite()->getNom(), $lien, $recu->getEspace()->nomAffiche(),
            rtrim($this->urlPublique, '/').'/confidentialite',
        );
    }

    public function espaceDe(Recu $recu): EspaceBailleur
    {
        return $recu->getEspace();
    }
}
