import 'package:carnetdeloyer/features/paiements/screens/ecran_encaisser.dart';
import 'package:carnetdeloyer/features/paiements/screens/ecran_paiements.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../outils.dart';
import 'harnais.dart';

Map<String, dynamic> encaissement({int propose = 30000, int restant = 390000, int mois = 13}) => {
      'contratId': 7,
      'devise': {'code': 'USD', 'nom': 'Dollar', 'symbole': r'$', 'decimales': 2, 'active': true},
      'loyer': 30000,
      'prochaineEcheance': {'id': 1, 'periodeDebut': '2026-10-01', 'periodeFin': '2026-10-31', 'dateExigible': '2026-10-01', 'montantDu': 30000, 'montantPaye': 30000 - propose, 'restantDu': propose, 'statut': 'en_retard'},
      'montantPropose': propose,
      'restantDu': restant,
      'moisMaximum': mois,
      'garantieAttendue': null,
    };

void main() {
  testWidgets('R-24, R-25 : montant pré-rempli, aperçu loyer × mois, plafonné au restant dû', (tester) async {
    final envoyes = <Map<String, dynamic>>[];
    final h = Harnais(FauxServeur((o, corps) async {
      if (o.path == '/contrats/7/encaissement') return (200, encaissement(propose: 10000, restant: 70000, mois: 3));
      if (o.path == '/contrats/7/paiements') {
        envoyes.add(corps!);
        return (201, paiementJson(montant: corps['montant'] as int, cle: corps['cleIdempotence'] as String));
      }
      return (404, {'code': 'INTROUVABLE', 'message': '', 'erreurs': {}});
    }), coffre: await coffreConnecte());
    await h.monter(tester, const EcranEncaisser(contratId: 7));

    Text total() => tester.widget<Text>(find.byKey(const Key('totalEncaisser')));
    // Restant de l'échéance partiellement payée : 100 $.
    expect(total().data, contains('100,00'));
    await tester.tap(find.byKey(const Key('plusMois')));
    await tester.pump();
    expect(total().data, contains('400,00'));
    await tester.tap(find.byKey(const Key('plusMois')));
    await tester.pump();
    // 100 + 300 + 300 = 700 = restant dû : le bouton + se désactive.
    expect(total().data, contains('700,00'));
    expect(tester.widget<IconButton>(find.byKey(const Key('plusMois'))).onPressed, isNull);

    await tester.tap(find.byKey(const Key('validerEncaissement')));
    await Harnais.stabiliser(tester);
    expect(envoyes.single['montant'], 70000);
    expect(envoyes.single['cleIdempotence'], matches(RegExp(r'^[0-9a-f-]{36}$')));
    expect(find.textContaining('CDL-2026-000001'), findsOneWidget);
    await h.terminer(tester);
  });

  testWidgets('R-26 : paiement partiel saisi à la main', (tester) async {
    final envoyes = <Map<String, dynamic>>[];
    final h = Harnais(FauxServeur((o, corps) async {
      if (o.path == '/contrats/7/encaissement') return (200, encaissement());
      envoyes.add(corps!);
      return (201, paiementJson(montant: corps['montant'] as int, cle: corps['cleIdempotence'] as String));
    }), coffre: await coffreConnecte());
    await h.monter(tester, const EcranEncaisser(contratId: 7));

    await tester.tap(find.text('Paiement partiel'));
    await tester.pump();
    await tester.enterText(find.byKey(const Key('champMontantPartiel')), '125,50');
    await tester.pump();
    await tester.tap(find.byKey(const Key('validerEncaissement')));
    await Harnais.stabiliser(tester);
    expect(envoyes.single['montant'], 12550);
    await h.terminer(tester);
  });

  testWidgets('R-136 : hors ligne, le paiement part en file et apparaît comme reçu provisoire', (tester) async {
    var reseau = true;
    final h = Harnais(FauxServeur((o, corps) async {
      if (o.path == '/contrats/7/encaissement') return (200, encaissement());
      if (!reseau) couperReseau(o);
      if (o.path == '/paiements') return (200, {'elements': [], 'page': 1, 'parPage': 30, 'total': 0});
      if (o.path == '/declarations') return (200, {'elements': [], 'page': 1, 'parPage': 20, 'total': 0});
      return (404, {'code': 'INTROUVABLE', 'message': '', 'erreurs': {}});
    }), coffre: await coffreConnecte());
    await h.monter(tester, const EcranEncaisser(contratId: 7));

    reseau = false;
    await tester.tap(find.byKey(const Key('validerEncaissement')));
    await Harnais.stabiliser(tester);
    expect(find.text('Hors ligne : paiement mis en file d\'attente.'), findsOneWidget);

    await h.monter(tester, const EcranPaiements());
    expect(find.text('En attente de synchronisation'), findsOneWidget);
    expect(find.textContaining('REÇU PROVISOIRE'), findsOneWidget);
    await h.terminer(tester);
  });

  testWidgets('erreur métier traduite (R-150)', (tester) async {
    final h = Harnais(FauxServeur((o, corps) async {
      if (o.path == '/contrats/7/encaissement') return (200, encaissement());
      return (403, {'code': 'UNITE_SUSPENDUE', 'message': 'technique', 'erreurs': {}});
    }), coffre: await coffreConnecte());
    await h.monter(tester, const EcranEncaisser(contratId: 7));
    await tester.tap(find.byKey(const Key('validerEncaissement')));
    await Harnais.stabiliser(tester);
    expect(find.text('Abonnement expiré : renouvelez-le pour enregistrer des paiements.'), findsOneWidget);
    await h.terminer(tester);
  });
}
