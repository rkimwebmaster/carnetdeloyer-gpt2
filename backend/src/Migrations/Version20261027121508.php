<?php

declare(strict_types=1);

namespace App\Migrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

/**
 * Auto-generated Migration: Please modify to your needs!
 */
final class Version20261027121508 extends AbstractMigration
{
    public function getDescription(): string
    {
        return 'Schéma initial CarnetDeLoyer v0.1 (référentiels, biens, contrats, échéances, paiements, reçus, abonnements, wallet, activité).';
    }

    public function up(Schema $schema): void
    {
        // this up() migration is auto-generated, please modify it to your needs
        $this->addSql('CREATE TABLE activite (id INT AUTO_INCREMENT NOT NULL, type VARCHAR(50) NOT NULL, objet_type VARCHAR(40) DEFAULT NULL, objet_id INT DEFAULT NULL, parametres JSON NOT NULL, created_at DATETIME NOT NULL, acteur_id INT DEFAULT NULL, espace_id INT DEFAULT NULL, contrat_id INT DEFAULT NULL, destinataire_id INT DEFAULT NULL, INDEX IDX_B87555158B8E8428 (created_at), INDEX IDX_B8755515DA6F574A (acteur_id), INDEX IDX_B8755515B6885C6C (espace_id), INDEX IDX_B87555151823061F (contrat_id), INDEX IDX_B8755515A4F84F6E (destinataire_id), PRIMARY KEY (id)) DEFAULT CHARACTER SET utf8mb4');
        $this->addSql('CREATE TABLE categorie_unite (id INT AUTO_INCREMENT NOT NULL, code VARCHAR(40) NOT NULL, libelle VARCHAR(80) NOT NULL, icone VARCHAR(60) NOT NULL, hotel TINYINT NOT NULL, active TINYINT NOT NULL, UNIQUE INDEX UNIQ_E81C2CC877153098 (code), PRIMARY KEY (id)) DEFAULT CHARACTER SET utf8mb4');
        $this->addSql('CREATE TABLE contact (id INT AUTO_INCREMENT NOT NULL, nom VARCHAR(120) NOT NULL, telephone VARCHAR(255) DEFAULT NULL, telephone_empreinte VARCHAR(64) DEFAULT NULL, created_at DATETIME NOT NULL, espace_id INT NOT NULL, utilisateur_id INT DEFAULT NULL, INDEX IDX_4C62E6381783D68 (telephone_empreinte), INDEX IDX_4C62E638B6885C6C (espace_id), INDEX IDX_4C62E638FB88E14F (utilisateur_id), PRIMARY KEY (id)) DEFAULT CHARACTER SET utf8mb4');
        $this->addSql('CREATE TABLE contrat (id INT AUTO_INCREMENT NOT NULL, loyer BIGINT NOT NULL, date_debut DATE NOT NULL, date_fin DATE DEFAULT NULL, statut VARCHAR(20) NOT NULL, garantie_montant BIGINT NOT NULL, garantie_statut VARCHAR(30) NOT NULL, garantie_retenue BIGINT NOT NULL, garantie_motif VARCHAR(255) DEFAULT NULL, date_sortie DATE DEFAULT NULL, cloture_le DATETIME DEFAULT NULL, created_at DATETIME NOT NULL, unite_id INT NOT NULL, locataire_id INT NOT NULL, devise_id INT NOT NULL, cree_par_id INT NOT NULL, INDEX IDX_60349993E564F0BF (statut), INDEX IDX_60349993EC4A74AB (unite_id), INDEX IDX_60349993D8A38199 (locataire_id), INDEX IDX_60349993F4445056 (devise_id), INDEX IDX_60349993FC29C013 (cree_par_id), PRIMARY KEY (id)) DEFAULT CHARACTER SET utf8mb4');
        $this->addSql('CREATE TABLE declaration_paiement (id INT AUTO_INCREMENT NOT NULL, montant BIGINT NOT NULL, date_paiement DATE NOT NULL, reference VARCHAR(120) DEFAULT NULL, statut VARCHAR(20) NOT NULL, motif_refus VARCHAR(255) DEFAULT NULL, traite_le DATETIME DEFAULT NULL, derniere_relance_le DATETIME DEFAULT NULL, created_at DATETIME NOT NULL, contrat_id INT NOT NULL, declare_par_id INT NOT NULL, paiement_id INT DEFAULT NULL, traite_par_id INT DEFAULT NULL, UNIQUE INDEX UNIQ_420A99302A4C4478 (paiement_id), INDEX IDX_420A99301823061F (contrat_id), INDEX IDX_420A99308B43E2A (declare_par_id), INDEX IDX_420A9930167FABE8 (traite_par_id), PRIMARY KEY (id)) DEFAULT CHARACTER SET utf8mb4');
        $this->addSql('CREATE TABLE derogation_parametre (id INT AUTO_INCREMENT NOT NULL, cle VARCHAR(60) NOT NULL, valeur VARCHAR(60) NOT NULL, created_at DATETIME NOT NULL, user_id INT NOT NULL, UNIQUE INDEX unique_derogation (user_id, cle), INDEX IDX_5D8C1C23A76ED395 (user_id), PRIMARY KEY (id)) DEFAULT CHARACTER SET utf8mb4');
        $this->addSql('CREATE TABLE devise (id INT AUTO_INCREMENT NOT NULL, code VARCHAR(3) NOT NULL, nom VARCHAR(50) NOT NULL, symbole VARCHAR(10) NOT NULL, decimales SMALLINT NOT NULL, active TINYINT NOT NULL, UNIQUE INDEX UNIQ_43EDA4DF77153098 (code), PRIMARY KEY (id)) DEFAULT CHARACTER SET utf8mb4');
        $this->addSql('CREATE TABLE echeance (id INT AUTO_INCREMENT NOT NULL, periode_debut DATE NOT NULL, periode_fin DATE NOT NULL, date_exigible DATE NOT NULL, montant_du BIGINT NOT NULL, montant_paye BIGINT NOT NULL, annulee TINYINT NOT NULL, contrat_id INT NOT NULL, INDEX IDX_40D9893B1C9F6528 (date_exigible), UNIQUE INDEX unique_echeance_periode (contrat_id, periode_debut), INDEX IDX_40D9893B1823061F (contrat_id), PRIMARY KEY (id)) DEFAULT CHARACTER SET utf8mb4');
        $this->addSql('CREATE TABLE ecriture_wallet (id INT AUTO_INCREMENT NOT NULL, espace VARCHAR(20) NOT NULL, sens VARCHAR(10) NOT NULL, montant BIGINT NOT NULL, motif VARCHAR(40) NOT NULL, reference VARCHAR(120) DEFAULT NULL, cle_unique VARCHAR(120) DEFAULT NULL, commentaire VARCHAR(255) DEFAULT NULL, created_at DATETIME NOT NULL, user_id INT NOT NULL, cree_par_id INT DEFAULT NULL, UNIQUE INDEX UNIQ_39774DE82FFB65E0 (cle_unique), INDEX IDX_39774DE8A76ED3956AB096D (user_id, espace), INDEX IDX_39774DE8A76ED395 (user_id), INDEX IDX_39774DE8FC29C013 (cree_par_id), PRIMARY KEY (id)) DEFAULT CHARACTER SET utf8mb4');
        $this->addSql('CREATE TABLE espace_bailleur (id INT AUTO_INCREMENT NOT NULL, raison_sociale VARCHAR(160) DEFAULT NULL, numero_rccm VARCHAR(80) DEFAULT NULL, adresse VARCHAR(255) DEFAULT NULL, dernier_numero_recu INT NOT NULL, gratuite_utilisee TINYINT NOT NULL, badge VARCHAR(30) DEFAULT NULL, badge_le DATETIME DEFAULT NULL, badge_expire_le DATETIME DEFAULT NULL, created_at DATETIME NOT NULL, proprietaire_id INT NOT NULL, badge_attribue_par_id INT DEFAULT NULL, UNIQUE INDEX UNIQ_75ED7BC276C50E4A (proprietaire_id), INDEX IDX_75ED7BC28D26677C (badge_attribue_par_id), PRIMARY KEY (id)) DEFAULT CHARACTER SET utf8mb4');
        $this->addSql('CREATE TABLE imputation (id INT AUTO_INCREMENT NOT NULL, montant BIGINT NOT NULL, active TINYINT NOT NULL, created_at DATETIME NOT NULL, paiement_id INT NOT NULL, echeance_id INT NOT NULL, INDEX IDX_AE81A25A4B1EFC02 (active), INDEX IDX_AE81A25A2A4C4478 (paiement_id), INDEX IDX_AE81A25A5B318673 (echeance_id), PRIMARY KEY (id)) DEFAULT CHARACTER SET utf8mb4');
        $this->addSql('CREATE TABLE otp_code (id INT AUTO_INCREMENT NOT NULL, telephone_empreinte VARCHAR(64) NOT NULL, code_hash VARCHAR(255) NOT NULL, expire_le DATETIME NOT NULL, tentatives INT NOT NULL, utilise_le DATETIME DEFAULT NULL, jeton_inscription_hash VARCHAR(64) DEFAULT NULL, jeton_expire_le DATETIME DEFAULT NULL, created_at DATETIME NOT NULL, UNIQUE INDEX UNIQ_93FE2319541BFB20 (jeton_inscription_hash), INDEX IDX_93FE23191783D68 (telephone_empreinte), PRIMARY KEY (id)) DEFAULT CHARACTER SET utf8mb4');
        $this->addSql('CREATE TABLE paiement (id INT AUTO_INCREMENT NOT NULL, type VARCHAR(20) NOT NULL, montant BIGINT NOT NULL, date_paiement DATE NOT NULL, moyen VARCHAR(20) NOT NULL, reference VARCHAR(120) DEFAULT NULL, cle_idempotence VARCHAR(64) NOT NULL, imputation_manuelle TINYINT NOT NULL, statut VARCHAR(20) NOT NULL, motif_annulation VARCHAR(255) DEFAULT NULL, annule_le DATETIME DEFAULT NULL, created_at DATETIME NOT NULL, contrat_id INT NOT NULL, saisi_par_id INT NOT NULL, annule_par_id INT DEFAULT NULL, UNIQUE INDEX UNIQ_B1DC7A1EF525847C (cle_idempotence), INDEX IDX_B1DC7A1E72E913B8 (date_paiement), INDEX IDX_B1DC7A1E1823061F (contrat_id), INDEX IDX_B1DC7A1EB0F809FE (saisi_par_id), INDEX IDX_B1DC7A1EF376B95 (annule_par_id), PRIMARY KEY (id)) DEFAULT CHARACTER SET utf8mb4');
        $this->addSql('CREATE TABLE paiement_abonnement (id INT AUTO_INCREMENT NOT NULL, loyer_mensuel BIGINT NOT NULL, devise_code VARCHAR(3) NOT NULL, pourcentage VARCHAR(10) NOT NULL, montant_devise BIGINT NOT NULL, taux_usd VARCHAR(30) NOT NULL, montant_usd BIGINT NOT NULL, source VARCHAR(20) NOT NULL, reference_transaction VARCHAR(120) DEFAULT NULL, statut VARCHAR(20) NOT NULL, motif_rejet VARCHAR(255) DEFAULT NULL, periode_debut DATE DEFAULT NULL, periode_fin DATE DEFAULT NULL, traite_le DATETIME DEFAULT NULL, created_at DATETIME NOT NULL, unite_id INT NOT NULL, contrat_id INT NOT NULL, payeur_id INT NOT NULL, traite_par_id INT DEFAULT NULL, INDEX IDX_A3DD064BE564F0BF (statut), INDEX IDX_A3DD064BEC4A74AB (unite_id), INDEX IDX_A3DD064B1823061F (contrat_id), INDEX IDX_A3DD064B422667C5 (payeur_id), INDEX IDX_A3DD064B167FABE8 (traite_par_id), PRIMARY KEY (id)) DEFAULT CHARACTER SET utf8mb4');
        $this->addSql('CREATE TABLE parametre (id INT AUTO_INCREMENT NOT NULL, cle VARCHAR(60) NOT NULL, valeur VARCHAR(60) NOT NULL, depuis DATETIME NOT NULL, modifie_par_id INT DEFAULT NULL, INDEX IDX_ACC7904141401D173743EE9D (cle, depuis), INDEX IDX_ACC79041553B2554 (modifie_par_id), PRIMARY KEY (id)) DEFAULT CHARACTER SET utf8mb4');
        $this->addSql('CREATE TABLE pays (id INT AUTO_INCREMENT NOT NULL, nom VARCHAR(100) NOT NULL, code_iso VARCHAR(2) NOT NULL, code_iso3 VARCHAR(3) NOT NULL, indicatif VARCHAR(10) NOT NULL, drapeau VARCHAR(10) DEFAULT NULL, active TINYINT NOT NULL, devise_par_defaut_id INT DEFAULT NULL, UNIQUE INDEX UNIQ_349F3CAE897848EB (code_iso), UNIQUE INDEX UNIQ_349F3CAE5A83CD23 (code_iso3), INDEX IDX_349F3CAE1821AAC (devise_par_defaut_id), PRIMARY KEY (id)) DEFAULT CHARACTER SET utf8mb4');
        $this->addSql('CREATE TABLE propriete (id INT AUTO_INCREMENT NOT NULL, nom VARCHAR(120) NOT NULL, type VARCHAR(20) NOT NULL, adresse VARCHAR(255) DEFAULT NULL, quartier VARCHAR(120) DEFAULT NULL, latitude VARCHAR(255) DEFAULT NULL, longitude VARCHAR(255) DEFAULT NULL, created_at DATETIME NOT NULL, espace_id INT NOT NULL, ville_id INT DEFAULT NULL, pays_id INT NOT NULL, INDEX IDX_73A85B93B6885C6C (espace_id), INDEX IDX_73A85B93A73F0036 (ville_id), INDEX IDX_73A85B93A6E44244 (pays_id), PRIMARY KEY (id)) DEFAULT CHARACTER SET utf8mb4');
        $this->addSql('CREATE TABLE recu (id INT AUTO_INCREMENT NOT NULL, sequence INT NOT NULL, numero VARCHAR(30) NOT NULL, jeton VARCHAR(64) NOT NULL, annule TINYINT NOT NULL, emis_le DATETIME NOT NULL, paiement_id INT NOT NULL, espace_id INT NOT NULL, UNIQUE INDEX UNIQ_C0D103172CF647B (jeton), UNIQUE INDEX UNIQ_C0D103172A4C4478 (paiement_id), UNIQUE INDEX unique_recu_numero (espace_id, numero), INDEX IDX_C0D10317B6885C6C (espace_id), PRIMARY KEY (id)) DEFAULT CHARACTER SET utf8mb4');
        $this->addSql('CREATE TABLE refresh_tokens (refresh_token VARCHAR(128) NOT NULL, username VARCHAR(255) NOT NULL, valid DATETIME NOT NULL, id INT AUTO_INCREMENT NOT NULL, UNIQUE INDEX UNIQ_9BACE7E1C74F2195 (refresh_token), PRIMARY KEY (id)) DEFAULT CHARACTER SET utf8mb4');
        $this->addSql('CREATE TABLE taux_change (devise_code VARCHAR(3) NOT NULL, taux VARCHAR(30) NOT NULL, recupere_le DATETIME NOT NULL, PRIMARY KEY (devise_code)) DEFAULT CHARACTER SET utf8mb4');
        $this->addSql('CREATE TABLE trace_market (id INT AUTO_INCREMENT NOT NULL, action VARCHAR(20) NOT NULL, created_at DATETIME NOT NULL, user_id INT NOT NULL, unite_id INT DEFAULT NULL, propriete_id INT DEFAULT NULL, INDEX IDX_36E456108B8E8428 (created_at), INDEX IDX_36E45610A76ED395 (user_id), INDEX IDX_36E45610EC4A74AB (unite_id), INDEX IDX_36E4561018566CAF (propriete_id), PRIMARY KEY (id)) DEFAULT CHARACTER SET utf8mb4');
        $this->addSql('CREATE TABLE unite (id INT AUTO_INCREMENT NOT NULL, nom VARCHAR(120) NOT NULL, loyer_indicatif BIGINT DEFAULT NULL, publiee_market TINYINT NOT NULL, description_market VARCHAR(500) DEFAULT NULL, publiee_le DATETIME DEFAULT NULL, abonnement_fin DATE DEFAULT NULL, gratuite_jusqu_au DATE DEFAULT NULL, created_at DATETIME NOT NULL, propriete_id INT NOT NULL, categorie_id INT NOT NULL, devise_indicative_id INT DEFAULT NULL, INDEX IDX_1D64C11818566CAF (propriete_id), INDEX IDX_1D64C118BCF5E72D (categorie_id), INDEX IDX_1D64C1183016F38B (devise_indicative_id), PRIMARY KEY (id)) DEFAULT CHARACTER SET utf8mb4');
        $this->addSql('CREATE TABLE `user` (id INT AUTO_INCREMENT NOT NULL, telephone VARCHAR(255) DEFAULT NULL, telephone_empreinte VARCHAR(64) DEFAULT NULL, nom VARCHAR(120) NOT NULL, email VARCHAR(180) DEFAULT NULL, mode_prefere VARCHAR(20) DEFAULT NULL, code_parrainage VARCHAR(12) NOT NULL, roles JSON NOT NULL, actif TINYINT NOT NULL, created_at DATETIME NOT NULL, anonymise_le DATETIME DEFAULT NULL, pays_id INT DEFAULT NULL, ville_id INT DEFAULT NULL, parrain_id INT DEFAULT NULL, UNIQUE INDEX UNIQ_8D93D6491783D68 (telephone_empreinte), UNIQUE INDEX UNIQ_8D93D64931F55253 (code_parrainage), INDEX IDX_8D93D649A6E44244 (pays_id), INDEX IDX_8D93D649A73F0036 (ville_id), INDEX IDX_8D93D649DE2A7A37 (parrain_id), PRIMARY KEY (id)) DEFAULT CHARACTER SET utf8mb4');
        $this->addSql('CREATE TABLE villes (id INT AUTO_INCREMENT NOT NULL, nom VARCHAR(150) NOT NULL, active TINYINT NOT NULL, pays_id INT NOT NULL, UNIQUE INDEX unique_ville_pays (pays_id, nom), INDEX IDX_19209FD8A6E44244 (pays_id), PRIMARY KEY (id)) DEFAULT CHARACTER SET utf8mb4');
        $this->addSql('ALTER TABLE activite ADD CONSTRAINT FK_B8755515DA6F574A FOREIGN KEY (acteur_id) REFERENCES `user` (id)');
        $this->addSql('ALTER TABLE activite ADD CONSTRAINT FK_B8755515B6885C6C FOREIGN KEY (espace_id) REFERENCES espace_bailleur (id)');
        $this->addSql('ALTER TABLE activite ADD CONSTRAINT FK_B87555151823061F FOREIGN KEY (contrat_id) REFERENCES contrat (id)');
        $this->addSql('ALTER TABLE activite ADD CONSTRAINT FK_B8755515A4F84F6E FOREIGN KEY (destinataire_id) REFERENCES `user` (id)');
        $this->addSql('ALTER TABLE contact ADD CONSTRAINT FK_4C62E638B6885C6C FOREIGN KEY (espace_id) REFERENCES espace_bailleur (id)');
        $this->addSql('ALTER TABLE contact ADD CONSTRAINT FK_4C62E638FB88E14F FOREIGN KEY (utilisateur_id) REFERENCES `user` (id)');
        $this->addSql('ALTER TABLE contrat ADD CONSTRAINT FK_60349993EC4A74AB FOREIGN KEY (unite_id) REFERENCES unite (id)');
        $this->addSql('ALTER TABLE contrat ADD CONSTRAINT FK_60349993D8A38199 FOREIGN KEY (locataire_id) REFERENCES contact (id)');
        $this->addSql('ALTER TABLE contrat ADD CONSTRAINT FK_60349993F4445056 FOREIGN KEY (devise_id) REFERENCES devise (id)');
        $this->addSql('ALTER TABLE contrat ADD CONSTRAINT FK_60349993FC29C013 FOREIGN KEY (cree_par_id) REFERENCES `user` (id)');
        $this->addSql('ALTER TABLE declaration_paiement ADD CONSTRAINT FK_420A99301823061F FOREIGN KEY (contrat_id) REFERENCES contrat (id)');
        $this->addSql('ALTER TABLE declaration_paiement ADD CONSTRAINT FK_420A99308B43E2A FOREIGN KEY (declare_par_id) REFERENCES `user` (id)');
        $this->addSql('ALTER TABLE declaration_paiement ADD CONSTRAINT FK_420A99302A4C4478 FOREIGN KEY (paiement_id) REFERENCES paiement (id)');
        $this->addSql('ALTER TABLE declaration_paiement ADD CONSTRAINT FK_420A9930167FABE8 FOREIGN KEY (traite_par_id) REFERENCES `user` (id)');
        $this->addSql('ALTER TABLE derogation_parametre ADD CONSTRAINT FK_5D8C1C23A76ED395 FOREIGN KEY (user_id) REFERENCES `user` (id)');
        $this->addSql('ALTER TABLE echeance ADD CONSTRAINT FK_40D9893B1823061F FOREIGN KEY (contrat_id) REFERENCES contrat (id)');
        $this->addSql('ALTER TABLE ecriture_wallet ADD CONSTRAINT FK_39774DE8A76ED395 FOREIGN KEY (user_id) REFERENCES `user` (id)');
        $this->addSql('ALTER TABLE ecriture_wallet ADD CONSTRAINT FK_39774DE8FC29C013 FOREIGN KEY (cree_par_id) REFERENCES `user` (id)');
        $this->addSql('ALTER TABLE espace_bailleur ADD CONSTRAINT FK_75ED7BC276C50E4A FOREIGN KEY (proprietaire_id) REFERENCES `user` (id)');
        $this->addSql('ALTER TABLE espace_bailleur ADD CONSTRAINT FK_75ED7BC28D26677C FOREIGN KEY (badge_attribue_par_id) REFERENCES `user` (id)');
        $this->addSql('ALTER TABLE imputation ADD CONSTRAINT FK_AE81A25A2A4C4478 FOREIGN KEY (paiement_id) REFERENCES paiement (id)');
        $this->addSql('ALTER TABLE imputation ADD CONSTRAINT FK_AE81A25A5B318673 FOREIGN KEY (echeance_id) REFERENCES echeance (id)');
        $this->addSql('ALTER TABLE paiement ADD CONSTRAINT FK_B1DC7A1E1823061F FOREIGN KEY (contrat_id) REFERENCES contrat (id)');
        $this->addSql('ALTER TABLE paiement ADD CONSTRAINT FK_B1DC7A1EB0F809FE FOREIGN KEY (saisi_par_id) REFERENCES `user` (id)');
        $this->addSql('ALTER TABLE paiement ADD CONSTRAINT FK_B1DC7A1EF376B95 FOREIGN KEY (annule_par_id) REFERENCES `user` (id)');
        $this->addSql('ALTER TABLE paiement_abonnement ADD CONSTRAINT FK_A3DD064BEC4A74AB FOREIGN KEY (unite_id) REFERENCES unite (id)');
        $this->addSql('ALTER TABLE paiement_abonnement ADD CONSTRAINT FK_A3DD064B1823061F FOREIGN KEY (contrat_id) REFERENCES contrat (id)');
        $this->addSql('ALTER TABLE paiement_abonnement ADD CONSTRAINT FK_A3DD064B422667C5 FOREIGN KEY (payeur_id) REFERENCES `user` (id)');
        $this->addSql('ALTER TABLE paiement_abonnement ADD CONSTRAINT FK_A3DD064B167FABE8 FOREIGN KEY (traite_par_id) REFERENCES `user` (id)');
        $this->addSql('ALTER TABLE parametre ADD CONSTRAINT FK_ACC79041553B2554 FOREIGN KEY (modifie_par_id) REFERENCES `user` (id)');
        $this->addSql('ALTER TABLE pays ADD CONSTRAINT FK_349F3CAE1821AAC FOREIGN KEY (devise_par_defaut_id) REFERENCES devise (id)');
        $this->addSql('ALTER TABLE propriete ADD CONSTRAINT FK_73A85B93B6885C6C FOREIGN KEY (espace_id) REFERENCES espace_bailleur (id)');
        $this->addSql('ALTER TABLE propriete ADD CONSTRAINT FK_73A85B93A73F0036 FOREIGN KEY (ville_id) REFERENCES villes (id)');
        $this->addSql('ALTER TABLE propriete ADD CONSTRAINT FK_73A85B93A6E44244 FOREIGN KEY (pays_id) REFERENCES pays (id)');
        $this->addSql('ALTER TABLE recu ADD CONSTRAINT FK_C0D103172A4C4478 FOREIGN KEY (paiement_id) REFERENCES paiement (id)');
        $this->addSql('ALTER TABLE recu ADD CONSTRAINT FK_C0D10317B6885C6C FOREIGN KEY (espace_id) REFERENCES espace_bailleur (id)');
        $this->addSql('ALTER TABLE trace_market ADD CONSTRAINT FK_36E45610A76ED395 FOREIGN KEY (user_id) REFERENCES `user` (id)');
        $this->addSql('ALTER TABLE trace_market ADD CONSTRAINT FK_36E45610EC4A74AB FOREIGN KEY (unite_id) REFERENCES unite (id)');
        $this->addSql('ALTER TABLE trace_market ADD CONSTRAINT FK_36E4561018566CAF FOREIGN KEY (propriete_id) REFERENCES propriete (id)');
        $this->addSql('ALTER TABLE unite ADD CONSTRAINT FK_1D64C11818566CAF FOREIGN KEY (propriete_id) REFERENCES propriete (id)');
        $this->addSql('ALTER TABLE unite ADD CONSTRAINT FK_1D64C118BCF5E72D FOREIGN KEY (categorie_id) REFERENCES categorie_unite (id)');
        $this->addSql('ALTER TABLE unite ADD CONSTRAINT FK_1D64C1183016F38B FOREIGN KEY (devise_indicative_id) REFERENCES devise (id)');
        $this->addSql('ALTER TABLE `user` ADD CONSTRAINT FK_8D93D649A6E44244 FOREIGN KEY (pays_id) REFERENCES pays (id)');
        $this->addSql('ALTER TABLE `user` ADD CONSTRAINT FK_8D93D649A73F0036 FOREIGN KEY (ville_id) REFERENCES villes (id)');
        $this->addSql('ALTER TABLE `user` ADD CONSTRAINT FK_8D93D649DE2A7A37 FOREIGN KEY (parrain_id) REFERENCES `user` (id)');
        $this->addSql('ALTER TABLE villes ADD CONSTRAINT FK_19209FD8A6E44244 FOREIGN KEY (pays_id) REFERENCES pays (id)');
    }

