<?php

namespace App\Entity;

use Doctrine\ORM\Mapping as ORM;

/** R-83, R-117 : catégorie d'unité avec son icône, gérée sans redéploiement. */
#[ORM\Entity]
class CategorieUnite
{
    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column]
    private ?int $id = null;

    #[ORM\Column(length: 40, unique: true)]
    private string $code;

    #[ORM\Column(length: 80)]
    private string $libelle;

    /** Nom d'icône (Material Symbols) affiché dans les listes. */
    #[ORM\Column(length: 60)]
    private string $icone;

    /** R-97 : catégorie hôtel (chambres d'hôtel). */
    #[ORM\Column]
    private bool $hotel = false;

    #[ORM\Column]
    private bool $active = true;

    public function __construct(string $code, string $libelle, string $icone, bool $hotel = false)
    {
        $this->code = $code;
        $this->libelle = $libelle;
        $this->icone = $icone;
        $this->hotel = $hotel;
    }

    public function getId(): ?int { return $this->id; }
    public function getCode(): string { return $this->code; }
    public function getLibelle(): string { return $this->libelle; }
    public function getIcone(): string { return $this->icone; }
    public function isHotel(): bool { return $this->hotel; }
    public function isActive(): bool { return $this->active; }
    public function setActive(bool $active): static { $this->active = $active; return $this; }
}
