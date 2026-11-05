<?php

namespace App\Tests;

use App\Entity\PaysApi;
use App\Entity\User;
use App\Securite\Chiffreur;
use Doctrine\ORM\EntityManagerInterface;
use Lexik\Bundle\JWTAuthenticationBundle\Services\JWTTokenManagerInterface;
use Symfony\Bundle\FrameworkBundle\KernelBrowser;
use Symfony\Bundle\FrameworkBundle\Test\WebTestCase;
use Symfony\Component\Clock\Clock;
use Symfony\Component\Clock\MockClock;
use Symfony\Component\Uid\Uuid;

/**
 * Base des tests d'API : vraie base MariaDB/MySQL (migrations réelles), chaque test
 * isolé dans une transaction annulée (DAMA), horloge figée et pilotable.
 */
abstract class ApiTestCase extends WebTestCase
{
    protected KernelBrowser $client;
    protected MockClock $horloge;
    private static int $compteurTelephone = 0;

    protected function setUp(): void
    {
        $this->client = static::createClient();
        $this->horloge = new MockClock('2026-10-27 09:00:00');
        Clock::set($this->horloge);
    }

    protected function tearDown(): void
    {
        Clock::set(new \Symfony\Component\Clock\NativeClock());
        parent::tearDown();
    }

    protected function em(): EntityManagerInterface
    {
        $doctrine = static::getContainer()->get('doctrine');
        $em = $doctrine->getManager();
        // Après une erreur métier levée dans une transaction, Doctrine ferme le
        // gestionnaire de la requête : on en ouvre un neuf pour la suite du test.
        if (!$em->isOpen()) {
            $em = $doctrine->resetManager();
        }

        return $em;
    }

    protected function nouveauTelephone(string $indicatif = '+243'): string
    {
        return $indicatif.'97'.str_pad((string) (++self::$compteurTelephone + random_int(0, 99999) * 100), 7, '0', STR_PAD_LEFT);
    }

    protected function utilisateur(string $nom = 'Bailleur Test', ?string $telephone = null, array $roles = []): User
    {
        $telephone ??= $this->nouveauTelephone();
        $chiffreur = static::getContainer()->get(Chiffreur::class);
        $user = new User($telephone, $chiffreur->empreinte($telephone), $nom, 'T'.strtoupper(substr(bin2hex(random_bytes(5)), 0, 9)));
        $user->setRoles($roles);
        $user->setPays($this->em()->getRepository(PaysApi::class)->findOneBy(['codeIso' => 'CD']));
        $this->em()->persist($user);
        $this->em()->flush();

        return $user;
    }

    protected function jeton(User $user): string
    {
        return static::getContainer()->get(JWTTokenManagerInterface::class)->create($user);
    }

    /**
     * @return array{0: int, 1: array<mixed>}
     */
    protected function api(string $methode, string $url, ?array $corps = null, ?User $en = null): array
    {
        $entetes = ['CONTENT_TYPE' => 'application/json', 'HTTP_ACCEPT' => 'application/json'];
        if (null !== $en) {
            $entetes['HTTP_AUTHORIZATION'] = 'Bearer '.$this->jeton($this->em()->find(User::class, $en->getId()));
        }
        $this->client->request($methode, $url, server: $entetes, content: null === $corps ? null : json_encode($corps, JSON_THROW_ON_ERROR));
        $reponse = $this->client->getResponse();
        $contenu = (string) $reponse->getContent();

        return [$reponse->getStatusCode(), '' === $contenu ? [] : (json_decode($contenu, true) ?? ['_brut' => $contenu])];
    }

    /** Vérifie le statut et renvoie le corps. */
    protected function ok(int $attendu, array $resultat): array
    {
        [$statut, $corps] = $resultat;
        self::assertSame($attendu, $statut, 'Réponse inattendue : '.json_encode($corps, JSON_UNESCAPED_UNICODE));

        return $corps;
    }

    /** Vérifie une erreur métier (R-149). */
    protected function erreur(int $statut, string $code, array $resultat): array
    {
        $corps = $this->ok($statut, $resultat);
        self::assertSame($code, $corps['code'] ?? null, json_encode($corps, JSON_UNESCAPED_UNICODE));
        self::assertArrayHasKey('message', $corps);
        self::assertArrayHasKey('erreurs', $corps);

        return $corps;
    }

    /** Crée une propriété simple (une unité) et renvoie l'id de l'unité. */
    protected function unite(User $bailleur, string $nom = 'Maison Kasavubu', ?int $loyer = 30000, string $devise = 'USD', string $categorie = 'maison'): int
    {
        $corps = $this->ok(201, $this->api('POST', '/api/v1/proprietes', [
            'nom' => $nom, 'type' => 'simple', 'quartier' => 'Gombe', 'latitude' => -4.3217, 'longitude' => 15.3125,
            'categorie' => $categorie, 'loyerIndicatif' => $loyer, 'devise' => $devise,
        ], $bailleur));

        return $corps['unites'][0]['id'];
    }

    protected function contrat(User $bailleur, int $uniteId, int $loyer = 30000, string $devise = 'USD', string $dateDebut = '2026-10-01', ?string $dateFin = null, int $garantie = 0, ?string $telLocataire = null): array
    {
        return $this->ok(201, $this->api('POST', '/api/v1/contrats', [
            'uniteId' => $uniteId, 'locataireNom' => 'Locataire Test', 'locataireTelephone' => $telLocataire,
            'devise' => $devise, 'loyer' => $loyer, 'dateDebut' => $dateDebut, 'dateFin' => $dateFin, 'garantie' => $garantie,
        ], $bailleur));
    }

    protected function payer(User $bailleur, int $contratId, int $montant, ?string $cle = null, string $date = '2026-10-27', string $type = 'loyer'): array
    {
        return $this->api('POST', "/api/v1/contrats/$contratId/paiements", [
            'montant' => $montant, 'datePaiement' => $date, 'moyen' => 'especes',
            'cleIdempotence' => $cle ?? Uuid::v4()->toRfc4122(), 'type' => $type,
        ], $bailleur);
    }
}
