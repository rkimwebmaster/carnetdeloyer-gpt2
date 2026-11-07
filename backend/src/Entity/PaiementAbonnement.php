<?php

namespace App\Entity;

use App\Enum\SourcePaiementAbonnement;
use App\Enum\StatutPaiementAbonnement;
use Doctrine\ORM\Mapping as ORM;

use function Symfony\Component\Clock\now;

/**
 * Paiement de l'abonnement annuel d'une unité (R-51, R-58).
 * Toutes les valeurs appliquées sont figées au moment du paiement (R-68, R-69).
 */
#[ORM\Entity]
#[ORM\Index(columns: ['statut'])]
class PaiementAbonnement
{
    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column]
    private ?int $id = null;

    #[ORM\ManyToOne(targetEntity: Unite::class)]
    #[ORM\JoinColumn(nullable: false)]
    private Unite $unite;

    #[ORM\ManyToOne(targetEntity: Contrat::class)]
    #[ORM\JoinColumn(nullable: false)]
    private Contrat $contrat;

    #[ORM\ManyToOne(targetEntity: User::class)]
    #[ORM\JoinColumn(nullable: false)]
    private User $payeur;

    #[ORM\Column(type: 'bigint')]
    private int $loyerMensuel;

    #[ORM\Column(length: 3)]
    private string $deviseCode;

    /** Pourcentage appliqué, en chaîne décimale (ex. "9.9"). */
    #[ORM\Column(length: 10)]
    private string $pourcentage;

    #[ORM\Column(type: 'bigint')]
    private int $montantDevise;

    /** Unités de la devise du contrat pour 1 USD, figé (R-69). */
    #[ORM\Column(length: 30)]
    private string $tauxUsd;

    #[ORM\Column(type: 'bigint')]
    private int $montantUsd;

    #[ORM\Column(length: 20, enumType: SourcePaiementAbonnement::class)]
    private SourcePaiementAbonnement $source;

    #[ORM\Column(length: 120, nullable: true)]
    private ?string $referenceTransaction;

    #[ORM\Column(length: 20, enumType: StatutPaiementAbonnement::class)]
    private StatutPaiementAbonnement $statut = StatutPaiementAbonnement::EnAttente;

    #[ORM\Column(length: 255, nullable: true)]
    private ?string $motifRejet = null;

    #[ORM\Column(type: 'date_immutable', nullable: true)]
    private ?\DateTimeImmutable $periodeDebut = null;

    #[ORM\Column(type: 'date_immutable', nullable: true)]
    private ?\DateTimeImmutable $periodeFin = null;

    #[ORM\ManyToOne(targetEntity: User::class)]
    private ?User $traitePar = null;

    #[ORM\Column(nullable: true)]
    private ?\DateTimeImmutable $traiteLe = null;

    #[ORM\Column]
    private \DateTimeImmutable $createdAt;

    public function __construct(Unite $unite, Contrat $contrat, User $payeur, int $loyerMensuel, string $deviseCode, string $pourcentage, int $montantDevise, string $tauxUsd, int $montantUsd, SourcePaiementAbonnement $source, ?string $referenceTransaction)
    {
        $this->unite = $unite;
        $this->contrat = $contrat;
        $this->payeur = $payeur;
        $this->loyerMensuel = $loyerMensuel;
        $this->deviseCode = $deviseCode;
        $this->pourcentage = $pourcentage;
        $this->montantDevise = $montantDevise;
        $this->tauxUsd = $tauxUsd;
        $this->montantUsd = $montantUsd;
        $this->source = $source;
        $this->referenceTransaction = $referenceTransaction;
        $this->createdAt = now();
    }

    public function getId(): ?int { return $this->id; }
    public function getUnite(): Unite { return $this->unite; }
    public function getContrat(): Contrat { return $this->contrat; }
    public function getPayeur(): User { return $this->payeur; }
    public function getLoyerMensuel(): int { return $this->loyerMensuel; }
    public function getDeviseCode(): string { return $this->deviseCode; }
    public function getPourcentage(): string { return $this->pourcentage; }
    public function getMontantDevise(): int { return $this->montantDevise; }
    public function getTauxUsd(): string { return $this->tauxUsd; }
    public function getMontantUsd(): int { return $this->montantUsd; }
    public function getSource(): SourcePaiementAbonnement { return $this->source; }
    public function getReferenceTransaction(): ?string { return $this->referenceTransaction; }
    public function getStatut(): StatutPaiementAbonnement { return $this->statut; }
    public function getMotifRejet(): ?string { return $this->motifRejet; }
    public function getPeriodeDebut(): ?\DateTimeImmutable { return $this->periodeDebut; }
    public function getPeriodeFin(): ?\DateTimeImmutable { return $this->periodeFin; }
    public function getCreatedAt(): \DateTimeImmutable { return $this->createdAt; }

    public function valider(\DateTimeImmutable $debut, \DateTimeImmutable $fin, ?User $par): void
    {
        $this->statut = StatutPaiementAbonnement::Valide;
        $this->periodeDebut = $debut;
        $this->periodeFin = $fin;
        $this->traitePar = $par;
        $this->traiteLe = now();
    }

    public function rejeter(string $motif, User $par): void
    {
        $this->statut = StatutPaiementAbonnement::Rejete;
        $this->motifRejet = $motif;
        $this->traitePar = $par;
        $this->traiteLe = now();
    }
}
