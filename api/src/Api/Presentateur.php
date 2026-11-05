<?php

namespace App\Api;

use App\Entity\Activite;
use App\Entity\CategorieUnite;
use App\Entity\Contact;
use App\Entity\Contrat;
use App\Entity\DeclarationPaiement;
use App\Entity\Devise;
use App\Entity\EcritureWallet;
use App\Entity\Echeance;
use App\Entity\EspaceBailleur;
use App\Entity\PaiementAbonnement;
use App\Entity\Paiement;
use App\Entity\PaysApi;
use App\Entity\Propriete;
use App\Entity\Recu;
use App\Entity\Unite;
use App\Entity\User;
use App\Entity\VilleApi;
use App\Service\Abonnements;
use App\Service\Echeancier;
use App\Service\Recus;
use Psr\Clock\ClockInterface;

/**
 * Représentation JSON des entités. Les montants sont toujours des entiers en
 * unité mineure accompagnés du code devise (R-14) ; l'app formate.
 * Les statuts et soldes viennent du serveur (R-135).
 */
final class Presentateur
{
    public function __construct(
        private readonly ClockInterface $clock,
        private readonly Echeancier $echeancier,
        private readonly Abonnements $abonnements,
        private readonly Recus $recus,
    ) {
    }

    public static function date(?\DateTimeInterface $d): ?string
    {
        return $d?->format('Y-m-d');
    }

    public static function dateHeure(?\DateTimeInterface $d): ?string
    {
        return $d?->format(\DateTimeInterface::ATOM);
    }

    public function devise(Devise $d): array
    {
        return ['id' => $d->getId(), 'code' => $d->getCode(), 'nom' => $d->getNom(), 'symbole' => $d->getSymbole(), 'decimales' => $d->getDecimales(), 'active' => $d->isActive()];
    }

    public function pays(PaysApi $p): array
    {
        return [
            'id' => $p->getId(), 'nom' => $p->getNom(), 'codeIso' => $p->getCodeIso(), 'codeIso3' => $p->getCodeIso3(),
            'indicatif' => $p->getIndicatif(), 'drapeau' => $p->getDrapeau(), 'deviseParDefaut' => $p->getDeviseParDefaut()?->getCode(),
        ];
    }

    public function ville(VilleApi $v): array
    {
        return ['id' => $v->getId(), 'nom' => $v->getNom(), 'paysId' => $v->getPays()->getId()];
    }

    public function categorie(CategorieUnite $c): array
    {
        return ['code' => $c->getCode(), 'libelle' => $c->getLibelle(), 'icone' => $c->getIcone(), 'hotel' => $c->isHotel()];
    }

    public function utilisateur(User $u, ?EspaceBailleur $espace): array
    {
        return [
            'id' => $u->getId(), 'nom' => $u->getNom(), 'telephone' => $u->getTelephone(), 'email' => $u->getEmail(),
            'pays' => null === $u->getPays() ? null : $this->pays($u->getPays()),
            'villeId' => $u->getVille()?->getId(),
            'modePrefere' => $u->getModePrefere()?->value,
            'codeParrainage' => $u->getCodeParrainage(),
            'aUnParrain' => null !== $u->getParrain(),
            'espaceBailleur' => null === $espace ? null : $this->espace($espace),
            'roles' => $u->getRoles(),
        ];
    }

    public function espace(EspaceBailleur $e): array
    {
        return [
            'id' => $e->getId(), 'nomAffiche' => $e->nomAffiche(), 'raisonSociale' => $e->getRaisonSociale(),
            'numeroRccm' => $e->getNumeroRccm(), 'adresse' => $e->getAdresse(),
            'badge' => $e->getBadge($this->clock->now())?->value,
            'gratuiteUtilisee' => $e->isGratuiteUtilisee(),
        ];
    }

