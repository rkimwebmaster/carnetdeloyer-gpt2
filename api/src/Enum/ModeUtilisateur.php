<?php

namespace App\Enum;

/** R-144 : énumération extensible des modes. */
enum ModeUtilisateur: string
{
    case Bailleur = 'bailleur';
    case Locataire = 'locataire';
}
