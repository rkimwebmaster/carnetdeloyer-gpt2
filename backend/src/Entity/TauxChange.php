<?php

namespace App\Entity;

use Doctrine\ORM\Mapping as ORM;

/**
 * Dernier taux connu de l'API de conversion (R-69). Utilisé en secours s'il a
 * moins de 48 h (section 11, solutions de secours).
 */
#[ORM\Entity]
class TauxChange
{
    #[ORM\Id]
    #[ORM\Column(length: 3)]
    private string $deviseCode;

    /** Unités de la devise pour 1 USD, en chaîne décimale. */
    #[ORM\Column(length: 30)]
    private string $taux;

    #[ORM\Column]
    private \DateTimeImmutable $recupereLe;

    public function __construct(string $deviseCode, string $taux, \DateTimeImmutable $recupereLe)
    {
        $this->deviseCode = $deviseCode;
        $this->taux = $taux;
        $this->recupereLe = $recupereLe;
    }

    public function getDeviseCode(): string { return $this->deviseCode; }
    public function getTaux(): string { return $this->taux; }
    public function getRecupereLe(): \DateTimeImmutable { return $this->recupereLe; }

    public function mettreAJour(string $taux, \DateTimeImmutable $le): void
    {
        $this->taux = $taux;
        $this->recupereLe = $le;
    }
}
