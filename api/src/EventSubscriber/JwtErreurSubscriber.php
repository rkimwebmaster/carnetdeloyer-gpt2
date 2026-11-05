<?php

namespace App\EventSubscriber;

use Gesdinet\JWTRefreshTokenBundle\Event\RefreshAuthenticationFailureEvent;
use Gesdinet\JWTRefreshTokenBundle\Event\RefreshTokenNotFoundEvent;
use Lexik\Bundle\JWTAuthenticationBundle\Event\AuthenticationFailureEvent;
use Lexik\Bundle\JWTAuthenticationBundle\Events;
use Symfony\Component\EventDispatcher\EventSubscriberInterface;
use Symfony\Component\HttpFoundation\JsonResponse;

/**
 * R-149 : les erreurs de session gardent le format { code, message, erreurs }.
 * L'app réagit au code SESSION en rafraîchissant le token (R-141).
 */
final class JwtErreurSubscriber implements EventSubscriberInterface
{
    public static function getSubscribedEvents(): array
    {
        return [
            Events::JWT_NOT_FOUND => 'surEchec',
            Events::JWT_INVALID => 'surEchec',
            Events::JWT_EXPIRED => 'surEchec',
            Events::AUTHENTICATION_FAILURE => 'surEchec',
            // R-142 : refresh expiré ou déjà utilisé, l'app redemande un OTP.
            'gesdinet.refresh_token_failure' => 'surEchec',
            'gesdinet.refresh_token_not_found' => 'surEchec',
        ];
    }

    public function surEchec(AuthenticationFailureEvent|RefreshAuthenticationFailureEvent|RefreshTokenNotFoundEvent $event): void
    {
        $event->setResponse(new JsonResponse([
            'code' => 'SESSION',
            'message' => 'Session absente ou expirée.',
            'erreurs' => new \stdClass(),
        ], 401));
    }
}
