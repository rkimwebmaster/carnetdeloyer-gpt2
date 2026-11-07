<?php

namespace App\Service;

use App\Api\ErreurMetier;
use App\Entity\Contact;
use App\Entity\Contrat;
use App\Entity\Devise;
use App\Entity\Echeance;
use App\Entity\Unite;
use App\Entity\User;
use App\Enum\MoyenPaiement;
use App\Enum\StatutGarantie;
use App\Enum\TypePaiement;
use Doctrine\DBAL\LockMode;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Component\Uid\Uuid;

/**
 * Création et clôture des contrats (R-11, R-16 à R-18, R-28, R-32, R-37, R-38).
 */
final class Contrats
{
    public function __construct(
        private readonly EntityManagerInterface $em,
        private readonly Echeancier $echeancier,
        private readonly Imputations $imputations,
        private readonly Abonnements $abonnements,
        private readonly Paiements $paiements,
        private readonly Activites $activites,
    ) {
    }

    /**
     * R-17 : devise proposée = celle du pays de la propriété, sinon celle du pays du compte.
     */
    public function deviseProposee(Unite $unite, User $user): ?Devise
    {
        $devise = $unite->getPropriete()->getPays()->getDeviseParDefaut() ?? $user->getPays()?->getDeviseParDefaut();

        return null !== $devise && $devise->isActive() ? $devise : null;
    }

    public function creer(User $par, Unite $unite, Contact $locataire, ?Devise $devise, int $loyer, \DateTimeImmutable $dateDebut, ?\DateTimeImmutable $dateFin, int $garantie = 0): Contrat
    {
        if ($unite->getCategorie()->isHotel()) {
            throw new ErreurMetier('CATEGORIE_HOTEL', 'La gestion des séjours d\'hôtel arrive en v0.5.', 422);
        }
        $devise ??= $this->deviseProposee($unite, $par) ?? throw ErreurMetier::champ('devise', 'DEVISE_REQUISE', 'Choisissez la devise du contrat.');
        if (!$devise->isActive()) {
            throw ErreurMetier::champ('devise', 'DEVISE_INACTIVE', 'Cette devise n\'est plus proposée pour un nouveau contrat.');
        }
        if ($loyer <= 0) {
            throw ErreurMetier::champ('loyer', 'MONTANT_INVALIDE', 'Le loyer doit être positif.');
        }
        if ($garantie < 0) {
            throw ErreurMetier::champ('garantie', 'MONTANT_INVALIDE', 'La garantie ne peut pas être négative.');
        }
        if (null !== $dateFin && $dateFin < $dateDebut) {
            throw ErreurMetier::champ('dateFin', 'DATES_INCOHERENTES', 'La date de fin précède la date de début.');
        }
        if ($locataire->getEspace() !== $unite->getEspace()) {
            throw ErreurMetier::interdit();
        }

        return $this->em->wrapInTransaction(function () use ($par, $unite, $locataire, $devise, $loyer, $dateDebut, $dateFin, $garantie): Contrat {
            // R-11 : un seul contrat actif par unité (verrou contre les créations simultanées).
            $this->em->lock($unite, LockMode::PESSIMISTIC_WRITE);
            if (null !== $this->abonnements->contratActif($unite)) {
                throw new ErreurMetier('UNITE_OCCUPEE', 'Cette unité a déjà un contrat actif.', 409);
            }
            $contrat = new Contrat($unite, $locataire, $devise, $loyer, Calendrier::jour($dateDebut), null === $dateFin ? null : Calendrier::jour($dateFin), $par);
            $contrat->prevoirGarantie($garantie);
            $this->em->persist($contrat);
            $unite->retirerDuMarket();
            $this->em->flush();

            $this->abonnements->surActivationContrat($contrat);
            $this->echeancier->generer($contrat);
            $this->activites->enregistrer(Activites::CONTRAT_CREE, $par, $unite->getEspace(), $contrat, $contrat, [
                'unite' => $unite->getNom(), 'locataire' => $locataire->getNom(),
            ]);
            $this->em->flush();

            return $contrat;
        });
    }

