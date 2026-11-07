<?php

namespace App\Tests\Api;

use App\Entity\Devise;
use App\Tests\ApiTestCase;

final class ContratTest extends ApiTestCase
{
    /** R-17 : devise du pays de la propriété proposée par défaut. */
    public function testCascadeDevise(): void
    {
        $bailleur = $this->utilisateur();
        $unite = $this->unite($bailleur, loyer: 50000000, devise: 'CDF');
        $proposition = $this->ok(200, $this->api('GET', "/api/v1/unites/$unite/contrat/proposition", null, $bailleur));
        self::assertSame('CDF', $proposition['devise']['code']);
        self::assertSame(50000000, $proposition['loyer']);

        $contrat = $this->ok(201, $this->api('POST', '/api/v1/contrats', [
            'uniteId' => $unite, 'locataireNom' => 'Jean K.', 'loyer' => 50000000, 'dateDebut' => '2026-10-01',
        ], $bailleur));
        self::assertSame('CDF', $contrat['devise']['code']);
    }

    /** R-18 : une devise désactivée n'est plus proposée pour un nouveau contrat mais reste valable. */
    public function testDeviseDesactivee(): void
    {
        $bailleur = $this->utilisateur();
        $u1 = $this->unite($bailleur, 'U1');
        $u2 = $this->unite($bailleur, 'U2');
        $c1 = $this->contrat($bailleur, $u1, devise: 'EUR');

        $this->em()->getRepository(Devise::class)->findOneBy(['code' => 'EUR'])->setActive(false);
        $this->em()->flush();

        $this->erreur(422, 'DEVISE_INACTIVE', $this->api('POST', '/api/v1/contrats', ['uniteId' => $u2, 'locataireNom' => 'X Y', 'loyer' => 100, 'dateDebut' => '2026-10-01', 'devise' => 'EUR'], $bailleur));
        // Le contrat existant reste encaissable.
        $this->ok(201, $this->payer($bailleur, $c1['id'], 30000));
    }

    /** R-11 : une unité n'a qu'un contrat actif. */
    public function testUniteOccupee(): void
    {
        $bailleur = $this->utilisateur();
        $unite = $this->unite($bailleur);
        $this->contrat($bailleur, $unite);
        $this->erreur(409, 'UNITE_OCCUPEE', $this->api('POST', '/api/v1/contrats', ['uniteId' => $unite, 'locataireNom' => 'Autre', 'loyer' => 1000, 'dateDebut' => '2026-11-01', 'devise' => 'USD'], $bailleur));
        $u = $this->ok(200, $this->api('GET', "/api/v1/unites/$unite", null, $bailleur));
        self::assertFalse($u['vacante']);
        self::assertSame('Locataire Test', $u['locataire']);
    }

    /** R-21 : 12 mois glissants, jamais au-delà de la date de fin. */
    public function testGenerationDesEcheances(): void
    {
        $bailleur = $this->utilisateur();
        $sansFin = $this->contrat($bailleur, $this->unite($bailleur, 'A'), dateDebut: '2026-10-01');
        // D'octobre 2026 à octobre 2027 inclus (aujourd'hui 27/10/2026 + 12 mois).
        self::assertCount(13, $sansFin['echeances']);
        self::assertSame('2026-10-01', $sansFin['echeances'][0]['periodeDebut']);
        self::assertSame('2026-10-31', $sansFin['echeances'][0]['periodeFin']);
        self::assertSame('en_retard', $sansFin['echeances'][0]['statut']);
        self::assertSame('a_venir', $sansFin['echeances'][1]['statut']);
        self::assertSame(30000, $sansFin['enRetard']);

        $avecFin = $this->contrat($bailleur, $this->unite($bailleur, 'B'), dateDebut: '2026-11-15', dateFin: '2027-02-14');
        self::assertSame(['2026-11-15', '2026-12-15', '2027-01-15'], array_column($avecFin['echeances'], 'periodeDebut'));

        // Le temps passe : la génération continue sans doublon.
        $this->horloge->modify('+2 months');
        $plusTard = $this->ok(200, $this->api('GET', '/api/v1/contrats/'.$sansFin['id'], null, $bailleur));
        self::assertCount(15, $plusTard['echeances']);
        self::assertSame(count(array_unique(array_column($plusTard['echeances'], 'periodeDebut'))), count($plusTard['echeances']));
    }

