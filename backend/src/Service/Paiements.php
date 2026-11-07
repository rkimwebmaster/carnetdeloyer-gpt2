<?php

namespace App\Service;

use App\Api\ErreurMetier;
use App\Entity\Contrat;
use App\Entity\Paiement;
use App\Entity\User;
use App\Enum\MoyenPaiement;
use App\Enum\StatutGarantie;
use App\Enum\TypePaiement;
use Doctrine\DBAL\Exception\UniqueConstraintViolationException;
use Doctrine\ORM\EntityManagerInterface;
use Doctrine\Persistence\ManagerRegistry;
use Psr\Clock\ClockInterface;

/**
 * Section 4 et 5 : encaissement, imputation, reçu, annulation.
 */
final class Paiements
{
    public function __construct(
        private EntityManagerInterface $em,
        private readonly ManagerRegistry $doctrine,
        private readonly ClockInterface $clock,
        private readonly Echeancier $echeancier,
        private readonly Imputations $imputations,
        private readonly Recus $recus,
        private readonly Abonnements $abonnements,
        private readonly Activites $activites,
    ) {
    }

    /**
     * Enregistre un paiement. Idempotent sur la clé fournie par le téléphone (R-137) :
     * si la clé a déjà été reçue, le paiement existant est renvoyé.
     *
     * @return array{Paiement, bool} le paiement et true s'il vient d'être créé
     */
    public function encaisser(Contrat $contrat, User $saisiPar, int $montant, \DateTimeImmutable $datePaiement, MoyenPaiement $moyen, string $cle, ?string $reference = null, TypePaiement $type = TypePaiement::Loyer): array
    {
        $existant = $this->parCle($cle, $saisiPar, $contrat);
        if (null !== $existant) {
            return [$existant, false];
        }

        $this->verifierSaisie($contrat, $montant, $datePaiement);
        if (MoyenPaiement::Garantie === $moyen) {
            throw ErreurMetier::champ('moyen', 'MOYEN_INVALIDE', 'Ce moyen est réservé à la clôture du contrat.');
        }

        try {
            $paiement = $this->em->wrapInTransaction(fn () => $this->creer($contrat, $saisiPar, $montant, $datePaiement, $moyen, $cle, $reference, $type));
        } catch (UniqueConstraintViolationException) {
            // Deux envois simultanés de la même clé : renvoyer celui qui a gagné.
            $this->em = $this->doctrine->resetManager();
            $existant = $this->parCle($cle, $saisiPar, $contrat);
            if (null === $existant) {
                throw new ErreurMetier('CONFLIT', 'Conflit d\'enregistrement, réessayez.', 409);
            }

            return [$existant, false];
        }

        return [$paiement, true];
    }

    /**
     * Création sans contrôle de saisie, dans une transaction déjà ouverte
     * (utilisé aussi par la clôture et la validation des déclarations).
     */
    public function creer(Contrat $contrat, User $saisiPar, int $montant, \DateTimeImmutable $datePaiement, MoyenPaiement $moyen, string $cle, ?string $reference, TypePaiement $type): Paiement
    {
        $this->echeancier->verrouiller($contrat);
        if ($this->abonnements->estSuspendue($contrat->getUnite())) {
            // R-56 : plus de saisie de paiement ni d'émission de reçu.
            throw new ErreurMetier('UNITE_SUSPENDUE', 'Abonnement expiré : renouvelez-le pour enregistrer des paiements.', 403);
        }

        if (TypePaiement::Garantie === $type) {
            if (StatutGarantie::Attendue !== $contrat->getGarantieStatut()) {
                throw new ErreurMetier('GARANTIE_NON_ATTENDUE', 'Aucune garantie en attente sur ce contrat.', 422);
            }
            if ($montant !== $contrat->getGarantieMontant()) {
                throw ErreurMetier::champ('montant', 'GARANTIE_MONTANT_INCORRECT', 'Le montant doit égaler la garantie prévue au contrat.');
            }
        } else {
            $this->echeancier->generer($contrat);
            if ($montant > $this->echeancier->restantDu($contrat)) {
                throw ErreurMetier::champ('montant', 'PAIEMENT_SUPERIEUR_AU_DU', 'Le montant dépasse le total restant dû sur les échéances générées.');
            }
        }

        $paiement = new Paiement($contrat, $type, $montant, $datePaiement, $moyen, $cle, $saisiPar, $reference);
        $this->em->persist($paiement);
        if (TypePaiement::Garantie === $type) {
            $contrat->garantieRecue();
        } else {
            $this->imputations->imputerAutomatiquement($paiement);
        }
        $this->em->flush();
        $recu = $this->recus->emettre($paiement);
        $this->activites->enregistrer(Activites::PAIEMENT_ENREGISTRE, $saisiPar, $contrat->getEspace(), $contrat, $paiement, [
            'montant' => $montant, 'devise' => $contrat->getDevise()->getCode(), 'type' => $type->value,
            'locataire' => $contrat->getLocataire()->getNom(), 'recu' => $recu->getNumero(),
        ]);
        $this->em->flush();

        return $paiement;
    }

