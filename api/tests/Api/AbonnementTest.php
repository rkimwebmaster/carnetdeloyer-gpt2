<?php

namespace App\Tests\Api;

use App\Entity\User;
use App\Enum\EspaceWallet;
use App\Service\Abonnements;
use App\Service\ConversionMonetaire;
use App\Service\Parametres;
use App\Service\Wallet;
use App\Sms\SmsEnvoyeurInterface;
use App\Tests\ApiTestCase;

final class AbonnementTest extends ApiTestCase
{
    /** Bailleur dont la gratuité est déjà consommée, avec une 2e unité louée. */
    private function deuxiemeUnite(?User $parrain = null, int $loyer = 30000, string $devise = 'USD'): array
    {
        $b = $this->utilisateur('Bailleur pro');
        if (null !== $parrain) {
            $this->em()->find(User::class, $b->getId())->setParrain($this->em()->find(User::class, $parrain->getId()));
            $this->em()->flush();
        }
        $this->contrat($b, $this->unite($b, 'Gratuite'));
        $unite = $this->unite($b, 'Payante');
        $contrat = $this->contrat($b, $unite, loyer: $loyer, devise: $devise);

        return [$b, $unite, $contrat];
    }

    private function crediter(User $u, int $centimes): void
    {
        static::getContainer()->get(Wallet::class)->crediter($this->em()->find(User::class, $u->getId()), EspaceWallet::Bailleur, $centimes, 'ajustement');
    }

    /** R-51, R-68 : 9,9 % du loyer mensuel, montant exact avant de payer. */
    public function testDevisEnUsd(): void
    {
        [$b, $unite] = $this->deuxiemeUnite();
        $a = $this->ok(200, $this->api('GET', "/api/v1/unites/$unite/abonnement", null, $b));
        self::assertSame('grace', $a['etat']);
        self::assertSame(['pourcentage' => '9.9', 'montantDevise' => 2970, 'devise' => 'USD', 'tauxUsd' => '1', 'montantUsd' => 2970, 'periodeDebut' => '2026-10-27', 'periodeFin' => '2027-10-27'], $a['devis']);
    }

    /** R-69 : conversion en USD au taux connu ; secours limité à 48 h. */
    public function testConversionDepuisLeFrancCongolais(): void
    {
        [$b, $unite] = $this->deuxiemeUnite(loyer: 85500000, devise: 'CDF'); // 855 000 FC
        $sansTaux = $this->ok(200, $this->api('GET', "/api/v1/unites/$unite/abonnement", null, $b));
        self::assertNull($sansTaux['devis']);
        self::assertSame('CONVERSION_INDISPONIBLE', $sansTaux['devisIndisponible']);

        static::getContainer()->get(ConversionMonetaire::class)->enregistrerTaux('CDF', '2850');
        $a = $this->ok(200, $this->api('GET', "/api/v1/unites/$unite/abonnement", null, $b));
        // 9,9 % de 855 000 FC = 84 645 FC = 29,70 $ au taux de 2 850.
        self::assertSame(8464500, $a['devis']['montantDevise']);
        self::assertSame(2970, $a['devis']['montantUsd']);

        $this->horloge->modify('+49 hours');
        $this->erreur(503, 'CONVERSION_INDISPONIBLE', $this->api('POST', "/api/v1/unites/$unite/abonnement/paiements", ['source' => 'manuel', 'referenceTransaction' => 'MP1'], $b));
    }

    /** R-62 : wallet utilisable seulement à partir de 11 USD. */
    public function testPaiementParWalletEtSeuil(): void
    {
        [$b, $unite] = $this->deuxiemeUnite();
        $this->crediter($b, 1000);
        $this->erreur(422, 'WALLET_SEUIL_NON_ATTEINT', $this->api('POST', "/api/v1/unites/$unite/abonnement/paiements", ['source' => 'wallet'], $b));
        $this->crediter($b, 1000);
        $this->erreur(422, 'WALLET_SOLDE_INSUFFISANT', $this->api('POST', "/api/v1/unites/$unite/abonnement/paiements", ['source' => 'wallet'], $b));
        $this->crediter($b, 1000);

        $pa = $this->ok(201, $this->api('POST', "/api/v1/unites/$unite/abonnement/paiements", ['source' => 'wallet'], $b));
        self::assertSame('valide', $pa['statut']);
        self::assertSame('2027-10-27', $pa['periodeFin']);
        $w = $this->ok(200, $this->api('GET', '/api/v1/wallet', null, $b));
        self::assertSame(30, $w['total']);
        self::assertSame('actif', $this->ok(200, $this->api('GET', "/api/v1/unites/$unite", null, $b))['abonnement']['etat']);
        // R-50 : pas de second paiement tant que l'abonnement court.
        $this->erreur(409, 'ABONNEMENT_DEJA_ACTIF', $this->api('POST', "/api/v1/unites/$unite/abonnement/paiements", ['source' => 'wallet'], $b));
    }

