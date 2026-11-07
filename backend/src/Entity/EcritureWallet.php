<?php

namespace App\Entity;

use App\Enum\EspaceWallet;
use App\Enum\SensEcriture;
use Doctrine\ORM\Mapping as ORM;

use function Symfony\Component\Clock\now;

/**
 * R-61, R-147 : écriture de journal typée, en centimes d'USD (R-60).
 * Le solde se calcule depuis le journal, jamais modifié directement (R-113).
 * La clé unique empêche de créditer deux fois le même événement.
 */
#[ORM\Entity]
#[ORM\Index(columns: ['user_id', 'espace'])]
class EcritureWallet
{
    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column]
    private ?int $id = null;

    #[ORM\ManyToOne(targetEntity: User::class)]
    #[ORM\JoinColumn(nullable: false)]
    private User $user;

    #[ORM\Column(length: 20, enumType: EspaceWallet::class)]
    private EspaceWallet $espace;

    #[ORM\Column(length: 10, enumType: SensEcriture::class)]
    private SensEcriture $sens;

    #[ORM\Column(type: 'bigint')]
    private int $montant;

    /** Code de motif (traduit côté app) : parrainage_location, reste_abonnement, paiement_abonnement, ajustement... */
    #[ORM\Column(length: 40)]
    private string $motif;

    #[ORM\Column(length: 120, nullable: true)]
    private ?string $reference;

    #[ORM\Column(length: 120, unique: true, nullable: true)]
    private ?string $cleUnique;

    #[ORM\Column(length: 255, nullable: true)]
    private ?string $commentaire;

    #[ORM\ManyToOne(targetEntity: User::class)]
    private ?User $creePar;

    #[ORM\Column]
    private \DateTimeImmutable $createdAt;

    public function __construct(User $user, EspaceWallet $espace, SensEcriture $sens, int $montant, string $motif, ?string $reference = null, ?string $cleUnique = null, ?string $commentaire = null, ?User $creePar = null)
    {
        if ($montant <= 0) {
            throw new \InvalidArgumentException('Le montant d\'une écriture doit être positif.');
        }
        $this->user = $user;
        $this->espace = $espace;
        $this->sens = $sens;
        $this->montant = $montant;
        $this->motif = $motif;
        $this->reference = $reference;
        $this->cleUnique = $cleUnique;
        $this->commentaire = $commentaire;
        $this->creePar = $creePar;
        $this->createdAt = now();
    }

    public function getId(): ?int { return $this->id; }
    public function getUser(): User { return $this->user; }
    public function getEspace(): EspaceWallet { return $this->espace; }
    public function getSens(): SensEcriture { return $this->sens; }
    public function getMontant(): int { return $this->montant; }
    public function getMontantSigne(): int { return SensEcriture::Credit === $this->sens ? $this->montant : -$this->montant; }
    public function getMotif(): string { return $this->motif; }
    public function getReference(): ?string { return $this->reference; }
    public function getCommentaire(): ?string { return $this->commentaire; }
    public function getCreatedAt(): \DateTimeImmutable { return $this->createdAt; }
}
