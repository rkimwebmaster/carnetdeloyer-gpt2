<?php

namespace App\Tests\Api;

use App\Tests\ApiTestCase;
use Symfony\Component\Uid\Uuid;

final class PaiementTest extends ApiTestCase
{
    /** @return array{0: \App\Entity\User, 1: array} */
    private function bailleurAvecContrat(int $loyer = 30000, string $debut = '2026-10-01'): array
    {
        $bailleur = $this->utilisateur();
        $contrat = $this->contrat($bailleur, $this->unite($bailleur), loyer: $loyer, dateDebut: $debut);

        return [$bailleur, $contrat];
    }

    /** R-24 : « Encaisser » propose la prochaine échéance due et son montant. */
    public function testPreRemplissage(): void
    {
        [$b, $c] = $this->bailleurAvecContrat();
        $e = $this->ok(200, $this->api('GET', '/api/v1/contrats/'.$c['id'].'/encaissement', null, $b));
        self::assertSame(30000, $e['montantPropose']);
        self::assertSame('2026-10-01', $e['prochaineEcheance']['periodeDebut']);
        self::assertSame(30000, $e['loyer']);
        self::assertSame(13, $e['moisMaximum']);
        self::assertSame('USD', $e['devise']['code']);
    }

    /** R-27 : imputation sur l'échéance la plus ancienne ; R-25 : avance de plusieurs mois. */
    public function testImputationEtAvance(): void
    {
        [$b, $c] = $this->bailleurAvecContrat();
        $p = $this->ok(201, $this->payer($b, $c['id'], 90000));
        self::assertSame('valide', $p['statut']);
        self::assertSame('Bailleur Test', $p['saisiPar'], 'R-13 : auteur tracé');

        $contrat = $this->ok(200, $this->api('GET', '/api/v1/contrats/'.$c['id'], null, $b));
        self::assertSame(['payee', 'payee', 'payee', 'a_venir'], array_column(\array_slice($contrat['echeances'], 0, 4), 'statut'));
        self::assertSame(0, $contrat['enRetard']);
        self::assertSame('2027-01-01', $contrat['prochaineEcheance']['periodeDebut']);
    }

    /** R-26 : paiement partiel. */
    public function testPaiementPartiel(): void
    {
        [$b, $c] = $this->bailleurAvecContrat(debut: '2026-11-01');
        $this->ok(201, $this->payer($b, $c['id'], 10000));
        $contrat = $this->ok(200, $this->api('GET', '/api/v1/contrats/'.$c['id'], null, $b));
        self::assertSame('partielle', $contrat['echeances'][0]['statut']);
        self::assertSame(20000, $contrat['echeances'][0]['restantDu']);
        $e = $this->ok(200, $this->api('GET', '/api/v1/contrats/'.$c['id'].'/encaissement', null, $b));
        self::assertSame(20000, $e['montantPropose']);
    }

    public function testMontantSuperieurAuDu(): void
    {
        [$b, $c] = $this->bailleurAvecContrat();
        $this->erreur(422, 'PAIEMENT_SUPERIEUR_AU_DU', $this->payer($b, $c['id'], 30000 * 13 + 1));
        $this->erreur(422, 'DATE_FUTURE', $this->payer($b, $c['id'], 100, date: '2026-12-01'));
        $this->erreur(422, 'VALIDATION', $this->payer($b, $c['id'], 100, cle: 'pas-un-uuid'));
    }

    /** R-137 : la même clé renvoie le paiement existant, sans doublon ni nouveau reçu. */
    public function testIdempotence(): void
    {
        [$b, $c] = $this->bailleurAvecContrat();
        $cle = Uuid::v4()->toRfc4122();
        $premier = $this->ok(201, $this->payer($b, $c['id'], 30000, $cle));
        $rejeu = $this->ok(200, $this->payer($b, $c['id'], 30000, strtoupper($cle)));
        self::assertSame($premier['id'], $rejeu['id']);
        self::assertSame($premier['recu']['numero'], $rejeu['recu']['numero']);
        self::assertSame(1, $this->ok(200, $this->api('GET', '/api/v1/paiements', null, $b))['total']);

        // R-139 : jamais rejouée sous un autre compte.
        $autre = $this->utilisateur('Autre');
        $c2 = $this->contrat($autre, $this->unite($autre));
        $this->erreur(409, 'CLE_IDEMPOTENCE_CONFLIT', $this->payer($autre, $c2['id'], 100, $cle));
    }

