<?php

use Symfony\Component\Dotenv\Dotenv;

require dirname(__DIR__).'/vendor/autoload.php';

if (method_exists(Dotenv::class, 'bootEnv')) {
    (new Dotenv())->bootEnv(dirname(__DIR__).'/.env');
}

if ($_SERVER['APP_DEBUG']) {
    umask(0000);
}

// Base de test reconstruite à chaque lancement : migrations réelles + référentiels.
// DAMA isole ensuite chaque test dans une transaction annulée.
if ('test' === ($_SERVER['APP_ENV'] ?? null) && !getenv('CDL_TESTS_SANS_RESET')) {
    $console = escapeshellarg(PHP_BINARY).' '.escapeshellarg(dirname(__DIR__).'/bin/console').' --env=test --no-interaction --quiet ';
    foreach ([
        'lexik:jwt:generate-keypair --skip-if-exists',
        'doctrine:database:drop --force --if-exists',
        'doctrine:database:create',
        'doctrine:migrations:migrate',
        'app:referentiels:charger',
    ] as $commande) {
        passthru($console.$commande, $code);
        if (0 !== $code) {
            fwrite(STDERR, "Échec de la préparation de la base de test : $commande\n");
            exit(1);
        }
    }
}
