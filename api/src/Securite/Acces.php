<?php

namespace App\Securite;

use App\Api\ErreurMetier;
use App\Entity\Contact;
use App\Entity\Contrat;
use App\Entity\DeclarationPaiement;
use App\Entity\EspaceBailleur;
use App\Entity\Paiement;
use App\Entity\Propriete;
use App\Entity\Unite;
use App\Entity\User;
use App\Service\Espaces;
use Doctrine\ORM\EntityManagerInterface;

/**
 * R-144 : chaque appel est autorisé selon ce que l'utilisateur possède, jamais
 * selon le mode affiché. Un objet qui n'appartient pas à l'utilisateur répond 404
 * (on ne révèle pas son existence).
 */
final class Acces
{
    public function __construct(
        private readonly EntityManagerInterface $em,
        private readonly Espaces $espaces,
    ) {
    }

    public function espace(User $user): EspaceBailleur
    {
        return $this->espaces->de($user) ?? throw ErreurMetier::introuvable('Espace bailleur');
    }

    public function propriete(User $user, int $id): Propriete
    {
        $p = $this->em->find(Propriete::class, $id);
        if (null === $p || $p->getEspace()->getProprietaire()->getId() !== $user->getId()) {
            throw ErreurMetier::introuvable('Propriété');
        }

        return $p;
    }

    public function unite(User $user, int $id): Unite
    {
        $u = $this->em->find(Unite::class, $id);
        if (null === $u || $u->getEspace()->getProprietaire()->getId() !== $user->getId()) {
            throw ErreurMetier::introuvable('Unité');
        }

        return $u;
    }

    public function contact(User $user, int $id): Contact
    {
        $c = $this->em->find(Contact::class, $id);
        if (null === $c || $c->getEspace()->getProprietaire()->getId() !== $user->getId()) {
            throw ErreurMetier::introuvable('Contact');
        }

        return $c;
    }

    /** Contrat vu par le bailleur. */
    public function contrat(User $user, int $id): Contrat
    {
        $c = $this->em->find(Contrat::class, $id);
        if (null === $c || $c->getEspace()->getProprietaire()->getId() !== $user->getId()) {
            throw ErreurMetier::introuvable('Contrat');
        }

        return $c;
    }

    /** Contrat vu par le locataire rattaché. */
    public function contratLocataire(User $user, int $id): Contrat
    {
        $c = $this->em->find(Contrat::class, $id);
        if (null === $c || $c->getLocataire()->getUtilisateur()?->getId() !== $user->getId()) {
            throw ErreurMetier::introuvable('Contrat');
        }

        return $c;
    }

    public function paiement(User $user, int $id): Paiement
    {
        $p = $this->em->find(Paiement::class, $id);
        if (null === $p || $p->getContrat()->getEspace()->getProprietaire()->getId() !== $user->getId()) {
            throw ErreurMetier::introuvable('Paiement');
        }

        return $p;
    }

    public function declaration(User $user, int $id): DeclarationPaiement
    {
        $d = $this->em->find(DeclarationPaiement::class, $id);
        if (null === $d || $d->getContrat()->getEspace()->getProprietaire()->getId() !== $user->getId()) {
            throw ErreurMetier::introuvable('Déclaration');
        }

        return $d;
    }
}
