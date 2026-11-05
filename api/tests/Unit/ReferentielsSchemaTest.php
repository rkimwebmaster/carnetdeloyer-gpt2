<?php

namespace App\Tests\Unit;

use App\Command\ChargerReferentielsCommand;
use App\Entity\CategorieUnite;
use App\Entity\Devise;
use App\Entity\PaysApi;
use App\Entity\VilleApi;
use Doctrine\DBAL\DriverManager;
use Doctrine\ORM\EntityManager;
use Doctrine\ORM\ORMSetup;
use Doctrine\ORM\Tools\SchemaTool;
use PHPUnit\Framework\TestCase;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Tester\CommandTester;

/** R-15 : une base historique doit être contrôlée avant toute écriture. */
final class ReferentielsSchemaTest extends TestCase
{
    private EntityManager $em;
    private CommandTester $commande;

    protected function setUp(): void
    {
        $config = ORMSetup::createAttributeMetadataConfiguration([dirname(__DIR__, 2).'/src/Entity'], true);
        $this->em = new EntityManager(DriverManager::getConnection(['driver' => 'pdo_sqlite', 'memory' => true]), $config);
        $metadata = array_map($this->em->getClassMetadata(...), [Devise::class, PaysApi::class, VilleApi::class, CategorieUnite::class]);
        (new SchemaTool($this->em))->createSchema($metadata);
        $this->commande = new CommandTester(new ChargerReferentielsCommand($this->em));
    }

    protected function tearDown(): void
    {
        $this->em->close();
        $this->em->getConnection()->close();
    }

    public function testControleConformeSansChargement(): void
    {
        self::assertSame(Command::SUCCESS, $this->commande->execute(['--verifier-schema' => true]));
        self::assertStringContainsString('Aucune écriture effectuée', $this->commande->getDisplay());
        self::assertSame(0, $this->em->getRepository(Devise::class)->count([]));
        self::assertSame(0, $this->em->getRepository(PaysApi::class)->count([]));
    }

    public function testAncienneDeviseSignaleeSansAltererLaBase(): void
    {
        $db = $this->em->getConnection();
        $db->executeStatement('ALTER TABLE devise RENAME COLUMN active TO is_active');
        $db->executeStatement('ALTER TABLE devise DROP COLUMN decimales');
        $db->insert('devise', ['code' => 'USD', 'nom' => 'Dollar existant', 'symbole' => '$', 'is_active' => 0]);
        $avant = $db->fetchAllAssociative('SELECT * FROM devise');

        self::assertSame(Command::FAILURE, $this->commande->execute(['--verifier-schema' => true]));
        self::assertStringContainsString('decimales', $this->commande->getDisplay());
        self::assertStringContainsString('is_active', $this->commande->getDisplay());
        self::assertSame($avant, $db->fetchAllAssociative('SELECT * FROM devise'));
        self::assertFalse($db->createSchemaManager()->introspectTable('devise')->hasColumn('active'));

        // Même sans l'option, le chargement doit refuser la base incompatible.
        self::assertSame(Command::FAILURE, $this->commande->execute([]));
        self::assertSame($avant, $db->fetchAllAssociative('SELECT * FROM devise'));
        self::assertSame(0, $this->em->getRepository(PaysApi::class)->count([]));
    }

    public function testTableAbsenteSignaleeSansCreationAutomatique(): void
    {
        $db = $this->em->getConnection();
        $db->executeStatement('DROP TABLE villes');
        self::assertSame(Command::FAILURE, $this->commande->execute(['--verifier-schema' => true]));
        self::assertStringContainsString('villes : table absente', $this->commande->getDisplay());
        self::assertFalse($db->createSchemaManager()->tablesExist(['villes']));
    }

    public function testIndexUniqueAbsentEstSignale(): void
    {
        $manager = $this->em->getConnection()->createSchemaManager();
        foreach ($manager->introspectTable('devise')->getIndexes() as $index) {
            if ($index->isUnique() && !$index->isPrimary()) {
                $manager->dropIndex($index->getName(), 'devise');
            }
        }
        self::assertSame(Command::FAILURE, $this->commande->execute(['--verifier-schema' => true]));
        self::assertStringContainsString('Index ou clés étrangères différents', $this->commande->getDisplay());
    }

    public function testAncienneSuppressionEnCascadeEstSignalee(): void
    {
        $db = $this->em->getConnection();
        $db->executeStatement('DROP TABLE villes');
        $db->executeStatement('CREATE TABLE villes (id INTEGER PRIMARY KEY AUTOINCREMENT, nom VARCHAR(150) NOT NULL, active BOOLEAN NOT NULL, pays_id INTEGER NOT NULL, CONSTRAINT ancienne_fk FOREIGN KEY (pays_id) REFERENCES pays (id) ON DELETE CASCADE)');
        $db->executeStatement('CREATE UNIQUE INDEX unique_ville_pays ON villes (pays_id, nom)');
        self::assertSame(Command::FAILURE, $this->commande->execute(['--verifier-schema' => true]));
        self::assertStringContainsString('Index ou clés étrangères différents', $this->commande->getDisplay());
        self::assertSame('CASCADE', array_values($db->createSchemaManager()->introspectTable('villes')->getForeignKeys())[0]->getOnDeleteAction()->value);
    }

    public function testChargementIdempotentPreserveLesDonneesExistantes(): void
    {
        $usd = new Devise('USD', 'Nom personnalisé', 'US$', 2);
        $usd->setActive(false);
        $this->em->persist($usd);
        $this->em->flush();
        $id = $usd->getId();

        self::assertSame(Command::SUCCESS, $this->commande->execute([]));
        $db = $this->em->getConnection();
        $avant = [];
        foreach (['devise', 'pays', 'villes', $this->em->getClassMetadata(CategorieUnite::class)->getTableName()] as $table) {
            $avant[$table] = $db->fetchAllAssociative('SELECT * FROM '.$table.' ORDER BY id');
        }
        self::assertSame(Command::SUCCESS, $this->commande->execute([]));
        foreach ($avant as $table => $lignes) {
            self::assertSame($lignes, $db->fetchAllAssociative('SELECT * FROM '.$table.' ORDER BY id'));
        }
        $this->em->clear();
        $usd = $this->em->find(Devise::class, $id);
        self::assertSame('Nom personnalisé', $usd->getNom());
        self::assertFalse($usd->isActive());
    }
}
