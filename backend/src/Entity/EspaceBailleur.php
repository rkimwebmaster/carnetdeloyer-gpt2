<?php

namespace App\Entity;

use App\Enum\BadgeVerification;
use Doctrine\ORM\Mapping as ORM;

use function Symfony\Component\Clock\now;

/**
 * Possède propriétés, abonnements et wallet. Séparé de l'utilisateur dès la v0.1
 * pour accueillir des gérants plus tard.
 */
#[ORM\Entity]
class EspaceBailleur
{
    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column]
    private ?int $id = null;

    #[ORM\OneToOne(targetEntity: User::class)]
    #[ORM\JoinColumn(nullable: false, unique: true)]
    private User $proprietaire;

    // R-164 : profil entreprise facultatif, affiché sur les reçus.
    #[ORM\Column(length: 160, nullable: true)]
    private ?string $raisonSociale = null;

    #[ORM\Column(length: 80, nullable: true)]
    private ?string $numeroRccm = null;

    #[ORM\Column(length: 255, nullable: true)]
    private ?string $adresse = null;

    /** R-33 : dernier numéro de reçu attribué (séquence sans trou). */
    #[ORM\Column]
    private int $dernierNumeroRecu = 0;

    /** R-50 : la gratuité de la première unité n'est accordée qu'une fois par compte. */
    #[ORM\Column]
    private bool $gratuiteUtilisee = false;

    // R-170 : on conserve le résultat de la vérification, pas les pièces.
    #[ORM\Column(length: 30, nullable: true, enumType: BadgeVerification::class)]
    private ?BadgeVerification $badge = null;

    #[ORM\Column(nullable: true)]
    private ?\DateTimeImmutable $badgeLe = null;

    #[ORM\Column(nullable: true)]
    private ?\DateTimeImmutable $badgeExpireLe = null;

    #[ORM\ManyToOne(targetEntity: User::class)]
    private ?User $badgeAttribuePar = null;

    #[ORM\Column]
    private \DateTimeImmutable $createdAt;

    public function __construct(User $proprietaire)
    {
        $this->proprietaire = $proprietaire;
        $this->createdAt = now();
    }

    public function getId(): ?int { return $this->id; }
    public function getProprietaire(): User { return $this->proprietaire; }
    public function getRaisonSociale(): ?string { return $this->raisonSociale; }
    public function setRaisonSociale(?string $v): static { $this->raisonSociale = $v; return $this; }
    public function getNumeroRccm(): ?string { return $this->numeroRccm; }
    public function setNumeroRccm(?string $v): static { $this->numeroRccm = $v; return $this; }
    public function getAdresse(): ?string { return $this->adresse; }
    public function setAdresse(?string $v): static { $this->adresse = $v; return $this; }
    public function isGratuiteUtilisee(): bool { return $this->gratuiteUtilisee; }
    public function marquerGratuiteUtilisee(): void { $this->gratuiteUtilisee = true; }

    public function prochainNumeroRecu(): int
    {
        return ++$this->dernierNumeroRecu;
    }

    public function getBadge(\DateTimeImmutable $aujourdhui): ?BadgeVerification
    {
        if (null !== $this->badgeExpireLe && $this->badgeExpireLe < $aujourdhui) {
            return null;
        }

        return $this->badge;
    }

    public function attribuerBadge(?BadgeVerification $badge, ?User $par, ?\DateTimeImmutable $expireLe = null): void
    {
        $this->badge = $badge;
        $this->badgeAttribuePar = $par;
        $this->badgeLe = null === $badge ? null : now();
        $this->badgeExpireLe = $expireLe;
    }

    public function getBadgeLe(): ?\DateTimeImmutable { return $this->badgeLe; }
    public function getBadgeExpireLe(): ?\DateTimeImmutable { return $this->badgeExpireLe; }

    /** Nom affiché sur les reçus et les annonces. */
    public function nomAffiche(): string
    {
        return $this->raisonSociale ?: $this->proprietaire->getNom();
    }
}