    /**
     * R-37, R-38, R-32 : clôture.
     *
     * @param ?StatutGarantie $reglementGarantie obligatoire si une garantie est détenue
     *
     * @return array{tropPercu: int, restantDu: int, garantieImputee: int}
     */
    public function cloturer(Contrat $contrat, User $par, \DateTimeImmutable $dateSortie, ?int $montantDerniereEcheance, ?StatutGarantie $reglementGarantie, int $montantRetenu = 0, ?string $motifRetenue = null): array
    {
        if (!$contrat->isActif()) {
            throw new ErreurMetier('CONTRAT_CLOTURE', 'Ce contrat est déjà clôturé.', 409);
        }
        $dateSortie = Calendrier::jour($dateSortie);
        if ($dateSortie < $contrat->getDateDebut()) {
            throw ErreurMetier::champ('dateSortie', 'DATES_INCOHERENTES', 'La date de sortie précède le début du contrat.');
        }
        $garantieDetenue = StatutGarantie::Detenue === $contrat->getGarantieStatut();
        if ($garantieDetenue) {
            $this->verifierReglementGarantie($contrat, $reglementGarantie, $montantRetenu, $motifRetenue);
        }
        if (null !== $montantDerniereEcheance && $montantDerniereEcheance < 0) {
            throw ErreurMetier::champ('montantDerniereEcheance', 'MONTANT_INVALIDE', 'Montant invalide.');
        }

        return $this->em->wrapInTransaction(function () use ($contrat, $par, $dateSortie, $montantDerniereEcheance, $reglementGarantie, $montantRetenu, $motifRetenue, $garantieDetenue): array {
            $this->echeancier->verrouiller($contrat);
            $this->echeancier->generer($contrat);
            $derniere = null;
            foreach ($this->echeancier->echeances($contrat) as $e) {
                if ($e->getPeriodeDebut() > $dateSortie) {
                    $e->annuler();
                } elseif (!$e->isAnnulee()) {
                    $derniere = $e;
                }
            }
            // R-37 : la dernière peut être ajustée à la main (pas de prorata automatique).
            if (null !== $montantDerniereEcheance && $derniere instanceof Echeance) {
                $derniere->setMontantDu($montantDerniereEcheance);
            }
            $tropPercu = $this->imputations->recalculer($contrat);

            $garantieImputee = 0;
            if ($garantieDetenue) {
                if (StatutGarantie::ImputeeSurLoyers === $reglementGarantie) {
                    $garantieImputee = min($contrat->getGarantieMontant(), $this->echeancier->restantDu($contrat));
                    if ($garantieImputee > 0) {
                        // R-32 : choix explicite du bailleur, qui génère une écriture (avec reçu).
                        $this->paiements->creer($contrat, $par, $garantieImputee, $dateSortie, MoyenPaiement::Garantie, 'garantie-'.Uuid::v4()->toRfc4122(), 'Garantie imputée à la clôture', TypePaiement::Loyer);
                    }
                    $contrat->reglerGarantie(StatutGarantie::ImputeeSurLoyers, $garantieImputee, $motifRetenue);
                } elseif (StatutGarantie::PartiellementRetenue === $reglementGarantie) {
                    $contrat->reglerGarantie(StatutGarantie::PartiellementRetenue, $montantRetenu, $motifRetenue);
                } else {
                    $contrat->reglerGarantie(StatutGarantie::Restituee);
                }
            } elseif (StatutGarantie::Attendue === $contrat->getGarantieStatut()) {
                $contrat->reglerGarantie(StatutGarantie::Aucune);
            }

            // R-38 : contrat en lecture seule, unité de nouveau vacante.
            $contrat->cloturer($dateSortie);
            $this->activites->enregistrer(Activites::CONTRAT_CLOTURE, $par, $contrat->getEspace(), $contrat, $contrat, [
                'unite' => $contrat->getUnite()->getNom(), 'locataire' => $contrat->getLocataire()->getNom(), 'dateSortie' => $dateSortie->format('Y-m-d'),
            ]);
            $this->em->flush();

            return ['tropPercu' => $tropPercu, 'restantDu' => $this->echeancier->restantDu($contrat), 'garantieImputee' => $garantieImputee];
        });
    }

    private function verifierReglementGarantie(Contrat $contrat, ?StatutGarantie $reglement, int $montantRetenu, ?string $motif): void
    {
        $permis = [StatutGarantie::Restituee, StatutGarantie::PartiellementRetenue, StatutGarantie::ImputeeSurLoyers];
        if (null === $reglement || !\in_array($reglement, $permis, true)) {
            throw ErreurMetier::champ('garantie', 'GARANTIE_REGLEMENT_REQUIS', 'Indiquez si la garantie est restituée, partiellement retenue ou imputée sur les loyers.');
        }
        if (StatutGarantie::PartiellementRetenue === $reglement) {
            if ($montantRetenu <= 0 || $montantRetenu > $contrat->getGarantieMontant()) {
                throw ErreurMetier::champ('montantRetenu', 'MONTANT_INVALIDE', 'Montant retenu invalide.');
            }
            if (null === $motif || '' === trim($motif)) {
                throw ErreurMetier::champ('motif', 'MOTIF_REQUIS', 'Le motif de la retenue est obligatoire.');
            }
        }
    }
}
