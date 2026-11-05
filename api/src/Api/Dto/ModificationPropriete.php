<?php

namespace App\Api\Dto;

use Symfony\Component\Validator\Constraints as Assert;

final class ModificationPropriete
{
    public function __construct(
        #[Assert\Length(min: 1, max: 120)]
        public ?string $nom = null,
        #[Assert\Length(max: 255)]
        public ?string $adresse = null,
        #[Assert\Length(max: 120)]
        public ?string $quartier = null,
        #[Assert\Positive]
        public ?int $villeId = null,
        #[Assert\Range(min: -90, max: 90)]
        public ?float $latitude = null,
        #[Assert\Range(min: -180, max: 180)]
        public ?float $longitude = null,
    ) {
    }
}