    /** R-58, R-111 : paiement manuel validé dans le back-office ; R-65 : parrainage. */
    public function testPaiementManuelValideEtParrainage(): void
    {
        $parrain = $this->utilisateur('Parrain');
        [$b, $unite, $contrat] = $this->deuxiemeUnite($parrain);
        $admin = $this->utilisateur('Admin', roles: ['ROLE_ADMIN']);

        $this->erreur(422, 'REFERENCE_REQUISE', $this->api('POST', "/api/v1/unites/$unite/abonnement/paiements", ['source' => 'manuel'], $b));
        $pa = $this->ok(201, $this->api('POST', "/api/v1/unites/$unite/abonnement/paiements", ['source' => 'manuel', 'referenceTransaction' => 'MP261027.0001'], $b));
        self::assertSame('en_attente', $pa['statut']);
        $this->erreur(409, 'ABONNEMENT_PAIEMENT_EN_ATTENTE', $this->api('POST', "/api/v1/unites/$unite/abonnement/paiements", ['source' => 'manuel', 'referenceTransaction' => 'MP2'], $b));

        // Un bailleur n'accède pas au back-office.
        $this->ok(403, $this->api('GET', '/api/v1/admin/paiements-abonnement', null, $b));
        $file = $this->ok(200, $this->api('GET', '/api/v1/admin/paiements-abonnement', null, $admin));
        self::assertSame(1, $file['total']);
        $valide = $this->ok(200, $this->api('POST', '/api/v1/admin/paiements-abonnement/'.$pa['id'].'/validation', null, $admin));
        self::assertSame('valide', $valide['statut']);
        $this->erreur(409, 'PAIEMENT_DEJA_TRAITE', $this->api('POST', '/api/v1/admin/paiements-abonnement/'.$pa['id'].'/validation', null, $admin));

        // R-65 : 2 USD au parrain, une seule fois par contrat ; rien pour la 1re unité gratuite.
        $w = $this->ok(200, $this->api('GET', '/api/v1/wallet', null, $parrain));
        self::assertSame(200, $w['total']);
        self::assertSame(200, $w['soldes']['locataire'], 'Le parrain sans espace bailleur accumule côté locataire');
        $gains = $this->ok(200, $this->api('GET', '/api/v1/activites?mode=locataire', null, $parrain));
        self::assertSame('gain_parrainage', $gains['elements'][0]['type']);
        unset($contrat);
    }

    /** R-55, R-56 : 15 jours de grâce puis suspension ; R-57 : réactivation sans rattrapage. */
    public function testGraceSuspensionReactivation(): void
    {
        [$b, $unite, $contrat] = $this->deuxiemeUnite();
        $this->ok(201, $this->payer($b, $contrat['id'], 10000));

        $this->horloge->modify('+15 days');
        self::assertSame('grace', $this->ok(200, $this->api('GET', "/api/v1/unites/$unite", null, $b))['abonnement']['etat']);
        $this->horloge->modify('+1 day');
        self::assertSame('suspendu', $this->ok(200, $this->api('GET', "/api/v1/unites/$unite", null, $b))['abonnement']['etat']);

        // R-56 : historique consultable, plus de saisie ni de reçu ; échéances toujours générées.
        $c = $this->ok(200, $this->api('GET', '/api/v1/contrats/'.$contrat['id'], null, $b));
        self::assertCount(1, $c['paiements']);
        $this->erreur(403, 'UNITE_SUSPENDUE', $this->payer($b, $contrat['id'], 10000, date: '2026-11-12'));

        $this->crediter($b, 5000);
        $pa = $this->ok(201, $this->api('POST', "/api/v1/unites/$unite/abonnement/paiements", ['source' => 'wallet'], $b));
        self::assertSame('2026-11-12', $pa['periodeDebut'], 'Nouvelle période à la date du paiement');
        self::assertSame('2027-11-12', $pa['periodeFin']);
        $this->ok(201, $this->payer($b, $contrat['id'], 10000, date: '2026-11-12'));
    }

