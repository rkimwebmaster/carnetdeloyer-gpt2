<?php

namespace App\Api\Dto;

use Symfony\Component\Validator\Constraints as Assert;

final class ModificationProfil
{
    public function __construct(
        #[Assert\Length(min: 2, max: 120)]
        public ?string $nom = null,
        #[Assert\Email, Assert\Length(max: 180)]
        public ?string $email = null,
        #[Assert\Choice(choices: ['bailleur', 'locataire'])]
        public ?string $modePrefere = null,
        #[Assert\Positive]
        public ?int $paysId = null,
        #[Assert\Positive]
        public ?int $villeId = null,
    ) {
    }
}
