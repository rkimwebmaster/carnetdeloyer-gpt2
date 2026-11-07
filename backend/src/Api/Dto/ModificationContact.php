<?php

namespace App\Api\Dto;

use Symfony\Component\Validator\Constraints as Assert;

final class ModificationContact
{
    public function __construct(
        #[Assert\Length(min: 2, max: 120)]
        public ?string $nom = null,
        #[Assert\Length(max: 30)]
        public ?string $telephone = null,
    ) {
    }
}
