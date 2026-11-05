<?php

namespace App\Api\Dto;

use Symfony\Component\Validator\Constraints as Assert;

final class NouvelleDeclaration
{
    public function __construct(
        #[Assert\NotNull, Assert\Positive]
        public ?int $montant = null,
        #[Assert\NotBlank, Assert\Date]
        public string $datePaiement = '',
        #[Assert\Length(max: 120)]
        public ?string $reference = null,
    ) {
    }
}
