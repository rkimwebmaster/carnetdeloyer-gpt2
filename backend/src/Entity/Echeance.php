<?php

namespace App\Entity;

use App\Enum\StatutEcheance;
use Doctrine\ORM\Mapping as ORM;

/**
 * Montant dû pour une période (R-21). Le statut est calculé (R-22).
 * $montantPaye est la somme des imputations actives, tenue à jour par l'imputation.
 */
#[ORM\Entity]
#[ORM\UniqueConstraint(name: 'unique_echeance_periode', columns: ['contrat_id', 'periode_debut'])]
#[ORM\Index(columns: ['date_exigible'])]
class Echeance
{
    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column]
    private ?int $id = null;

    #[ORM\ManyToOne(targetEntity: Contrat::class)]
    #[ORM\JoinColumn(nullable: false)]
    private Contrat $contrat;

    #[ORM\Column(type: 'date_immutable')]
    private \DateTimeImmutable $periodeDebut;

    #[ORM\Column(type: 'date_immutable')]
    private \DateTimeImmutable $periodeFin;

    /** Loyer payable d'avance : exigible au début de la période. */
    #[ORM\Column(type: 'date_immutable')]
    private \DateTimeImmutable $dateExigible;

    #[ORM\Column(type: 'bigint')]
    private int $montantDu;

    #[ORM\Column(type: 'bigint')]
    private int $montantPaye = 0;

    /** R-37 : échéances postérieures à la sortie annulées. */
    #[ORM\Column]
    private bool $annulee = false;

    public function __construct(Contrat $contrat, \DateTimeImmutable $periodeDebut, \DateTimeImmutable $periodeFin, int $montantDu)
    {
        $this->contrat = $contrat;
        $this->periodeDebut = $periodeDebut;
        $this->periodeFin = $periodeFin;
        $this->dateExigible = $periodeDebut;
        $this->montantDu = $montantDu;
    }

    public function getId(): ?int { return $this->id; }
    public function getContrat(): Contrat { return $this->contrat; }
    public function getPeriodeDebut(): \DateTimeImmutable { return $this->periodeDebut; }
    public function getPeriodeFin(): \DateTimeImmutable { return $this->periodeFin; }
    public function getDateExigible(): \DateTimeImmutable { return $this->dateExigible; }
    public function getMontantDu(): int { return $this->montantDu; }
    public function setMontantDu(int $montant): void { $this->montantDu = $montant; }
    public function getMontantPaye(): int { return $this->montantPaye; }
    public function setMontantPaye(int $montant): void { $this->montantPaye = $montant; }
    public function isAnnulee(): bool { return $this->annulee; }
    public function annuler(): void { $this->annulee = true; }

    public function getRestantDu(): int
    {
        return $this->annulee ? 0 : max(0, $this->montantDu - $this->montantPaye);
    }

    public function statut(\DateTimeImmutable $aujourdhui): StatutEcheance
    {
        if ($this->annulee) {
            return StatutEcheance::Annulee;
        }
        if ($this->montantPaye >= $this->montantDu) {
            return StatutEcheance::Payee;
        }
        if ($this->dateExigible < $aujourdhui->setTime(0, 0)) {
            return StatutEcheance::EnRetard;
        }

        return $this->montantPaye > 0 ? StatutEcheance::Partielle : StatutEcheance::AVenir;
    }
}
