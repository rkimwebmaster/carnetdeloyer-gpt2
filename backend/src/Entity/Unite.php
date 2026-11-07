<?php

namespace App\Entity;

use Doctrine\ORM\Mapping as ORM;

use function Symfony\Component\Clock\now;

/**
 * Logement, chambre, boutique, bureau, terrain, chambre d'hôtel.
 * Le loyer indicatif sert seulement à pré-remplir (R-16).
 */
#[ORM\Entity]
class Unite
{
    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column]
    private ?int $id = null;

    #[ORM\ManyToOne(targetEntity: Propriete::class)]
    #[ORM\JoinColumn(nullable: false)]
    private Propriete $propriete;

    #[ORM\Column(length: 120)]
    private string $nom;

    #[ORM\ManyToOne(targetEntity: CategorieUnite::class)]
    #[ORM\JoinColumn(nullable: false)]
    private CategorieUnite $categorie;

    /** En unité mineure de $deviseIndicative (R-14). */
    #[ORM\Column(type: 'bigint', nullable: true)]
    private ?int $loyerIndicatif = null;

    #[ORM\ManyToOne(targetEntity: Devise::class)]
    private ?Devise $deviseIndicative = null;

    // R-107 : publication gratuite en un geste sur le Market (unités vacantes).
    #[ORM\Column]
    private bool $publieeMarket = false;

    #[ORM\Column(length: 500, nullable: true)]
    private ?string $descriptionMarket = null;

    #[ORM\Column(nullable: true)]
    private ?\DateTimeImmutable $publieeLe = null;

    /** R-52 : fin de la période d'abonnement en cours (null = jamais activée). */
    #[ORM\Column(type: 'date_immutable', nullable: true)]
    private ?\DateTimeImmutable $abonnementFin = null;

    /** R-50 : fin de la gratuité si cette unité est la première unité gratuite. */
    #[ORM\Column(type: 'date_immutable', nullable: true)]
    private ?\DateTimeImmutable $gratuiteJusquAu = null;

    #[ORM\Column]
    private \DateTimeImmutable $createdAt;

    public function __construct(Propriete $propriete, string $nom, CategorieUnite $categorie)
    {
        $this->propriete = $propriete;
        $this->nom = $nom;
        $this->categorie = $categorie;
        $this->createdAt = now();
    }

    public function getId(): ?int { return $this->id; }
    public function getPropriete(): Propriete { return $this->propriete; }
    public function getEspace(): EspaceBailleur { return $this->propriete->getEspace(); }
    public function getNom(): string { return $this->nom; }
    public function setNom(string $nom): static { $this->nom = $nom; return $this; }
    public function getCategorie(): CategorieUnite { return $this->categorie; }
    public function setCategorie(CategorieUnite $c): static { $this->categorie = $c; return $this; }
    public function getLoyerIndicatif(): ?int { return $this->loyerIndicatif; }
    public function getDeviseIndicative(): ?Devise { return $this->deviseIndicative; }

    public function setLoyerIndicatif(?int $montant, ?Devise $devise): static
    {
        $this->loyerIndicatif = $montant;
        $this->deviseIndicative = null === $montant ? null : $devise;

        return $this;
    }

    public function isPublieeMarket(): bool { return $this->publieeMarket; }
    public function getDescriptionMarket(): ?string { return $this->descriptionMarket; }
    public function getPublieeLe(): ?\DateTimeImmutable { return $this->publieeLe; }

    public function publier(?string $description): void
    {
        $this->publieeMarket = true;
        $this->descriptionMarket = $description;
        $this->publieeLe = now();
    }

    public function retirerDuMarket(): void
    {
        $this->publieeMarket = false;
    }

    public function getAbonnementFin(): ?\DateTimeImmutable { return $this->abonnementFin; }
    public function setAbonnementFin(?\DateTimeImmutable $fin): static { $this->abonnementFin = $fin; return $this; }
    public function getGratuiteJusquAu(): ?\DateTimeImmutable { return $this->gratuiteJusquAu; }
    public function setGratuiteJusquAu(?\DateTimeImmutable $d): static { $this->gratuiteJusquAu = $d; return $this; }
}
