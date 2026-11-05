import 'package:carnetdeloyer/features/home/screens/ecran_parrainage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../outils.dart';
import 'harnais.dart';

void main() {
  testWidgets('R-72 : profil, demande OTP et changement du numéro sans changer de compte', (tester) async {
    var telephone = '+243970000001';
    final serveur = FauxServeur((o, corps) async {
      if (o.path == '/moi') return (200, {'id': 1, 'nom': 'Aline', 'telephone': telephone, 'codeParrainage': 'ABC1234', 'roles': ['ROLE_USER']});
      if (o.path == '/auth/otp') {
        expect(corps!['telephone'], '+243970000002');
        return (202, {'envoye': true});
      }
      if (o.path == '/moi/telephone') {
        expect(corps!['code'], '123456');
        telephone = corps['telephone'] as String;
        return (200, {'id': 1, 'telephone': telephone});
      }
      return (404, {'code': 'INTROUVABLE'});
    });
    final h = Harnais(serveur);
    await h.monter(tester, const EcranProfil());
    await tester.tap(find.text('Changer mon numéro'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('nouveauTelephone')), '+243970000002');
    await tester.tap(find.text('Envoyer le code'));
    await Harnais.stabiliser(tester);
    expect(serveur.requetes.any((r) => r.path == '/auth/otp'), isTrue);
    await tester.enterText(find.byKey(const Key('codeNouveauTelephone')), '123456');
    await tester.ensureVisible(find.text('Valider'));
    await tester.tap(find.text('Valider'));
    await Harnais.stabiliser(tester);
    await tester.pumpAndSettle();
    expect(find.text('+243970000002'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await h.terminer(tester);
  });
}
