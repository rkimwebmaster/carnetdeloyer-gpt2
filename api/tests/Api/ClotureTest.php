<?php

namespace App\Tests\Api;

use App\Tests\ApiTestCase;

final class ClotureTest extends ApiTestCase
{
    /** R-37, R-38 : échéances postérieures annulées, impayés dus, lecture seule, unité vacante. */
    public function testClotureSimple(): void
    {
        $b = $this->utilisateur();
        $unite = $this->unite($b);
        $c = $this->contrat($b, $unite, dateDebut: '2026-08-01');
        $this->ok(201, $this->payer($b, $c['id'], 30000));

        $r = $this->ok(200, $this->api('POST', '/api/v1/contrats/'.$c['id'].'/cloture', ['dateSortie' => '2026-10-15', 'montantDerniereEcheance' => 15000], $b));
        self::assertSame('cloture', $r['contrat']['statut']);
        // Août payé ; septembre 30000 + octobre ajusté à 15000 restent dus (pas de prorata automatique).
        self::assertSame(45000, $r['restantDu']);
        self::assertSame(0, $r['tropPercu']);
        $statuts = array_column($r['contrat']['echeances'], 'statut');
        self::assertSame(['payee', 'en_retard', 'en_retard'], \array_slice($statuts, 0, 3));
        self::assertSame(['annulee'], array_values(array_unique(\array_slice($statuts, 3))));

        // Lecture seule.
        $this->erreur(409, 'CONTRAT_CLOTURE', $this->payer($b, $c['id'], 100));
        $this->erreur(409, 'CONTRAT_CLOTURE', $this->api('POST', '/api/v1/contrats/'.$c['id'].'/cloture', ['dateSortie' => '2026-10-15'], $b));
        // L'unité redevient vacante et peut être relouée.
        self::assertTrue($this->ok(200, $this->api('GET', "/api/v1/unites/$unite", null, $b))['vacante']);
        $this->contrat($b, $unite, dateDebut: '2026-11-01');
    }

    /** Une avance au-delà de la sortie apparaît comme trop-perçu (à rembourser hors app). */
    public function testTropPercuApresSortie(): void
    {
        $b = $this->utilisateur();
        $c = $this->contrat($b, $this->unite($b), dateDebut: '2026-10-01');
        $this->ok(201, $this->payer($b, $c['id'], 90000));
        $r = $this->ok(200, $this->api('POST', '/api/v1/contrats/'.$c['id'].'/cloture', ['dateSortie' => '2026-10-31'], $b));
        self::assertSame(60000, $r['tropPercu']);
        self::assertSame(0, $r['restantDu']);
    }

    /** R-32 : règlement explicite de la garantie à la clôture. */
    public function testGarantieRestitueeOuRetenue(): void
    {
        $b = $this->utilisateur();
        $c = $this->contrat($b, $this->unite($b, 'A'), garantie: 60000);
        $this->ok(201, $this->payer($b, $c['id'], 60000, type: 'garantie'));

        $this->erreur(422, 'GARANTIE_REGLEMENT_REQUIS', $this->api('POST', '/api/v1/contrats/'.$c['id'].'/cloture', ['dateSortie' => '2026-10-31'], $b));
        $this->erreur(422, 'MOTIF_REQUIS', $this->api('POST', '/api/v1/contrats/'.$c['id'].'/cloture', ['dateSortie' => '2026-10-31', 'garantie' => 'partiellement_retenue', 'montantRetenu' => 10000], $b));
        $this->erreur(422, 'MONTANT_INVALIDE', $this->api('POST', '/api/v1/contrats/'.$c['id'].'/cloture', ['dateSortie' => '2026-10-31', 'garantie' => 'partiellement_retenue', 'montantRetenu' => 70000, 'motif' => 'x'], $b));

        $r = $this->ok(200, $this->api('POST', '/api/v1/contrats/'.$c['id'].'/cloture', ['dateSortie' => '2026-10-31', 'garantie' => 'partiellement_retenue', 'montantRetenu' => 10000, 'motif' => 'Peinture'], $b));
        self::assertSame(['montant' => 60000, 'statut' => 'partiellement_retenue', 'retenue' => 10000, 'motif' => 'Peinture'], $r['contrat']['garantie']);

        $c2 = $this->contrat($b, $this->unite($b, 'B'), garantie: 60000);
        $this->ok(201, $this->payer($b, $c2['id'], 60000, type: 'garantie'));
        $r2 = $this->ok(200, $this->api('POST', '/api/v1/contrats/'.$c2['id'].'/cloture', ['dateSortie' => '2026-10-31', 'garantie' => 'restituee'], $b));
        self::assertSame('restituee', $r2['contrat']['garantie']['statut']);
    }

    /** R-32 : garantie imputée sur loyers impayés, par une écriture avec reçu. */
    public function testGarantieImputeeSurLoyers(): void
    {
        $b = $this->utilisateur();
        $c = $this->contrat($b, $this->unite($b), dateDebut: '2026-09-01', garantie: 45000);
        $this->ok(201, $this->payer($b, $c['id'], 45000, type: 'garantie'));

        $r = $this->ok(200, $this->api('POST', '/api/v1/contrats/'.$c['id'].'/cloture', ['dateSortie' => '2026-10-31', 'garantie' => 'imputee_sur_loyers'], $b));
        self::assertSame(45000, $r['garantieImputee']);
        self::assertSame(15000, $r['restantDu']);
        self::assertSame('imputee_sur_loyers', $r['contrat']['garantie']['statut']);
        $imputation = array_values(array_filter($r['contrat']['paiements'], static fn ($p) => 'garantie' === $p['moyen']));
        self::assertCount(1, $imputation);
        self::assertSame(45000, $imputation[0]['montant']);
        self::assertNotNull($imputation[0]['recu']);
    }
}
