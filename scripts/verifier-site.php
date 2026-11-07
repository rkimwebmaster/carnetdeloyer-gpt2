<?php

/** Vérification autonome des vues publiques, sans .env, serveur ni base de données. */
require dirname(__DIR__).'/backend/vendor/autoload.php';

$twig = new Twig\Environment(new Twig\Loader\FilesystemLoader(dirname(__DIR__).'/backend/templates'), [
    'strict_variables' => true,
    'autoescape' => 'html',
]);
$routes = [];
foreach ((new ReflectionClass(App\Controller\Web\SiteController::class))->getMethods() as $method) {
    foreach ($method->getAttributes(Symfony\Component\Routing\Attribute\Route::class) as $attribute) {
        $route = $attribute->newInstance();
        $routes[$route->getName()] = $route->getPath();
    }
}
// Vérifier à la racine et dans le sous-dossier XAMPP, avec ou sans index.php.
foreach ([['', ''], ['/carnetdeloyer-gpt2-main/backend/public', '/carnetdeloyer-gpt2-main/backend/public/index.php']] as [$basePath, $baseUrl]) {
    $twig->addGlobal('app', ['environment' => 'dev', 'request' => ['basePath' => $basePath, 'baseUrl' => $baseUrl]]);
    $twig->addFunction(new Twig\TwigFunction('path', static function (string $name) use ($routes, $baseUrl): string {
        if (!isset($routes[$name])) {
            throw new RuntimeException('Route inconnue : '.$name);
        }

        return $baseUrl.$routes[$name];
    }));
    foreach ($routes as $name => $path) {
        $page = substr($name, 5);
        $html = $twig->render('site/'.$page.'.html.twig', ['page' => $page]);
        if (!str_contains($html, '<main id="contenu">') || !str_contains($html, $basePath.'/site/site.css')) {
            throw new RuntimeException('Structure ou chemin des ressources invalide : '.$page);
        }
        // Contrôle de structure HTML et de l'unicité des identifiants, sans accès réseau.
        $dom = new DOMDocument();
        @$dom->loadHTML('<?xml encoding="utf-8" ?>'.$html, LIBXML_NONET);
        $ids = [];
        foreach ((new DOMXPath($dom))->query('//*[@id]') as $node) {
            $id = $node->getAttribute('id');
            if (isset($ids[$id])) {
                throw new RuntimeException('Identifiant dupliqué : '.$id);
            }
            $ids[$id] = true;
        }
        echo 'OK '.$baseUrl.$path.' ('.strlen($html)." octets)\n";
    }
    $twig->render('pages/confidentialite.html.twig');
    echo 'OK '.$baseUrl."/confidentialite\n";
    // L'environnement Twig doit être recréé pour changer ses globals après le rendu.
    $loader = $twig->getLoader();
    $twig = new Twig\Environment($loader, ['strict_variables' => true, 'autoescape' => 'html']);
}
