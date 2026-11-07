<?php

namespace App\Api\Dto;

use Symfony\Component\Validator\Constraints as Assert;

final class NouvelleUnite
{
    public function __construct(
        #[Assert\NotBlank, Assert\Length(max: 120)]
        public string $nom = '',
        #[Assert\NotBlank, Assert\Length(max: 40)]
        public string $categorie = '',
        #[Assert\PositiveOrZero]
        public ?int $loyerIndicatif = null,
        #[Assert\Length(exactly: 3)]
        public ?string $devise = null,
    ) {
    }
}
