<?php

namespace App\Entity;

use Doctrine\ORM\Mapping as ORM;

use function Symfony\Component\Clock\now;

/** R-67 : dérogation d'un paramètre pour un compte. */
#[ORM\Entity]
#[ORM\UniqueConstraint(name: 'unique_derogation', columns: ['user_id', 'cle'])]
class DerogationParametre
{
    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column]
    private ?int $id = null;

    #[ORM\ManyToOne(targetEntity: User::class)]
    #[ORM\JoinColumn(nullable: false)]
    private User $user;

    #[ORM\Column(length: 60)]
    private string $cle;

    #[ORM\Column(length: 60)]
    private string $valeur;

    #[ORM\Column]
    private \DateTimeImmutable $createdAt;

    public function __construct(User $user, string $cle, string $valeur)
    {
        $this->user = $user;
        $this->cle = $cle;
        $this->valeur = $valeur;
        $this->createdAt = now();
    }

    public function getUser(): User { return $this->user; }
    public function getCle(): string { return $this->cle; }
    public function getValeur(): string { return $this->valeur; }
    public function setValeur(string $valeur): void { $this->valeur = $valeur; }
}