    /**
     * R-34 : annulation avec motif obligatoire ; recalcul de l'imputation ; le reçu
     * passe au statut annulé en gardant son numéro ; le locataire est notifié.
     */
    public function annuler(Paiement $paiement, User $par, string $motif): void
    {
        $motif = trim($motif);
        if ('' === $motif) {
            throw ErreurMetier::champ('motif', 'MOTIF_REQUIS', 'Le motif d\'annulation est obligatoire.');
        }
        if (!$paiement->isValide()) {
            throw new ErreurMetier('PAIEMENT_DEJA_ANNULE', 'Ce paiement est déjà annulé.', 409);
        }
        $contrat = $paiement->getContrat();
        if (!$contrat->isActif()) {
            throw new ErreurMetier('CONTRAT_CLOTURE', 'Un contrat clôturé est en lecture seule.', 409);
        }

        $this->em->wrapInTransaction(function () use ($paiement, $par, $motif, $contrat): void {
            $this->echeancier->verrouiller($contrat);
            $paiement->annuler($motif, $par);
            $this->recus->pour($paiement)?->annuler();
            if (TypePaiement::Garantie === $paiement->getType()) {
                $contrat->garantieAnnulee();
            } else {
                $this->imputations->recalculer($contrat);
            }
            $this->activites->enregistrer(Activites::PAIEMENT_ANNULE, $par, $contrat->getEspace(), $contrat, $paiement, [
                'montant' => $paiement->getMontant(), 'devise' => $contrat->getDevise()->getCode(), 'motif' => $motif,
            ]);
            $this->em->flush();
        });
    }

    private function verifierSaisie(Contrat $contrat, int $montant, \DateTimeImmutable $datePaiement): void
    {
        if (!$contrat->isActif()) {
            throw new ErreurMetier('CONTRAT_CLOTURE', 'Un contrat clôturé est en lecture seule.', 409);
        }
        if ($montant <= 0) {
            throw ErreurMetier::champ('montant', 'MONTANT_INVALIDE', 'Le montant doit être positif.');
        }
        if (Calendrier::jour($datePaiement) > Calendrier::jour($this->clock->now())->modify('+1 day')) {
            throw ErreurMetier::champ('datePaiement', 'DATE_FUTURE', 'La date de paiement ne peut pas être dans le futur.');
        }
    }

    private function parCle(string $cle, User $saisiPar, Contrat $contrat): ?Paiement
    {
        $existant = $this->em->getRepository(Paiement::class)->findOneBy(['cleIdempotence' => $cle]);
        if (null === $existant) {
            return null;
        }
        if ($existant->getSaisiPar()->getId() !== $saisiPar->getId() || $existant->getContrat()->getId() !== $contrat->getId()) {
            // R-139 : une clé n'est jamais rejouée sous un autre compte.
            throw new ErreurMetier('CLE_IDEMPOTENCE_CONFLIT', 'Cette clé de paiement appartient à un autre envoi.', 409);
        }

        return $existant;
    }
}
