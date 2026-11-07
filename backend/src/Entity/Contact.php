<?php

namespace App\Entity;

use Doctrine\ORM\Mapping as ORM;

use function Symfony\Component\Clock\now;

/**
 * R-19 : le locataire d'un contrat est un Contact (nom, téléphone, utilisateur
 * rattaché s'il s'inscrit), distinct de l'Utilisateur (R-02).
 */
#[ORM\Entity]
#[ORM\Index(columns: ['telephone_empreinte'])]
class Contact
{
    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column]
    private ?int $id = null;

    #[ORM\ManyToOne(targetEntity: EspaceBailleur::class)]
    #[ORM\JoinColumn(nullable: false)]
    private EspaceBailleur $espace;

    #[ORM\Column(length: 120)]
    private string $nom;

    #[ORM\Column(type: 'chiffre', nullable: true)]
    private ?string $telephone = null;

    #[ORM\Column(length: 64, nullable: true)]
    private ?string $telephoneEmpreinte = null;

    /** R-72 : rattaché après confirmation par le locataire. */
    #[ORM\ManyToOne(targetEntity: User::class)]
    private ?User $utilisateur = null;

    #[ORM\Column]
    private \DateTimeImmutable $createdAt;

    public function __construct(EspaceBailleur $espace, string $nom)
    {
        $this->espace = $espace;
        $this->nom = $nom;
        $this->createdAt = now();
    }

    public function getId(): ?int { return $this->id; }
    public function getEspace(): EspaceBailleur { return $this->espace; }
    public function getNom(): string { return $this->nom; }
    public function setNom(string $nom): static { $this->nom = $nom; return $this; }
    public function getTelephone(): ?string { return $this->telephone; }
    public function getTelephoneEmpreinte(): ?string { return $this->telephoneEmpreinte; }

    /**
     * R-72 : si le bailleur change le numéro, l'ancien titulaire perd l'accès.
     */
    public function changerTelephone(?string $telephone, ?string $empreinte): void
    {
        if ($empreinte !== $this->telephoneEmpreinte) {
            $this->utilisateur = null;
        }
        $this->telephone = $telephone;
        $this->telephoneEmpreinte = $empreinte;
    }

    public function getUtilisateur(): ?User { return $this->utilisateur; }
    public function rattacher(User $user): void { $this->utilisateur = $user; }
}
