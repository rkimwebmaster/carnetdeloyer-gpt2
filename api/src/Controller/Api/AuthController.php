<?php

namespace App\Controller\Api;

use App\Api\Dto\DemandeOtp;
use App\Api\Dto\Inscription;
use App\Api\Dto\VerificationOtp;
use App\Service\Authentification;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpKernel\Attribute\MapRequestPayload;
use Symfony\Component\Routing\Attribute\Route;

/**
 * R-71, R-160 : connexion et inscription par OTP.
 * Le rafraîchissement du token est géré par le firewall (POST /api/v1/auth/token/rafraichir).
 */
#[Route('/api/v1/auth', methods: ['POST'])]
final class AuthController extends ApiController
{
    public function __construct(private readonly Authentification $auth)
    {
    }

    #[Route('/otp')]
    public function demanderOtp(#[MapRequestPayload] DemandeOtp $dto, Request $request): JsonResponse
    {
        $this->auth->demanderOtp($dto->telephone, (string) $request->getClientIp());

        return $this->json(['envoye' => true], 202);
    }

    /**
     * Compte existant : renvoie les jetons. Numéro inconnu : renvoie un jeton
     * d'inscription à présenter à /inscription avec le nom.
     */
    #[Route('/otp/verification')]
    public function verifierOtp(#[MapRequestPayload] VerificationOtp $dto): JsonResponse
    {
        $resultat = $this->auth->verifierOtp($dto->telephone, $dto->code);
        if (null === $resultat['utilisateur']) {
            return $this->json(['inscriptionRequise' => true, 'jetonInscription' => $resultat['jetonInscription']]);
        }

        return $this->json(['inscriptionRequise' => false] + $this->auth->jetons($resultat['utilisateur']));
    }

    #[Route('/inscription')]
    public function inscrire(#[MapRequestPayload] Inscription $dto): JsonResponse
    {
        $user = $this->auth->inscrire($dto->telephone, $dto->jetonInscription, $dto->nom, $dto->codeParrain);

        return $this->json($this->auth->jetons($user), 201);
    }
}
