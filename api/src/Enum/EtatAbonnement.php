<?php

namespace App\Enum;

/** R-50 à R-57 : état calculé de l'abonnement d'une unité. */
enum EtatAbonnement: string
{
    /** R-52 : unité vacante, non facturée. */
    case NonFacture = 'non_facture';
    case Gratuit = 'gratuit';
    case Actif = 'actif';
    /** R-55 : échu, dans les 15 jours de grâce. */
    case Grace = 'grace';
    /** R-56 : lecture seule. */
    case Suspendu = 'suspendu';
}
