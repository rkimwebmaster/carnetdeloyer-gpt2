<?php

namespace App\Entity;

use Doctrine\ORM\Mapping as ORM;

use function Symfony\Component\Clock\now;

/**
 * R-115 : chaque action d'un administrateur est tracée (qui, quoi, quand).
 * Distinct du fil d'activité des utilisateurs (R-174).
 */
#[ORM\Entity]
#[ORM\Index(columns: ['created_at'])]
class JournalAudit
{
    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column]
    private ?int $id = null;

    #[ORM\ManyToOne(targetEntity: User::class)]
    #[ORM\JoinColumn(nullable: false)]
    private User $admin;

    #[ORM\Column(length: 60)]
    private string $action;

    /** @var array<string, scalar|null> */
    #[ORM\Column]
    private array $contexte;

    #[ORM\Column]
    private \DateTimeImmutable $createdAt;

    /** @param array<string, scalar|null> $contexte */
    public function __construct(User $admin, string $action, array $contexte)
    {
        $this->admin = $admin;
        $this->action = $action;
        $this->contexte = $contexte;
        $this->createdAt = now();
    }

    public function getId(): ?int { return $this->id; }
    public function getAdmin(): User { return $this->admin; }
    public function getAction(): string { return $this->action; }
    /** @return array<string, scalar|null> */
    public function getContexte(): array { return $this->contexte; }
    public function getCreatedAt(): \DateTimeImmutable { return $this->createdAt; }
}
