<?php

namespace App\Api\Dto;

use Symfony\Component\Validator\Constraints as Assert;

final class Reimputation
{
    /**
     * @param list<array{echeanceId: int, montant: int}> $imputations
     */
    public function __construct(
        #[Assert\NotNull, Assert\Count(min: 1), Assert\All([
            new Assert\Collection([
                'echeanceId' => [new Assert\NotNull(), new Assert\Type('int'), new Assert\Positive()],
                'montant' => [new Assert\NotNull(), new Assert\Type('int'), new Assert\PositiveOrZero()],
            ]),
        ])]
        public array $imputations = [],
    ) {
    }
}
