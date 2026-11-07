<?php

namespace App\Enum;

/** R-30, R-32 */
enum StatutGarantie: string
{
    case Aucune = 'aucune';
    case Attendue = 'attendue';
    case Detenue = 'detenue';
    case Restituee = 'restituee';
    case PartiellementRetenue = 'partiellement_retenue';
    case ImputeeSurLoyers = 'imputee_sur_loyers';
}
