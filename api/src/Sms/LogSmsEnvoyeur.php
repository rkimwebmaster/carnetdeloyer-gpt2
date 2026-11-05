<?php

namespace App\Sms;

use Psr\Log\LoggerInterface;

/** Développement : le SMS est écrit dans les journaux, rien n'est envoyé. */
final class LogSmsEnvoyeur implements SmsEnvoyeurInterface
{
    public function __construct(private readonly LoggerInterface $logger)
    {
    }

    public function envoyer(string $telephone, string $message): void
    {
        $this->logger->notice('[SMS] {tel} : {msg}', ['tel' => $telephone, 'msg' => $message]);
    }
}
