<?php

namespace App\Entity;

use Doctrine\ORM\Mapping as ORM;

use function Symfony\Component\Clock\now;

/**
 * R-101 : consultation et contact sur le Market toujours tracés. Prépare
 * l'entité Déblocage (R-106).
 */
#[ORM\Entity]
#[ORM\Index(columns: ['created_at'])]
class TraceMarket
{
    public const CONSULTATION = 'consultation';
    public const CONTACT = 'contact';

    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column]
    private ?int $id = null;

    #[ORM\ManyToOne(targetEntity: User::class)]
    #[ORM\JoinColumn(nullable: false)]
    private User $user;

    #[ORM\ManyToOne(targetEntity: Unite::class)]
    private ?Unite $unite;

    #[ORM\ManyToOne(targetEntity: Propriete::class)]
    private ?Propriete $propriete;

    #[ORM\Column(length: 20)]
    private string $action;

    #[ORM\Column]
    private \DateTimeImmutable $createdAt;

    public function __construct(User $user, string $action, ?Unite $unite = null, ?Propriete $propriete = null)
    {
        $this->user = $user;
        $this->action = $action;
        $this->unite = $unite;
        $this->propriete = $propriete;
        $this->createdAt = now();
    }

    public function getId(): ?int { return $this->id; }
    public function getAction(): string { return $this->action; }
}
