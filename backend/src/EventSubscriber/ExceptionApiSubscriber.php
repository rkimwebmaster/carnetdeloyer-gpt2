<?php

namespace App\EventSubscriber;

use App\Api\ErreurMetier;
use Psr\Log\LoggerInterface;
use Symfony\Component\EventDispatcher\EventSubscriberInterface;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpKernel\Event\ExceptionEvent;
use Symfony\Component\HttpKernel\Exception\HttpExceptionInterface;
use Symfony\Component\HttpKernel\KernelEvents;
use Symfony\Component\Security\Core\Exception\AccessDeniedException;
use Symfony\Component\Validator\Exception\ValidationFailedException;

/**
 * Convertit toute exception levée sous /api en réponse JSON uniforme (R-149).
 */
final class ExceptionApiSubscriber implements EventSubscriberInterface
{
    public function __construct(private readonly LoggerInterface $logger)
    {
    }

    public static function getSubscribedEvents(): array
    {
        // Priorité supérieure au listener de sécurité pour les ErreurMetier,
        // mais AccessDeniedException est laissé au firewall (401/403 corrects).
        return [KernelEvents::EXCEPTION => ['surException', 0]];
    }

    public function surException(ExceptionEvent $event): void
    {
        if (!str_starts_with($event->getRequest()->getPathInfo(), '/api')) {
            return;
        }
        $e = $event->getThrowable();

        if ($e instanceof ErreurMetier) {
            $event->setResponse($this->reponse($e->codeMetier, $e->getMessage(), $e->statutHttp, $e->erreurs));

            return;
        }

        $validation = $e instanceof ValidationFailedException ? $e : $e->getPrevious();
        if ($validation instanceof ValidationFailedException) {
            $erreurs = [];
            foreach ($validation->getViolations() as $violation) {
                $erreurs[$violation->getPropertyPath() ?: '_'][] = $violation->getMessage();
            }
            $event->setResponse($this->reponse('VALIDATION', 'Données invalides.', 422, $erreurs));

            return;
        }

        if ($e instanceof AccessDeniedException) {
            return;
        }

        if ($e instanceof HttpExceptionInterface) {
            $statut = $e->getStatusCode();
            $code = match ($statut) {
                400 => 'REQUETE_INVALIDE',
                401 => 'SESSION',
                403 => 'INTERDIT',
                404 => 'INTROUVABLE',
                405 => 'METHODE_NON_AUTORISEE',
                415 => 'FORMAT_NON_SUPPORTE',
                422 => 'VALIDATION',
                429 => 'TROP_DE_REQUETES',
                default => 'ERREUR_HTTP',
            };
            $event->setResponse($this->reponse($code, $statut >= 500 ? 'Erreur serveur.' : $e->getMessage(), $statut));

            return;
        }

        $this->logger->error('Erreur API non gérée', ['exception' => $e]);
        $event->setResponse($this->reponse('ERREUR_SERVEUR', 'Erreur serveur.', 500));
    }

    /**
     * @param array<string, list<string>> $erreurs
     */
    private function reponse(string $code, string $message, int $statut, array $erreurs = []): JsonResponse
    {
        return new JsonResponse(['code' => $code, 'message' => $message, 'erreurs' => (object) $erreurs], $statut);
    }
}
