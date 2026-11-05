<?php

namespace App\Controller\Web;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;

final class PagesController extends AbstractController
{
    /** R-121 : politique de confidentialité, liée depuis le premier message au locataire. */
    #[Route('/confidentialite', methods: ['GET'])]
    public function confidentialite(): Response
    {
        return $this->render('pages/confidentialite.html.twig');
    }
}
