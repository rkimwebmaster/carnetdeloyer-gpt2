<?php

namespace App\Entity;

use Doctrine\ORM\Mapping as ORM;

/**
 * R-15 : pays (plusieurs villes, clé étrangère deviseParDefaut).
 * Nom de classe et table conservés pour rester compatible avec la base existante.
 */
#[ORM\Entity]
#[ORM\Table(name: 'pays')]
class PaysApi
{
    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column]
    private ?int $id = null;

    #[ORM\Column(length: 100)]
    private string $nom;

    #[ORM\Column(name: 'code_iso', length: 2, unique: true)]
    private string $codeIso;

    #[ORM\Column(name: 'code_iso3', length: 3, unique: true)]
    private string $codeIso3;

    /** Indicatif au format "+243". */
    #[ORM\Column(length: 10)]
    private string $indicatif;

    #[ORM\Column(length: 10, nullable: true)]
    private ?string $drapeau = null;

    #[ORM\ManyToOne(targetEntity: Devise::class)]
    #[ORM\JoinColumn(nullable: true)]
    private ?Devise $deviseParDefaut = null;

    /** R-117 : on désactive, on ne supprime pas. */
    #[ORM\Column]
    private bool $active = true;

    public function __construct(string $nom, string $codeIso, string $codeIso3, string $indicatif, ?Devise $deviseParDefaut = null, ?string $drapeau = null)
    {
        $this->nom = $nom;
        $this->codeIso = strtoupper($codeIso);
        $this->codeIso3 = strtoupper($codeIso3);
        $this->indicatif = '+'.ltrim($indicatif, '+');
        $this->deviseParDefaut = $deviseParDefaut;
        $this->drapeau = $drapeau;
    }

    public function getId(): ?int { return $this->id; }
    public function getNom(): string { return $this->nom; }
    public function getCodeIso(): string { return $this->codeIso; }
    public function getCodeIso3(): string { return $this->codeIso3; }
    public function getIndicatif(): string { return $this->indicatif; }
    public function getDrapeau(): ?string { return $this->drapeau; }
    public function getDeviseParDefaut(): ?Devise { return $this->deviseParDefaut; }
    public function setDeviseParDefaut(?Devise $devise): static { $this->deviseParDefaut = $devise; return $this; }
    public function isActive(): bool { return $this->active; }
    public function setActive(bool $active): static { $this->active = $active; return $this; }

    public function __toString(): string { return trim(($this->drapeau ?? '').' '.$this->nom); }
}
