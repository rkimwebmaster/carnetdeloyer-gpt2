<?php

namespace App\Securite;

/**
 * R-70 : le téléphone est l'identifiant principal, au format international E.164.
 */
final class Telephone
{
    /**
     * Retourne le numéro au format +XXXXXXXX, ou null s'il est invalide.
     */
    public static function normaliser(?string $saisie): ?string
    {
        if (null === $saisie) {
            return null;
        }
        $nettoye = preg_replace('/[\s\-\.\(\)]/', '', trim($saisie));
        if (str_starts_with($nettoye, '00')) {
            $nettoye = '+'.substr($nettoye, 2);
        }
        if (!preg_match('/^\+[1-9]\d{7,14}$/', $nettoye)) {
            return null;
        }

        return $nettoye;
    }
}
