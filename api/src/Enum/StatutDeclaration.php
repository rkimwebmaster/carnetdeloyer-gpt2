<?php

namespace App\Enum;

/** R-40 */
enum StatutDeclaration: string
{
    case EnAttente = 'en_attente';
    case Validee = 'validee';
    case Refusee = 'refusee';
}
