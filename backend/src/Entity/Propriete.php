<?php

namespace App\Entity;

use App\Enum\TypePropriete;
use Doctrine\ORM\Mapping as ORM;

use function Symfony\Component\Clock\now;

/** Parcelle ou immeuble : adresse, ville, pays, coordonnées GPS (chiffrées, R-124). */
#[ORM\Entity]
class Propriete
{
    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column]
    private ?int $id = null;

    #[ORM\ManyToOne(targetEntity: EspaceBailleur::class)]
    #[ORM\JoinColumn(nullable: false)]
    private EspaceBailleur $espace;

    #[ORM\Column(length: 120)]
    private string $nom;

    #[ORM\Column(length: 20, enumType: TypePropriete::class)]
    private TypePropriete $type;

    #[ORM\Column(length: 255, nullable: true)]
    private ?string $adresse = null;

    /** Zone publique affichée sur le Market (R-88, R-106). */
    #[ORM\Column(length: 120, nullable: true)]
    private ?string $quartier = null;

    #[ORM\ManyToOne(targetEntity: VilleApi::class)]
    private ?VilleApi $ville = null;

    #[ORM\ManyToOne(targetEntity: PaysApi::class)]
    #[ORM\JoinColumn(nullable: false)]
    private PaysApi $pays;

    #[ORM\Column(type: 'chiffre', nullable: true)]
    private ?string $latitude = null;

    #[ORM\Column(type: 'chiffre', nullable: true)]
    private ?string $longitude = null;

    #[ORM\Column]
    private \DateTimeImmutable $createdAt;

    public function __construct(EspaceBailleur $espace, string $nom, TypePropriete $type, PaysApi $pays)
    {
        $this->espace = $espace;
        $this->nom = $nom;
        $this->type = $type;
        $this->pays = $pays;
        $this->createdAt = now();
    }

    public function getId(): ?int { return $this->id; }
    public function getEspace(): EspaceBailleur { return $this->espace; }
    public function getNom(): string { return $this->nom; }
    public function setNom(string $nom): static { $this->nom = $nom; return $this; }
    public function getType(): TypePropriete { return $this->type; }
    public function getAdresse(): ?string { return $this->adresse; }
    public function setAdresse(?string $v): static { $this->adresse = $v; return $this; }
    public function getQuartier(): ?string { return $this->quartier; }
    public function setQuartier(?string $v): static { $this->quartier = $v; return $this; }
    public function getVille(): ?VilleApi { return $this->ville; }
    public function setVille(?VilleApi $v): static { $this->ville = $v; return $this; }
    public function getPays(): PaysApi { return $this->pays; }
    public function setPays(PaysApi $v): static { $this->pays = $v; return $this; }
    public function getLatitude(): ?float { return null === $this->latitude ? null : (float) $this->latitude; }
    public function getLongitude(): ?float { return null === $this->longitude ? null : (float) $this->longitude; }

    public function setCoordonnees(?float $latitude, ?float $longitude): static
    {
        $this->latitude = null === $latitude ? null : (string) $latitude;
        $this->longitude = null === $longitude ? null : (string) $longitude;

        return $this;
    }

    public function getCreatedAt(): \DateTimeImmutable { return $this->createdAt; }
}