    public function propriete(Propriete $p, int $nbUnites = 0): array
    {
        return [
            'id' => $p->getId(), 'nom' => $p->getNom(), 'type' => $p->getType()->value, 'adresse' => $p->getAdresse(),
            'quartier' => $p->getQuartier(), 'ville' => null === $p->getVille() ? null : $this->ville($p->getVille()),
            'pays' => $this->pays($p->getPays()),
            // R-88 : position exacte réservée au bailleur et au locataire rattaché.
            'latitude' => $p->getLatitude(), 'longitude' => $p->getLongitude(),
            'nombreUnites' => $nbUnites,
        ];
    }

    public function unite(Unite $u, bool $avecPropriete = true): array
    {
        $contrat = $this->abonnements->contratActif($u);

        return [
            'id' => $u->getId(), 'nom' => $u->getNom(), 'categorie' => $this->categorie($u->getCategorie()),
            'proprieteId' => $u->getPropriete()->getId(),
            'propriete' => $avecPropriete ? $u->getPropriete()->getNom() : null,
            'loyerIndicatif' => null === $u->getLoyerIndicatif() ? null : ['montant' => $u->getLoyerIndicatif(), 'devise' => $u->getDeviseIndicative()?->getCode()],
            'vacante' => null === $contrat,
            'contratActifId' => $contrat?->getId(),
            'locataire' => $contrat?->getLocataire()->getNom(),
            'publieeMarket' => $u->isPublieeMarket(),
            'descriptionMarket' => $u->getDescriptionMarket(),
            'abonnement' => [
                'etat' => $this->abonnements->etat($u)->value,
                'fin' => self::date($this->abonnements->finPeriode($u)),
            ],
        ];
    }

    public function contact(Contact $c): array
    {
        return ['id' => $c->getId(), 'nom' => $c->getNom(), 'telephone' => $c->getTelephone(), 'inscrit' => null !== $c->getUtilisateur()];
    }

    public function contratResume(Contrat $c): array
    {
        $prochaine = $c->isActif() ? $this->echeancier->prochaineDue($c) : null;

        return [
            'id' => $c->getId(), 'statut' => $c->getStatut()->value,
            'unite' => ['id' => $c->getUnite()->getId(), 'nom' => $c->getUnite()->getNom(), 'propriete' => $c->getUnite()->getPropriete()->getNom(), 'categorie' => $this->categorie($c->getUnite()->getCategorie())],
            'locataire' => $this->contact($c->getLocataire()),
            'bailleur' => ['nom' => $c->getEspace()->nomAffiche(), 'badge' => $c->getEspace()->getBadge($this->clock->now())?->value],
            'devise' => $this->devise($c->getDevise()),
            'loyer' => $c->getLoyer(),
            'dateDebut' => self::date($c->getDateDebut()), 'dateFin' => self::date($c->getDateFin()),
            'dateSortie' => self::date($c->getDateSortie()),
            'enRetard' => $this->echeancier->enRetard($c),
            'restantDu' => $this->echeancier->restantDu($c),
            'prochaineEcheance' => null === $prochaine ? null : $this->echeance($prochaine),
        ];
    }

    public function contratDetail(Contrat $c, array $paiements): array
    {
        return $this->contratResume($c) + [
            'garantie' => [
                'montant' => $c->getGarantieMontant(), 'statut' => $c->getGarantieStatut()->value,
                'retenue' => $c->getGarantieRetenue(), 'motif' => $c->getGarantieMotif(),
            ],
            'echeances' => array_map($this->echeance(...), $this->echeancier->echeances($c)),
            'paiements' => array_map($this->paiement(...), $paiements),
        ];
    }

    public function echeance(Echeance $e): array
    {
        return [
            'id' => $e->getId(), 'periodeDebut' => self::date($e->getPeriodeDebut()), 'periodeFin' => self::date($e->getPeriodeFin()),
            'dateExigible' => self::date($e->getDateExigible()), 'montantDu' => $e->getMontantDu(), 'montantPaye' => $e->getMontantPaye(),
            'restantDu' => $e->getRestantDu(), 'statut' => $e->statut($this->clock->now())->value,
        ];
    }

