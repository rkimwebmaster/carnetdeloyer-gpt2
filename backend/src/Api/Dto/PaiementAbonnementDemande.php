<?php

namespace App\Api\Dto;

use Symfony\Component\Validator\Constraints as Assert;

final class PaiementAbonnementDemande
{
    public function __construct(
        #[Assert\Choice(choices: ['wallet', 'manuel'])]
        public string $source = 'manuel',
        #[Assert\Length(max: 120)]
        public ?string $referenceTransaction = null,
    ) {
    }
}
