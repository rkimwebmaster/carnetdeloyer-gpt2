<?php

namespace App\Command;

use App\Service\Abonnements;
use App\Service\Declarations;
use Symfony\Component\Console\Attribute\AsCommand;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;

/** R-55 et R-40 : rappels quotidiens (abonnements, déclarations sans réponse). */
#[AsCommand('app:rappels', 'Envoie les rappels d\'abonnement et relance les déclarations en attente')]
final class RappelsCommand extends Command
{
    public function __construct(private readonly Abonnements $abonnements, private readonly Declarations $declarations)
    {
        parent::__construct();
    }

    protected function execute(InputInterface $input, OutputInterface $output): int
    {
        $output->writeln(\sprintf('%d rappel(s) d\'abonnement.', $this->abonnements->envoyerRappels()));
        $output->writeln(\sprintf('%d déclaration(s) relancée(s).', $this->declarations->relancer()));

        return Command::SUCCESS;
    }
}
