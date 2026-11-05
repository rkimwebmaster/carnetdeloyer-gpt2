import 'package:carnetdeloyer/features/locations/screens/ecran_locations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../outils.dart';
import 'harnais.dart';

void main() {
  testWidgets('R-72 : confirmer une unité ne confirme pas les autres contrats du même contact', (tester) async {
    final restants = [1, 2];
    final serveur = FauxServeur((o, corps) async {
      if (o.path == '/locataire/rattachements') {
        return (200, [
          {'contactId': 7, 'bailleur': 'Bailleur', 'contrats': [for (final id in restants) {'id': id, 'unite': 'Unité $id', 'propriete': 'Immeuble'}]},
        ]);
      }
      if (o.path == '/locataire/contrats') return (200, {'elements': [], 'total': 0});
      if (o.path == '/locataire/contrats/1/confirmation') {
        restants.remove(1);
        return (200, {'confirme': true});
      }
      return (404, {'code': 'INTROUVABLE'});
    });
    final h = Harnais(serveur);
    await h.monter(tester, const EcranLocations());
    expect(find.byKey(const ValueKey('rattachement-1')), findsOneWidget);
    expect(find.byKey(const ValueKey('rattachement-2')), findsOneWidget);
    await tester.tap(find.descendant(of: find.byKey(const ValueKey('rattachement-1')), matching: find.text('Confirmer ce contrat')));
    await Harnais.stabiliser(tester);
    expect(find.byKey(const ValueKey('rattachement-1')), findsNothing);
    expect(find.byKey(const ValueKey('rattachement-2')), findsOneWidget);
    expect(serveur.requetes.where((r) => r.method == 'POST').map((r) => r.path), ['/locataire/contrats/1/confirmation']);
    expect(tester.takeException(), isNull);
    await h.terminer(tester);
  });

  testWidgets('R-182 : refus explicite et nettoyage du cache du locataire uniquement', (tester) async {
    var refuse = false;
    final serveur = FauxServeur((o, corps) async {
      if (o.path == '/locataire/rattachements') {
        return (200, refuse ? [] : [
          {'contactId': 7, 'bailleur': 'Bailleur', 'contrats': [{'id': 1, 'unite': 'U1', 'propriete': 'Immeuble'}]},
        ]);
      }
      if (o.path == '/locataire/contrats') return (200, {'elements': [], 'total': 0});
      if (o.path == '/locataire/contrats/1/refus') {
        refuse = true;
        return (200, {'refuse': true});
      }
      return (404, {'code': 'INTROUVABLE'});
    });
    final h = Harnais(serveur);
    await h.monter(tester, const EcranLocations());
    await tester.runAsync(() async {
      await h.base.mettreEnCache(0, '/locataire/contrats/1', {'id': 1});
      await h.base.mettreEnCache(0, '/proprietes', {'aConserver': true});
      await h.base.mettreEnCache(99, '/locataire/contrats/1', {'autreCompte': true});
    });
    await tester.tap(find.text('Ne me concerne pas'));
    await tester.pumpAndSettle();
    expect(refuse, isFalse);
    await tester.tap(find.text('Fermer'));
    await tester.pumpAndSettle();
    expect(refuse, isFalse);
    await tester.tap(find.text('Ne me concerne pas'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Ne me concerne pas'));
    await Harnais.stabiliser(tester);
    expect(refuse, isTrue);
    await tester.runAsync(() async {
      expect(await h.base.lireCache(0, '/locataire/contrats/1'), isNull);
      expect(await h.base.lireCache(0, '/proprietes'), isNotNull);
      expect(await h.base.lireCache(99, '/locataire/contrats/1'), isNotNull);
    });
    expect(find.byKey(const ValueKey('rattachement-1')), findsNothing);
    expect(tester.takeException(), isNull);
    await h.terminer(tester);
  });
}
