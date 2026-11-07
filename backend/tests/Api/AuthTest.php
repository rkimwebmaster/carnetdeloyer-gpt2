<?php

namespace App\Tests\Api;

use App\Entity\User;
use App\Sms\SmsEnvoyeurInterface;
use App\Tests\ApiTestCase;

final class AuthTest extends ApiTestCase
{
    private function dernierCode(string $telephone): string
    {
        $sms = static::getContainer()->get(SmsEnvoyeurInterface::class)->dernierPour($telephone);
        self::assertNotNull($sms, 'Aucun SMS envoyé');
        self::assertMatchesRegularExpression('/\b(\d{6})\b/', $sms);
        preg_match('/\b(\d{6})\b/', $sms, $m);

        return $m[1];
    }

    private function demanderCode(string $telephone): string
    {
        $this->ok(202, $this->api('POST', '/api/v1/auth/otp', ['telephone' => $telephone]));

        return $this->dernierCode($telephone);
    }

    /** R-160 : téléphone, OTP, nom, code parrain facultatif. */
    public function testInscriptionComplete(): void
    {
        $parrain = $this->utilisateur('Parrain');
        $telephone = '+243 970 123 456';
        $code = $this->demanderCode('+243970123456');

        $verif = $this->ok(200, $this->api('POST', '/api/v1/auth/otp/verification', ['telephone' => $telephone, 'code' => $code]));
        self::assertTrue($verif['inscriptionRequise']);
        self::assertArrayNotHasKey('token', $verif);

        $jetons = $this->ok(201, $this->api('POST', '/api/v1/auth/inscription', [
            'telephone' => $telephone, 'jetonInscription' => $verif['jetonInscription'], 'nom' => 'Aline Mbuyi', 'codeParrain' => strtolower($parrain->getCodeParrainage()),
        ]));
        self::assertNotEmpty($jetons['token']);
        self::assertNotEmpty($jetons['refresh_token']);

        $this->client->request('GET', '/api/v1/moi', server: ['HTTP_AUTHORIZATION' => 'Bearer '.$jetons['token']]);
        $moi = json_decode((string) $this->client->getResponse()->getContent(), true);
        self::assertSame('Aline Mbuyi', $moi['nom']);
        self::assertSame('+243970123456', $moi['telephone']);
        // R-17 : pays déduit de l'indicatif.
        self::assertSame('CD', $moi['pays']['codeIso']);
        self::assertTrue($moi['aUnParrain']);
        self::assertNull($moi['modePrefere']);

        // Le jeton d'inscription n'est utilisable qu'une fois.
        $this->erreur(422, 'JETON_INSCRIPTION_INVALIDE', $this->api('POST', '/api/v1/auth/inscription', [
            'telephone' => $telephone, 'jetonInscription' => $verif['jetonInscription'], 'nom' => 'Autre',
        ]));
    }

    /** R-124 : le téléphone n'est jamais stocké en clair. */
    public function testTelephoneChiffreEnBase(): void
    {
        $user = $this->utilisateur('Chiffré', '+243970555444');
        $brut = $this->em()->getConnection()->fetchAssociative('SELECT telephone, telephone_empreinte FROM `user` WHERE id = ?', [$user->getId()]);
        self::assertStringNotContainsString('970555444', $brut['telephone']);
        self::assertStringStartsWith('v1:', $brut['telephone']);
        self::assertSame(64, \strlen($brut['telephone_empreinte']));
    }

    public function testConnexionCompteExistant(): void
    {
        $user = $this->utilisateur('Existant', '+243970000777');
        $code = $this->demanderCode('+243970000777');
        $r = $this->ok(200, $this->api('POST', '/api/v1/auth/otp/verification', ['telephone' => '+243970000777', 'code' => $code]));
        self::assertFalse($r['inscriptionRequise']);
        self::assertNotEmpty($r['token']);

        // Le code ne sert qu'une fois.
        $this->erreur(422, 'OTP_EXPIRE', $this->api('POST', '/api/v1/auth/otp/verification', ['telephone' => '+243970000777', 'code' => $code]));
        unset($user);
    }

