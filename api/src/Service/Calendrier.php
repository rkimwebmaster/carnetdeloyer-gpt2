<?php

namespace App\Service;

/** Arithmétique de dates sans surprise (31 janvier + 1 mois = 28/29 février). */
final class Calendrier
{
    public static function ajouterMois(\DateTimeImmutable $base, int $mois): \DateTimeImmutable
    {
        $annee = (int) $base->format('Y');
        $m = (int) $base->format('n') - 1 + $mois;
        $annee += intdiv($m, 12) - ($m < 0 && 0 !== $m % 12 ? 1 : 0);
        $m = (($m % 12) + 12) % 12 + 1;
        $jour = min((int) $base->format('j'), (int) (new \DateTimeImmutable(\sprintf('%04d-%02d-01', $annee, $m)))->format('t'));

        return $base->setDate($annee, $m, $jour)->setTime(0, 0);
    }

    public static function jour(\DateTimeImmutable $d): \DateTimeImmutable
    {
        return $d->setTime(0, 0);
    }

    public static function joursEntre(\DateTimeImmutable $a, \DateTimeImmutable $b): int
    {
        return (int) self::jour($a)->diff(self::jour($b))->format('%r%a');
    }
}
