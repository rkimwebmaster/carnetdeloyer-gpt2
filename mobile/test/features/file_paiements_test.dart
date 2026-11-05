import 'package:carnetdeloyer/core/api/client_api.dart';
import 'package:carnetdeloyer/core/cache/base_locale.dart';
import 'package:carnetdeloyer/core/erreurs/erreur_app.dart';
import 'package:carnetdeloyer/core/session/coffre.dart';
import 'package:carnetdeloyer/features/paiements/services/file_paiements.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import '../outils.dart';

SaisiePaiement saisie({int contratId = 7, int montant = 30000}) => SaisiePaiement(
      contratId: contratId,
      montant: montant,
      devise: 'USD',
      datePaiement: '2026-10-27',
      moyen: 'especes',
      libelle: 'Studio 4 · Jean',
    );

void main() {
  late BaseLocale base;
  late StockageSession stockage;
  var reseau = true;
  final recues = <String, Map<String, dynamic>>{};
  final cles = <String>[];

  /// Faux serveur idempotent (comme l'API : même clé => même paiement, 200).
  FauxServeur serveur() => FauxServeur((o, corps) async {
        if (!reseau) couperReseau(o);
        final cle = corps!['cleIdempotence'] as String;
        cles.add(cle);
        if (corps['montant'] == 999) return (422, {'code': 'PAIEMENT_SUPERIEUR_AU_DU', 'message': 'trop', 'erreurs': {'montant': ['trop']}});
        if (o.path.contains('/contrats/66/')) return (409, {'code': 'CONTRAT_CLOTURE', 'message': 'clôturé', 'erreurs': {}});
        if (recues.containsKey(cle)) return (200, recues[cle]);
        final p = paiementJson(id: recues.length + 1, cle: cle, montant: corps['montant'] as int, numero: 'CDL-2026-${(recues.length + 1).toString().padLeft(6, '0')}');
        recues[cle] = p;
        return (201, p);
      });

  FilePaiements file(int utilisateur) => FilePaiements(
        api: ClientApi(stockage: stockage, urlBase: 'http://t', adaptateur: serveur()),
        base: base,
        utilisateurId: utilisateur,
      );

  setUp(() async {
    base = BaseLocale(NativeDatabase.memory());
    stockage = StockageSession(CoffreMemoire());
    await stockage.enregistrerJetons(Jetons(fauxJwt(1), 'r'));
    reseau = true;
    recues.clear();
    cles.clear();
  });

  tearDown(() => base.close());

  test('en ligne : paiement confirmé avec son reçu, file vide', () async {
    final r = await file(1).encaisser(saisie());
    expect(r, isA<PaiementConfirme>());
    expect((r as PaiementConfirme).paiement.recu!.numero, 'CDL-2026-000001');
    expect(await file(1).observer().first, isEmpty);
  });

  test('R-136 : hors ligne => en file avec reçu provisoire, puis envoyé au retour du réseau', () async {
    reseau = false;
    final f = file(1);
    final r = await f.encaisser(saisie());
    expect(r, isA<PaiementEnFile>());
    final enAttente = await f.observer().first;
    expect(enAttente.single.etat, 'en_attente');
    expect(enAttente.single.id, (r as PaiementEnFile).id);

    reseau = true;
    expect(await f.synchroniser(), 1);
    expect(await f.observer().first, isEmpty);
    expect(recues.keys.single, r.id, reason: 'R-137 : la clé envoyée est l\'UUID créé à la saisie');
  });

  test('R-137 : renvoi après réponse perdue => aucun doublon', () async {
    final f = file(1);
    reseau = false;
    await f.encaisser(saisie());
    reseau = true;
    await f.synchroniser();
    // Simule une réponse perdue : la ligne repasse "en attente" et est renvoyée.
    await base.customStatement("UPDATE paiements_en_attente SET etat = 'en_attente'");
    await f.synchroniser();
    expect(cles.length, 2);
    expect(cles.toSet().length, 1);
    expect(recues.length, 1, reason: 'le serveur a reconnu la clé');
  });

  test('ordre de saisie conservé ; un rejet métier n\'arrête pas la file', () async {
    final f = file(1);
    reseau = false;
    await f.encaisser(saisie(montant: 100));
    await f.encaisser(saisie(contratId: 66, montant: 200));
    await f.encaisser(saisie(montant: 300));
    reseau = true;

    expect(await f.synchroniser(), 2);
    expect(recues.values.map((p) => p['montant']), [100, 300]);
    final restants = await f.observer().first;
    expect(restants.single.etat, 'rejete');
    expect(restants.single.codeRejet, 'CONTRAT_CLOTURE');

    // R-36 : le bailleur peut supprimer un paiement non synchronisé.
    await f.supprimer(restants.single.id);
    expect(await f.observer().first, isEmpty);
  });

  test('coupure au milieu de la file : les suivants attendent', () async {
    final f = file(1);
    reseau = false;
    await f.encaisser(saisie(montant: 100));
    await f.encaisser(saisie(montant: 200));
    expect(await f.synchroniser(), 0);
    expect((await f.observer().first).length, 2);
  });

  test('rejet immédiat en ligne : erreur affichée, rien ne reste en file', () async {
    final f = file(1);
    await expectLater(f.encaisser(saisie(montant: 999)), throwsA(isA<ErreurMetier>().having((e) => e.code, 'code', 'PAIEMENT_SUPERIEUR_AU_DU')));
    expect(await f.observer().first, isEmpty);
  });

  test('R-139 : la file d\'un utilisateur n\'est jamais envoyée sous un autre compte', () async {
    reseau = false;
    await file(1).encaisser(saisie());
    reseau = true;
    expect(await file(2).synchroniser(), 0);
    expect(recues, isEmpty);
    expect(await file(2).observer().first, isEmpty);
    expect((await file(1).observer().first).length, 1);
  });

  test('deux synchronisations simultanées partagent le même envoi', () async {
    final f = file(1);
    reseau = false;
    await f.encaisser(saisie());
    reseau = true;
    final r = await Future.wait([f.synchroniser(), f.synchroniser()]);
    expect(r, [1, 1]);
    expect(cles.length, 1, reason: 'un seul envoi réseau pour deux demandes');
  });
}