    /** R-53 : le reste non consommé est crédité au wallet lors d'un nouveau contrat. */
    public function testResteCrediteAuNouveauContrat(): void
    {
        [$b, $unite, $contrat] = $this->deuxiemeUnite();
        $this->crediter($b, 2970);
        $this->ok(201, $this->api('POST', "/api/v1/unites/$unite/abonnement/paiements", ['source' => 'wallet'], $b));
        self::assertSame(0, $this->ok(200, $this->api('GET', '/api/v1/wallet', null, $b))['total']);

        // Sortie après 6 mois et quelques jours : pas de remboursement immédiat.
        $this->horloge->modify('+183 days');
        $this->ok(200, $this->api('POST', '/api/v1/contrats/'.$contrat['id'].'/cloture', ['dateSortie' => '2027-04-28'], $b));
        self::assertSame(0, $this->ok(200, $this->api('GET', '/api/v1/wallet', null, $b))['total']);

        $this->contrat($b, $unite, dateDebut: '2027-05-01');
        $w = $this->ok(200, $this->api('GET', '/api/v1/wallet', null, $b));
        // 182 jours restants sur 365 : 2 970 × 182 / 365 = 1 481 (arrondi).
        self::assertSame(1481, $w['total']);
        self::assertSame('reste_abonnement', $w['ecritures']['elements'][0]['motif']);
        self::assertSame('grace', $this->ok(200, $this->api('GET', "/api/v1/unites/$unite", null, $b))['abonnement']['etat'], 'Le nouveau contrat se paie à son activation');
    }

    /** R-50 : la gratuité suit l'unité pendant 12 mois, même si le locataire change. */
    public function testGratuiteConserveeSurLaMemeUnite(): void
    {
        $b = $this->utilisateur();
        $unite = $this->unite($b);
        $c = $this->contrat($b, $unite);
        $this->ok(200, $this->api('POST', '/api/v1/contrats/'.$c['id'].'/cloture', ['dateSortie' => '2026-10-31'], $b));
        $this->contrat($b, $unite, dateDebut: '2026-11-01');
        $a = $this->ok(200, $this->api('GET', "/api/v1/unites/$unite", null, $b))['abonnement'];
        self::assertSame(['etat' => 'gratuit', 'fin' => '2027-10-27'], $a);

        // Au 13e mois, elle devient payante.
        $this->horloge->modify('+366 days');
        self::assertSame('grace', $this->ok(200, $this->api('GET', "/api/v1/unites/$unite", null, $b))['abonnement']['etat']);
    }

    /** R-67, R-68 : paramètre modifié et dérogation, jamais rétroactifs. */
    public function testParametresEtDerogation(): void
    {
        [$b, $unite] = $this->deuxiemeUnite();
        $support = $this->utilisateur('Support', roles: ['ROLE_ADMIN']);
        $superAdmin = $this->utilisateur('Super', roles: ['ROLE_SUPER_ADMIN']);
        $this->erreur(403, 'INTERDIT', $this->api('PUT', '/api/v1/admin/parametres/abonnement_pourcentage', ['valeur' => '8'], $support));
        $this->erreur(422, 'PARAMETRE_INVALIDE', $this->api('PUT', '/api/v1/admin/parametres/abonnement_pourcentage', ['valeur' => 'abc'], $superAdmin));
        $this->ok(200, $this->api('PUT', '/api/v1/admin/parametres/abonnement_pourcentage', ['valeur' => '8'], $superAdmin));
        self::assertSame(2400, $this->ok(200, $this->api('GET', "/api/v1/unites/$unite/abonnement", null, $b))['devis']['montantUsd']);

        static::getContainer()->get(Parametres::class)->deroger($this->em()->find(User::class, $b->getId()), Parametres::ABONNEMENT_POURCENTAGE, '5');
        $this->em()->flush();
        self::assertSame(1500, $this->ok(200, $this->api('GET', "/api/v1/unites/$unite/abonnement", null, $b))['devis']['montantUsd']);
    }

    /** R-55 : rappels à J-15, J-3 et J (activité + SMS). */
    public function testRappels(): void
    {
        $b = $this->utilisateur('Rappel', '+243970444555');
        $this->contrat($b, $this->unite($b)); // gratuite jusqu'au 2027-10-27
        $this->horloge->modify('2027-10-12 08:00');
        $abonnements = static::getContainer()->get(Abonnements::class);
        self::assertSame(1, $abonnements->envoyerRappels());
        self::assertStringContainsString('dans 15 jours', static::getContainer()->get(SmsEnvoyeurInterface::class)->dernierPour('+243970444555'));
        $this->horloge->modify('2027-10-13 08:00');
        self::assertSame(0, $abonnements->envoyerRappels());
        $this->horloge->modify('2027-10-27 08:00');
        self::assertSame(1, $abonnements->envoyerRappels());
    }
}
