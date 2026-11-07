<?php

namespace App;

use App\Doctrine\ChiffreType;
use App\Securite\Chiffreur;
use Symfony\Bundle\FrameworkBundle\Kernel\MicroKernelTrait;
use Symfony\Component\HttpKernel\Kernel as BaseKernel;

class Kernel extends BaseKernel
{
    use MicroKernelTrait;

    public function boot(): void
    {
        parent::boot();

        // Le type Doctrine "chiffre" est statique : on lui donne le chiffreur du conteneur.
        ChiffreType::utiliser($this->getContainer()->get(Chiffreur::class));
    }
}
