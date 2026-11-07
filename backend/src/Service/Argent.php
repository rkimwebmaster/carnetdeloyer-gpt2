<?php

namespace App\Service;

/**
 * Calculs monétaires en entiers (R-14) : aucun nombre à virgule flottante
 * n'intervient dans un montant. Les décimaux (pourcentages, taux) arrivent en
 * chaînes et sont convertis en fractions entières. Arrondi au plus proche,
 * moitié vers le haut.
 */
final class Argent
{
    private const DECIMALES_MAX = 6;

    /**
     * Ex. pourcentage(30000, '9.9') = 2970 (29,70 $ pour 300 $).
     */
    public static function pourcentage(int $montant, string $pourcentage): int
    {
        [$num, $den] = self::fraction($pourcentage);

        return self::diviserArrondi($montant * $num, $den * 100);
    }

    /**
     * Convertit un montant (unité mineure de la devise) en centimes d'USD.
     *
     * @param string $tauxUsd   unités de la devise pour 1 USD (ex. "2850.5")
     * @param int    $decimales décimales de la devise
     */
    public static function versCentimesUsd(int $montant, string $tauxUsd, int $decimales): int
    {
        [$num, $den] = self::fraction($tauxUsd);
        if (0 === $num) {
            throw new \InvalidArgumentException('Taux de change nul.');
        }

        // usd = montant / 10^decimales / taux ; centimes = usd * 100
        return self::diviserArrondi($montant * 100 * $den, $num * 10 ** $decimales);
    }

    /**
     * Part proportionnelle : montant * partie / total, arrondie.
     */
    public static function prorata(int $montant, int $partie, int $total): int
    {
        if ($total <= 0) {
            return 0;
        }

        return self::diviserArrondi($montant * max(0, min($partie, $total)), $total);
    }

    /**
     * Convertit une saisie décimale ("300", "300.5", "300,50") en unité mineure.
     */
    public static function depuisDecimal(string $saisie, int $decimales): int
    {
        $saisie = str_replace([' ', ','], ['', '.'], trim($saisie));
        if (!preg_match('/^\d+(\.\d+)?$/', $saisie)) {
            throw new \InvalidArgumentException('Montant invalide.');
        }
        [$entier, $fraction] = array_pad(explode('.', $saisie), 2, '');
        if (\strlen($fraction) > $decimales) {
            throw new \InvalidArgumentException('Trop de décimales pour cette devise.');
        }

        return (int) $entier * 10 ** $decimales + (int) str_pad($fraction, $decimales, '0');
    }

    /**
     * @return array{int, int} numérateur, dénominateur (puissance de 10)
     */
    public static function fraction(string $decimal): array
    {
        $decimal = trim($decimal);
        if (!preg_match('/^\d+(\.\d+)?$/', $decimal)) {
            throw new \InvalidArgumentException(\sprintf('Décimal invalide : "%s".', $decimal));
        }
        [$entier, $fraction] = array_pad(explode('.', $decimal), 2, '');
        $fraction = substr(rtrim($fraction, '0'), 0, self::DECIMALES_MAX);
        $den = 10 ** \strlen($fraction);

        return [(int) $entier * $den + (int) ($fraction ?: '0'), $den];
    }

    private static function diviserArrondi(int $numerateur, int $denominateur): int
    {
        if ($numerateur < 0) {
            return -self::diviserArrondi(-$numerateur, $denominateur);
        }

        return intdiv(2 * $numerateur + $denominateur, 2 * $denominateur);
    }
}
