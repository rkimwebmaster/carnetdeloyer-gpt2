<?php

namespace App\Tests\Api;

use App\Entity\Devise;
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
}
