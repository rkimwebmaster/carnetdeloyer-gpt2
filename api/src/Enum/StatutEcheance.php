<?php

namespace App\Enum;

/** R-22 : statuts calculés, jamais stockés. */
enum StatutEcheance: string
{
    case AVenir = 'a_venir';
    case Payee = 'payee';
    case Partielle = 'partielle';
    case EnRetard = 'en_retard';
    case Annulee = 'annulee';
}
