<?php

namespace App\Api\Dto;

use Symfony\Component\Validator\Constraints as Assert;

final class NouveauPaiement
{
    public function __construct(
        /** Unité mineure de la devise du contrat (R-14, R-20). */
        #[Assert\NotNull, Assert\Positive]
        public ?int $montant = null,
        #[Assert\NotBlank, Assert\Date]
        public string $datePaiement = '',
        #[Assert\Choice(choices: ['especes', 'mobile_money', 'virement', 'autre'])]
        public string $moyen = 'especes',
        #[Assert\Length(max: 120)]
        public ?string $reference = null,
        /** R-137 : UUID généré par le téléphone. */
        #[Assert\NotBlank, Assert\Uuid]
        public string $cleIdempotence = '',
        #[Assert\Choice(choices: ['loyer', 'garantie'])]
        public string $type = 'loyer',
    ) {
    }
}
