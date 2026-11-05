<?php

namespace App\Tests\Api;

use App\Entity\JournalAudit;
use App\Tests\ApiTestCase;

final class CompteTest extends ApiTestCase
{
    /** R-74, R-121 : message de reçu prêt à partager, avec lien de confidentialité. */
    public function testMessageDePartageDuRecu(): void
    {
        $b = $this->utilisateur();
        $c = $this->contrat($b, $this->unite($b, 'Studio 4'));
        $p = $this->ok(201, $this->payer($b, $c['id'], 30000));
        $message = $p['recu']['messagePartage'];
        self::assertStringContainsString('Locataire Test', $message);
        self::assertStringContainsString('300,00 $', $message);
        self::assertStringContainsString($p['recu']['lien'], $message);
        self::assertStringContainsString('/confidentialite', $message);

        $this->client->request('GET', '/confidentialite');
        self::assertSame(200, $this->client->getResponse()->getStatusCode());
    }

    /** R-123 : export. */
    public function testExport(): void
    {
        $b = $this->utilisateur();
        $c = $this->contrat($b, $this->unite($b));
        $this->ok(201, $this->payer($b, $c['id'], 30000));
        $export = $this->ok(200, $this->api('GET', '/api/v1/moi/export', null, $b));
        self::assertCount(1, $export['contratsBailleur']);
        self::assertCount(1, $export['contratsBailleur'][0]['paiements']);
        self::assertStringContainsString('attachment', (string) $this->client->getResponse()->headers->get('Content-Disposition'));
    }

    /** R-122 : suppression = anonymisation ; preuves conservées pour l'autre partie. */
    public function testSuppressionDeCompte(): void
    {
        $b = $this->utilisateur('Bailleur');
        $locataire = $this->utilisateur('Locataire', '+243970777888');
        $c = $this->contrat($b, $this->unite($b), telLocataire: '+243970777888');
        $a = $this->ok(200, $this->api('GET', '/api/v1/locataire/rattachements', null, $locataire));
        $this->ok(200, $this->api('POST', '/api/v1/locataire/rattachements/'.$a[0]['contactId'], null, $locataire));
        $this->ok(201, $this->payer($b, $c['id'], 30000));

        $this->ok(200, $this->api('DELETE', '/api/v1/moi', null, $locataire));
        $brut = $this->em()->getConnection()->fetchAssociative('SELECT nom, telephone, telephone_empreinte, actif FROM `user` WHERE id = ?', [$locataire->getId()]);
        self::assertSame(['nom' => 'Compte supprimé', 'telephone' => null, 'telephone_empreinte' => null, 'actif' => 0], $brut);

        // Le bailleur garde contrat, paiement et reçu.
        $vue = $this->ok(200, $this->api('GET', '/api/v1/contrats/'.$c['id'], null, $b));
        self::assertCount(1, $vue['paiements']);
        self::assertNull($vue['locataire']['telephone']);
    }

    /** R-110, R-115 : recherche, suspension, journal d'audit. */
    public function testBackOfficeComptesEtAudit(): void
    {
        $cible = $this->utilisateur('Cible', '+243970123123');
        $admin = $this->utilisateur('Support', roles: ['ROLE_ADMIN']);
        $trouve = $this->ok(200, $this->api('GET', '/api/v1/admin/utilisateurs?q='.urlencode('+243 970 123 123'), null, $admin));
        self::assertSame(1, $trouve['total']);
        self::assertNull($trouve['elements'][0]['wallet'], 'R-116 : le support ne voit pas le wallet');

        $this->ok(200, $this->api('PUT', '/api/v1/admin/utilisateurs/'.$cible->getId().'/suspension', ['suspendu' => true], $admin));
        $journal = $this->ok(200, $this->api('GET', '/api/v1/admin/audit', null, $admin));
        self::assertSame('compte_suspendu', $journal['elements'][0]['action']);
        self::assertSame('Support', $journal['elements'][0]['admin']);
        self::assertSame(1, $this->em()->getRepository(JournalAudit::class)->count([]));

        $tdb = $this->ok(200, $this->api('GET', '/api/v1/admin/tableau-de-bord', null, $admin));
        self::assertArrayHasKey('chiffreAffairesMoisUsd', $tdb);
    }
}
