<?php

namespace App\Enum;

enum TypePropriete: string
{
    /** R-10 : une seule maison, unité unique créée automatiquement. */
    case Simple = 'simple';
    case Immeuble = 'immeuble';
}