    public function down(Schema $schema): void
    {
        // this down() migration is auto-generated, please modify it to your needs
        $this->addSql('ALTER TABLE activite DROP FOREIGN KEY FK_B8755515DA6F574A');
        $this->addSql('ALTER TABLE activite DROP FOREIGN KEY FK_B8755515B6885C6C');
        $this->addSql('ALTER TABLE activite DROP FOREIGN KEY FK_B87555151823061F');
        $this->addSql('ALTER TABLE activite DROP FOREIGN KEY FK_B8755515A4F84F6E');
        $this->addSql('ALTER TABLE contact DROP FOREIGN KEY FK_4C62E638B6885C6C');
        $this->addSql('ALTER TABLE contact DROP FOREIGN KEY FK_4C62E638FB88E14F');
        $this->addSql('ALTER TABLE contrat DROP FOREIGN KEY FK_60349993EC4A74AB');
        $this->addSql('ALTER TABLE contrat DROP FOREIGN KEY FK_60349993D8A38199');
        $this->addSql('ALTER TABLE contrat DROP FOREIGN KEY FK_60349993F4445056');
        $this->addSql('ALTER TABLE contrat DROP FOREIGN KEY FK_60349993FC29C013');
        $this->addSql('ALTER TABLE declaration_paiement DROP FOREIGN KEY FK_420A99301823061F');
        $this->addSql('ALTER TABLE declaration_paiement DROP FOREIGN KEY FK_420A99308B43E2A');
        $this->addSql('ALTER TABLE declaration_paiement DROP FOREIGN KEY FK_420A99302A4C4478');
        $this->addSql('ALTER TABLE declaration_paiement DROP FOREIGN KEY FK_420A9930167FABE8');
        $this->addSql('ALTER TABLE derogation_parametre DROP FOREIGN KEY FK_5D8C1C23A76ED395');
        $this->addSql('ALTER TABLE echeance DROP FOREIGN KEY FK_40D9893B1823061F');
        $this->addSql('ALTER TABLE ecriture_wallet DROP FOREIGN KEY FK_39774DE8A76ED395');
        $this->addSql('ALTER TABLE ecriture_wallet DROP FOREIGN KEY FK_39774DE8FC29C013');
        $this->addSql('ALTER TABLE espace_bailleur DROP FOREIGN KEY FK_75ED7BC276C50E4A');
        $this->addSql('ALTER TABLE espace_bailleur DROP FOREIGN KEY FK_75ED7BC28D26677C');
        $this->addSql('ALTER TABLE imputation DROP FOREIGN KEY FK_AE81A25A2A4C4478');
        $this->addSql('ALTER TABLE imputation DROP FOREIGN KEY FK_AE81A25A5B318673');
        $this->addSql('ALTER TABLE paiement DROP FOREIGN KEY FK_B1DC7A1E1823061F');
        $this->addSql('ALTER TABLE paiement DROP FOREIGN KEY FK_B1DC7A1EB0F809FE');
        $this->addSql('ALTER TABLE paiement DROP FOREIGN KEY FK_B1DC7A1EF376B95');
        $this->addSql('ALTER TABLE paiement_abonnement DROP FOREIGN KEY FK_A3DD064BEC4A74AB');
        $this->addSql('ALTER TABLE paiement_abonnement DROP FOREIGN KEY FK_A3DD064B1823061F');
        $this->addSql('ALTER TABLE paiement_abonnement DROP FOREIGN KEY FK_A3DD064B422667C5');
        $this->addSql('ALTER TABLE paiement_abonnement DROP FOREIGN KEY FK_A3DD064B167FABE8');
        $this->addSql('ALTER TABLE parametre DROP FOREIGN KEY FK_ACC79041553B2554');
        $this->addSql('ALTER TABLE pays DROP FOREIGN KEY FK_349F3CAE1821AAC');
        $this->addSql('ALTER TABLE propriete DROP FOREIGN KEY FK_73A85B93B6885C6C');
        $this->addSql('ALTER TABLE propriete DROP FOREIGN KEY FK_73A85B93A73F0036');
        $this->addSql('ALTER TABLE propriete DROP FOREIGN KEY FK_73A85B93A6E44244');
        $this->addSql('ALTER TABLE recu DROP FOREIGN KEY FK_C0D103172A4C4478');
        $this->addSql('ALTER TABLE recu DROP FOREIGN KEY FK_C0D10317B6885C6C');
        $this->addSql('ALTER TABLE trace_market DROP FOREIGN KEY FK_36E45610A76ED395');
        $this->addSql('ALTER TABLE trace_market DROP FOREIGN KEY FK_36E45610EC4A74AB');
        $this->addSql('ALTER TABLE trace_market DROP FOREIGN KEY FK_36E4561018566CAF');
        $this->addSql('ALTER TABLE unite DROP FOREIGN KEY FK_1D64C11818566CAF');
        $this->addSql('ALTER TABLE unite DROP FOREIGN KEY FK_1D64C118BCF5E72D');
        $this->addSql('ALTER TABLE unite DROP FOREIGN KEY FK_1D64C1183016F38B');
        $this->addSql('ALTER TABLE `user` DROP FOREIGN KEY FK_8D93D649A6E44244');
        $this->addSql('ALTER TABLE `user` DROP FOREIGN KEY FK_8D93D649A73F0036');
        $this->addSql('ALTER TABLE `user` DROP FOREIGN KEY FK_8D93D649DE2A7A37');
        $this->addSql('ALTER TABLE villes DROP FOREIGN KEY FK_19209FD8A6E44244');
        $this->addSql('DROP TABLE activite');
        $this->addSql('DROP TABLE categorie_unite');
        $this->addSql('DROP TABLE contact');
        $this->addSql('DROP TABLE contrat');
        $this->addSql('DROP TABLE declaration_paiement');
        $this->addSql('DROP TABLE derogation_parametre');
        $this->addSql('DROP TABLE devise');
        $this->addSql('DROP TABLE echeance');
        $this->addSql('DROP TABLE ecriture_wallet');
        $this->addSql('DROP TABLE espace_bailleur');
        $this->addSql('DROP TABLE imputation');
        $this->addSql('DROP TABLE otp_code');
        $this->addSql('DROP TABLE paiement');
        $this->addSql('DROP TABLE paiement_abonnement');
        $this->addSql('DROP TABLE parametre');
        $this->addSql('DROP TABLE pays');
        $this->addSql('DROP TABLE propriete');
        $this->addSql('DROP TABLE recu');
        $this->addSql('DROP TABLE refresh_tokens');
        $this->addSql('DROP TABLE taux_change');
        $this->addSql('DROP TABLE trace_market');
        $this->addSql('DROP TABLE unite');
        $this->addSql('DROP TABLE `user`');
        $this->addSql('DROP TABLE villes');
    }
}
