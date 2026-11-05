import 'package:carnetdeloyer/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

double contraste(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  return ((la > lb ? la : lb) + .05) / ((la > lb ? lb : la) + .05);
}

void main() {
  for (final sombre in [false, true]) {
    final nom = sombre ? 'sombre' : 'clair';
    final theme = sombre ? ThemeCdl.sombre() : ThemeCdl.clair();

    test('Contrastes du texte, des boutons et du focus en mode $nom', () {
      final schema = theme.colorScheme;
      expect(contraste(schema.onSurface, schema.surface), greaterThanOrEqualTo(4.5));
      expect(contraste(schema.onSurfaceVariant, schema.surface), greaterThanOrEqualTo(4.5));
      final bouton = theme.filledButtonTheme.style!;
      expect(contraste(bouton.foregroundColor!.resolve({})!, bouton.backgroundColor!.resolve({})!), greaterThanOrEqualTo(4.5));
      final focus = theme.inputDecorationTheme.focusedBorder!.borderSide.color;
      expect(contraste(focus, schema.surface), greaterThanOrEqualTo(3));
      for (final statut in ['payee', 'en_retard', 'partielle', 'a_venir', 'annulee']) {
        final fond = Color.alphaBlend(ThemeCdl.fondStatut(statut, schema), schema.surface);
        expect(contraste(ThemeCdl.statut(statut, schema), fond), greaterThanOrEqualTo(4.5), reason: '$statut en mode $nom');
      }
    });

    testWidgets('Formulaire utilisable avec le thème $nom et texte agrandi', (tester) async {
      var clics = 0;
      await tester.pumpWidget(MaterialApp(
        theme: theme,
        home: MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(1.5)),
          child: Scaffold(body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              const TextField(decoration: InputDecoration(labelText: 'Nom du bien')),
              FilledButton(onPressed: () => clics++, child: const Text('Enregistrer')),
            ]),
          )),
        ),
      ));
      await tester.enterText(find.byType(TextField), 'Maison Kolwezi');
      await tester.tap(find.text('Enregistrer'));
      await tester.pump();
      expect(clics, 1);
      expect(find.text('Maison Kolwezi'), findsOneWidget);
      expect(tester.getSize(find.byType(FilledButton)).height, greaterThanOrEqualTo(50));
      expect(tester.takeException(), isNull);
    });
  }
}
