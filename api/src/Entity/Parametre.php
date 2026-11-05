<?php

namespace App\Entity;

use Doctrine\ORM\Mapping as ORM;

use function Symfony\Component\Clock\now;

/**
 * R-67 : valeur par défaut réglable, avec historique (une ligne par changement).
 * La valeur en vigueur est la plus récente.
 */
#[ORM\Entity]
#[ORM\Index(columns: ['cle', 'depuis'])]
class Parametre
{
    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column]
    private ?int $id = null;

    #[ORM\Column(length: 60)]
    private string $cle;

    #[ORM\Column(length: 60)]
    private string $valeur;

    #[ORM\Column]
    private \DateTimeImmutable $depuis;

    #[ORM\ManyToOne(targetEntity: User::class)]
    private ?User $modifiePar;

    public function __construct(string $cle, string $valeur, ?User $modifiePar = null)
    {
        $this->cle = $cle;
        $this->valeur = $valeur;
        $this->modifiePar = $modifiePar;
        $this->depuis = now();
    }

    public function getCle(): string { return $this->cle; }
    public function getValeur(): string { return $this->valeur; }
    public function getDepuis(): \DateTimeImmutable { return $this->depuis; }
    public function getModifiePar(): ?User { return $this->modifiePar; }
}
