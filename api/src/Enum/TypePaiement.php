<?php

namespace App\Enum;

enum TypePaiement: string
{
    case Loyer = 'loyer';
    /** R-30 : la garantie a son propre reçu et n'entre jamais dans les loyers dus. */
    case Garantie = 'garantie';
}
