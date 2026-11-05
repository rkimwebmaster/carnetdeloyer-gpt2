<?php

namespace App\Enum;

/** R-06 : un paiement n'est jamais supprimé, seulement annulé. */
enum StatutPaiement: string
{
    case Valide = 'valide';
    case Annule = 'annule';
}