    public function testCodeIncorrectPuisBlocageApresCinqEssais(): void
    {
        $code = $this->demanderCode('+243970000888');
        $faux = '000000' === $code ? '111111' : '000000';
        for ($i = 0; $i < 5; ++$i) {
            $this->erreur(422, 'OTP_INVALIDE', $this->api('POST', '/api/v1/auth/otp/verification', ['telephone' => '+243970000888', 'code' => $faux]));
        }
        // Même le bon code est refusé après 5 tentatives.
        $this->erreur(422, 'OTP_EXPIRE', $this->api('POST', '/api/v1/auth/otp/verification', ['telephone' => '+243970000888', 'code' => $code]));
    }

    public function testCodeExpire(): void
    {
        $code = $this->demanderCode('+243970000999');
        $this->horloge->modify('+11 minutes');
        $this->erreur(422, 'OTP_EXPIRE', $this->api('POST', '/api/v1/auth/otp/verification', ['telephone' => '+243970000999', 'code' => $code]));
    }

    public function testTelephoneInvalide(): void
    {
        $r = $this->erreur(422, 'TELEPHONE_INVALIDE', $this->api('POST', '/api/v1/auth/otp', ['telephone' => '0970000001']));
        self::assertArrayHasKey('telephone', $r['erreurs']);
    }

    public function testValidationDesChamps(): void
    {
        $r = $this->erreur(422, 'VALIDATION', $this->api('POST', '/api/v1/auth/otp/verification', ['telephone' => '+243970000001', 'code' => '12']));
        self::assertArrayHasKey('code', $r['erreurs']);
    }

    public function testCodeParrainInconnu(): void
    {
        $code = $this->demanderCode('+243970000321');
        $verif = $this->ok(200, $this->api('POST', '/api/v1/auth/otp/verification', ['telephone' => '+243970000321', 'code' => $code]));
        $this->erreur(422, 'CODE_PARRAIN_INCONNU', $this->api('POST', '/api/v1/auth/inscription', [
            'telephone' => '+243970000321', 'jetonInscription' => $verif['jetonInscription'], 'nom' => 'Sans parrain', 'codeParrain' => 'NEXISTE',
        ]));
    }

    /** R-140 : refresh token à usage unique (rotation). */
    public function testRafraichissementAvecRotation(): void
    {
        $code = $this->demanderCode('+243970000654');
        $verif = $this->ok(200, $this->api('POST', '/api/v1/auth/otp/verification', ['telephone' => '+243970000654', 'code' => $code]));
        $jetons = $this->ok(201, $this->api('POST', '/api/v1/auth/inscription', ['telephone' => '+243970000654', 'jetonInscription' => $verif['jetonInscription'], 'nom' => 'Rotation']));

        $nouveaux = $this->ok(200, $this->api('POST', '/api/v1/auth/token/rafraichir', ['refresh_token' => $jetons['refresh_token']]));
        self::assertNotEmpty($nouveaux['token']);
        self::assertNotSame($jetons['refresh_token'], $nouveaux['refresh_token']);

        $this->erreur(401, 'SESSION', $this->api('POST', '/api/v1/auth/token/rafraichir', ['refresh_token' => $jetons['refresh_token']]));
    }

    public function testJetonInvalide(): void
    {
        $this->client->request('GET', '/api/v1/moi', server: ['HTTP_AUTHORIZATION' => 'Bearer pas.un.jeton']);
        self::assertSame(401, $this->client->getResponse()->getStatusCode());
        self::assertSame('SESSION', json_decode((string) $this->client->getResponse()->getContent(), true)['code']);
    }

    /** R-161 : choix du mode par défaut ; R-144 : sans effet sur les droits. */
    public function testChoixDuModeEtProfil(): void
    {
        $user = $this->utilisateur();
        $moi = $this->ok(200, $this->api('PATCH', '/api/v1/moi', ['modePrefere' => 'locataire', 'email' => 'a@b.cd'], $user));
        self::assertSame('locataire', $moi['modePrefere']);
        self::assertSame('a@b.cd', $moi['email']);
        $this->erreur(422, 'VALIDATION', $this->api('PATCH', '/api/v1/moi', ['modePrefere' => 'gerant'], $user));
    }

    public function testCompteSuspenduNePeutPasSeConnecter(): void
    {
        $user = $this->utilisateur('Suspendu', '+243970000432');
        $this->em()->find(User::class, $user->getId())->setActif(false);
        $this->em()->flush();
        $code = $this->demanderCode('+243970000432');
        $this->erreur(403, 'COMPTE_SUSPENDU', $this->api('POST', '/api/v1/auth/otp/verification', ['telephone' => '+243970000432', 'code' => $code]));
    }
}
