<?php

declare(strict_types=1);

namespace App\Migrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

/** R-19, R-72, R-182 : reprise additive, sans suppression de contrat ou de preuve. */
final class Version20261105050000 extends AbstractMigration
{
    public function getDescription(): string
    {
        return 'Compte locataire non vérifié et décision par contrat ; préserve les accès déjà confirmés.';
    }

    public function up(Schema $schema): void
    {
        $this->addSql('ALTER TABLE `user` ADD telephone_verifie TINYINT DEFAULT 0 NOT NULL');
        // Avant cette version, les comptes applicatifs étaient créés après OTP.
        $this->addSql('UPDATE `user` SET telephone_verifie = 1');
        $this->addSql('ALTER TABLE contrat ADD locataire_confirme_le DATETIME DEFAULT NULL, ADD locataire_refuse_le DATETIME DEFAULT NULL');
        // Le lien Contact→User représentait la confirmation globale historique.
        // La date de reprise ne prétend pas être la date réelle de l'ancien accord.
        $this->addSql('UPDATE contrat c INNER JOIN contact l ON c.locataire_id = l.id SET c.locataire_confirme_le = CURRENT_TIMESTAMP WHERE l.utilisateur_id IS NOT NULL');
    }

    public function down(Schema $schema): void
    {
        $this->throwIrreversibleMigrationException('Les confirmations et refus sont des preuves conservées (R-06). Prévoir une correction additive.');
    }
}
