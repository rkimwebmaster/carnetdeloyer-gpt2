<?php

namespace App\Service;

use App\Api\Dto\NouvellePropriete;
use App\Api\Dto\NouvelleUnite;
use App\Api\ErreurMetier;
use App\Entity\CategorieUnite;
use App\Entity\Devise;
use App\Entity\EspaceBailleur;
use App\Entity\PaysApi;
use App\Entity\Propriete;
use App\Entity\Unite;
use App\Entity\User;
use App\Entity\VilleApi;
use App\Enum\BadgeVerification;
use App\Enum\TypePropriete;
use Doctrine\ORM\EntityManagerInterface;
use Psr\Clock\ClockInterface;

/**
 * Propriétés et unités (R-10, R-16, R-98, R-107 à R-109).
 */
final class Biens
{
    public function __construct(
        private readonly EntityManagerInterface $em,
        private readonly ClockInterface $clock,
        private readonly Espaces $espaces,
        private readonly Abonnements $abonnements,
        private readonly Activites $activites,
    ) {
    }

    public function creerPropriete(User $user, NouvellePropriete $dto): Propriete
    {
        $espace = $this->espaces->obtenir($user);
        $type = TypePropriete::from($dto->type);
        // R-17 : le pays du compte sert de défaut à une nouvelle propriété.
        $pays = null !== $dto->paysId ? $this->em->find(PaysApi::class, $dto->paysId) : $user->getPays();
        if (null === $pays || !$pays->isActive()) {
            throw ErreurMetier::champ('paysId', 'PAYS_REQUIS', 'Indiquez le pays de la propriété.');
        }
        $propriete = new Propriete($espace, trim($dto->nom), $type, $pays);
        $propriete->setAdresse($dto->adresse)->setQuartier($dto->quartier)->setVille($this->ville($dto->villeId, $pays))
            ->setCoordonnees($dto->latitude, $dto->longitude);

        $unites = $dto->unites;
        if (TypePropriete::Simple === $type) {
            // R-10 : une propriété simple crée automatiquement son unité unique.
            $unites = [new NouvelleUnite($dto->nom, $dto->categorie ?? 'maison', $dto->loyerIndicatif, $dto->devise)];
        } elseif ([] === $unites) {
            throw ErreurMetier::champ('unites', 'UNITES_REQUISES', 'Ajoutez au moins une unité à l\'immeuble.');
        }

        return $this->em->wrapInTransaction(function () use ($propriete, $unites, $espace): Propriete {
            $this->em->persist($propriete);
            foreach ($unites as $u) {
                $this->ajouterUnite($propriete, $u, $espace);
            }
            $this->em->flush();

            return $propriete;
        });
    }

    public function ajouterUnite(Propriete $propriete, NouvelleUnite $dto, ?EspaceBailleur $espace = null): Unite
    {
        if (TypePropriete::Simple === $propriete->getType() && null !== $propriete->getId()
            && \count($this->em->getRepository(Unite::class)->findBy(['propriete' => $propriete])) >= 1) {
            throw new ErreurMetier('PROPRIETE_SIMPLE', 'Une propriété simple n\'a qu\'une unité.', 422);
        }
        $categorie = $this->categorie($dto->categorie, $espace ?? $propriete->getEspace());
        $unite = new Unite($propriete, trim($dto->nom), $categorie);
        $unite->setLoyerIndicatif($dto->loyerIndicatif, $this->deviseIndicative($dto->devise, $dto->loyerIndicatif, $propriete));
        $this->em->persist($unite);

        return $unite;
    }

    public function modifierUnite(Unite $unite, ?string $nom, ?string $categorie, ?int $loyer, ?string $devise): void
    {
        if (null !== $nom) {
            $unite->setNom(trim($nom));
        }
        if (null !== $categorie) {
            $unite->setCategorie($this->categorie($categorie, $unite->getEspace()));
        }
        if (null !== $loyer) {
            // R-16 : le loyer indicatif ne change aucun contrat existant.
            $unite->setLoyerIndicatif($loyer, $this->deviseIndicative($devise, $loyer, $unite->getPropriete()) ?? $unite->getDeviseIndicative());
        }
        $this->em->flush();
    }

    /**
     * R-107, R-108 : seul le propriétaire publie une unité vacante, gratuitement.
     * R-109 : coordonnées interdites dans la description.
     */
    public function publier(User $user, Unite $unite, ?string $description): void
    {
        if (null !== $this->abonnements->contratActif($unite)) {
            throw new ErreurMetier('UNITE_OCCUPEE', 'Seules les unités vacantes se publient sur le Market.', 409);
        }
        if ($unite->getCategorie()->isHotel()) {
            throw new ErreurMetier('CATEGORIE_HOTEL', 'Les chambres d\'hôtel apparaissent dans l\'onglet Hôtels.', 422);
        }
        $description = null === $description ? null : trim($description);
        if (null !== $description && FiltreCoordonnees::contient($description)) {
            throw ErreurMetier::champ('description', 'COORDONNEES_INTERDITES', 'Les numéros de téléphone et coordonnées sont interdits dans la description.');
        }
        $unite->publier($description ?: null);
        $this->activites->enregistrer(Activites::ANNONCE_PUBLIEE, $user, $unite->getEspace(), null, $unite, ['unite' => $unite->getNom()]);
        $this->em->flush();
    }

    private function categorie(string $code, EspaceBailleur $espace): CategorieUnite
    {
        $categorie = $this->em->getRepository(CategorieUnite::class)->findOneBy(['code' => $code, 'active' => true])
            ?? throw ErreurMetier::champ('categorie', 'CATEGORIE_INCONNUE', 'Catégorie d\'unité inconnue.');
        // R-98 : seules les entreprises vérifiées publient dans la catégorie Hôtels.
        if ($categorie->isHotel() && BadgeVerification::Entreprise !== $espace->getBadge($this->clock->now())) {
            throw ErreurMetier::champ('categorie', 'HOTEL_RESERVE_ENTREPRISES', 'La catégorie Hôtel est réservée aux entreprises vérifiées.');
        }

        return $categorie;
    }

    private function deviseIndicative(?string $code, ?int $loyer, Propriete $propriete): ?Devise
    {
        if (null === $loyer) {
            return null;
        }
        if (null === $code) {
            return $propriete->getPays()->getDeviseParDefaut()
                ?? throw ErreurMetier::champ('devise', 'DEVISE_REQUISE', 'Précisez la devise du loyer indicatif.');
        }
        $devise = $this->em->getRepository(Devise::class)->findOneBy(['code' => strtoupper($code)]);
        if (null === $devise || !$devise->isActive()) {
            throw ErreurMetier::champ('devise', 'DEVISE_INCONNUE', 'Devise inconnue ou désactivée.');
        }

        return $devise;
    }

    public function ville(?int $villeId, PaysApi $pays): ?VilleApi
    {
        if (null === $villeId) {
            return null;
        }
        $ville = $this->em->find(VilleApi::class, $villeId);
        if (null === $ville || !$ville->isActive() || $ville->getPays()->getId() !== $pays->getId()) {
            throw ErreurMetier::champ('villeId', 'VILLE_INCONNUE', 'Ville inconnue pour ce pays.');
        }

        return $ville;
    }
}
