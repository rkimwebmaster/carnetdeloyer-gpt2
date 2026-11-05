<?php

namespace App\Enum;

/** R-58 */
enum SourcePaiementAbonnement: string
{
    case Wallet = 'wallet';
    /** Référence de transaction mobile money saisie, validée dans le back-office. */
    case Manuel = 'manuel';
    case Agregateur = 'agregateur';
}
