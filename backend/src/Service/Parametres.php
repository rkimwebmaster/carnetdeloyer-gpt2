<?php

namespace App\Service;

use App\Entity\DerogationParametre;
use App\Entity\Parametre;
use App\Entity\User;
use Doctrine\ORM\EntityManagerInterface;

/**
 * R-67 : valeurs par défaut réglables depuis le back-office, avec historique,
 * et dérogation possible par compte. Montants en centimes d'USD.
 */
final class Parametres
{
    public const ABONNEMENT_POURCENTAGE = 'abonnement_pourcentage';
    public const PARRAINAGE_LOCATION_CENTIMES = 'parrainage_location_centimes_usd';
    public const WALLET_SEUIL_CENTIMES = 'wallet_seuil_centimes_usd';
    public const PARRAINAGE_HOTEL_POURCENTAGE = 'parrainage_hotel_pourcentage';
    public const COMMISSION_HOTEL_POURCENTAGE = 'commission_hotel_pourcentage';
    public const VENTE_POURCENTAGE = 'vente_pourcentage';
    public const ABONNEMENT_GRACE_JOURS = 'abonnement_grace_jours';
    public const PHOTOS_MAX = 'photos_max';

    public const DEFAUTS = [
        self::ABONNEMENT_POURCENTAGE => '9.9',
        self::PARRAINAGE_LOCATION_CENTIMES => '200',
        self::WALLET_SEUIL_CENTIMES => '1100',
        self::PARRAINAGE_HOTEL_POURCENTAGE => '20',
        self::COMMISSION_HOTEL_POURCENTAGE => '9.9',
        self::VENTE_POURCENTAGE => '2',
        self::ABONNEMENT_GRACE_JOURS => '15',
        self::PHOTOS_MAX => '6',
    ];

    public function __construct(private readonly EntityManagerInterface $em)
    {
    }

    public function valeur(string $cle, ?User $user = null): string
    {
        if (!\array_key_exists($cle, self::DEFAUTS)) {
            throw new \InvalidArgumentException(\sprintf('Paramètre inconnu : %s', $cle));
        }
        if (null !== $user && null !== $user->getId()) {
            $derogation = $this->em->getRepository(DerogationParametre::class)->findOneBy(['user' => $user, 'cle' => $cle]);
            if (null !== $derogation) {
                return $derogation->getValeur();
            }
        }
        $actuel = $this->em->getRepository(Parametre::class)->findOneBy(['cle' => $cle], ['depuis' => 'DESC', 'id' => 'DESC']);

        return $actuel?->getValeur() ?? self::DEFAUTS[$cle];
    }

    public function entier(string $cle, ?User $user = null): int
    {
        return (int) $this->valeur($cle, $user);
    }

    public function definir(string $cle, string $valeur, ?User $par): Parametre
    {
        $this->valider($cle, $valeur);
        $p = new Parametre($cle, $valeur, $par);
        $this->em->persist($p);

        return $p;
    }

    public function deroger(User $user, string $cle, ?string $valeur): void
    {
        $repo = $this->em->getRepository(DerogationParametre::class);
        $existante = $repo->findOneBy(['user' => $user, 'cle' => $cle]);
        if (null === $valeur) {
            if (null !== $existante) {
                $this->em->remove($existante);
            }

            return;
        }
        $this->valider($cle, $valeur);
        if (null !== $existante) {
            $existante->setValeur($valeur);
        } else {
            $this->em->persist(new DerogationParametre($user, $cle, $valeur));
        }
    }

    /** @return array<string, string> */
    public function tous(): array
    {
        $valeurs = [];
        foreach (array_keys(self::DEFAUTS) as $cle) {
            $valeurs[$cle] = $this->valeur($cle);
        }

        return $valeurs;
    }

    private function valider(string $cle, string $valeur): void
    {
        if (!\array_key_exists($cle, self::DEFAUTS)) {
            throw new \InvalidArgumentException(\sprintf('Paramètre inconnu : %s', $cle));
        }
        if (!preg_match('/^\d+(\.\d{1,6})?$/', $valeur)) {
            throw new \InvalidArgumentException('Valeur numérique positive attendue.');
        }
    }
}
