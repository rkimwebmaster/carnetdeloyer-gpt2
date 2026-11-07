<?php

namespace App\Tests\Api;

use App\Tests\ApiTestCase;

final class DeclarationTest extends ApiTestCase
{
    /**
     * @return array{0: \App\Entity\User, 1: \App\Entity\User, 2: array}
     */
    private function bailleurEtLocataireRattache(): array
    {
        $bailleur = $this->utilisateur('Bailleur');
        $locataire = $this->utilisateur('Locataire inscrit', '+243970111222');
        $contrat = $this->contrat($bailleur, $this->unite($bailleur), telLocataire: '+243 970 111 222');

        $a = $this->ok(200, $this->api('GET', '/api/v1/locataire/rattachements', null, $locataire));
        self::assertCount(1, $a);
        self::assertSame('Bailleur', $a[0]['bailleur']);
        $this->ok(200, $this->api('POST', '/api/v1/locataire/rattachements/'.$a[0]['contactId'], null, $locataire));

        return [$bailleur, $locataire, $contrat];
    }

    /** R-72 : rattachement après confirmation, R-73 : un compte, deux modes. */
    public function testRattachementEtConsultation(): void
    {
        [$bailleur, $locataire, $contrat] = $this->bailleurEtLocataireRattache();
        // Avant/sans rattachement, un autre utilisateur ne voit rien.
        $autre = $this->utilisateur('Autre');
        $this->erreur(404, 'INTROUVABLE', $this->api('GET', '/api/v1/locataire/contrats/'.$contrat['id'], null, $autre));

        $this->ok(201, $this->payer($bailleur, $contrat['id'], 30000));
        $vue = $this->ok(200, $this->api('GET', '/api/v1/locataire/contrats/'.$contrat['id'], null, $locataire));
        self::assertSame('Bailleur', $vue['bailleur']['nom']);
        self::assertCount(1, $vue['paiements']);
        self::assertNotNull($vue['paiements'][0]['recu']['lien']);
        self::assertSame(-4.3217, $vue['adresse']['latitude'], 'R-88 : position exacte pour le locataire rattaché');

        $liste = $this->ok(200, $this->api('GET', '/api/v1/locataire/contrats', null, $locataire));
        self::assertSame(1, $liste['total']);
        // Le locataire n'a aucun droit de bailleur sur ce contrat.
        $this->erreur(404, 'INTROUVABLE', $this->api('GET', '/api/v1/contrats/'.$contrat['id'], null, $locataire));
        $this->erreur(404, 'INTROUVABLE', $this->payer($locataire, $contrat['id'], 100));
    }

    /** R-72 : si le bailleur change le numéro, l'ancien perd l'accès. */
    public function testChangementDeNumeroRetireLAcces(): void
    {
        [$bailleur, $locataire, $contrat] = $this->bailleurEtLocataireRattache();
        $this->ok(200, $this->api('PATCH', '/api/v1/contacts/'.$contrat['locataire']['id'], ['telephone' => '+243970999000'], $bailleur));
        $this->erreur(404, 'INTROUVABLE', $this->api('GET', '/api/v1/locataire/contrats/'.$contrat['id'], null, $locataire));
    }

    /** R-39, R-40 : déclaration, sans effet sur le solde avant validation. */
    public function testDeclarationValidee(): void
    {
        [$bailleur, $locataire, $contrat] = $this->bailleurEtLocataireRattache();
        $d = $this->ok(201, $this->api('POST', '/api/v1/locataire/contrats/'.$contrat['id'].'/declarations', ['montant' => 30000, 'datePaiement' => '2026-10-26', 'reference' => 'MP261026.1234'], $locataire));
        self::assertSame('en_attente', $d['statut']);

        $c = $this->ok(200, $this->api('GET', '/api/v1/contrats/'.$contrat['id'], null, $bailleur));
        self::assertSame(30000, $c['enRetard'], 'En attente, la déclaration ne modifie jamais le solde');

        $file = $this->ok(200, $this->api('GET', '/api/v1/declarations', null, $bailleur));
        self::assertSame(1, $file['total']);

        $v = $this->ok(200, $this->api('POST', '/api/v1/declarations/'.$d['id'].'/validation', null, $bailleur));
        self::assertSame('validee', $v['statut']);
        $c = $this->ok(200, $this->api('GET', '/api/v1/contrats/'.$contrat['id'], null, $bailleur));
        self::assertSame(0, $c['enRetard']);
        self::assertSame('mobile_money', $c['paiements'][0]['moyen']);
        self::assertNotNull($c['paiements'][0]['recu']);
        $this->erreur(409, 'DECLARATION_DEJA_TRAITEE', $this->api('POST', '/api/v1/declarations/'.$d['id'].'/validation', null, $bailleur));
    }

