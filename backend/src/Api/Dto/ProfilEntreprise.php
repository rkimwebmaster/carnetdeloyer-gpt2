<?php

namespace App\Api\Dto;

use Symfony\Component\Validator\Constraints as Assert;

final class ProfilEntreprise
{
    public function __construct(
        #[Assert\Length(max: 160)]
        public ?string $raisonSociale = null,
        #[Assert\Length(max: 80)]
        public ?string $numeroRccm = null,
        #[Assert\Length(max: 255)]
        public ?string $adresse = null,
    ) {
    }
}
