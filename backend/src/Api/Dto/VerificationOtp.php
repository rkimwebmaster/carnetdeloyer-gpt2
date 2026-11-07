<?php

namespace App\Api\Dto;

use Symfony\Component\Validator\Constraints as Assert;

final class VerificationOtp
{
    public function __construct(
        #[Assert\NotBlank]
        public string $telephone = '',
        #[Assert\NotBlank, Assert\Regex('/^\d{6}$/')]
        public string $code = '',
    ) {
    }
}
