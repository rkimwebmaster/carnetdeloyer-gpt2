<?php

namespace App\Entity;

use Doctrine\ORM\Mapping as ORM;

use function Symfony\Component\Clock\now;

/**
 * Preuve d'un paiement : numéro séquentiel sans trou par espace (R-33),
 * jamais supprimé, annulé en gardant son numéro (R-34). Le jeton forme le
 * lien public non devinable (R-75).
 */
#[ORM\Entity]
#[ORM\UniqueConstraint(name: 'unique_recu_numero', columns: ['espace_id', 'numero'])]
class Recu
{
    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column]
    private ?int $id = null;

    #[ORM\OneToOne(targetEntity: Paiement::class)]
    #[ORM\JoinColumn(nullable: false, unique: true)]
    private Paiement $paiement;

    #[ORM\ManyToOne(targetEntity: EspaceBailleur::class)]
    #[ORM\JoinColumn(nullable: false)]
    private EspaceBailleur $espace;

    #[ORM\Column]
    private int $sequence;

    #[ORM\Column(length: 30)]
    private string $numero;

    #[ORM\Column(length: 64, unique: true)]
    private string $jeton;

    #[ORM\Column]
    private bool $annule = false;

    #[ORM\Column]
    private \DateTimeImmutable $emisLe;

    public function __construct(Paiement $paiement, EspaceBailleur $espace, int $sequence, string $numero, string $jeton)
    {
        $this->paiement = $paiement;
        $this->espace = $espace;
        $this->sequence = $sequence;
        $this->numero = $numero;
        $this->jeton = $jeton;
        $this->emisLe = now();
    }

    public function getId(): ?int { return $this->id; }
    public function getPaiement(): Paiement { return $this->paiement; }
    public function getEspace(): EspaceBailleur { return $this->espace; }
    public function getSequence(): int { return $this->sequence; }
    public function getNumero(): string { return $this->numero; }
    public function getJeton(): string { return $this->jeton; }
    public function isAnnule(): bool { return $this->annule; }
    public function annuler(): void { $this->annule = true; }
    public function getEmisLe(): \DateTimeImmutable { return $this->emisLe; }
}
