<?php

namespace App\Controller\Web;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;

/** R-189 : site vitrine. Aucune lecture ni écriture des données métier. */
final class SiteController extends AbstractController
{
    #[Route('/', name: 'site_accueil', methods: ['GET'])]
    public function accueil(): Response
    {
        return $this->render('site/accueil.html.twig', ['page' => 'accueil']);
    }

    #[Route('/fonctionnalites', name: 'site_fonctionnalites', methods: ['GET'])]
    #[Route('/tarifs', name: 'site_tarifs', methods: ['GET'])]
    #[Route('/market', name: 'site_market', methods: ['GET'])]
    #[Route('/hotels', name: 'site_hotels', methods: ['GET'])]
    #[Route('/connexion', name: 'site_connexion', methods: ['GET'])]
    #[Route('/inscription', name: 'site_inscription', methods: ['GET'])]
    #[Route('/demonstration', name: 'site_demonstration', methods: ['GET'])]
    #[Route('/espace', name: 'site_espace', methods: ['GET'])]
    public function page(Request $request): Response
    {
        $page = substr((string) $request->attributes->get('_route'), 5);

        return $this->render('site/'.$page.'.html.twig', ['page' => $page]);
    }
}
