import 'package:carnetdeloyer/core/api/client_api.dart';
import 'package:carnetdeloyer/core/cache/base_locale.dart';
import 'package:carnetdeloyer/core/l10n/l10n.dart';
import 'package:carnetdeloyer/core/session/coffre.dart';
import 'package:carnetdeloyer/core/session/fournisseurs.dart';
import 'package:carnetdeloyer/core/session/session.dart';
import 'package:carnetdeloyer/main.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../outils.dart';

/// Environnement de test : coffre en mémoire, base Drift en mémoire, faux serveur.
class Harnais {
  Harnais(this.serveur, {Coffre? coffre}) : coffre = coffre ?? CoffreMemoire();

  final FauxServeur serveur;
  final Coffre coffre;
  final BaseLocale base = BaseLocale(NativeDatabase.memory());
  bool enLigne = true;

  List overrides() => [
        coffreProvider.overrideWithValue(coffre),
        baseLocaleProvider.overrideWithValue(base),
        clientApiProvider.overrideWith((ref) {
          final c = ClientApi(stockage: ref.watch(stockageSessionProvider), urlBase: 'http://t', adaptateur: serveur);
          c.surSessionExpiree = () => ref.read(sessionProvider.notifier).expirer();
          return c;
        }),
        enLigneProvider.overrideWith((ref) => Stream.value(enLigne)),
      ];

  /// Lance l'application complète.
  Future<void> lancerApp(WidgetTester tester) async {
    await initializeDateFormatting('fr');
    await tester.pumpWidget(ProviderScope(overrides: [...overrides()], child: const AppCdl()));
    await stabiliser(tester);
  }

  /// Monte un seul écran.
  Future<void> monter(WidgetTester tester, Widget ecran) async {
    await initializeDateFormatting('fr');
    await tester.pumpWidget(ProviderScope(
      overrides: [...overrides()],
      child: MaterialApp(
        locale: const Locale('fr'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [AppLocalizations.delegate, ...GlobalMaterialLocalizations.delegates],
        home: ecran,
      ),
    ));
    await stabiliser(tester);
  }

  /// Laisse passer les appels asynchrones (Drift, faux serveur).
  static Future<void> stabiliser(WidgetTester tester) async {
    for (var i = 0; i < 12; i++) {
      await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 10)));
      await tester.pump(const Duration(milliseconds: 50));
    }
  }

  /// Démonte l'arbre (ferme les flux Drift) et écoule les minuteries (SnackBar…),
  /// puis ferme la base hors du temps simulé.
  Future<void> terminer(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 10));
    await tester.runAsync(base.close);
  }
}

/// Coffre d'un utilisateur déjà connecté, avec PIN 2468 et un mode.
Future<CoffreMemoire> coffreConnecte({String? mode}) async {
  final coffre = CoffreMemoire();
  final s = StockageSession(coffre);
  await s.enregistrerJetons(Jetons(fauxJwt(1), 'r'));
  await s.definirPin('2468');
  if (mode != null) await s.definirMode(mode);
  return coffre;
}
