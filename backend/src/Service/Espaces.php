<?php

namespace App\Service;

use App\Entity\EspaceBailleur;
use App\Entity\User;
use Doctrine\ORM\EntityManagerInterface;

final class Espaces
{
    public function __construct(private readonly EntityManagerInterface $em)
    {
    }

    public function de(User $user): ?EspaceBailleur
    {
        return $this->em->getRepository(EspaceBailleur::class)->findOneBy(['proprietaire' => $user]);
    }

    /** L'espace bailleur est créé au premier besoin (première propriété). */
    public function obtenir(User $user): EspaceBailleur
    {
        $espace = $this->de($user);
        if (null === $espace) {
            $espace = new EspaceBailleur($user);
            $this->em->persist($espace);
            $this->em->flush();
        }

        return $espace;
    }
}
