<?php

namespace App\Enum;

/** R-170 */
enum BadgeVerification: string
{
    case Identite = 'identite_verifiee';
    case Entreprise = 'entreprise_verifiee';
}
