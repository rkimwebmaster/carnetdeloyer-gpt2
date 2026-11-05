<?php

namespace App\Tests\Api;

use App\Entity\EspaceBailleur;
use App\Entity\TraceMarket;
use App\Enum\BadgeVerification;
use App\Tests\ApiTestCase;

final class MarketTest extends ApiTestCase
{
    /** R-107 à R-109 : unités vacantes publiées en un geste, sans coordonnées. */
    public function testPublicationEtConsultation(): void
    {
        $b = $this->utilisateur('Bailleur Market');
        $unite = $this->unite($b, 'Appartement Golf');

        $this->erreur(422, 'COORDONNEES_INTERDITES', $this->api('POST', "/api/v1/unites/$unite/publication", ['description' => 'Appelez 0970000001'], $b));
        $this->ok(200, $this->api('POST', "/api/v1/unites/$unite/publication", ['description' => 'Trois chambres, quartier calme.'], $b));

        $visiteur = $this->utilisateur('Visiteur');
        $liste = $this->ok(200, $this->api('GET', '/api/v1/market/annonces', null, $visiteur));
        self::assertSame(1, $liste['total']);
        $annonce = $liste['elements'][0];
        self::assertSame('Appartement Golf', $annonce['titre']);
        self::assertSame(['quartier' => 'Gombe', 'ville' => null, 'pays' => 'République démocratique du Congo'], $annonce['zone']);
        self::assertArrayNotHasKey('latitude', $annonce);

        $detail = $this->ok(200, $this->api('GET', '/api/v1/market/annonces/'.$annonce['id'], null, $visiteur));
        self::assertSame(['latitude' => -4.32, 'longitude' => 15.31], $detail['positionApproximative'], 'R-88 : zone approximative');
        $contact = $this->ok(200, $this->api('POST', '/api/v1/market/annonces/'.$annonce['id'].'/contact', null, $visiteur));
        self::assertStringStartsWith('+243', $contact['telephone']);
        // R-101 : consultation et contact tracés.
        self::assertSame(2, $this->em()->getRepository(TraceMarket::class)->count([]));

        // R-09 : connexion obligatoire.
        $this->erreur(401, 'SESSION', $this->api('GET', '/api/v1/market/annonces'));
    }

    /** Une unité louée disparaît du Market ; R-108 : seul le propriétaire publie. */
    public function testUniteLoueeRetireeEtProprietaireSeul(): void
    {
        $b = $this->utilisateur();
        $unite = $this->unite($b);
        $this->ok(200, $this->api('POST', "/api/v1/unites/$unite/publication", [], $b));
        $this->erreur(404, 'INTROUVABLE', $this->api('POST', "/api/v1/unites/$unite/publication", [], $this->utilisateur('Intermédiaire')));

        $this->contrat($b, $unite);
        self::assertSame(0, $this->ok(200, $this->api('GET', '/api/v1/market/annonces', null, $b))['total']);
        $this->erreur(409, 'UNITE_OCCUPEE', $this->api('POST', "/api/v1/unites/$unite/publication", [], $b));
    }

    /** R-97, R-98 : vitrine des hôtels d'entreprises vérifiées, position exacte. */
    public function testVitrineHotels(): void
    {
        $hotelier = $this->utilisateur('Hôtelier');
        $this->unite($hotelier, 'Siège');
        $espace = $this->em()->getRepository(EspaceBailleur::class)->findOneBy(['proprietaire' => $hotelier->getId()]);
        $espace->attribuerBadge(BadgeVerification::Entreprise, null);
        $espace->setRaisonSociale('Hôtel Karavia SARL');
        $this->em()->flush();
        $this->ok(201, $this->api('POST', '/api/v1/proprietes', ['nom' => 'Hôtel Karavia', 'type' => 'immeuble', 'latitude' => -11.6876, 'longitude' => 27.5026, 'unites' => [
            ['nom' => 'Chambre 101', 'categorie' => 'chambre_hotel', 'loyerIndicatif' => 6000, 'devise' => 'USD'],
            ['nom' => 'Suite', 'categorie' => 'chambre_hotel', 'loyerIndicatif' => 12000, 'devise' => 'USD'],
        ]], $hotelier));

        $hotels = $this->ok(200, $this->api('GET', '/api/v1/hotels', null, $this->utilisateur('Voyageur')));
        self::assertSame(1, $hotels['total']);
        $h = $hotels['elements'][0];
        self::assertSame('Hôtel Karavia', $h['nom']);
        self::assertSame(-11.6876, $h['latitude']);
        self::assertSame(['montant' => 6000, 'devise' => 'USD'], $h['prixParNuitDes']);
        self::assertSame('Hôtel Karavia SARL', $h['contact']['nom']);

        // Badge retiré (R-171) : l'hôtel disparaît de la vitrine.
        $admin = $this->utilisateur('Vérificateur', roles: ['ROLE_ADMIN']);
        $this->ok(200, $this->api('PUT', '/api/v1/admin/espaces/'.$espace->getId().'/badge', ['badge' => null], $admin));
        self::assertSame(0, $this->ok(200, $this->api('GET', '/api/v1/hotels', null, $hotelier))['total']);
    }
}