    public function paiement(Paiement $p): array
    {
        $recu = $this->recus->pour($p);

        return [
            'id' => $p->getId(), 'contratId' => $p->getContrat()->getId(), 'type' => $p->getType()->value,
            'montant' => $p->getMontant(), 'devise' => $p->getContrat()->getDevise()->getCode(),
            'datePaiement' => self::date($p->getDatePaiement()), 'moyen' => $p->getMoyen()->value, 'reference' => $p->getReference(),
            'statut' => $p->getStatut()->value, 'motifAnnulation' => $p->getMotifAnnulation(),
            'cleIdempotence' => $p->getCleIdempotence(),
            'saisiPar' => $p->getSaisiPar()->getNom(),
            'locataire' => $p->getContrat()->getLocataire()->getNom(),
            'unite' => $p->getContrat()->getUnite()->getNom(),
            'imputationManuelle' => $p->isImputationManuelle(),
            'recu' => null === $recu ? null : $this->recu($recu),
            'creeLe' => self::dateHeure($p->getCreatedAt()),
        ];
    }

    public function recu(Recu $r): array
    {
        $lien = $this->recus->lienPublic($r);

        return [
            'id' => $r->getId(), 'numero' => $r->getNumero(), 'annule' => $r->isAnnule(), 'emisLe' => self::dateHeure($r->getEmisLe()), 'lien' => $lien,
            // R-74 : message prêt à envoyer par WhatsApp ou SMS depuis le téléphone du bailleur ;
            // R-121 : il contient le lien vers la politique de confidentialité.
            'messagePartage' => $this->recus->messagePartage($r, $lien),
        ];
    }

    public function declaration(DeclarationPaiement $d): array
    {
        return [
            'id' => $d->getId(), 'contratId' => $d->getContrat()->getId(), 'montant' => $d->getMontant(),
            'devise' => $d->getContrat()->getDevise()->getCode(), 'datePaiement' => self::date($d->getDatePaiement()),
            'reference' => $d->getReference(), 'statut' => $d->getStatut()->value, 'motifRefus' => $d->getMotifRefus(),
            'locataire' => $d->getContrat()->getLocataire()->getNom(), 'unite' => $d->getContrat()->getUnite()->getNom(),
            'paiementId' => $d->getPaiement()?->getId(), 'creeLe' => self::dateHeure($d->getCreatedAt()),
        ];
    }

    public function paiementAbonnement(PaiementAbonnement $p): array
    {
        return [
            'id' => $p->getId(), 'uniteId' => $p->getUnite()->getId(), 'unite' => $p->getUnite()->getNom(),
            'contratId' => $p->getContrat()->getId(), 'payeur' => $p->getPayeur()->getNom(),
            'loyerMensuel' => $p->getLoyerMensuel(), 'devise' => $p->getDeviseCode(), 'pourcentage' => $p->getPourcentage(),
            'montantDevise' => $p->getMontantDevise(), 'tauxUsd' => $p->getTauxUsd(), 'montantUsd' => $p->getMontantUsd(),
            'source' => $p->getSource()->value, 'referenceTransaction' => $p->getReferenceTransaction(),
            'statut' => $p->getStatut()->value, 'motifRejet' => $p->getMotifRejet(),
            'periodeDebut' => self::date($p->getPeriodeDebut()), 'periodeFin' => self::date($p->getPeriodeFin()),
            'creeLe' => self::dateHeure($p->getCreatedAt()),
        ];
    }

    public function ecriture(EcritureWallet $e): array
    {
        return [
            'id' => $e->getId(), 'espace' => $e->getEspace()->value, 'sens' => $e->getSens()->value,
            'montant' => $e->getMontant(), 'devise' => 'USD', 'motif' => $e->getMotif(), 'reference' => $e->getReference(),
            'commentaire' => $e->getCommentaire(), 'creeLe' => self::dateHeure($e->getCreatedAt()),
        ];
    }

    public function activite(Activite $a): array
    {
        return [
            'id' => $a->getId(), 'type' => $a->getType(), 'acteur' => $a->getActeur()?->getNom(),
            'contratId' => $a->getContrat()?->getId(), 'objetType' => $a->getObjetType(), 'objetId' => $a->getObjetId(),
            'parametres' => (object) $a->getParametres(), 'creeLe' => self::dateHeure($a->getCreatedAt()),
        ];
    }
}
