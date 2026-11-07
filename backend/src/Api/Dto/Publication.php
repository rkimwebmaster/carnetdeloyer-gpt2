<?php

namespace App\Api\Dto;

use Symfony\Component\Validator\Constraints as Assert;

final class Publication
{
    public function __construct(
        #[Assert\Length(max: 500)]
        public ?string $description = null,
    ) {
    }
}
