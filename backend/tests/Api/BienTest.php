<?php

namespace App\Tests\Api;

use App\Entity\Devise;
use App\Entity\EspaceBailleur;
use App\Enum\BadgeVerification;
use App\Tests\ApiTestCase;

final class BienTest extends ApiTestCase
{
    /** R-10 : une propriété simple crée automatiquement son unité unique. */
    public function testProprieteSimpleCreeUneUnite(): void
    {
        $bailleur = $this->utilisateur();
        $p = $this->ok(201, $this->api('POST', '/api/v1/proprietes', [
            'nom' => 'Villa Lumumba', 'type' => 'simple', 'quartier' => 'Golf', 'latitude' => -11.66, 'longitude' => 27.48,
            'categorie' => 'maison', 'loyerIndicatif' => 50000,
        ], $bailleur));
        self::assertSame('CD', $p['pays']['codeIso'], 'R-17 : pays du compte par défaut');
        self::assertCount(1, $p['unites']);
        $unite = $p['unites'][0];
        self::assertSame('Villa Lumumba', $unite['nom']);
        self::assertSame(['montant' => 50000, 'devise' => 'CDF'], $unite['loyerIndicatif'], 'Devise du pays par défaut');
        self::assertTrue($unite['vacante']);
        self::assertSame('non_facture', $unite['abonnement']['etat'], 'R-52 : unité vacante non facturée');

        // Une propriété simple n'accepte pas d'autre unité.
        $this->erreur(422, 'PROPRIETE_SIMPLE', $this->api('POST', '/api/v1/proprietes/'.$p['id'].'/unites', ['nom' => 'Annexe', 'categorie' => 'chambre'], $bailleur));
    }

    public function testImmeubleAvecUnites(): void
    {
        $bailleur = $this->utilisateur();
        $this->erreur(422, 'UNITES_REQUISES', $this->api('POST', '/api/v1/proprietes', ['nom' => 'Immeuble vide', 'type' => 'immeuble'], $bailleur));

        $p = $this->ok(201, $this->api('POST', '/api/v1/proprietes', [
            'nom' => 'Immeuble Bel-Air', 'type' => 'immeuble',
            'unites' => [
                ['nom' => 'Appartement A1', 'categorie' => 'appartement', 'loyerIndicatif' => 25000, 'devise' => 'USD'],
                ['nom' => 'Boutique RDC', 'categorie' => 'boutique'],
            ],
        ], $bailleur));
        self::assertSame(2, $p['nombreUnites']);

        $ajout = $this->ok(201, $this->api('POST', '/api/v1/proprietes/'.$p['id'].'/unites', ['nom' => 'Bureau B2', 'categorie' => 'bureau'], $bailleur));
        self::assertSame('business_center', $ajout['categorie']['icone']);

        $liste = $this->ok(200, $this->api('GET', '/api/v1/unites', null, $bailleur));
        self::assertSame(3, $liste['total']);
        self::assertSame(['Appartement A1', 'Boutique RDC', 'Bureau B2'], array_column($liste['elements'], 'nom'));
    }

    public function testCategorieInconnueEtDeviseInactive(): void
    {
        $bailleur = $this->utilisateur();
        $this->erreur(422, 'CATEGORIE_INCONNUE', $this->api('POST', '/api/v1/proprietes', ['nom' => 'X', 'categorie' => 'chateau'], $bailleur));

        $eur = $this->em()->getRepository(Devise::class)->findOneBy(['code' => 'EUR']);
        $eur->setActive(false);
        $this->em()->flush();
        $this->erreur(422, 'DEVISE_INCONNUE', $this->api('POST', '/api/v1/proprietes', ['nom' => 'X', 'loyerIndicatif' => 1, 'devise' => 'EUR'], $bailleur));
    }

    /** R-144 : chacun ne voit que ce qu'il possède. */
    public function testIsolationEntreBailleurs(): void
    {
        $a = $this->utilisateur('A');
        $b = $this->utilisateur('B');
        $uniteA = $this->unite($a);

        $this->erreur(404, 'INTROUVABLE', $this->api('GET', "/api/v1/unites/$uniteA", null, $b));
        $this->erreur(404, 'INTROUVABLE', $this->api('PATCH', "/api/v1/unites/$uniteA", ['nom' => 'Piratée'], $b));
        self::assertSame(0, $this->ok(200, $this->api('GET', '/api/v1/unites', null, $b))['total']);
        self::assertSame(0, $this->ok(200, $this->api('GET', '/api/v1/proprietes', null, $b))['total']);
    }

    /** R-98 : la catégorie Hôtel est réservée aux entreprises vérifiées. */
    public function testHotelReserveAuxEntreprisesVerifiees(): void
    {
        $bailleur = $this->utilisateur();
        $this->erreur(422, 'HOTEL_RESERVE_ENTREPRISES', $this->api('POST', '/api/v1/proprietes', ['nom' => 'Hôtel', 'categorie' => 'chambre_hotel'], $bailleur));

        $this->unite($bailleur); // crée l'espace
        $espace = $this->em()->getRepository(EspaceBailleur::class)->findOneBy(['proprietaire' => $bailleur->getId()]);
        $espace->attribuerBadge(BadgeVerification::Entreprise, null);
        $this->em()->flush();
        $this->ok(201, $this->api('POST', '/api/v1/proprietes', ['nom' => 'Hôtel Karavia', 'type' => 'immeuble', 'unites' => [['nom' => 'Chambre 101', 'categorie' => 'chambre_hotel', 'loyerIndicatif' => 6000, 'devise' => 'USD']]], $bailleur));
    }

    /** R-16 : modifier le loyer indicatif ne change aucun contrat. */
    public function testLoyerIndicatifNeChangePasLeContrat(): void
    {
        $bailleur = $this->utilisateur();
        $unite = $this->unite($bailleur, loyer: 30000);
        $contrat = $this->contrat($bailleur, $unite, loyer: 30000);
        $this->ok(200, $this->api('PATCH', "/api/v1/unites/$unite", ['loyerIndicatif' => 45000, 'devise' => 'USD'], $bailleur));
        $apres = $this->ok(200, $this->api('GET', '/api/v1/contrats/'.$contrat['id'], null, $bailleur));
        self::assertSame(30000, $apres['loyer']);
        self::assertSame(30000, $apres['echeances'][0]['montantDu']);
    }

    public function testCoordonneesGpsChiffreesEnBase(): void
    {
        $bailleur = $this->utilisateur();
        $this->unite($bailleur);
        $brut = $this->em()->getConnection()->fetchAssociative('SELECT latitude, longitude FROM propriete ORDER BY id DESC LIMIT 1');
        self::assertStringStartsWith('v1:', $brut['latitude']);
        self::assertStringNotContainsString('4.32', $brut['latitude']);
    }
}
