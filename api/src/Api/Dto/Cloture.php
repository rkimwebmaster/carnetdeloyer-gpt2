<?php

namespace App\Api\Dto;

use Symfony\Component\Validator\Constraints as Assert;

final class Cloture
{
    public function __construct(
        #[Assert\NotBlank, Assert\Date]
        public string $dateSortie = '',
        #[Assert\PositiveOrZero]
        public ?int $montantDerniereEcheance = null,
        #[Assert\Choice(choices: ['restituee', 'partiellement_retenue', 'imputee_sur_loyers'])]
        public ?string $garantie = null,
        #[Assert\PositiveOrZero]
        public int $montantRetenu = 0,
        #[Assert\Length(max: 255)]
        public ?string $motif = null,
    ) {
    }
}
