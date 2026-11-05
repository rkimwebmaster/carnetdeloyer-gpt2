<?php

namespace App\Entity;

use App\Enum\ModeUtilisateur;
use Doctrine\ORM\Mapping as ORM;
use Symfony\Component\Security\Core\User\UserInterface;

use function Symfony\Component\Clock\now;

/**
 * R-09, R-70 : personne qui se connecte, identifiée par son téléphone.
 * Le téléphone est chiffré en base ; l'empreinte permet de le retrouver (R-124).
 */
#[ORM\Entity]
#[ORM\Table(name: '`user`')]
class User implements UserInterface
{
    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column]
    private ?int $id = null;

    #[ORM\Column(type: 'chiffre', nullable: true)]
    private ?string $telephone;

    #[ORM\Column(length: 64, unique: true, nullable: true)]
    private ?string $telephoneEmpreinte;

    #[ORM\Column(length: 120)]
    private string $nom;

    #[ORM\Column(length: 180, nullable: true)]
    private ?string $email = null;

    /** R-17 : rempli depuis l'indicatif du téléphone, modifiable. */
    #[ORM\ManyToOne(targetEntity: PaysApi::class)]
    private ?PaysApi $pays = null;

    #[ORM\ManyToOne(targetEntity: VilleApi::class)]
    private ?VilleApi $ville = null;

    /** R-144 : dernière préférence, sans effet sur les droits. */
    #[ORM\Column(length: 20, nullable: true, enumType: ModeUtilisateur::class)]
    private ?ModeUtilisateur $modePrefere = null;

    #[ORM\Column(length: 12, unique: true)]
    private string $codeParrainage;

    #[ORM\ManyToOne(targetEntity: User::class)]
    private ?User $parrain = null;

    /** @var list<string> */
    #[ORM\Column]
    private array $roles = [];

    #[ORM\Column]
    private bool $actif = true;

    #[ORM\Column]
    private \DateTimeImmutable $createdAt;

    /** R-122 : compte supprimé, données personnelles anonymisées. */
    #[ORM\Column(nullable: true)]
    private ?\DateTimeImmutable $anonymiseLe = null;

    public function __construct(string $telephone, string $telephoneEmpreinte, string $nom, string $codeParrainage)
    {
        $this->telephone = $telephone;
        $this->telephoneEmpreinte = $telephoneEmpreinte;
        $this->nom = $nom;
        $this->codeParrainage = $codeParrainage;
        $this->createdAt = now();
    }

    public function getId(): ?int { return $this->id; }
    public function getTelephone(): ?string { return $this->telephone; }
    public function getNom(): string { return $this->nom; }
    public function setNom(string $nom): static { $this->nom = $nom; return $this; }
    public function getEmail(): ?string { return $this->email; }
    public function setEmail(?string $email): static { $this->email = $email; return $this; }
    public function getPays(): ?PaysApi { return $this->pays; }
    public function setPays(?PaysApi $pays): static { $this->pays = $pays; return $this; }
    public function getVille(): ?VilleApi { return $this->ville; }
    public function setVille(?VilleApi $ville): static { $this->ville = $ville; return $this; }
    public function getModePrefere(): ?ModeUtilisateur { return $this->modePrefere; }
    public function setModePrefere(?ModeUtilisateur $mode): static { $this->modePrefere = $mode; return $this; }
    public function getCodeParrainage(): string { return $this->codeParrainage; }
    public function getParrain(): ?User { return $this->parrain; }
    public function setParrain(?User $parrain): static { $this->parrain = $parrain; return $this; }
    public function isActif(): bool { return $this->actif; }
    public function setActif(bool $actif): static { $this->actif = $actif; return $this; }
    public function getCreatedAt(): \DateTimeImmutable { return $this->createdAt; }
    public function getAnonymiseLe(): ?\DateTimeImmutable { return $this->anonymiseLe; }

    public function anonymiser(): void
    {
        $this->telephone = null;
        $this->telephoneEmpreinte = null;
        $this->email = null;
        $this->nom = 'Compte supprimé';
        $this->actif = false;
        $this->anonymiseLe = now();
    }

    public function getRoles(): array
    {
        return array_values(array_unique([...$this->roles, 'ROLE_USER']));
    }

    /** @param list<string> $roles */
    public function setRoles(array $roles): static { $this->roles = $roles; return $this; }

    public function getUserIdentifier(): string
    {
        return (string) $this->id;
    }

    public function eraseCredentials(): void
    {
    }
}
