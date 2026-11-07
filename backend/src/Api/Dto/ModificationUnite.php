<?php

namespace App\Api\Dto;

use Symfony\Component\Validator\Constraints as Assert;

final class ModificationUnite
{
    public function __construct(
        #[Assert\Length(min: 1, max: 120)]
        public ?string $nom = null,
        #[Assert\Length(max: 40)]
        public ?string $categorie = null,
        #[Assert\PositiveOrZero]
        public ?int $loyerIndicatif = null,
        #[Assert\Length(exactly: 3)]
        public ?string $devise = null,
    ) {
    }
}
