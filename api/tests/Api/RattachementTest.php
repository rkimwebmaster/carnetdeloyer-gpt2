<?php

namespace App\Tests\Api;

use App\Entity\Contact;
use App\Entity\User;
use App\Service\Authentification;
use App\Sms\SmsEnvoyeurInterface;
use App\Tests\ApiTestCase;

/** R-19, R-72, R-182 : possession du numéro et consentement propre à chaque contrat. */
final class RattachementTest extends ApiTestCase
{
    public function testCompteProvisoirePuisInscriptionConserveIdentiteEtContrats(): void
    {
        $bailleur = $this->utilisateur('Bailleur');
        $tel = $this->nouveauTelephone();
        $c = $this->contrat($bailleur, $this->unite($bailleur), telLocataire: $tel);
        self::assertFalse($c['locataire']['inscrit']);
        $contact = $this->em()->find(Contact::class, $c['locataire']['id']);
        $provisoire = $contact->getUtilisateur();
        self::assertNotNull($provisoire);
        self::assertFalse($provisoire->isTelephoneVerifie());
        $id = $provisoire->getId();
        $this->erreur(403, 'TELEPHONE_NON_VERIFIE', $this->api('GET', '/api/v1/moi', null, $provisoire));

        // Même téléphone, autre bien : une seule identité, sans ouvrir d'accès.
        $this->contrat($bailleur, $this->unite($bailleur, 'Autre bien'), telLocataire: $tel);
        self::assertSame(1, $this->em()->getRepository(User::class)->count(['telephoneEmpreinte' => $provisoire->getTelephoneEmpreinte()]));

        $this->ok(202, $this->api('POST', '/api/v1/auth/otp', ['telephone' => $tel]));
        $sms = static::getContainer()->get(SmsEnvoyeurInterface::class)->dernierPour($tel);
        preg_match('/\b(\d{6})\b/', $sms, $m);
        $verification = $this->ok(200, $this->api('POST', '/api/v1/auth/otp/verification', ['telephone' => $tel, 'code' => $m[1]]));
        self::assertTrue($verification['inscriptionRequise']);
        self::assertArrayNotHasKey('token', $verification);
        $this->ok(201, $this->api('POST', '/api/v1/auth/inscription', ['telephone' => $tel, 'nom' => 'Mon vrai nom', 'jetonInscription' => $verification['jetonInscription']]));
        $user = $this->em()->find(User::class, $id);
        self::assertTrue($user->isTelephoneVerifie());
        self::assertSame('Mon vrai nom', $user->getNom());
        self::assertSame($id, $this->em()->find(Contact::class, $contact->getId())->getUtilisateur()->getId());
        self::assertCount(2, $this->ok(200, $this->api('GET', '/api/v1/locataire/rattachements', null, $user)));
        $this->erreur(404, 'INTROUVABLE', $this->api('GET', '/api/v1/locataire/contrats/'.$c['id'], null, $user));
    }

    private function deuxContrats(): array
    {
        $b = $this->utilisateur('Bailleur');
        $l = $this->utilisateur('Locataire');
        $c1 = $this->contrat($b, $this->unite($b, 'U1'), telLocataire: $l->getTelephone());
        $c2 = $this->ok(201, $this->api('POST', '/api/v1/contrats', [
            'uniteId' => $this->unite($b, 'U2'), 'contactId' => $c1['locataire']['id'], 'devise' => 'USD', 'loyer' => 30000, 'dateDebut' => '2026-10-01',
        ], $b));

        return [$b, $l, $c1, $c2];
    }

