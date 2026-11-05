<?php

namespace App\Service;

use App\Api\ErreurMetier;
use App\Entity\Contrat;
use App\Entity\EspaceBailleur;
use App\Entity\PaiementAbonnement;
use App\Entity\Unite;
use App\Entity\User;
use App\Enum\EspaceWallet;
use App\Enum\EtatAbonnement;
use App\Enum\SourcePaiementAbonnement;
use App\Enum\StatutContrat;
use App\Enum\StatutPaiementAbonnement;
use App\Sms\SmsEnvoyeurInterface;
use Doctrine\ORM\EntityManagerInterface;
use Psr\Clock\ClockInterface;

/**
 * Section 6 : abonnement par unité.
 *
 * - R-50 première unité gratuite 12 mois, une seule fois par compte ;
 * - R-51 9,9 % (par défaut) du loyer mensuel, par an et par unité ;
 * - R-52 unité vacante non facturée, période de 12 mois dès l'activation ;
 * - R-53 pas de remboursement, reste crédité au wallet si nouveau contrat ;
 * - R-55 à R-57 rappels, grâce de 15 jours, suspension, réactivation sans rattrapage ;
 * - R-65 parrainage de 2 USD par contrat payé du filleul ;
 * - R-68, R-69 valeurs figées au paiement, conversion en USD.
 */
final class Abonnements
{
    private const DUREE_MOIS = 12;
    /** Renouvellement anticipé possible dans les 30 derniers jours. */
    private const FENETRE_RENOUVELLEMENT_JOURS = 30;

    public function __construct(
        private readonly EntityManagerInterface $em,
        private readonly ClockInterface $clock,
        private readonly Parametres $parametres,
        private readonly ConversionMonetaire $conversion,
        private readonly Wallet $wallet,
        private readonly Activites $activites,
        private readonly Espaces $espaces,
        private readonly SmsEnvoyeurInterface $sms,
    ) {
    }

    public function contratActif(Unite $unite): ?Contrat
    {
        if (null === $unite->getId()) {
            return null;
        }

        return $this->em->getRepository(Contrat::class)->findOneBy(['unite' => $unite, 'statut' => StatutContrat::Actif]);
    }

    public function etat(Unite $unite): EtatAbonnement
    {
        if (null === $this->contratActif($unite)) {
            return EtatAbonnement::NonFacture;
        }
        $aujourdhui = $this->aujourdhui();
        if (null !== $unite->getGratuiteJusquAu() && $aujourdhui < $unite->getGratuiteJusquAu()) {
            return EtatAbonnement::Gratuit;
        }
        $fin = $unite->getAbonnementFin() ?? $aujourdhui;
        if ($aujourdhui < $fin) {
            return EtatAbonnement::Actif;
        }
        $grace = $this->parametres->entier(Parametres::ABONNEMENT_GRACE_JOURS, $unite->getEspace()->getProprietaire());
        if ($aujourdhui <= $fin->modify(\sprintf('+%d days', $grace))) {
            return EtatAbonnement::Grace;
        }

        return EtatAbonnement::Suspendu;
    }

    public function estSuspendue(Unite $unite): bool
    {
        return EtatAbonnement::Suspendu === $this->etat($unite);
    }

    /** Date de fin effective (gratuité ou période payée). */
    public function finPeriode(Unite $unite): ?\DateTimeImmutable
    {
        $gratuite = $unite->getGratuiteJusquAu();
        $fin = $unite->getAbonnementFin();
        if (null !== $gratuite && (null === $fin || $gratuite > $fin)) {
            return $gratuite;
        }

        return $fin;
    }

    /**
     * Appelé à la création d'un contrat (R-50, R-52, R-53).
     */
    public function surActivationContrat(Contrat $contrat): void
    {
        $unite = $contrat->getUnite();
        $espace = $unite->getEspace();
        $aujourdhui = $this->aujourdhui();

        // Unité encore dans sa période gratuite : la gratuité continue.
        if (null !== $unite->getGratuiteJusquAu() && $aujourdhui < $unite->getGratuiteJusquAu()) {
            $unite->setAbonnementFin($unite->getGratuiteJusquAu());

            return;
        }

        if (!$espace->isGratuiteUtilisee()) {
            $fin = Calendrier::ajouterMois($aujourdhui, self::DUREE_MOIS);
            $unite->setGratuiteJusquAu($fin);
            $unite->setAbonnementFin($fin);
            $espace->marquerGratuiteUtilisee();
            $this->activites->enregistrer(Activites::ABONNEMENT_GRATUIT, null, $espace, $contrat, $unite, ['unite' => $unite->getNom(), 'jusquAu' => $fin->format('Y-m-d')]);

            return;
        }

        // R-53 : le reste non consommé d'une période payée est crédité au wallet.
        $fin = $unite->getAbonnementFin();
        if (null !== $fin && $fin > $aujourdhui) {
            $dernier = $this->em->getRepository(PaiementAbonnement::class)->findOneBy(
                ['unite' => $unite, 'statut' => StatutPaiementAbonnement::Valide],
                ['periodeFin' => 'DESC', 'id' => 'DESC'],
            );
            if (null !== $dernier && null !== $dernier->getPeriodeDebut() && null !== $dernier->getPeriodeFin() && $dernier->getPeriodeFin() > $aujourdhui) {
                $total = Calendrier::joursEntre($dernier->getPeriodeDebut(), $dernier->getPeriodeFin());
                $restant = Calendrier::joursEntre($aujourdhui, $dernier->getPeriodeFin());
                $this->wallet->crediter(
                    $espace->getProprietaire(),
                    EspaceWallet::Bailleur,
                    Argent::prorata($dernier->getMontantUsd(), $restant, $total),
                    'reste_abonnement',
                    'paiement_abonnement:'.$dernier->getId(),
                    'reste_abonnement:'.$dernier->getId(),
                );
            }
        }
        // L'abonnement du nouveau contrat est dû dès l'activation.
        $unite->setAbonnementFin($aujourdhui);
    }

