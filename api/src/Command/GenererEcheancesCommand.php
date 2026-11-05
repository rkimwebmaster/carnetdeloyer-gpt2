<?php

namespace App\Command;

use App\Entity\Contrat;
use App\Enum\StatutContrat;
use App\Service\Echeancier;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Component\Console\Attribute\AsCommand;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;

/** R-21 : tâche quotidienne qui prolonge les 12 mois glissants. */
#[AsCommand('app:echeances:generer', 'Génère les échéances des contrats actifs sur 12 mois glissants')]
final class GenererEcheancesCommand extends Command
{
    public function __construct(private readonly EntityManagerInterface $em, private readonly Echeancier $echeancier)
    {
        parent::__construct();
    }

    protected function execute(InputInterface $input, OutputInterface $output): int
    {
        $total = 0;
        foreach ($this->em->getRepository(Contrat::class)->findBy(['statut' => StatutContrat::Actif]) as $contrat) {
            $total += $this->echeancier->generer($contrat);
        }
        $output->writeln(\sprintf('%d échéance(s) créée(s).', $total));

        return Command::SUCCESS;
    }
}
