<?php

namespace App\Controller\Web;

use App\Entity\Recu;
use App\Enum\TypePaiement;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpKernel\Exception\NotFoundHttpException;
use Symfony\Component\Routing\Attribute\Route;

/**
 * R-75 : page web publique du reçu, consultable sans compte, via un lien
 * unique non devinable. Reçus en français (R-89).
 */
final class RecuPublicController extends AbstractController
{
    #[Route('/r/{jeton<[a-f0-9]{48}>}', methods: ['GET'])]
    public function voir(string $jeton, EntityManagerInterface $em): Response
    {
        $recu = $em->getRepository(Recu::class)->findOneBy(['jeton' => $jeton]) ?? throw new NotFoundHttpException();
        $paiement = $recu->getPaiement();
        $contrat = $paiement->getContrat();
        $devise = $contrat->getDevise();

        $reponse = $this->render('recu/public.html.twig', [
            'recu' => $recu,
            'paiement' => $paiement,
            'contrat' => $contrat,
            'espace' => $recu->getEspace(),
            'montant' => number_format($paiement->getMontant() / 10 ** $devise->getDecimales(), $devise->getDecimales(), ',', ' '),
            'devise' => $devise,
            'estGarantie' => TypePaiement::Garantie === $paiement->getType(),
        ]);
        $reponse->headers->set('X-Robots-Tag', 'noindex, nofollow');
        $reponse->headers->set('Referrer-Policy', 'no-referrer');

        return $reponse;
    }
}