    /** R-33 : numérotation séquentielle par espace, sans trou, même après un échec. */
    public function testNumerotationSansTrou(): void
    {
        [$b, $c] = $this->bailleurAvecContrat();
        $n1 = $this->ok(201, $this->payer($b, $c['id'], 10000))['recu']['numero'];
        $this->erreur(422, 'PAIEMENT_SUPERIEUR_AU_DU', $this->payer($b, $c['id'], 99999999));
        $n2 = $this->ok(201, $this->payer($b, $c['id'], 10000))['recu']['numero'];
        self::assertSame('CDL-2026-000001', $n1);
        self::assertSame('CDL-2026-000002', $n2);

        // Un autre bailleur a sa propre séquence.
        [$b2, $c2] = $this->bailleurAvecContrat();
        self::assertSame('CDL-2026-000001', $this->ok(201, $this->payer($b2, $c2['id'], 100))['recu']['numero']);
    }

    /** R-34 : annulation avec motif, contre-écriture, reçu annulé qui garde son numéro, recalcul. */
    public function testAnnulation(): void
    {
        [$b, $c] = $this->bailleurAvecContrat();
        $p1 = $this->ok(201, $this->payer($b, $c['id'], 30000, date: '2026-10-05'));
        $p2 = $this->ok(201, $this->payer($b, $c['id'], 30000, date: '2026-10-20'));

        $this->erreur(422, 'VALIDATION', $this->api('POST', '/api/v1/paiements/'.$p1['id'].'/annulation', ['motif' => ''], $b));
        $annule = $this->ok(200, $this->api('POST', '/api/v1/paiements/'.$p1['id'].'/annulation', ['motif' => 'Erreur de saisie'], $b));
        self::assertSame('annule', $annule['statut']);
        self::assertTrue($annule['recu']['annule']);
        self::assertSame($p1['recu']['numero'], $annule['recu']['numero']);
        $this->erreur(409, 'PAIEMENT_DEJA_ANNULE', $this->api('POST', '/api/v1/paiements/'.$p1['id'].'/annulation', ['motif' => 'encore'], $b));

        // Recalcul : le 2e paiement solde maintenant octobre, novembre redevient à venir.
        $contrat = $this->ok(200, $this->api('GET', '/api/v1/contrats/'.$c['id'], null, $b));
        self::assertSame(['payee', 'a_venir'], array_column(\array_slice($contrat['echeances'], 0, 2), 'statut'));
        unset($p2);

        // R-35 : correction = nouvelle saisie avec un nouveau reçu.
        self::assertSame('CDL-2026-000003', $this->ok(201, $this->payer($b, $c['id'], 30000))['recu']['numero']);
    }

    /** R-27 : le bailleur corrige l'imputation à la main ; elle survit aux recalculs. */
    public function testReimputationManuelle(): void
    {
        [$b, $c] = $this->bailleurAvecContrat();
        $p1 = $this->ok(201, $this->payer($b, $c['id'], 30000, date: '2026-10-02'));
        $contrat = $this->ok(200, $this->api('GET', '/api/v1/contrats/'.$c['id'], null, $b));
        [$oct, $nov, $dec] = array_column(\array_slice($contrat['echeances'], 0, 3), 'id');

        $this->erreur(422, 'IMPUTATION_TOTAL_INCORRECT', $this->api('PUT', '/api/v1/paiements/'.$p1['id'].'/imputations', ['imputations' => [['echeanceId' => $nov, 'montant' => 100]]], $b));
        $this->ok(200, $this->api('PUT', '/api/v1/paiements/'.$p1['id'].'/imputations', ['imputations' => [['echeanceId' => $nov, 'montant' => 30000]]], $b));

        // Un 2e paiement automatique va sur octobre (plus ancien impayé), puis on annule un 3e : la correction manuelle tient.
        $this->ok(201, $this->payer($b, $c['id'], 30000));
        $p3 = $this->ok(201, $this->payer($b, $c['id'], 15000));
        $this->ok(200, $this->api('POST', '/api/v1/paiements/'.$p3['id'].'/annulation', ['motif' => 'Doublon'], $b));
        $contrat = $this->ok(200, $this->api('GET', '/api/v1/contrats/'.$c['id'], null, $b));
        $parId = array_column($contrat['echeances'], null, 'id');
        self::assertSame('payee', $parId[$oct]['statut']);
        self::assertSame('payee', $parId[$nov]['statut']);
        self::assertSame(0, $parId[$dec]['montantPaye']);
    }

