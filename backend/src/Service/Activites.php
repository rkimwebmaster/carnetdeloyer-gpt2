<?php

namespace App\Service;

use App\Entity\Activite;
use App\Entity\Contrat;
use App\Entity\EspaceBailleur;
use App\Entity\User;
use Doctrine\ORM\EntityManagerInterface;

/**
 * R-172 : création automatique des activités par le serveur.
 */
final class Activites
{
    public const PAIEMENT_ENREGISTRE = 'paiement_enregistre';
    public const PAIEMENT_ANNULE = 'paiement_annule';
    public const DECLARATION_RECUE = 'declaration_recue';
    public const DECLARATION_VALIDEE = 'declaration_validee';
    public const DECLARATION_REFUSEE = 'declaration_refusee';
    public const DECLARATION_RELANCE = 'declaration_relance';
    public const CONTRAT_CREE = 'contrat_cree';
    public const CONTRAT_CLOTURE = 'contrat_cloture';
    public const ABONNEMENT_PAYE = 'abonnement_paye';
    public const ABONNEMENT_GRATUIT = 'abonnement_gratuit';
    public const ABONNEMENT_EXPIRE_BIENTOT = 'abonnement_expire_bientot';
    public const GAIN_PARRAINAGE = 'gain_parrainage';
    public const ANNONCE_PUBLIEE = 'annonce_publiee';
    public const BADGE_OBTENU = 'badge_obtenu';

    public function __construct(private readonly EntityManagerInterface $em)
    {
    }

    /**
     * @param array<string, scalar|null> $parametres
     */
    public function enregistrer(string $type, ?User $acteur, ?EspaceBailleur $espace, ?Contrat $contrat = null, ?object $objet = null, array $parametres = [], ?User $destinataire = null): Activite
    {
        $objetType = null;
        $objetId = null;
        if (null !== $objet) {
            $objetType = lcfirst((new \ReflectionClass($objet))->getShortName());
            $objetId = method_exists($objet, 'getId') ? $objet->getId() : null;
        }
        $activite = new Activite($type, $acteur, $espace, $contrat, $objetType, $objetId, $parametres, $destinataire);
        $this->em->persist($activite);

        return $activite;
    }
}
