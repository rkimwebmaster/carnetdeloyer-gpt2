<?php

namespace App\Api\Dto;

use Symfony\Component\Validator\Constraints as Assert;

final class NouveauContrat
{
    public function __construct(
        #[Assert\NotNull, Assert\Positive]
        public ?int $uniteId = null,
        /** Contact existant, ou nouveau contact (nom + téléphone). */
        #[Assert\Positive]
        public ?int $contactId = null,
        #[Assert\Length(min: 2, max: 120)]
        public ?string $locataireNom = null,
        #[Assert\Length(max: 30)]
        public ?string $locataireTelephone = null,
        #[Assert\Length(exactly: 3)]
        public ?string $devise = null,
        /** Loyer mensuel en unité mineure (R-14). */
        #[Assert\NotNull, Assert\Positive]
        public ?int $loyer = null,
        #[Assert\NotBlank, Assert\Date]
        public string $dateDebut = '',
        #[Assert\Date]
        public ?string $dateFin = null,
        #[Assert\PositiveOrZero]
        public int $garantie = 0,
    ) {
    }
}