    public function testContratSurUniteDUnAutreBailleur(): void
    {
        $a = $this->utilisateur('A');
        $b = $this->utilisateur('B');
        $this->erreur(404, 'INTROUVABLE', $this->api('POST', '/api/v1/contrats', ['uniteId' => $this->unite($a), 'locataireNom' => 'X Y', 'loyer' => 1, 'dateDebut' => '2026-10-01', 'devise' => 'USD'], $b));
    }

    public function testValidations(): void
    {
        $bailleur = $this->utilisateur();
        $unite = $this->unite($bailleur);
        $this->erreur(422, 'DATES_INCOHERENTES', $this->api('POST', '/api/v1/contrats', ['uniteId' => $unite, 'locataireNom' => 'X Y', 'loyer' => 1, 'dateDebut' => '2026-10-01', 'dateFin' => '2026-09-01', 'devise' => 'USD'], $bailleur));
        $this->erreur(422, 'LOCATAIRE_REQUIS', $this->api('POST', '/api/v1/contrats', ['uniteId' => $unite, 'loyer' => 1, 'dateDebut' => '2026-10-01', 'devise' => 'USD'], $bailleur));
        $this->erreur(422, 'TELEPHONE_INVALIDE', $this->api('POST', '/api/v1/contrats', ['uniteId' => $unite, 'locataireNom' => 'X Y', 'locataireTelephone' => '12', 'loyer' => 1, 'dateDebut' => '2026-10-01', 'devise' => 'USD'], $bailleur));
        $r = $this->erreur(422, 'VALIDATION', $this->api('POST', '/api/v1/contrats', ['uniteId' => $unite, 'locataireNom' => 'X Y', 'loyer' => -5, 'dateDebut' => 'demain'], $bailleur));
        self::assertArrayHasKey('loyer', $r['erreurs']);
        self::assertArrayHasKey('dateDebut', $r['erreurs']);
    }

    /** R-50 : la première unité est gratuite 12 mois, une seule fois par compte. */
    public function testPremiereUniteGratuite(): void
    {
        $bailleur = $this->utilisateur();
        $u1 = $this->unite($bailleur, 'U1');
        $u2 = $this->unite($bailleur, 'U2');
        $this->contrat($bailleur, $u1);
        $this->contrat($bailleur, $u2);

        $a1 = $this->ok(200, $this->api('GET', "/api/v1/unites/$u1", null, $bailleur))['abonnement'];
        $a2 = $this->ok(200, $this->api('GET', "/api/v1/unites/$u2", null, $bailleur))['abonnement'];
        self::assertSame(['etat' => 'gratuit', 'fin' => '2027-10-27'], $a1);
        // R-52 : la 2e unité se paie à l'activation (15 jours de grâce).
        self::assertSame(['etat' => 'grace', 'fin' => '2026-10-27'], $a2);
    }

    public function testListeEtFiltres(): void
    {
        $bailleur = $this->utilisateur();
        $this->contrat($bailleur, $this->unite($bailleur, 'U1'), dateDebut: '2026-10-01');
        $this->contrat($bailleur, $this->unite($bailleur, 'U2'), dateDebut: '2026-11-01');

        self::assertSame(2, $this->ok(200, $this->api('GET', '/api/v1/contrats?statut=actif', null, $bailleur))['total']);
        $retard = $this->ok(200, $this->api('GET', '/api/v1/contrats?enRetard=1', null, $bailleur));
        self::assertSame(1, $retard['total']);
        self::assertSame('U1', $retard['elements'][0]['unite']['nom']);
    }
}
