<?php

namespace App\Entity;

use Doctrine\ORM\Mapping as ORM;

/**
 * R-15 : devise, entité distincte (code ISO 4217, nom, symbole, décimales, active).
 * Aucun taux de change n'est stocké ici : la conversion passe par l'API de
 * conversion et le taux est figé sur chaque paiement (R-69).
 */
#[ORM\Entity]
#[ORM\Table(name: 'devise')]
class Devise
{
    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column]
    private ?int $id = null;

    #[ORM\Column(length: 3, unique: true)]
    private string $code;

    #[ORM\Column(length: 50)]
    private string $nom;

    #[ORM\Column(length: 10)]
    private string $symbole;

    /** Nombre de décimales de l'unité mineure (USD : 2, CDF : 2, XOF : 0). */
    #[ORM\Column(type: 'smallint')]
    private int $decimales;

    /** R-18 : une devise désactivée n'est plus proposée pour un nouveau contrat. */
    #[ORM\Column]
    private bool $active = true;

    public function __construct(string $code, string $nom, string $symbole, int $decimales = 2)
    {
        $this->code = strtoupper($code);
        $this->nom = $nom;
        $this->symbole = $symbole;
        $this->decimales = $decimales;
    }

    public function getId(): ?int { return $this->id; }
    public function getCode(): string { return $this->code; }
    public function getNom(): string { return $this->nom; }
    public function setNom(string $nom): static { $this->nom = $nom; return $this; }
    public function getSymbole(): string { return $this->symbole; }
    public function setSymbole(string $symbole): static { $this->symbole = $symbole; return $this; }
    public function getDecimales(): int { return $this->decimales; }
    public function setDecimales(int $decimales): static { $this->decimales = $decimales; return $this; }
    public function isActive(): bool { return $this->active; }
    public function setActive(bool $active): static { $this->active = $active; return $this; }

    public function __toString(): string { return $this->code; }
}
