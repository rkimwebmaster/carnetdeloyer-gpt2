<?php

namespace App\Tests\Unit;

use App\Securite\Chiffreur;
use App\Securite\Telephone;
use App\Service\FiltreCoordonnees;
use PHPUnit\Framework\Attributes\DataProvider;
use PHPUnit\Framework\TestCase;

final class SecuriteTest extends TestCase
{
    private function chiffreur(): Chiffreur
    {
        return new Chiffreur(base64_encode(str_repeat('k', 32)));
    }

    public function testChiffrementAllerRetour(): void
    {
        $c = $this->chiffreur();
        $chiffre = $c->chiffrer('+243970000001');
        self::assertStringNotContainsString('970000001', $chiffre);
        self::assertSame('+243970000001', $c->dechiffrer($chiffre));
        // Nonce aléatoire : deux chiffrements diffèrent.
        self::assertNotSame($chiffre, $c->chiffrer('+243970000001'));
    }

    public function testDonneeAltereeRefusee(): void
    {
        $c = $this->chiffreur();
        $chiffre = $c->chiffrer('secret');
        $brut = base64_decode(substr($chiffre, 3));
        $brut[\strlen($brut) - 1] = \chr(\ord($brut[\strlen($brut) - 1]) ^ 1);
        $this->expectException(\RuntimeException::class);
        $c->dechiffrer('v1:'.base64_encode($brut));
    }

    public function testMauvaiseCleRefusee(): void
    {
        $chiffre = $this->chiffreur()->chiffrer('secret');
        $this->expectException(\RuntimeException::class);
        (new Chiffreur(base64_encode(str_repeat('x', 32))))->dechiffrer($chiffre);
    }

    public function testCleDeTailleInvalide(): void
    {
        $this->expectException(\InvalidArgumentException::class);
        new Chiffreur(base64_encode('courte'));
    }

    public function testEmpreinteDeterministe(): void
    {
        $c = $this->chiffreur();
        self::assertSame($c->empreinte('+243970000001'), $c->empreinte('+243970000001'));
        self::assertNotSame($c->empreinte('+243970000001'), $c->empreinte('+243970000002'));
        self::assertSame(64, \strlen($c->empreinte('x')));
    }

    public static function telephones(): iterable
    {
        yield ['+243 970 000 001', '+243970000001'];
        yield ['00243-970-000-001', '+243970000001'];
        yield ['+1 (202) 555-0147', '+12025550147'];
        yield ['0970000001', null];
        yield ['+0243970000001', null];
        yield ['+243abc', null];
        yield ['+2431', null];
    }

    #[DataProvider('telephones')]
    public function testNormalisationTelephone(string $saisie, ?string $attendu): void
    {
        self::assertSame($attendu, Telephone::normaliser($saisie));
    }

    public static function descriptions(): iterable
    {
        yield 'texte normal' => ['Belle maison 3 chambres, 2 salles de bain, parking.', false];
        yield 'prix ou surface' => ['Loyer 300 $, 120 m2, construite en 2019.', false];
        yield 'téléphone collé' => ['Appelez le 0970000001', true];
        yield 'téléphone espacé' => ['Contact : +243 97 00 00 001', true];
        yield 'téléphone à points' => ['Tel 097.000.0001', true];
        yield 'e-mail' => ['écrire à jean.dupont@exemple.com', true];
        yield 'lien whatsapp' => ['wa.me/243970000001', true];
        yield 'lien web' => ['voir https://exemple.com', true];
    }

    #[DataProvider('descriptions')]
    public function testFiltreCoordonnees(string $texte, bool $interdit): void
    {
        self::assertSame($interdit, FiltreCoordonnees::contient($texte));
    }
}
