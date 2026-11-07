<?php

namespace App\Tests\Unit;

use App\Service\Argent;
use PHPUnit\Framework\Attributes\DataProvider;
use PHPUnit\Framework\TestCase;

final class ArgentTest extends TestCase
{
    public function testExempleDeLaSpecification(): void
    {
        // Section 6 : une unité à 300 $ par mois coûte 29,70 $ par an.
        self::assertSame(2970, Argent::pourcentage(30000, '9.9'));
        // R-91 : 2 nuits à 30 $ rapportent 5,94 $.
        self::assertSame(594, Argent::pourcentage(6000, '9.9'));
    }

    public static function pourcentages(): iterable
    {
        yield 'arrondi au plus proche' => [1005, '10', 101];
        yield 'moitié vers le haut' => [5, '10', 1];
        yield 'zéro' => [0, '9.9', 0];
        yield 'pourcentage entier' => [10000, '2', 200];
        yield 'beaucoup de décimales' => [100000, '9.999999', 10000];
    }

    #[DataProvider('pourcentages')]
    public function testPourcentage(int $montant, string $pct, int $attendu): void
    {
        self::assertSame($attendu, Argent::pourcentage($montant, $pct));
    }

    public function testConversionEnUsd(): void
    {
        // 29 700 FC (2 décimales => 2 970 000) à 2 850 FC pour 1 $ = 10,42 $
        self::assertSame(1042, Argent::versCentimesUsd(2970000, '2850', 2));
        // XAF sans décimales : 600 000 FCFA à 600 FCFA/$ = 1 000 $
        self::assertSame(100000, Argent::versCentimesUsd(600000, '600', 0));
        // Taux décimal
        self::assertSame(108, Argent::versCentimesUsd(100, '0.925', 2));
        self::assertSame(2970, Argent::versCentimesUsd(2970, '1', 2));
    }

    public function testTauxNulRefuse(): void
    {
        $this->expectException(\InvalidArgumentException::class);
        Argent::versCentimesUsd(100, '0', 2);
    }

    public function testProrata(): void
    {
        self::assertSame(1485, Argent::prorata(2970, 182, 364));
        self::assertSame(0, Argent::prorata(2970, 10, 0));
        self::assertSame(2970, Argent::prorata(2970, 400, 365));
        self::assertSame(0, Argent::prorata(2970, -5, 365));
    }

    public function testSaisieDecimale(): void
    {
        self::assertSame(30000, Argent::depuisDecimal('300', 2));
        self::assertSame(30050, Argent::depuisDecimal('300,5', 2));
        self::assertSame(1500000, Argent::depuisDecimal('1 500 000', 0));
    }

    public function testSaisieDecimaleTropPrecise(): void
    {
        $this->expectException(\InvalidArgumentException::class);
        Argent::depuisDecimal('10.5', 0);
    }

    public function testDecimalInvalide(): void
    {
        $this->expectException(\InvalidArgumentException::class);
        Argent::fraction('-1');
    }
}
