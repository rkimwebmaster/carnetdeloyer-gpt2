<?php

namespace App\Enum;

/** R-03 : l'app enregistre des paiements faits ailleurs. */
enum MoyenPaiement: string
{
    case Especes = 'especes';
    case MobileMoney = 'mobile_money';
    case Virement = 'virement';
    case Autre = 'autre';
    /** R-32 : garantie imputée sur loyers impayés à la clôture. */
    case Garantie = 'garantie';
}