    public function testConfirmationNeDonnePasAccesAuxAutresContratsDuContact(): void
    {
        [$b, $l, $c1, $c2] = $this->deuxContrats();
        $attente = $this->ok(200, $this->api('GET', '/api/v1/locataire/rattachements', null, $l));
        self::assertCount(2, $attente[0]['contrats']);
        $this->erreur(409, 'CONFIRMATION_PAR_CONTRAT_REQUISE', $this->api('POST', '/api/v1/locataire/rattachements/'.$c1['locataire']['id'], null, $l));
        $this->ok(200, $this->api('POST', '/api/v1/locataire/contrats/'.$c1['id'].'/confirmation', null, $l));
        $this->ok(200, $this->api('POST', '/api/v1/locataire/contrats/'.$c1['id'].'/confirmation', null, $l));
        $this->ok(200, $this->api('GET', '/api/v1/locataire/contrats/'.$c1['id'], null, $l));
        $this->erreur(404, 'INTROUVABLE', $this->api('GET', '/api/v1/locataire/contrats/'.$c2['id'], null, $l));
        self::assertSame(1, $this->ok(200, $this->api('GET', '/api/v1/locataire/contrats', null, $l))['total']);
        self::assertCount(1, $this->ok(200, $this->api('GET', '/api/v1/moi/export', null, $l))['contratsLocataire']);
        $this->ok(201, $this->payer($b, $c1['id'], 100));
        $this->ok(201, $this->payer($b, $c2['id'], 200));
        self::assertSame(1, $this->ok(200, $this->api('GET', '/api/v1/locataire/paiements', null, $l))['total']);
        $activites = $this->ok(200, $this->api('GET', '/api/v1/activites?mode=locataire', null, $l));
        self::assertNotContains($c2['id'], array_column($activites['elements'], 'contratId'));
    }

    public function testRefusNeCloturePasLeContratEtNeRetirePasLesAutresLocations(): void
    {
        [$b, $l, $c1, $c2] = $this->deuxContrats();
        foreach ([$c1, $c2] as $c) {
            $this->ok(200, $this->api('POST', '/api/v1/locataire/contrats/'.$c['id'].'/confirmation', null, $l));
        }
        $this->ok(200, $this->api('POST', '/api/v1/locataire/contrats/'.$c1['id'].'/refus', null, $l));
        $this->ok(200, $this->api('POST', '/api/v1/locataire/contrats/'.$c1['id'].'/refus', null, $l));
        $this->erreur(404, 'INTROUVABLE', $this->api('GET', '/api/v1/locataire/contrats/'.$c1['id'], null, $l));
        $this->ok(200, $this->api('GET', '/api/v1/locataire/contrats/'.$c2['id'], null, $l));
        self::assertSame([], $this->ok(200, $this->api('GET', '/api/v1/locataire/rattachements', null, $l)));
        $vuBailleur = $this->ok(200, $this->api('GET', '/api/v1/contrats/'.$c1['id'], null, $b));
        self::assertSame('actif', $vuBailleur['statut']);
        self::assertNotNull($vuBailleur['locataireRefuseLe']);
        $activites = $this->ok(200, $this->api('GET', '/api/v1/activites', null, $b));
        self::assertCount(1, array_filter($activites['elements'], static fn ($a) => 'contrat_refuse' === $a['type']));
    }

    public function testCorrectionAvantConfirmationRetireAncienNumeroEtPermetAuBonDeConfirmer(): void
    {
        $b = $this->utilisateur();
        $ancien = $this->utilisateur('Mauvais numéro');
        $bon = $this->utilisateur('Bon numéro');
        $c = $this->contrat($b, $this->unite($b), telLocataire: $ancien->getTelephone());
        $this->ok(200, $this->api('POST', '/api/v1/locataire/contrats/'.$c['id'].'/refus', null, $ancien));
        $this->erreur(404, 'INTROUVABLE', $this->api('POST', '/api/v1/locataire/contrats/'.$c['id'].'/confirmation', null, $ancien));
        $this->ok(200, $this->api('PATCH', '/api/v1/contacts/'.$c['locataire']['id'], ['telephone' => $bon->getTelephone()], $b));
        self::assertSame([], $this->ok(200, $this->api('GET', '/api/v1/locataire/rattachements', null, $ancien)));
        $this->erreur(404, 'INTROUVABLE', $this->api('POST', '/api/v1/locataire/contrats/'.$c['id'].'/confirmation', null, $ancien));
        $this->ok(200, $this->api('POST', '/api/v1/locataire/contrats/'.$c['id'].'/confirmation', null, $bon));
        $this->ok(200, $this->api('GET', '/api/v1/locataire/contrats/'.$c['id'], null, $bon));
        $this->erreur(409, 'LOCATAIRE_CONFIRME', $this->api('PATCH', '/api/v1/contacts/'.$c['locataire']['id'], ['telephone' => $ancien->getTelephone()], $b));
    }

