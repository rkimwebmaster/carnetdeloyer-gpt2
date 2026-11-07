<?php

namespace App\Tests\Unit;

use App\Entity\Contrat;
use App\Entity\Echeance;
use App\Enum\StatutEcheance;
use PHPUnit\Framework\TestCase;

final class EcheanceTest extends TestCase
{
    private function echeance(string $debut, int $du = 30000, int $paye = 0): Echeance
    {
        $contrat = (new \ReflectionClass(Contrat::class))->newInstanceWithoutConstructor();
        $e = new Echeance($contrat, new \DateTimeImmutable($debut), (new \DateTimeImmutable($debut))->modify('+1 month -1 day'), $du);
        $e->setMontantPaye($paye);

        return $e;
    }

    public function testStatutsCalcules(): void
    {
        $auj = new \DateTimeImmutable('2026-10-27 14:00');
        self::assertSame(StatutEcheance::AVenir, $this->echeance('2026-11-01')->statut($auj));
        self::assertSame(StatutEcheance::Partielle, $this->echeance('2026-11-01', paye: 10000)->statut($auj));
        self::assertSame(StatutEcheance::Payee, $this->echeance('2026-10-01', paye: 30000)->statut($auj));
        // R-22 : en retard = date dépassée et non soldée, même partiellement payée.
        self::assertSame(StatutEcheance::EnRetard, $this->echeance('2026-10-01')->statut($auj));
        self::assertSame(StatutEcheance::EnRetard, $this->echeance('2026-10-01', paye: 10000)->statut($auj));
        // Exigible aujourd'hui : pas encore en retard.
        self::assertSame(StatutEcheance::AVenir, $this->echeance('2026-10-27')->statut($auj));

        $annulee = $this->echeance('2026-10-01');
        $annulee->annuler();
        self::assertSame(StatutEcheance::Annulee, $annulee->statut($auj));
        self::assertSame(0, $annulee->getRestantDu());
    }

    public function testRestantDu(): void
    {
        self::assertSame(20000, $this->echeance('2026-10-01', paye: 10000)->getRestantDu());
        self::assertSame(0, $this->echeance('2026-10-01', paye: 40000)->getRestantDu());
    }
}
