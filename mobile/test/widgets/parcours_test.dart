import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../outils.dart';
import 'harnais.dart';

Map<String, dynamic> profil() => {
      'id': 1, 'nom': 'Aline', 'telephone': '+243970000001', 'codeParrainage': 'ABC1234',
      'pays': {'id': 1, 'nom': 'RDC', 'codeIso': 'CD', 'deviseParDefaut': 'CDF'}, 'roles': ['ROLE_USER'],
    };

Future<(int, Object?)> api(dynamic o, Map<String, dynamic>? corps) async {
  final chemin = (o as dynamic).path as String;
  if (chemin == '/moi') return (200, profil());
  if (chemin == '/tableau-de-bord') return (200, {'unites': 0, 'unitesLouees': 0, 'unitesVacantes': 0, 'contratsEnRetard': 0, 'enRetard': [], 'encaisseCeMois': []});
  if (chemin == '/activites') return (200, {'elements': [], 'page': 1, 'parPage': 15, 'total': 0});
  if (chemin == '/locataire/rattachements') return (200, []);
  if (chemin == '/locataire/contrats') return (200, {'elements': [], 'page': 1, 'parPage': 20, 'total': 0});
  return (200, {});
}

void main() {
  testWidgets('R-160 : inscription téléphone → code → nom → PIN → choix du mode → accueil bailleur', (tester) async {
    final h = Harnais(FauxServeur((o, corps) async {
      switch (o.path) {
        case '/auth/otp':
          return (202, {'envoye': true});
        case '/auth/otp/verification':
          return (200, {'inscriptionRequise': true, 'jetonInscription': 'jeton'});
        case '/auth/inscription':
          expect(corps!['nom'], 'Aline Mbuyi');
          return (201, {'token': fauxJwt(1), 'refresh_token': 'r', 'refresh_token_expiration': 0});
        case '/moi':
          return o.method == 'PATCH' ? (200, profil()) : (200, profil());
      }
      return api(o, corps);
    }));
    await h.lancerApp(tester);

    await tester.enterText(find.byKey(const Key('champTelephone')), '+243 970 000 001');
    await tester.tap(find.text('Continuer'));
    await Harnais.stabiliser(tester);
    expect(find.textContaining('+243970000001'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('champCode')), '123456');
    await Harnais.stabiliser(tester);
    await tester.enterText(find.byKey(const Key('champNom')), 'Aline Mbuyi');
    await tester.tap(find.text('Continuer'));
    await Harnais.stabiliser(tester);

    expect(find.text('Créez votre code PIN'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('champPin')), '2468');
    await tester.tap(find.byKey(const Key('validerPin')));
    await Harnais.stabiliser(tester);
    expect(find.text('Confirmez le code PIN'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('champPin')), '2468');
    await tester.tap(find.byKey(const Key('validerPin')));
    await Harnais.stabiliser(tester);

    expect(find.text('Comment utilisez-vous CarnetDeLoyer ?'), findsOneWidget);
    await tester.tap(find.byKey(const Key('mode_bailleur')));
    await Harnais.stabiliser(tester);

    expect(find.text('Bonjour Aline'), findsOneWidget);
    expect(find.text('Bien démarrer'), findsOneWidget, reason: 'R-162 : guide de démarrage');
    expect(find.text('Biens'), findsOneWidget);
    expect(find.text('Hôtels'), findsOneWidget);
    await h.terminer(tester);
  });

  testWidgets('R-141 : verrou par PIN sans réseau, 5 erreurs → retour à l\'OTP', (tester) async {
    final h = Harnais(FauxServeur((o, _) async => couperReseau(o)), coffre: await coffreConnecte(mode: 'bailleur'));
    await h.lancerApp(tester);

    expect(find.text('Saisissez votre code PIN'), findsOneWidget);
    for (var i = 0; i < 4; i++) {
      await tester.enterText(find.byKey(const Key('champPin')), '0000');
      await tester.tap(find.byKey(const Key('validerPin')));
      await Harnais.stabiliser(tester);
    }
    expect(find.text('Code incorrect. Essais restants : 1'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('champPin')), '0000');
    await tester.tap(find.byKey(const Key('validerPin')));
    await Harnais.stabiliser(tester);
    expect(find.text('Votre numéro de téléphone'), findsOneWidget);
    await h.terminer(tester);
  });

  testWidgets('bon PIN hors ligne → accueil ; bascule de mode depuis le menu (R-145)', (tester) async {
    final h = Harnais(FauxServeur(api), coffre: await coffreConnecte(mode: 'bailleur'));
    await h.lancerApp(tester);

    await tester.enterText(find.byKey(const Key('champPin')), '2468');
    await tester.tap(find.byKey(const Key('validerPin')));
    await Harnais.stabiliser(tester);
    expect(find.text('Bonjour Aline'), findsOneWidget);
    expect(find.text('Paiements'), findsOneWidget);

    await tester.tap(find.byTooltip('Ouvrir le menu de navigation'));
    await Harnais.stabiliser(tester);
    await tester.tap(find.byKey(const Key('basculerMode')));
    await Harnais.stabiliser(tester);

    expect(find.text('Mes locations'), findsWidgets);
    expect(find.text('Paiements'), findsNothing, reason: 'barre du bas propre au mode locataire');
    expect(find.text('Retrouvez vos contrats'), findsOneWidget);
    await h.terminer(tester);
  });
}
