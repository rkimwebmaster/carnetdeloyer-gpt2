<?php

namespace App\Doctrine;

use App\Securite\Chiffreur;
use Doctrine\DBAL\Platforms\AbstractPlatform;
use Doctrine\DBAL\Types\Type;

/**
 * Colonne texte chiffrée de façon transparente (R-124).
 * Le chiffreur est fourni au démarrage du noyau (Kernel::boot).
 */
final class ChiffreType extends Type
{
    public const NOM = 'chiffre';

    private static ?Chiffreur $chiffreur = null;

    public static function utiliser(Chiffreur $chiffreur): void
    {
        self::$chiffreur = $chiffreur;
    }

    public function getSQLDeclaration(array $column, AbstractPlatform $platform): string
    {
        $column['length'] ??= 255;

        return $platform->getStringTypeDeclarationSQL($column);
    }

    public function convertToDatabaseValue(mixed $value, AbstractPlatform $platform): ?string
    {
        if (null === $value) {
            return null;
        }

        return self::chiffreur()->chiffrer((string) $value);
    }

    public function convertToPHPValue(mixed $value, AbstractPlatform $platform): ?string
    {
        if (null === $value) {
            return null;
        }

        return self::chiffreur()->dechiffrer((string) $value);
    }

    private static function chiffreur(): Chiffreur
    {
        return self::$chiffreur ?? throw new \LogicException('ChiffreType utilisé avant le démarrage du noyau.');
    }
}
