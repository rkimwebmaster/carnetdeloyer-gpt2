<?php

namespace App\Entity;

use App\Enum\StatutContrat;
use App\Enum\StatutGarantie;
use Doctrine\ORM\Mapping as ORM;

use function Symfony\Component\Clock\now;

/**
 * Location d'une unité. Une seule devise (R-20), un montant propre (R-16),
 * un locataire titulaire (R-12), une date de fin optionnelle (R-28).
 */
#[ORM\Entity]
#[ORM\Index(columns: ['statut'])]
class Contrat
{
    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column]
    private ?int $id = null;

    #[ORM\ManyToOne(targetEntity: Unite::class)]
    #[ORM\JoinColumn(nullable: false)]
    private Unite $unite;

    #[ORM\ManyToOne(targetEntity: Contact::class)]
    #[ORM\JoinColumn(nullable: false)]
    private Contact $locataire;

    #[ORM\ManyToOne(targetEntity: Devise::class)]
    #[ORM\JoinColumn(nullable: false)]
    private Devise $devise;

    /** Loyer mensuel en unité mineure (R-14). */
    #[ORM\Column(type: 'bigint')]
    private int $loyer;

    #[ORM\Column(type: 'date_immutable')]
    private \DateTimeImmutable $dateDebut;

    #[ORM\Column(type: 'date_immutable', nullable: true)]
    private ?\DateTimeImmutable $dateFin = null;

    #[ORM\Column(length: 20, enumType: StatutContrat::class)]
    private StatutContrat $statut = StatutContrat::Actif;

    // R-30, R-32 : garantie à part.
    #[ORM\Column(type: 'bigint')]
    private int $garantieMontant = 0;

    #[ORM\Column(length: 30, enumType: StatutGarantie::class)]
    private StatutGarantie $garantieStatut = StatutGarantie::Aucune;

    #[ORM\Column(type: 'bigint')]
    private int $garantieRetenue = 0;

    #[ORM\Column(length: 255, nullable: true)]
    private ?string $garantieMotif = null;

    // R-37 : clôture.
    #[ORM\Column(type: 'date_immutable', nullable: true)]
    private ?\DateTimeImmutable $dateSortie = null;

    #[ORM\Column(nullable: true)]
    private ?\DateTimeImmutable $clotureLe = null;

    #[ORM\ManyToOne(targetEntity: User::class)]
    #[ORM\JoinColumn(nullable: false)]
    private User $creePar;

    #[ORM\Column]
    private \DateTimeImmutable $createdAt;

    public function __construct(Unite $unite, Contact $locataire, Devise $devise, int $loyer, \DateTimeImmutable $dateDebut, ?\DateTimeImmutable $dateFin, User $creePar)
    {
        $this->unite = $unite;
        $this->locataire = $locataire;
        $this->devise = $devise;
        $this->loyer = $loyer;
        $this->dateDebut = $dateDebut;
        $this->dateFin = $dateFin;
        $this->creePar = $creePar;
        $this->createdAt = now();
    }

    public function getId(): ?int { return $this->id; }
    public function getUnite(): Unite { return $this->unite; }
    public function getEspace(): EspaceBailleur { return $this->unite->getEspace(); }
    public function getLocataire(): Contact { return $this->locataire; }
    public function getDevise(): Devise { return $this->devise; }
    public function getLoyer(): int { return $this->loyer; }
    public function getDateDebut(): \DateTimeImmutable { return $this->dateDebut; }
    public function getDateFin(): ?\DateTimeImmutable { return $this->dateFin; }
    public function getStatut(): StatutContrat { return $this->statut; }
    public function isActif(): bool { return StatutContrat::Actif === $this->statut; }
    public function getCreePar(): User { return $this->creePar; }
    public function getCreatedAt(): \DateTimeImmutable { return $this->createdAt; }

    public function getGarantieMontant(): int { return $this->garantieMontant; }
    public function getGarantieStatut(): StatutGarantie { return $this->garantieStatut; }
    public function getGarantieRetenue(): int { return $this->garantieRetenue; }
    public function getGarantieMotif(): ?string { return $this->garantieMotif; }

    public function prevoirGarantie(int $montant): void
    {
        $this->garantieMontant = $montant;
        $this->garantieStatut = $montant > 0 ? StatutGarantie::Attendue : StatutGarantie::Aucune;
    }

    public function garantieRecue(): void
    {
        $this->garantieStatut = StatutGarantie::Detenue;
    }

    public function garantieAnnulee(): void
    {
        $this->garantieStatut = $this->garantieMontant > 0 ? StatutGarantie::Attendue : StatutGarantie::Aucune;
    }

    public function reglerGarantie(StatutGarantie $statut, int $retenue = 0, ?string $motif = null): void
    {
        $this->garantieStatut = $statut;
        $this->garantieRetenue = $retenue;
        $this->garantieMotif = $motif;
    }

    public function getDateSortie(): ?\DateTimeImmutable { return $this->dateSortie; }
    public function getClotureLe(): ?\DateTimeImmutable { return $this->clotureLe; }

    public function cloturer(\DateTimeImmutable $dateSortie): void
    {
        $this->dateSortie = $dateSortie;
        $this->statut = StatutContrat::Cloture;
        $this->clotureLe = now();
    }
}
