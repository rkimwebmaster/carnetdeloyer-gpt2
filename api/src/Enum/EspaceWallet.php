<?php

namespace App\Enum;

/** R-147 : chaque écriture est étiquetée par espace. */
enum EspaceWallet: string
{
    case Bailleur = 'bailleur';
    case Locataire = 'locataire';
}
