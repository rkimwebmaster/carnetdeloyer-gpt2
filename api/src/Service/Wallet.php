<?php

namespace App\Service;

use App\Api\ErreurMetier;
use App\Entity\EcritureWallet;
use App\Entity\User;
use App\Enum\EspaceWallet;
use App\Enum\SensEcriture;
use Doctrine\DBAL\LockMode;
use Doctrine\ORM\EntityManagerInterface;

/**
 * R-60 à R-62, R-147, R-148 : wallet en centimes d'USD, journal d'écritures par
 * utilisateur étiquetées par espace. Le solde se calcule toujours depuis le journal.
 */
final class Wallet
{
    public function __construct(
        private readonly EntityManagerInterface $em,
        private readonly Parametres $parametres,
    ) {
    }

    public function solde(User $user, ?EspaceWallet $espace = null): int
    {
        $qb = $this->em->createQueryBuilder()
            ->select("COALESCE(SUM(CASE WHEN e.sens = 'credit' THEN e.montant ELSE -e.montant END), 0)")
            ->from(EcritureWallet::class, 'e')
            ->where('e.user = :user')->setParameter('user', $user);
        if (null !== $espace) {
            $qb->andWhere('e.espace = :espace')->setParameter('espace', $espace);
        }

        return (int) $qb->getQuery()->getSingleScalarResult();
    }

    /**
     * Crédit idempotent : une même clé unique ne crédite qu'une fois.
     */
    public function crediter(User $user, EspaceWallet $espace, int $montant, string $motif, ?string $reference = null, ?string $cleUnique = null, ?string $commentaire = null, ?User $par = null): ?EcritureWallet
    {
        if ($montant <= 0) {
            return null;
        }
        if (null !== $cleUnique && null !== $this->em->getRepository(EcritureWallet::class)->findOneBy(['cleUnique' => $cleUnique])) {
            return null;
        }
        $ecriture = new EcritureWallet($user, $espace, SensEcriture::Credit, $montant, $motif, $reference, $cleUnique, $commentaire, $par);
        $this->em->persist($ecriture);
        $this->em->flush();

        return $ecriture;
    }

    /**
     * Débit d'une dépense. Doit être appelé dans une transaction.
     *
     * R-62 : seuil de 11 USD (par défaut) sur le total du wallet, sauf exception (R-92).
     * R-148 : puise d'abord dans l'espace où la dépense a lieu, puis dans l'autre.
     *
     * @return list<EcritureWallet>
     */
    public function debiter(User $user, EspaceWallet $espaceDepense, int $montant, string $motif, ?string $reference = null, bool $appliquerSeuil = true, ?string $commentaire = null, ?User $par = null): array
    {
        if ($montant <= 0) {
            throw new \InvalidArgumentException('Montant de débit invalide.');
        }
        // Verrou sur l'utilisateur : deux débits simultanés ne peuvent pas passer sous zéro.
        $this->em->lock($user, LockMode::PESSIMISTIC_WRITE);

        $total = $this->solde($user);
        $seuil = $this->parametres->entier(Parametres::WALLET_SEUIL_CENTIMES, $user);
        if ($appliquerSeuil && $total < $seuil) {
            throw new ErreurMetier('WALLET_SEUIL_NON_ATTEINT', \sprintf('Le wallet est utilisable à partir de %s USD.', number_format($seuil / 100, 2, '.', '')), 422);
        }
        if ($total < $montant) {
            throw new ErreurMetier('WALLET_SOLDE_INSUFFISANT', 'Solde du wallet insuffisant.', 422);
        }

        $autre = EspaceWallet::Bailleur === $espaceDepense ? EspaceWallet::Locataire : EspaceWallet::Bailleur;
        $dansEspace = min($montant, max(0, $this->solde($user, $espaceDepense)));
        $ecritures = [];
        if ($dansEspace > 0) {
            $ecritures[] = new EcritureWallet($user, $espaceDepense, SensEcriture::Debit, $dansEspace, $motif, $reference, null, $commentaire, $par);
        }
        if ($montant - $dansEspace > 0) {
            $ecritures[] = new EcritureWallet($user, $autre, SensEcriture::Debit, $montant - $dansEspace, $motif, $reference, null, $commentaire, $par);
        }
        foreach ($ecritures as $e) {
            $this->em->persist($e);
        }

        return $ecritures;
    }
}
