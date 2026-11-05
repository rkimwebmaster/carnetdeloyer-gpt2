<?php

namespace App\Entity;

use Doctrine\ORM\Mapping as ORM;

use function Symfony\Component\Clock\now;

/**
 * R-172 : fil d'activité créé par le serveur. Le texte est traduit côté app
 * à partir du type (code) et des paramètres (R-173).
 */
#[ORM\Entity]
#[ORM\Index(columns: ['created_at'])]
class Activite
{
    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column]
    private ?int $id = null;

    #[ORM\ManyToOne(targetEntity: User::class)]
    private ?User $acteur;

    /** Visible en mode bailleur par le propriétaire de l'espace. */
    #[ORM\ManyToOne(targetEntity: EspaceBailleur::class)]
    private ?EspaceBailleur $espace;

    /** Visible en mode locataire par le locataire rattaché au contrat. */
    #[ORM\ManyToOne(targetEntity: Contrat::class)]
    private ?Contrat $contrat;

    /** Pour les activités personnelles (gain de parrainage...). */
    #[ORM\ManyToOne(targetEntity: User::class)]
    private ?User $destinataire;

    #[ORM\Column(length: 50)]
    private string $type;

    #[ORM\Column(length: 40, nullable: true)]
    private ?string $objetType;

    #[ORM\Column(nullable: true)]
    private ?int $objetId;

    /** @var array<string, scalar|null> */
    #[ORM\Column]
    private array $parametres;

    #[ORM\Column]
    private \DateTimeImmutable $createdAt;

    /**
     * @param array<string, scalar|null> $parametres
     */
    public function __construct(string $type, ?User $acteur, ?EspaceBailleur $espace, ?Contrat $contrat, ?string $objetType, ?int $objetId, array $parametres = [], ?User $destinataire = null)
    {
        $this->type = $type;
        $this->acteur = $acteur;
        $this->espace = $espace;
        $this->contrat = $contrat;
        $this->objetType = $objetType;
        $this->objetId = $objetId;
        $this->parametres = $parametres;
        $this->destinataire = $destinataire;
        $this->createdAt = now();
    }

    public function getId(): ?int { return $this->id; }
    public function getActeur(): ?User { return $this->acteur; }
    public function getEspace(): ?EspaceBailleur { return $this->espace; }
    public function getContrat(): ?Contrat { return $this->contrat; }
    public function getType(): string { return $this->type; }
    public function getObjetType(): ?string { return $this->objetType; }
    public function getObjetId(): ?int { return $this->objetId; }
    /** @return array<string, scalar|null> */
    public function getParametres(): array { return $this->parametres; }
    public function getCreatedAt(): \DateTimeImmutable { return $this->createdAt; }
}
