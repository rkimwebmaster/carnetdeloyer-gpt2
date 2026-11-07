<?php

namespace App\Tests\Unit;

use App\Service\Calendrier;
use PHPUnit\Framework\Attributes\DataProvider;
use PHPUnit\Framework\TestCase;

final class CalendrierTest extends TestCase
{
    public static function cas(): iterable
    {
        yield 'mois simple' => ['2026-01-15', 1, '2026-02-15'];
        yield '31 janvier => fin février' => ['2026-01-31', 1, '2026-02-28'];
        yield 'année bissextile' => ['2028-01-31', 1, '2028-02-29'];
        yield 'reprend le jour de base' => ['2026-01-31', 2, '2026-03-31'];
        yield 'changement d\'année' => ['2026-11-30', 3, '2027-02-28'];
        yield 'douze mois' => ['2026-10-27', 12, '2027-10-27'];
        yield 'négatif' => ['2026-03-31', -1, '2026-02-28'];
        yield 'négatif sur l\'année' => ['2026-01-15', -13, '2024-12-15'];
    }

    #[DataProvider('cas')]
    public function testAjouterMois(string $base, int $mois, string $attendu): void
    {
        self::assertSame($attendu, Calendrier::ajouterMois(new \DateTimeImmutable($base.' 15:30'), $mois)->format('Y-m-d'));
    }

    public function testJoursEntre(): void
    {
        self::assertSame(365, Calendrier::joursEntre(new \DateTimeImmutable('2026-10-27 23:00'), new \DateTimeImmutable('2027-10-27 01:00')));
        self::assertSame(-3, Calendrier::joursEntre(new \DateTimeImmutable('2026-10-27'), new \DateTimeImmutable('2026-10-24')));
    }
}
