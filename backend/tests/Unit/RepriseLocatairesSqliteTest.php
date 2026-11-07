<?php

namespace App\Tests\Unit;

use App\Migrations\Version20261105050000;
use Doctrine\DBAL\DriverManager;
use Doctrine\DBAL\Schema\Schema;
use PHPUnit\Framework\TestCase;
use Psr\Log\NullLogger;

final class RepriseLocatairesSqliteTest extends TestCase
{
    public function testRepriseConserveLesIdentitesEtLesAccesHistoriques(): void
    {
        $db = DriverManager::getConnection(['driver' => 'pdo_sqlite', 'memory' => true]);
        $db->executeStatement('CREATE TABLE "user" (id INTEGER PRIMARY KEY, nom VARCHAR(120) NOT NULL)');
        $db->executeStatement('CREATE TABLE contact (id INTEGER PRIMARY KEY, utilisateur_id INTEGER DEFAULT NULL)');
        $db->executeStatement('CREATE TABLE contrat (id INTEGER PRIMARY KEY, locataire_id INTEGER NOT NULL)');
        $db->insert('user', ['id' => 1, 'nom' => 'Compte historique']);
        $db->insert('contact', ['id' => 1, 'utilisateur_id' => 1]);
        $db->insert('contact', ['id' => 2, 'utilisateur_id' => null]);
        foreach ([10 => 1, 20 => 1, 30 => 2] as $id => $contact) {
            $db->insert('contrat', ['id' => $id, 'locataire_id' => $contact]);
        }
        $migration = new Version20261105050000($db, new NullLogger());
        $migration->up(new Schema());
        foreach ($migration->getSql() as $requete) {
            $db->executeStatement($requete->getStatement(), $requete->getParameters(), $requete->getTypes());
        }
        self::assertSame(1, (int) $db->fetchOne('SELECT telephone_verifie FROM "user" WHERE id = 1'));
        self::assertSame('Compte historique', $db->fetchOne('SELECT nom FROM "user" WHERE id = 1'));
        self::assertSame(2, (int) $db->fetchOne('SELECT COUNT(*) FROM contrat WHERE locataire_confirme_le IS NOT NULL'));
        self::assertNull($db->fetchOne('SELECT locataire_confirme_le FROM contrat WHERE id = 30'));
        self::assertSame(0, (int) $db->fetchOne('SELECT COUNT(*) FROM contrat WHERE locataire_refuse_le IS NOT NULL'));
        self::assertSame(3, (int) $db->fetchOne('SELECT COUNT(*) FROM contrat'));
        $db->insert('user', ['id' => 2, 'nom' => 'Nouveau compte']);
        self::assertSame(0, (int) $db->fetchOne('SELECT telephone_verifie FROM "user" WHERE id = 2'));
        $db->close();
    }
}
