<?php

namespace App\Entity;

use Doctrine\ORM\Mapping as ORM;

/**
 * R-15 : ville. Pas de suppression en cascade : une ville référencée par des
 * propriétés ou des comptes se désactive (R-06, R-117).
 */
#[ORM\Entity]
#[ORM\Table(name: 'villes')]
#[ORM\UniqueConstraint(name: 'unique_ville_pays', columns: ['pays_id', 'nom'])]
class VilleApi
{
    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column]
    private ?int $id = null;

    #[ORM\Column(length: 150)]
    private string $nom;

    #[ORM\ManyToOne(targetEntity: PaysApi::class)]
    #[ORM\JoinColumn(name: 'pays_id', nullable: false)]
    private PaysApi $pays;

    #[ORM\Column]
    private bool $active = true;

    public function __construct(PaysApi $pays, string $nom)
    {
        $this->pays = $pays;
        $this->nom = trim($nom);
    }

    public function getId(): ?int { return $this->id; }
    public function getNom(): string { return $this->nom; }
    public function getPays(): PaysApi { return $this->pays; }
    public function isActive(): bool { return $this->active; }
    public function setActive(bool $active): static { $this->active = $active; return $this; }

    public function __toString(): string { return $this->nom; }
}
