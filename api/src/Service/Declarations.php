<?php

namespace App\Service;

use App\Api\ErreurMetier;
use App\Entity\Contrat;
use App\Entity\DeclarationPaiement;
use App\Entity\User;
use App\Enum\MoyenPaiement;
use App\Enum\StatutDeclaration;
use App\Enum\TypePaiement;
use Doctrine\ORM\EntityManagerInterface;
use Psr\Clock\ClockInterface;

/**
 * R-39, R-40 : « J'ai payé ». En attente ou refusée, la déclaration ne modifie
 * jamais le solde. Pas de validation automatique, seulement des relances.
 */
final class Declarations
{
    public const RELANCE_APRES_JOURS = 2;

    public function __construct(
        private readonly EntityManagerInterface $em,
        private readonly ClockInterface $clock,
        private readonly Paiements $paiements,
        private readonly Activites $activites,
    ) {
    }

    public function declarer(Contrat $contrat, User $locataire, int $montant, \DateTimeImmutable $datePaiement, ?string $reference): DeclarationPaiement
    {
        if ($contrat->getLocataire()->getUtilisateur()?->getId() !== $locataire->getId()) {
            throw ErreurMetier::introuvable('Contrat');
        }
        if (!$contrat->isActif()) {
            throw new ErreurMetier('CONTRAT_CLOTURE', 'Ce contrat est clôturé.', 409);
        }
        if ($montant <= 0) {
            throw ErreurMetier::champ('montant', 'MONTANT_INVALIDE', 'Le montant doit être positif.');
        }
        $declaration = new DeclarationPaiement($contrat, $locataire, $montant, Calendrier::jour($datePaiement), $reference);
        $this->em->persist($declaration);
        $this->em->flush();
        $this->activites->enregistrer(Activites::DECLARATION_RECUE, $locataire, $contrat->getEspace(), $contrat, $declaration, [
            'montant' => $montant, 'devise' => $contrat->getDevise()->getCode(), 'locataire' => $contrat->getLocataire()->getNom(),
        ]);
        $this->em->flush();

        return $declaration;
    }

    public function valider(DeclarationPaiement $declaration, User $bailleur): void
    {
        $this->verifierEnAttente($declaration);
        $contrat = $declaration->getContrat();
        if (!$contrat->isActif()) {
            throw new ErreurMetier('CONTRAT_CLOTURE', 'Ce contrat est clôturé.', 409);
        }
        $this->em->wrapInTransaction(function () use ($declaration, $bailleur, $contrat): void {
            $paiement = $this->paiements->creer(
                $contrat, $bailleur, $declaration->getMontant(), $declaration->getDatePaiement(),
                null !== $declaration->getReference() ? MoyenPaiement::MobileMoney : MoyenPaiement::Autre,
                'declaration-'.$declaration->getId(), $declaration->getReference(), TypePaiement::Loyer,
            );
            $declaration->valider($paiement, $bailleur);
            $this->activites->enregistrer(Activites::DECLARATION_VALIDEE, $bailleur, $contrat->getEspace(), $contrat, $declaration, ['montant' => $declaration->getMontant(), 'devise' => $contrat->getDevise()->getCode()]);
            $this->em->flush();
        });
    }

    public function refuser(DeclarationPaiement $declaration, User $bailleur, string $motif): void
    {
        $this->verifierEnAttente($declaration);
        if ('' === trim($motif)) {
            throw ErreurMetier::champ('motif', 'MOTIF_REQUIS', 'Le motif du refus est obligatoire.');
        }
        $declaration->refuser(trim($motif), $bailleur);
        $contrat = $declaration->getContrat();
        $this->activites->enregistrer(Activites::DECLARATION_REFUSEE, $bailleur, $contrat->getEspace(), $contrat, $declaration, ['montant' => $declaration->getMontant(), 'devise' => $contrat->getDevise()->getCode(), 'motif' => trim($motif)]);
        $this->em->flush();
    }

    /** R-40 : relance au bailleur sans réponse. */
    public function relancer(): int
    {
        $limite = $this->clock->now()->modify(\sprintf('-%d days', self::RELANCE_APRES_JOURS));
        $enAttente = $this->em->getRepository(DeclarationPaiement::class)->findBy(['statut' => StatutDeclaration::EnAttente]);
        $relancees = 0;
        foreach ($enAttente as $d) {
            $derniere = $d->getDerniereRelanceLe() ?? $d->getCreatedAt();
            if ($derniere > $limite) {
                continue;
            }
            $contrat = $d->getContrat();
            $this->activites->enregistrer(Activites::DECLARATION_RELANCE, null, $contrat->getEspace(), $contrat, $d, ['montant' => $d->getMontant(), 'devise' => $contrat->getDevise()->getCode(), 'locataire' => $contrat->getLocataire()->getNom()]);
            $d->relancee();
            ++$relancees;
        }
        $this->em->flush();

        return $relancees;
    }

    private function verifierEnAttente(DeclarationPaiement $declaration): void
    {
        if (StatutDeclaration::EnAttente !== $declaration->getStatut()) {
            throw new ErreurMetier('DECLARATION_DEJA_TRAITEE', 'Cette déclaration a déjà été traitée.', 409);
        }
    }
}
