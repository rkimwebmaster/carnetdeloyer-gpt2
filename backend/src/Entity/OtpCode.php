<?php

namespace App\Entity;

use Doctrine\ORM\Mapping as ORM;

use function Symfony\Component\Clock\now;

/**
 * R-71 : code OTP envoyé par SMS. Seule l'empreinte du code est stockée.
 * Après vérification d'un numéro inconnu, un jeton d'inscription court est émis
 * pour finir l'inscription (nom, code parrain) sans renvoyer d'OTP (R-160).
 */
#[ORM\Entity]
#[ORM\Index(columns: ['telephone_empreinte'])]
class OtpCode
{
    public const MAX_TENTATIVES = 5;

    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column]
    private ?int $id = null;

    #[ORM\Column(length: 64)]
    private string $telephoneEmpreinte;

    #[ORM\Column(length: 255)]
    private string $codeHash;

    #[ORM\Column]
    private \DateTimeImmutable $expireLe;

    #[ORM\Column]
    private int $tentatives = 0;

    #[ORM\Column(nullable: true)]
    private ?\DateTimeImmutable $utiliseLe = null;

    #[ORM\Column(length: 64, nullable: true, unique: true)]
    private ?string $jetonInscriptionHash = null;

    #[ORM\Column(nullable: true)]
    private ?\DateTimeImmutable $jetonExpireLe = null;

    #[ORM\Column]
    private \DateTimeImmutable $createdAt;

    public function __construct(string $telephoneEmpreinte, string $codeHash, \DateTimeImmutable $expireLe)
    {
        $this->telephoneEmpreinte = $telephoneEmpreinte;
        $this->codeHash = $codeHash;
        $this->expireLe = $expireLe;
        $this->createdAt = now();
    }

    public function getTelephoneEmpreinte(): string { return $this->telephoneEmpreinte; }
    public function getCodeHash(): string { return $this->codeHash; }
    public function getExpireLe(): \DateTimeImmutable { return $this->expireLe; }
    public function getTentatives(): int { return $this->tentatives; }
    public function incrementerTentatives(): void { ++$this->tentatives; }
    public function getUtiliseLe(): ?\DateTimeImmutable { return $this->utiliseLe; }
    public function marquerUtilise(): void { $this->utiliseLe = now(); }
    public function getJetonExpireLe(): ?\DateTimeImmutable { return $this->jetonExpireLe; }

    public function emettreJetonInscription(string $jetonHash, \DateTimeImmutable $expireLe): void
    {
        $this->jetonInscriptionHash = $jetonHash;
        $this->jetonExpireLe = $expireLe;
    }

    public function consommerJeton(): void
    {
        $this->jetonInscriptionHash = null;
        $this->jetonExpireLe = null;
    }
}
