<?php

namespace App\Api;

/**
 * Erreur de règle métier renvoyée à l'app sous la forme (R-149) :
 * { "code": "CODE_METIER", "message": "...", "erreurs": { "champ": ["..."] } }
 *
 * Le code est stable et traduit côté app ; le message est technique (R-89, R-150).
 */
final class ErreurMetier extends \RuntimeException
{
    /**
     * @param array<string, list<string>> $erreurs
     */
    public function __construct(
        public readonly string $codeMetier,
        string $message,
        public readonly int $statutHttp = 422,
        public readonly array $erreurs = [],
    ) {
        parent::__construct($message);
    }

    public static function introuvable(string $quoi = 'Ressource'): self
    {
        return new self('INTROUVABLE', $quoi.' introuvable.', 404);
    }

    public static function interdit(string $message = 'Action non autorisée.'): self
    {
        return new self('INTERDIT', $message, 403);
    }

    public static function champ(string $champ, string $code, string $message): self
    {
        return new self($code, $message, 422, [$champ => [$message]]);
    }
}
