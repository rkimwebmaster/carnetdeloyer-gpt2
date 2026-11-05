<?php

namespace App\Tests\Api;

use App\Entity\Devise;
use App\Entity\PaysApi;
use App\Entity\VilleApi;
use App\Tests\ApiTestCase;

final class ReferentielTest extends ApiTestCase
{
    public function testPaysAccessiblesSansConnexion(): void
    {
        $pays = $this->ok(200, $this->api('GET', '/api/v1/referentiels/pays'));
        $rdc = array_values(array_filter($pays, static fn ($p) => 'CD' === $p['codeIso']))[0];
        self::assertSame('+243', $rdc['indicatif']);
        self::assertSame('CDF', $rdc['deviseParDefaut']);

        $villes = $this->ok(200, $this->api('GET', '/api/v1/referentiels/pays/'.$rdc['id'].'/villes?q=Lubum'));
        self::assertSame(['Lubumbashi'], array_column($villes, 'nom'));
    }

    public function testDeviseDesactiveeInvisible(): void
    {
        $eur = $this->em()->getRepository(Devise::class)->findOneBy(['code' => 'EUR']);
        $eur->setActive(false);
        $this->em()->flush();

        $codes = array_column($this->ok(200, $this->api('GET', '/api/v1/referentiels/devises')), 'code');
        self::assertContains('USD', $codes);
        self::assertNotContains('EUR', $codes);
        $cdf = array_values(array_filter($this->ok(200, $this->api('GET', '/api/v1/referentiels/devises')), static fn ($d) => 'XAF' === $d['code']))[0];
        self::assertSame(0, $cdf['decimales']);
    }

    public function testCategoriesAvecIcones(): void
    {
        $categories = $this->ok(200, $this->api('GET', '/api/v1/referentiels/categories'));
        $parCode = array_column($categories, null, 'code');
        self::assertSame('house', $parCode['maison']['icone']);
        self::assertTrue($parCode['chambre_hotel']['hotel']);
    }

    public function testRouteProtegeeExigeUneSession(): void
    {
        $this->erreur(401, 'SESSION', $this->api('GET', '/api/v1/moi'));
    }

    /** R-15, R-117 : désactiver un pays masque aussi ses villes, sans effacer l'historique. */
    public function testPaysDesactiveMasqueSesVillesSansSuppression(): void
    {
        $rdc = $this->em()->getRepository(PaysApi::class)->findOneBy(['codeIso' => 'CD']);
        $id = $rdc->getId();
        $nombre = $this->em()->getRepository(VilleApi::class)->count(['pays' => $rdc]);
        $rdc->setActive(false);
        $this->em()->flush();

        $pays = $this->ok(200, $this->api('GET', '/api/v1/referentiels/pays'));
        self::assertNotContains('CD', array_column($pays, 'codeIso'));
        self::assertSame([], $this->ok(200, $this->api('GET', '/api/v1/referentiels/pays/'.$id.'/villes')));
        self::assertSame($nombre, $this->em()->getRepository(VilleApi::class)->count(['pays' => $this->em()->find(PaysApi::class, $id)]));
    }

    public function testVilleDesactiveeMasqueeSansMasquerSonPays(): void
    {
        $ville = $this->em()->getRepository(VilleApi::class)->findOneBy(['nom' => 'Lubumbashi']);
        $paysId = $ville->getPays()->getId();
        $ville->setActive(false);
        $this->em()->flush();

        self::assertSame([], $this->ok(200, $this->api('GET', '/api/v1/referentiels/pays/'.$paysId.'/villes?q=Lubum')));
        self::assertContains('CD', array_column($this->ok(200, $this->api('GET', '/api/v1/referentiels/pays')), 'codeIso'));
    }
}
