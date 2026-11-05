<?php

namespace App\Sms;

/** Tests : garde les SMS en mémoire pour pouvoir lire les codes OTP. */
final class MemoireSmsEnvoyeur implements SmsEnvoyeurInterface
{
    /** @var list<array{telephone: string, message: string}> */
    public array $envoyes = [];

    public function envoyer(string $telephone, string $message): void
    {
        $this->envoyes[] = ['telephone' => $telephone, 'message' => $message];
    }

    public function dernierPour(string $telephone): ?string
    {
        foreach (array_reverse($this->envoyes) as $sms) {
            if ($sms['telephone'] === $telephone) {
                return $sms['message'];
            }
        }

        return null;
    }
}
