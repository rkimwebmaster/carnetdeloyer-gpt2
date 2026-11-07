<?php

namespace App\Entity;

use App\Enum\MoyenPaiement;
use App\Enum\StatutPaiement;
use App\Enum\TypePaiement;
use Doctrine\ORM\Mapping as ORM;

use function Symfony\Component\Clock\now;

/**
 * Somme reçue (R-03). Jamais supprimée : annulée avec motif (R-06, R-34).
 * L'auteur de la saisie est tracé (R-13). La clé d'idempotence est générée
 * par le téléphone (R-137).
 */
#[ORM\Entity]
#[ORM\Index(columns: ['date_paiement'])]
class Paiement
{
    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column]
    private ?int $id = null;

    #[ORM\ManyToOne(targetEntity: Contrat::class)]
    #[ORM\JoinColumn(nullable: false)]
    private Contrat $contrat;

    #[ORM\Column(length: 20, enumType: TypePaiement::class)]
    private TypePaiement $type;

    #[ORM\Column(type: 'bigint')]
    private int $montant;

    #[ORM\Column(type: 'date_immutable')]
    private \DateTimeImmutable $datePaiement;

    #[ORM\Column(length: 20, enumType: MoyenPaiement::class)]
    private MoyenPaiement $moyen;

    #[ORM\Column(length: 120, nullable: true)]
    private ?string $reference = null;

    #[ORM\Column(length: 64, unique: true)]
    private string $cleIdempotence;

    #[ORM\ManyToOne(targetEntity: User::class)]
    #[ORM\JoinColumn(nullable: false)]
    private User $saisiPar;

    /** R-27 : imputation corrigée à la main, conservée lors des recalculs. */
    #[ORM\Column]
    private bool $imputationManuelle = false;

    #[ORM\Column(length: 20, enumType: StatutPaiement::class)]
    private StatutPaiement $statut = StatutPaiement::Valide;

    #[ORM\Column(length: 255, nullable: true)]
    private ?string $motifAnnulation = null;

    #[ORM\Column(nullable: true)]
    private ?\DateTimeImmutable $annuleLe = null;

    #[ORM\ManyToOne(targetEntity: User::class)]
    private ?User $annulePar = null;

    #[ORM\Column]
    private \DateTimeImmutable $createdAt;

    public function __construct(Contrat $contrat, TypePaiement $type, int $montant, \DateTimeImmutable $datePaiement, MoyenPaiement $moyen, string $cleIdempotence, User $saisiPar, ?string $reference = null)
    {
        $this->contrat = $contrat;
        $this->type = $type;
        $this->montant = $montant;
        $this->datePaiement = $datePaiement;
        $this->moyen = $moyen;
        $this->cleIdempotence = $cleIdempotence;
        $this->saisiPar = $saisiPar;
        $this->reference = $reference;
        $this->createdAt = now();
    }

    public function getId(): ?int { return $this->id; }
    public function getContrat(): Contrat { return $this->contrat; }
    public function getType(): TypePaiement { return $this->type; }
    public function getMontant(): int { return $this->montant; }
    public function getDatePaiement(): \DateTimeImmutable { return $this->datePaiement; }
    public function getMoyen(): MoyenPaiement { return $this->moyen; }
    public function getReference(): ?string { return $this->reference; }
    public function getCleIdempotence(): string { return $this->cleIdempotence; }
    public function getSaisiPar(): User { return $this->saisiPar; }
    public function isImputationManuelle(): bool { return $this->imputationManuelle; }
    public function marquerImputationManuelle(): void { $this->imputationManuelle = true; }
    public function getStatut(): StatutPaiement { return $this->statut; }
    public function isValide(): bool { return StatutPaiement::Valide === $this->statut; }
    public function getMotifAnnulation(): ?string { return $this->motifAnnulation; }
    public function getAnnuleLe(): ?\DateTimeImmutable { return $this->annuleLe; }
    public function getAnnulePar(): ?User { return $this->annulePar; }
    public function getCreatedAt(): \DateTimeImmutable { return $this->createdAt; }

    public function annuler(string $motif, User $par): void
    {
        $this->statut = StatutPaiement::Annule;
        $this->motifAnnulation = $motif;
        $this->annuleLe = now();
        $this->annulePar = $par;
    }
}
