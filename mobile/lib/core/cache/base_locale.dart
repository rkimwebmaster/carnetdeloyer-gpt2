import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'base_locale.g.dart';

@DataClassName('ReponseEnCache')
/// R-80 : réponses de l'API mises en cache pour la consultation hors ligne
/// (propriétés, unités, contrats, échéances, soldes). Jamais les photos (R-85).
class CacheReponses extends Table {
  TextColumn get cle => text()();
  IntColumn get utilisateurId => integer()();
  TextColumn get json => text()();
  DateTimeColumn get majLe => dateTime()();

  @override
  Set<Column> get primaryKey => {cle, utilisateurId};
}

/// R-136 : file (outbox) des paiements saisis hors ligne.
@DataClassName('PaiementEnAttente')
/// États : en_attente, envoye, rejete (avec motif).
class PaiementsEnAttente extends Table {
  /// UUID généré sur le téléphone, envoyé comme clé d'idempotence (R-137).
  TextColumn get id => text()();

  /// R-139 : la file est liée à l'utilisateur.
  IntColumn get utilisateurId => integer()();
  IntColumn get contratId => integer()();
  IntColumn get montant => integer()();
  TextColumn get devise => text()();
  TextColumn get datePaiement => text()();
  TextColumn get moyen => text()();
  TextColumn get reference => text().nullable()();
  TextColumn get libelle => text()();
  TextColumn get etat => text().withDefault(const Constant('en_attente'))();
  TextColumn get codeRejet => text().nullable()();
  TextColumn get motifRejet => text().nullable()();
  TextColumn get recuNumero => text().nullable()();
  DateTimeColumn get creeLe => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [CacheReponses, PaiementsEnAttente])
class BaseLocale extends _$BaseLocale {
  BaseLocale([QueryExecutor? executeur]) : super(executeur ?? driftDatabase(name: 'carnetdeloyer'));

  @override
  int get schemaVersion => 1;

  // --- Cache ---------------------------------------------------------------

  Future<void> mettreEnCache(int utilisateurId, String cle, Object? donnees) => into(cacheReponses).insertOnConflictUpdate(
        CacheReponsesCompanion.insert(cle: cle, utilisateurId: utilisateurId, json: jsonEncode(donnees), majLe: DateTime.now()),
      );

  Future<dynamic> lireCache(int utilisateurId, String cle) async {
    final ligne = await (select(cacheReponses)..where((c) => c.cle.equals(cle) & c.utilisateurId.equals(utilisateurId))).getSingleOrNull();
    return ligne == null ? null : jsonDecode(ligne.json);
  }

  // --- File d'attente des paiements ----------------------------------------

  Future<void> ajouterPaiement(PaiementsEnAttenteCompanion paiement) => into(paiementsEnAttente).insert(paiement);

  /// Paiements de l'utilisateur pas encore confirmés par le serveur.
  Stream<List<PaiementEnAttente>> observerFile(int utilisateurId) => (select(paiementsEnAttente)
        ..where((p) => p.utilisateurId.equals(utilisateurId) & p.etat.isNotIn(['envoye']))
        ..orderBy([(p) => OrderingTerm.asc(p.creeLe)]))
      .watch();

  Future<List<PaiementEnAttente>> aEnvoyer(int utilisateurId) => (select(paiementsEnAttente)
        ..where((p) => p.utilisateurId.equals(utilisateurId) & p.etat.equals('en_attente'))
        ..orderBy([(p) => OrderingTerm.asc(p.creeLe)]))
      .get();

  Future<void> marquerEnvoye(String id, String? recuNumero) =>
      (update(paiementsEnAttente)..where((p) => p.id.equals(id))).write(PaiementsEnAttenteCompanion(etat: const Value('envoye'), recuNumero: Value(recuNumero)));

  Future<void> marquerRejete(String id, String code, String motif) => (update(paiementsEnAttente)..where((p) => p.id.equals(id)))
      .write(PaiementsEnAttenteCompanion(etat: const Value('rejete'), codeRejet: Value(code), motifRejet: Value(motif)));

  /// R-36 : un paiement pas encore synchronisé peut être supprimé librement.
  Future<int> supprimerNonSynchronise(String id, int utilisateurId) =>
      (delete(paiementsEnAttente)..where((p) => p.id.equals(id) & p.utilisateurId.equals(utilisateurId) & p.etat.isNotIn(['envoye']))).go();
}
