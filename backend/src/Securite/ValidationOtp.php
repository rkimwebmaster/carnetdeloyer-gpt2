<?php

namespace App\Securite;

use Symfony\Component\DependencyInjection\Attribute\Autowire;

/** Exception de développement R-71 : le cycle de vie de l'OTP reste contrôlé par Authentification. */
final class ValidationOtp
{
    public function __construct(
        #[Autowire('%kernel.environment%')]
        private readonly string $environnement,
    ) {
    }

    public function correspond(string $code, string $empreinte): bool
    {
        if (!preg_match('/^[0-9]{6}$/D', $code)) {
            return false;
        }

        return 'dev' === $this->environnement || password_verify($code, $empreinte);
    }

    public function estDeveloppement(): bool
    {
        return 'dev' === $this->environnement;
    }
}