    /**
     * R-68 : le bailleur voit le montant exact avant de payer.
     *
     * @return array{contrat: Contrat, pourcentage: string, montantDevise: int, deviseCode: string, tauxUsd: string, montantUsd: int, periodeDebut: \DateTimeImmutable, periodeFin: \DateTimeImmutable}
     */
    public function devis(Unite $unite): array
    {
        $contrat = $this->contratActif($unite) ?? throw new ErreurMetier('UNITE_VACANTE', 'Une unité vacante n\'est pas facturée.', 422);
        $this->verifierPayable($unite);
        $proprietaire = $unite->getEspace()->getProprietaire();
        $pourcentage = $this->parametres->valeur(Parametres::ABONNEMENT_POURCENTAGE, $proprietaire);
        $montantDevise = Argent::pourcentage($contrat->getLoyer(), $pourcentage);
        $taux = $this->conversion->tauxUsd($contrat->getDevise());
        $montantUsd = Argent::versCentimesUsd($montantDevise, $taux, $contrat->getDevise()->getDecimales());
        [$debut, $fin] = $this->prochainePeriode($unite);

        return [
            'contrat' => $contrat,
            'pourcentage' => $pourcentage,
            'montantDevise' => $montantDevise,
            'deviseCode' => $contrat->getDevise()->getCode(),
            'tauxUsd' => $taux,
            'montantUsd' => $montantUsd,
            'periodeDebut' => $debut,
            'periodeFin' => $fin,
        ];
    }

    public function payerParWallet(Unite $unite, User $payeur): PaiementAbonnement
    {
        return $this->em->wrapInTransaction(function () use ($unite, $payeur): PaiementAbonnement {
            $devis = $this->devis($unite);
            $pa = $this->creerPaiement($unite, $payeur, $devis, SourcePaiementAbonnement::Wallet, null);
            if ($devis['montantUsd'] > 0) {
                $this->wallet->debiter($payeur, EspaceWallet::Bailleur, $devis['montantUsd'], 'paiement_abonnement', 'unite:'.$unite->getId());
            }
            $this->appliquerValidation($pa, null);
            $this->em->flush();

            return $pa;
        });
    }

    /**
     * R-58 : paiement mobile money hors agrégateur, référence de transaction
     * saisie par le bailleur, validé manuellement dans le back-office.
     */
    public function declarerPaiementManuel(Unite $unite, User $payeur, string $reference): PaiementAbonnement
    {
        $enAttente = $this->em->getRepository(PaiementAbonnement::class)->findOneBy(['unite' => $unite, 'statut' => StatutPaiementAbonnement::EnAttente]);
        if (null !== $enAttente) {
            throw new ErreurMetier('ABONNEMENT_PAIEMENT_EN_ATTENTE', 'Un paiement est déjà en attente de validation pour cette unité.', 409);
        }
        $pa = $this->creerPaiement($unite, $payeur, $this->devis($unite), SourcePaiementAbonnement::Manuel, $reference);
        $this->em->flush();

        return $pa;
    }

    public function valider(PaiementAbonnement $pa, User $admin): void
    {
        if (StatutPaiementAbonnement::EnAttente !== $pa->getStatut()) {
            throw new ErreurMetier('PAIEMENT_DEJA_TRAITE', 'Ce paiement a déjà été traité.', 409);
        }
        $this->em->wrapInTransaction(function () use ($pa, $admin): void {
            $this->appliquerValidation($pa, $admin);
            $this->em->flush();
        });
    }

    public function rejeter(PaiementAbonnement $pa, User $admin, string $motif): void
    {
        if (StatutPaiementAbonnement::EnAttente !== $pa->getStatut()) {
            throw new ErreurMetier('PAIEMENT_DEJA_TRAITE', 'Ce paiement a déjà été traité.', 409);
        }
        $pa->rejeter($motif, $admin);
        $this->em->flush();
    }

