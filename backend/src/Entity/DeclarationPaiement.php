<?php

namespace App\Entity;

use App\Enum\StatutDeclaration;
use Doctrine\ORM\Mapping as ORM;

use function Symfony\Component\Clock\now;

/**
 * R-39, R-40 : « J'ai payé » déclaré par le locataire. Ne modifie jamais le solde
 * tant qu'elle n'est pas validée par le bailleur.
 */
#[ORM\Entity]
class DeclarationPaiement
{
    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column]
    private ?int $id = null;

    #[ORM\ManyToOne(targetEntity: Contrat::class)]
    #[ORM\JoinColumn(nullable: false)]
    private Contrat $contrat;

    #[ORM\ManyToOne(targetEntity: User::class)]
    #[ORM\JoinColumn(nullable: false)]
    private User $declarePar;

    #[ORM\Column(type: 'bigint')]
    private int $montant;

    #[ORM\Column(type: 'date_immutable')]
    private \DateTimeImmutable $datePaiement;

    #[ORM\Column(length: 120, nullable: true)]
    private ?string $reference = null;

    #[ORM\Column(length: 20, enumType: StatutDeclaration::class)]
    private StatutDeclaration $statut = StatutDeclaration::EnAttente;

    #[ORM\Column(length: 255, nullable: true)]
    private ?string $motifRefus = null;

    #[ORM\OneToOne(targetEntity: Paiement::class)]
    private ?Paiement $paiement = null;

    #[ORM\ManyToOne(targetEntity: User::class)]
    private ?User $traitePar = null;

    #[ORM\Column(nullable: true)]
    private ?\DateTimeImmutable $traiteLe = null;

    #[ORM\Column(nullable: true)]
    private ?\DateTimeImmutable $derniereRelanceLe = null;

    #[ORM\Column]
    private \DateTimeImmutable $createdAt;

    public function __construct(Contrat $contrat, User $declarePar, int $montant, \DateTimeImmutable $datePaiement, ?string $reference)
    {
        $this->contrat = $contrat;
        $this->declarePar = $declarePar;
        $this->montant = $montant;
        $this->datePaiement = $datePaiement;
        $this->reference = $reference;
        $this->createdAt = now();
    }

    public function getId(): ?int { return $this->id; }
    public function getContrat(): Contrat { return $this->contrat; }
    public function getDeclarePar(): User { return $this->declarePar; }
    public function getMontant(): int { return $this->montant; }
    public function getDatePaiement(): \DateTimeImmutable { return $this->datePaiement; }
    public function getReference(): ?string { return $this->reference; }
    public function getStatut(): StatutDeclaration { return $this->statut; }
    public function getMotifRefus(): ?string { return $this->motifRefus; }
    public function getPaiement(): ?Paiement { return $this->paiement; }
    public function getCreatedAt(): \DateTimeImmutable { return $this->createdAt; }
    public function getDerniereRelanceLe(): ?\DateTimeImmutable { return $this->derniereRelanceLe; }
    public function relancee(): void { $this->derniereRelanceLe = now(); }

    public function valider(Paiement $paiement, User $par): void
    {
        $this->statut = StatutDeclaration::Validee;
        $this->paiement = $paiement;
        $this->traitePar = $par;
        $this->traiteLe = now();
    }

    public function refuser(string $motif, User $par): void
    {
        $this->statut = StatutDeclaration::Refusee;
        $this->motifRefus = $motif;
        $this->traitePar = $par;
        $this->traiteLe = now();
    }
}
