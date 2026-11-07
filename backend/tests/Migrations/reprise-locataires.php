<?php

/** R-72 : tester la reprise sur une base MariaDB jetable, jamais celle du PC. */

use App\Migrations\Version20261105050000;
use Doctrine\DBAL\DriverManager;
use Doctrine\DBAL\Schema\Schema;
use Doctrine\DBAL\Tools\DsnParser;
use Psr\Log\NullLogger;

require dirname(__DIR__, 2).'/vendor/autoload.php';

if ('true' !== getenv('GITHUB_ACTIONS') || !getenv('CDL_MIGRATION_DSN')) {
    fwrite(STDERR, "Ce test nécessite la base éphémère dédiée de GitHub Actions.\n");
    exit(1);
}
$params = (new DsnParser(['mysql' => 'pdo_mysql']))->parse(getenv('CDL_MIGRATION_DSN'));
if ('cdl_reprise_ci' !== ($params['dbname'] ?? null)) {
    throw new LogicException('Nom de base réservé au test de reprise requis.');
}
$serveur = $params;
unset($serveur['dbname']);
$connexion = DriverManager::getConnection($serveur);
// Sans IF NOT EXISTS : refuser de réutiliser une base qui pourrait contenir des données.
$connexion->executeStatement('CREATE DATABASE cdl_reprise_ci');
$connexion->close();
$db = DriverManager::getConnection($params);
$db->executeStatement('CREATE TABLE `user` (id INT PRIMARY KEY, nom VARCHAR(120) NOT NULL)');
$db->executeStatement('CREATE TABLE contact (id INT PRIMARY KEY, utilisateur_id INT DEFAULT NULL)');
$db->executeStatement('CREATE TABLE contrat (id INT PRIMARY KEY, locataire_id INT NOT NULL)');
$db->insert('user', ['id' => 1, 'nom' => 'Utilisateur historique']);
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
$verifier = static function (bool $ok, string $cas): void {
    if (!$ok) {
        throw new RuntimeException('Reprise incorrecte : '.$cas);
    }
};
$verifier(1 === (int) $db->fetchOne('SELECT telephone_verifie FROM `user` WHERE id = 1'), 'ancien compte vérifié');
$verifier('Utilisateur historique' === $db->fetchOne('SELECT nom FROM `user` WHERE id = 1'), 'nom conservé');
$verifier(2 === (int) $db->fetchOne('SELECT COUNT(*) FROM contrat WHERE locataire_confirme_le IS NOT NULL'), 'deux confirmations historiques conservées');
$verifier(null === $db->fetchOne('SELECT locataire_confirme_le FROM contrat WHERE id = 30'), 'contrat non confirmé reste privé');
$verifier(0 === (int) $db->fetchOne('SELECT COUNT(*) FROM contrat WHERE locataire_refuse_le IS NOT NULL'), 'aucun refus inventé');
$verifier(3 === (int) $db->fetchOne('SELECT COUNT(*) FROM contrat'), 'aucune suppression');
$db->insert('user', ['id' => 2, 'nom' => 'Nouveau compte provisoire']);
$verifier(0 === (int) $db->fetchOne('SELECT telephone_verifie FROM `user` WHERE id = 2'), 'nouveau compte non vérifié par défaut');
echo "OK : migration de reprise, identités et accès historiques préservés.\n";
$db->close();
