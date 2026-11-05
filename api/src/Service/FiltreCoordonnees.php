<?php

namespace App\Service;

/**
 * R-86, R-109 : numéros de téléphone, e-mails et liens de contact interdits dans
 * les descriptions d'annonces.
 */
final class FiltreCoordonnees
{
    public static function contient(string $texte): bool
    {
        // Suite d'au moins 8 chiffres, éventuellement séparés (espaces, points, tirets).
        $chiffres = preg_replace('/(?<=\d)[\s.\-\/]+(?=\d)/u', '', $texte);
        if (preg_match('/\+?\d{8,}/', (string) $chiffres)) {
            return true;
        }
        // E-mails et liens de messagerie.
        if (preg_match('/[\w.+-]+@[\w-]+\.[\w.]+/u', $texte)) {
            return true;
        }

        return (bool) preg_match('/(wa\.me|whatsapp\.com|t\.me\/|https?:\/\/)/iu', $texte);
    }
}
