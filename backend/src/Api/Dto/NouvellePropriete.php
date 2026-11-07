<?php

namespace App\Api\Dto;

use Symfony\Component\Validator\Constraints as Assert;

final class NouvellePropriete
{
    /**
     * @param list<NouvelleUnite> $unites
     */
    public function __construct(
        #[Assert\NotBlank, Assert\Length(max: 120)]
        public string $nom = '',
        #[Assert\Choice(choices: ['simple', 'immeuble'])]
        public string $type = 'simple',
        #[Assert\Length(max: 255)]
        public ?string $adresse = null,
        #[Assert\Length(max: 120)]
        public ?string $quartier = null,
        #[Assert\Positive]
        public ?int $villeId = null,
        #[Assert\Positive]
        public ?int $paysId = null,
        #[Assert\Range(min: -90, max: 90)]
        public ?float $latitude = null,
        #[Assert\Range(min: -180, max: 180)]
        public ?float $longitude = null,
        /** Pour une propriété simple : catégorie et loyer de l'unité unique (R-10). */
        #[Assert\Length(max: 40)]
        public ?string $categorie = null,
        #[Assert\PositiveOrZero]
        public ?int $loyerIndicatif = null,
        #[Assert\Length(exactly: 3)]
        public ?string $devise = null,
        #[Assert\Valid, Assert\Count(max: 200)]
        public array $unites = [],
    ) {
    }
}
