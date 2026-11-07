<?php

namespace App\Entity;

use Doctrine\ORM\Mapping as ORM;

use function Symfony\Component\Clock\now;

/**
 * Part d'un paiement affectée à une échéance (R-27). Une imputation n'est pas
 * effacée lors d'un recalcul : elle est désactivée (historique conservé).
 */
#[ORM\Entity]
#[ORM\Index(columns: ['active'])]
class Imputation
{
    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column]
    private ?int $id = null;

    #[ORM\ManyToOne(targetEntity: Paiement::class)]
    #[ORM\JoinColumn(nullable: false)]
    private Paiement $paiement;

    #[ORM\ManyToOne(targetEntity: Echeance::class)]
    #[ORM\JoinColumn(nullable: false)]
    private Echeance $echeance;

    #[ORM\Column(type: 'bigint')]
    private int $montant;

    #[ORM\Column]
    private bool $active = true;

    #[ORM\Column]
    private \DateTimeImmutable $createdAt;

    public function __construct(Paiement $paiement, Echeance $echeance, int $montant)
    {
        $this->paiement = $paiement;
        $this->echeance = $echeance;
        $this->montant = $montant;
        $this->createdAt = now();
    }

    public function getId(): ?int { return $this->id; }
    public function getPaiement(): Paiement { return $this->paiement; }
    public function getEcheance(): Echeance { return $this->echeance; }
    public function getMontant(): int { return $this->montant; }
    public function isActive(): bool { return $this->active; }
    public function desactiver(): void { $this->active = false; }
}
