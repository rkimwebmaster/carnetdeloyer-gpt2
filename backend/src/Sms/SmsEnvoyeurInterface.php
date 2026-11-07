<?php

namespace App\Sms;

/**
 * R-77 : le serveur n'envoie de SMS que pour les codes OTP et les rappels
 * d'expiration d'abonnement. Le fournisseur réel (et son secours) est branché ici.
 */
interface SmsEnvoyeurInterface
{
    public function envoyer(string $telephone, string $message): void;
}
