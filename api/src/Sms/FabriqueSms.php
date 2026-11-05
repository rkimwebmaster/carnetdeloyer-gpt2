<?php

namespace App\Sms;

use Psr\Log\LoggerInterface;

final class FabriqueSms
{
    private ?MemoireSmsEnvoyeur $memoire = null;

    public function __construct(private readonly LoggerInterface $logger)
    {
    }

    public function creer(string $fournisseur): SmsEnvoyeurInterface
    {
        return match ($fournisseur) {
            'log' => new LogSmsEnvoyeur($this->logger),
            'memoire' => $this->memoire ??= new MemoireSmsEnvoyeur(),
            default => throw new \InvalidArgumentException(\sprintf('Fournisseur SMS inconnu : "%s". Brancher le fournisseur réel ici (R-77).', $fournisseur)),
        };
    }
}
