<?php

namespace App\Api\Dto;

use Symfony\Component\Validator\Constraints as Assert;

final class Inscription
{
    public function __construct(
        #[Assert\NotBlank]
        public string $telephone = '',
        #[Assert\NotBlank]
        public string $jetonInscription = '',
        #[Assert\NotBlank, Assert\Length(min: 2, max: 120)]
        public string $nom = '',
        #[Assert\Length(max: 12)]
        public ?string $codeParrain = null,
    ) {
    }
}