    public function testAutreCompteNePeutNiConfirmerNiRefuser(): void
    {
        $b = $this->utilisateur();
        $l = $this->utilisateur('Locataire');
        $autre = $this->utilisateur('Autre');
        $c = $this->contrat($b, $this->unite($b), telLocataire: $l->getTelephone());
        foreach (['confirmation', 'refus'] as $action) {
            $this->erreur(404, 'INTROUVABLE', $this->api('POST', '/api/v1/locataire/contrats/'.$c['id'].'/'.$action, null, $autre));
        }
        $this->erreur(404, 'INTROUVABLE', $this->api('POST', '/api/v1/locataire/contrats/'.$c['id'].'/declarations', ['montant' => 100, 'datePaiement' => '2026-10-27'], $l));
    }

    public function testLocataireChangeLuiMemeSonNumeroAvecOtpEtGardeSesContrats(): void
    {
        [$b, $l, $c1, $c2] = $this->deuxContrats();
        $ancien = $l->getTelephone();
        $this->ok(200, $this->api('POST', '/api/v1/locataire/contrats/'.$c1['id'].'/confirmation', null, $l));
        $nouveau = $this->nouveauTelephone();
        $this->ok(202, $this->api('POST', '/api/v1/auth/otp', ['telephone' => $nouveau]));
        $sms = static::getContainer()->get(SmsEnvoyeurInterface::class)->dernierPour($nouveau);
        preg_match('/\b(\d{6})\b/', $sms, $m);
        $faux = '000000' === $m[1] ? '111111' : '000000';
        $this->erreur(422, 'OTP_INVALIDE', $this->api('POST', '/api/v1/moi/telephone', ['telephone' => $nouveau, 'code' => $faux], $l));
        self::assertSame(1, $this->em()->getRepository(\App\Entity\OtpCode::class)->findOneBy([], ['id' => 'DESC'])->getTentatives(), 'Une tentative incorrecte reste comptée.');
        self::assertSame($ancien, $this->em()->find(User::class, $l->getId())->getTelephone());
        $profil = $this->ok(200, $this->api('POST', '/api/v1/moi/telephone', ['telephone' => $nouveau, 'code' => $m[1]], $l));
        self::assertSame($l->getId(), $profil['id']);
        self::assertSame($nouveau, $profil['telephone']);
        $this->ok(200, $this->api('GET', '/api/v1/locataire/contrats/'.$c1['id'], null, $l));
        $this->erreur(404, 'INTROUVABLE', $this->api('GET', '/api/v1/locataire/contrats/'.$c2['id'], null, $l));
        self::assertSame($nouveau, $this->ok(200, $this->api('GET', '/api/v1/contrats/'.$c1['id'], null, $b))['locataire']['telephone']);
        $auth = static::getContainer()->get(Authentification::class);
        self::assertNull($auth->utilisateurParTelephone($ancien));
        self::assertSame($l->getId(), $auth->utilisateurParTelephone($nouveau)->getId());
        $this->erreur(422, 'OTP_EXPIRE', $this->api('POST', '/api/v1/moi/telephone', ['telephone' => $nouveau, 'code' => $m[1]], $l));
    }

    public function testChangementDeNumeroNeFusionneJamaisDeuxComptes(): void
    {
        $user = $this->utilisateur();
        $autre = $this->utilisateur('Autre');
        $avant = $user->getTelephone();
        $this->erreur(409, 'TELEPHONE_DEJA_UTILISE', $this->api('POST', '/api/v1/moi/telephone', ['telephone' => $autre->getTelephone(), 'code' => '123456'], $user));
        self::assertSame($avant, $this->em()->find(User::class, $user->getId())->getTelephone());
        self::assertSame(2, $this->em()->getRepository(User::class)->count([]));
    }
}