    /** R-30 : la garantie a son propre reçu et n'entre jamais dans les loyers dus. */
    public function testGarantieSepareeDesLoyers(): void
    {
        $b = $this->utilisateur();
        $c = $this->contrat($b, $this->unite($b), garantie: 60000);
        self::assertSame('attendue', $c['garantie']['statut']);
        $this->erreur(422, 'GARANTIE_MONTANT_INCORRECT', $this->payer($b, $c['id'], 1000, type: 'garantie'));
        $g = $this->ok(201, $this->payer($b, $c['id'], 60000, type: 'garantie'));
        self::assertSame('garantie', $g['type']);
        self::assertNotNull($g['recu']);
        $contrat = $this->ok(200, $this->api('GET', '/api/v1/contrats/'.$c['id'], null, $b));
        self::assertSame('detenue', $contrat['garantie']['statut']);
        self::assertSame(30000, $contrat['enRetard'], 'La garantie ne solde aucun loyer');
        $this->erreur(422, 'GARANTIE_NON_ATTENDUE', $this->payer($b, $c['id'], 60000, type: 'garantie'));

        // Annuler la garantie la remet en attente.
        $this->ok(200, $this->api('POST', '/api/v1/paiements/'.$g['id'].'/annulation', ['motif' => 'Erreur'], $b));
        self::assertSame('attendue', $this->ok(200, $this->api('GET', '/api/v1/contrats/'.$c['id'], null, $b))['garantie']['statut']);
    }

    /** R-75 : page publique du reçu, sans compte, lien non devinable. */
    public function testRecuPublic(): void
    {
        [$b, $c] = $this->bailleurAvecContrat();
        $p = $this->ok(201, $this->payer($b, $c['id'], 30000));
        $chemin = parse_url($p['recu']['lien'], PHP_URL_PATH);
        self::assertMatchesRegularExpression('#^/r/[a-f0-9]{48}$#', $chemin);

        $this->client->request('GET', $chemin);
        $html = (string) $this->client->getResponse()->getContent();
        self::assertSame(200, $this->client->getResponse()->getStatusCode());
        self::assertStringContainsString($p['recu']['numero'], $html);
        self::assertStringContainsString('300,00', $html);
        self::assertStringContainsString('noindex', (string) $this->client->getResponse()->headers->get('X-Robots-Tag'));

        $this->client->request('GET', '/r/'.str_repeat('0', 48));
        self::assertSame(404, $this->client->getResponse()->getStatusCode());

        $this->ok(200, $this->api('POST', '/api/v1/paiements/'.$p['id'].'/annulation', ['motif' => 'Erreur'], $b));
        $this->client->request('GET', $chemin);
        self::assertStringContainsString('Reçu annulé', (string) $this->client->getResponse()->getContent());
    }

    public function testAutreBailleurNePeutRienFaire(): void
    {
        [$b, $c] = $this->bailleurAvecContrat();
        $p = $this->ok(201, $this->payer($b, $c['id'], 30000));
        $intrus = $this->utilisateur('Intrus');
        $this->erreur(404, 'INTROUVABLE', $this->payer($intrus, $c['id'], 100));
        $this->erreur(404, 'INTROUVABLE', $this->api('POST', '/api/v1/paiements/'.$p['id'].'/annulation', ['motif' => 'x'], $intrus));
        $this->erreur(404, 'INTROUVABLE', $this->api('GET', '/api/v1/contrats/'.$c['id'], null, $intrus));
    }

    public function testTableauDeBord(): void
    {
        [$b, $c] = $this->bailleurAvecContrat();
        $this->unite($b, 'Vacante');
        $this->ok(201, $this->payer($b, $c['id'], 10000));
        $t = $this->ok(200, $this->api('GET', '/api/v1/tableau-de-bord', null, $b));
        self::assertSame(2, $t['unites']);
        self::assertSame(1, $t['unitesLouees']);
        self::assertSame(1, $t['unitesVacantes']);
        self::assertSame([['devise' => 'USD', 'montant' => 20000]], $t['enRetard']);
        self::assertSame([['devise' => 'USD', 'montant' => 10000]], $t['encaisseCeMois']);
    }
}
