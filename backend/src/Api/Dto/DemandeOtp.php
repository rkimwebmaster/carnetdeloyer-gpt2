<?php

namespace App\Api\Dto;

use Symfony\Component\Validator\Constraints as Assert;

final class DemandeOtp
{
    public function __construct(
        #[Assert\NotBlank]
        public string $telephone = '',
    ) {
    }
}
