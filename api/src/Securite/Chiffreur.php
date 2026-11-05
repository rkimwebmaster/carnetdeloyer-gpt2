<?php

namespace App\Securite;

/**
 * Chiffrement symétrique des données sensibles en base (R-124) :
 * téléphones et coordonnées GPS.
 *
 * - chiffrer()/dechiffrer() : libsodium secretbox (nonce aléatoire, authentifié).
 * - empreinte() : HMAC-SHA256 déterministe, pour rechercher un téléphone
 *   sans le stocker en clair (index aveugle).
 */
final class Chiffreur
{
    private const PREFIXE = 'v1:';

    private string $cle;
    private string $cleEmpreinte;

    public function __construct(string $cleBase64)
    {
        $cle = base64_decode($cleBase64, true);
        if (false === $cle || SODIUM_CRYPTO_SECRETBOX_KEYBYTES !== \strlen($cle)) {
            throw new \InvalidArgumentException('APP_CHIFFREMENT_CLE doit contenir 32 octets encodés en base64.');
        }
        $this->cle = $cle;
        // Clé dérivée distincte pour les empreintes.
        $this->cleEmpreinte = hash_hmac('sha256', 'empreinte', $cle, true);
    }

    public function chiffrer(string $clair): string
    {
        $nonce = random_bytes(SODIUM_CRYPTO_SECRETBOX_NONCEBYTES);

        return self::PREFIXE.base64_encode($nonce.sodium_crypto_secretbox($clair, $nonce, $this->cle));
    }

    public function dechiffrer(string $chiffre): string
    {
        if (!str_starts_with($chiffre, self::PREFIXE)) {
            throw new \RuntimeException('Valeur chiffrée invalide.');
        }
        $brut = base64_decode(substr($chiffre, \strlen(self::PREFIXE)), true);
        if (false === $brut || \strlen($brut) <= SODIUM_CRYPTO_SECRETBOX_NONCEBYTES) {
            throw new \RuntimeException('Valeur chiffrée invalide.');
        }
        $clair = sodium_crypto_secretbox_open(
            substr($brut, SODIUM_CRYPTO_SECRETBOX_NONCEBYTES),
            substr($brut, 0, SODIUM_CRYPTO_SECRETBOX_NONCEBYTES),
            $this->cle,
        );
        if (false === $clair) {
            throw new \RuntimeException('Déchiffrement impossible (clé incorrecte ou donnée altérée).');
        }

        return $clair;
    }

    public function empreinte(string $valeur): string
    {
        return hash_hmac('sha256', $valeur, $this->cleEmpreinte);
    }
}