    public function testDeclarationRefusee(): void
    {
        [$bailleur, $locataire, $contrat] = $this->bailleurEtLocataireRattache();
        $d = $this->ok(201, $this->api('POST', '/api/v1/locataire/contrats/'.$contrat['id'].'/declarations', ['montant' => 30000, 'datePaiement' => '2026-10-26'], $locataire));
        $this->erreur(422, 'VALIDATION', $this->api('POST', '/api/v1/declarations/'.$d['id'].'/refus', ['motif' => ''], $bailleur));
        $r = $this->ok(200, $this->api('POST', '/api/v1/declarations/'.$d['id'].'/refus', ['motif' => 'Aucun dépôt reçu'], $bailleur));
        self::assertSame('refusee', $r['statut']);
        $c = $this->ok(200, $this->api('GET', '/api/v1/contrats/'.$contrat['id'], null, $bailleur));
        self::assertSame(30000, $c['enRetard']);
        self::assertCount(0, $c['paiements']);
        $vue = $this->ok(200, $this->api('GET', '/api/v1/locataire/contrats/'.$contrat['id'], null, $locataire));
        self::assertSame('Aucun dépôt reçu', $vue['declarations'][0]['motifRefus']);
    }

    /** R-40 : relance, jamais de validation automatique. */
    public function testRelanceSansValidationAutomatique(): void
    {
        [$bailleur, $locataire, $contrat] = $this->bailleurEtLocataireRattache();
        $this->ok(201, $this->api('POST', '/api/v1/locataire/contrats/'.$contrat['id'].'/declarations', ['montant' => 30000, 'datePaiement' => '2026-10-26'], $locataire));
        $this->horloge->modify('+3 days');
        $declarations = static::getContainer()->get(\App\Service\Declarations::class);
        self::assertSame(1, $declarations->relancer());
        self::assertSame(0, $declarations->relancer(), 'Pas de double relance le même jour');
        self::assertSame(1, $this->ok(200, $this->api('GET', '/api/v1/declarations', null, $bailleur))['total'], 'Toujours en attente');

        $activites = $this->ok(200, $this->api('GET', '/api/v1/activites', null, $bailleur));
        self::assertContains('declaration_relance', array_column($activites['elements'], 'type'));
    }

    /** R-173 : le locataire ne voit que l'activité de ses propres contrats. */
    public function testFilDActiviteParMode(): void
    {
        [$bailleur, $locataire, $contrat] = $this->bailleurEtLocataireRattache();
        $this->ok(201, $this->payer($bailleur, $contrat['id'], 30000));
        $autreContrat = $this->contrat($bailleur, $this->unite($bailleur, 'Autre'), telLocataire: '+243970333444');
        $this->ok(201, $this->payer($bailleur, $autreContrat['id'], 30000));

        $bailleurVoit = $this->ok(200, $this->api('GET', '/api/v1/activites?mode=bailleur', null, $bailleur));
        self::assertSame(2, \count(array_filter($bailleurVoit['elements'], static fn ($a) => 'paiement_enregistre' === $a['type'])));

        $locataireVoit = $this->ok(200, $this->api('GET', '/api/v1/activites?mode=locataire', null, $locataire));
        $paiements = array_values(array_filter($locataireVoit['elements'], static fn ($a) => 'paiement_enregistre' === $a['type']));
        self::assertCount(1, $paiements);
        self::assertSame($contrat['id'], $paiements[0]['contratId']);
        self::assertSame(30000, $paiements[0]['parametres']['montant']);
        self::assertCount(0, array_filter($locataireVoit['elements'], static fn ($a) => 'abonnement_gratuit' === $a['type']), 'Pas d\'activité d\'abonnement côté locataire');
    }
}
