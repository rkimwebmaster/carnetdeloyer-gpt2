<?php

namespace App\Api\Dto;

use Symfony\Component\Validator\Constraints as Assert;

final class Motif
{
    public function __construct(
        #[Assert\NotBlank, Assert\Length(max: 255)]
        public string $motif = '',
    ) {
    }
}
