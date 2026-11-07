<?php

namespace App\Enum;

enum StatutPaiementAbonnement: string
{
    case EnAttente = 'en_attente';
    case Valide = 'valide';
    case Rejete = 'rejete';
}