    /**
     * R-55 : rappels à J-15, J-3 et J. Retourne le nombre de rappels envoyés.
     */
    public function envoyerRappels(): int
    {
        $aujourdhui = $this->aujourdhui();
        $dates = array_map(static fn (int $j) => $aujourdhui->modify("+$j days"), [15, 3, 0]);
        $contrats = $this->em->getRepository(Contrat::class)->findBy(['statut' => StatutContrat::Actif]);
        $envoyes = 0;
        foreach ($contrats as $contrat) {
            $unite = $contrat->getUnite();
            $fin = $this->finPeriode($unite);
            if (null === $fin || !\in_array($fin->format('Y-m-d'), array_map(static fn ($d) => $d->format('Y-m-d'), $dates), true)) {
                continue;
            }
            $jours = Calendrier::joursEntre($aujourdhui, $fin);
            $espace = $unite->getEspace();
            $this->activites->enregistrer(Activites::ABONNEMENT_EXPIRE_BIENTOT, null, $espace, $contrat, $unite, ['unite' => $unite->getNom(), 'jours' => $jours, 'fin' => $fin->format('Y-m-d')]);
            $telephone = $espace->getProprietaire()->getTelephone();
            if (null !== $telephone) {
                $this->sms->envoyer($telephone, \sprintf('CarnetDeLoyer : l\'abonnement de "%s" expire %s. Renouvelez-le dans l\'app.', $unite->getNom(), 0 === $jours ? 'aujourd\'hui' : "dans $jours jours"));
            }
            ++$envoyes;
        }
        $this->em->flush();

        return $envoyes;
    }

    /**
     * @param array{contrat: Contrat, pourcentage: string, montantDevise: int, deviseCode: string, tauxUsd: string, montantUsd: int} $devis
     */
    private function creerPaiement(Unite $unite, User $payeur, array $devis, SourcePaiementAbonnement $source, ?string $reference): PaiementAbonnement
    {
        $pa = new PaiementAbonnement(
            $unite, $devis['contrat'], $payeur, $devis['contrat']->getLoyer(), $devis['deviseCode'],
            $devis['pourcentage'], $devis['montantDevise'], $devis['tauxUsd'], $devis['montantUsd'], $source, $reference,
        );
        $this->em->persist($pa);

        return $pa;
    }

    private function appliquerValidation(PaiementAbonnement $pa, ?User $admin): void
    {
        $unite = $pa->getUnite();
        [$debut, $fin] = $this->prochainePeriode($unite);
        $pa->valider($debut, $fin, $admin);
        $unite->setAbonnementFin($fin);

        $espace = $unite->getEspace();
        $this->activites->enregistrer(Activites::ABONNEMENT_PAYE, $pa->getPayeur(), $espace, $pa->getContrat(), $unite, [
            'unite' => $unite->getNom(), 'montantUsd' => $pa->getMontantUsd(), 'jusquAu' => $fin->format('Y-m-d'),
        ]);
        $this->crediterParrain($espace, $pa);
    }

    /** R-65 : 2 USD (par défaut) au parrain, une fois par contrat payé. */
    private function crediterParrain(EspaceBailleur $espace, PaiementAbonnement $pa): void
    {
        $filleul = $espace->getProprietaire();
        $parrain = $filleul->getParrain();
        if (null === $parrain || !$parrain->isActif()) {
            return;
        }
        $montant = $this->parametres->entier(Parametres::PARRAINAGE_LOCATION_CENTIMES, $parrain);
        $espaceGain = null !== $this->espaces->de($parrain) ? EspaceWallet::Bailleur : EspaceWallet::Locataire;
        $ecriture = $this->wallet->crediter($parrain, $espaceGain, $montant, 'parrainage_location', 'contrat:'.$pa->getContrat()->getId(), 'parrainage_location:contrat:'.$pa->getContrat()->getId());
        if (null !== $ecriture) {
            $this->activites->enregistrer(Activites::GAIN_PARRAINAGE, null, null, null, $ecriture, ['montantUsd' => $montant, 'filleul' => $filleul->getNom()], $parrain);
        }
    }

    /**
     * R-52, R-57 : période suivante. Après suspension, nouvelle période à la date
     * du paiement, sans rattrapage ; sinon dans la continuité de la précédente.
     *
     * @return array{\DateTimeImmutable, \DateTimeImmutable}
     */
    private function prochainePeriode(Unite $unite): array
    {
        $aujourdhui = $this->aujourdhui();
        $debut = EtatAbonnement::Suspendu === $this->etat($unite) ? $aujourdhui : ($this->finPeriode($unite) ?? $aujourdhui);

        return [$debut, Calendrier::ajouterMois($debut, self::DUREE_MOIS)];
    }

    private function verifierPayable(Unite $unite): void
    {
        $etat = $this->etat($unite);
        if (\in_array($etat, [EtatAbonnement::Actif, EtatAbonnement::Gratuit], true)) {
            $fin = $this->finPeriode($unite);
            if (null !== $fin && Calendrier::joursEntre($this->aujourdhui(), $fin) > self::FENETRE_RENOUVELLEMENT_JOURS) {
                throw new ErreurMetier('ABONNEMENT_DEJA_ACTIF', \sprintf('Abonnement actif jusqu\'au %s.', $fin->format('d/m/Y')), 409);
            }
        }
    }

    private function aujourdhui(): \DateTimeImmutable
    {
        return Calendrier::jour($this->clock->now());
    }
}
