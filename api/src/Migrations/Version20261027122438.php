<?php

declare(strict_types=1);

namespace App\Migrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

/**
 * Auto-generated Migration: Please modify to your needs!
 */
final class Version20261027122438 extends AbstractMigration
{
    public function getDescription(): string
    {
        return 'Journal d\'audit des administrateurs (R-115).';
    }

    public function up(Schema $schema): void
    {
        // this up() migration is auto-generated, please modify it to your needs
        $this->addSql('CREATE TABLE journal_audit (id INT AUTO_INCREMENT NOT NULL, action VARCHAR(60) NOT NULL, contexte JSON NOT NULL, created_at DATETIME NOT NULL, admin_id INT NOT NULL, INDEX IDX_71C3CC538B8E8428 (created_at), INDEX IDX_71C3CC53642B8210 (admin_id), PRIMARY KEY (id)) DEFAULT CHARACTER SET utf8mb4');
        $this->addSql('ALTER TABLE journal_audit ADD CONSTRAINT FK_71C3CC53642B8210 FOREIGN KEY (admin_id) REFERENCES `user` (id)');
    }

    public function down(Schema $schema): void
    {
        // this down() migration is auto-generated, please modify it to your needs
        $this->addSql('ALTER TABLE journal_audit DROP FOREIGN KEY FK_71C3CC53642B8210');
        $this->addSql('DROP TABLE journal_audit');
    }
}
