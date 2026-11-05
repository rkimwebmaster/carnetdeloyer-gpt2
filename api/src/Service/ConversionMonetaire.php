<?php

namespace App\Service;

use App\Api\ErreurMetier;
use App\Entity\Devise;
use App\Entity\TauxChange;
use Doctrine\ORM\EntityManagerInterface;
use Psr\Clock\ClockInterface;
use Psr\Log\LoggerInterface;
use Symfony\Contracts\HttpClient\HttpClientInterface;

/**
 * R-69 : conversion en USD via une API de conversion monétaire.
 * Secours : dernier taux connu s'il a moins de 48 h, sinon paiement hors USD
 * bloqué avec un message clair.
 */
final class ConversionMonetaire
{
    private const VALIDITE_SECOURS_HEURES = 48;
    private const RAFRAICHIR_APRES_MINUTES = 60;

    public function __construct(
        private readonly EntityManagerInterface $em,
        private readonly HttpClientInterface $http,
        private readonly ClockInterface $clock,
        private readonly LoggerInterface $logger,
        private readonly ?string $urlTaux = null,
    ) {
    }

    /**
     * Unités de la devise pour 1 USD, en chaîne décimale.
     */
    public function tauxUsd(Devise $devise): string
    {
        if ('USD' === $devise->getCode()) {
            return '1';
        }
        $maintenant = $this->clock->now();
        $connu = $this->em->find(TauxChange::class, $devise->getCode());

        if (null === $connu || $connu->getRecupereLe() < $maintenant->modify(\sprintf('-%d minutes', self::RAFRAICHIR_APRES_MINUTES))) {
            $connu = $this->rafraichir($devise->getCode()) ?? $connu;
        }

        if (null === $connu || $connu->getRecupereLe() < $maintenant->modify(\sprintf('-%d hours', self::VALIDITE_SECOURS_HEURES))) {
            throw new ErreurMetier('CONVERSION_INDISPONIBLE', 'Conversion monétaire indisponible : réessayez plus tard ou payez en USD.', 503);
        }

        return $connu->getTaux();
    }

    public function enregistrerTaux(string $code, string $taux): TauxChange
    {
        $existant = $this->em->find(TauxChange::class, $code);
        if (null === $existant) {
            $existant = new TauxChange($code, $taux, $this->clock->now());
            $this->em->persist($existant);
        } else {
            $existant->mettreAJour($taux, $this->clock->now());
        }
        $this->em->flush();

        return $existant;
    }

    private function rafraichir(string $code): ?TauxChange
    {
        if (null === $this->urlTaux || '' === $this->urlTaux) {
            return null;
        }
        try {
            $donnees = $this->http->request('GET', $this->urlTaux, ['timeout' => 5])->toArray();
            $taux = $donnees['rates'][$code] ?? null;
            if (!is_numeric($taux) || $taux <= 0) {
                return null;
            }

            return $this->enregistrerTaux($code, rtrim(rtrim(number_format((float) $taux, 6, '.', ''), '0'), '.'));
        } catch (\Throwable $e) {
            $this->logger->warning('API de conversion indisponible', ['exception' => $e]);

            return null;
        }
    }
}
