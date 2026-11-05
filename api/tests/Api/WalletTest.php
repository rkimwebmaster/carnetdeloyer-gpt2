<?php

namespace App\Tests\Api;

use App\Entity\User;
use App\Enum\EspaceWallet;
use App\Service\Wallet;
use App\Tests\ApiTestCase;

final class WalletTest extends ApiTestCase
{
    /** R-148 : une dépense puise d'abord dans l'espace où elle a lieu, puis dans l'autre. */
    public function testDebitParEspace(): void
    {
        $u = $this->utilisateur();
        $wallet = static::getContainer()->get(Wallet::class);
        $user = $this->em()->find(User::class, $u->getId());
        $wallet->crediter($user, EspaceWallet::Bailleur, 500, 'ajustement');
        $wallet->crediter($user, EspaceWallet::Locataire, 1000, 'parrainage_location');

        $this->em()->wrapInTransaction(fn () => $wallet->debiter($user, EspaceWallet::Bailleur, 1200, 'paiement_abonnement'));

        self::assertSame(300, $wallet->solde($user));
        self::assertSame(0, $wallet->solde($user, EspaceWallet::Bailleur));
        self::assertSame(300, $wallet->solde($user, EspaceWallet::Locataire));
    }

    /** R-61 : crédits idempotents, jamais deux fois le même événement. */
    public function testCreditIdempotent(): void
    {
        $u = $this->utilisateur();
        $wallet = static::getContainer()->get(Wallet::class);
        $user = $this->em()->find(User::class, $u->getId());
        self::assertNotNull($wallet->crediter($user, EspaceWallet::Bailleur, 200, 'parrainage_location', null, 'cle-1'));
        self::assertNull($wallet->crediter($user, EspaceWallet::Bailleur, 200, 'parrainage_location', null, 'cle-1'));
        self::assertSame(200, $wallet->solde($user));
    }

    /** R-113 : ajustement uniquement par écriture motivée, réservé au super-administrateur. */
    public function testAjustementBackOffice(): void
    {
        $u = $this->utilisateur();
        $support = $this->utilisateur('Support', roles: ['ROLE_ADMIN']);
        $super = $this->utilisateur('Super', roles: ['ROLE_SUPER_ADMIN']);
        $this->erreur(403, 'INTERDIT', $this->api('POST', '/api/v1/admin/utilisateurs/'.$u->getId().'/wallet/ajustements', ['montant' => 500, 'motif' => 'Geste commercial'], $support));
        $this->erreur(422, 'AJUSTEMENT_INVALIDE', $this->api('POST', '/api/v1/admin/utilisateurs/'.$u->getId().'/wallet/ajustements', ['montant' => 500], $super));
        self::assertSame(['total' => 500], $this->ok(200, $this->api('POST', '/api/v1/admin/utilisateurs/'.$u->getId().'/wallet/ajustements', ['montant' => 500, 'motif' => 'Geste commercial'], $super)));
        self::assertSame(['total' => 200], $this->ok(200, $this->api('POST', '/api/v1/admin/utilisateurs/'.$u->getId().'/wallet/ajustements', ['montant' => -300, 'motif' => 'Correction'], $super)));

        $w = $this->ok(200, $this->api('GET', '/api/v1/wallet', null, $u));
        self::assertSame(2, $w['ecritures']['total']);
        self::assertSame('Correction', $w['ecritures']['elements'][0]['commentaire']);
        self::assertFalse($w['utilisable']);
        self::assertSame(1100, $w['seuil']);
    }
}
