import 'package:carnetdeloyer/core/session/coffre.dart';
import 'package:flutter_test/flutter_test.dart';

import '../outils.dart';

void main() {
  test('R-141 : PIN stocké sous forme d\'empreinte salée, vérifié hors ligne', () async {
    final coffre = CoffreMemoire();
    final s = StockageSession(coffre);
    await s.definirPin('2468');
    expect(coffre.valeurs.values.join(), isNot(contains('2468')));
    expect(await s.verifierPin('2468'), isTrue);
    expect(await s.verifierPin('1357'), isFalse);
    expect(await s.verifierPin(''), isFalse);
  });

  test('identifiant utilisateur lu dans le JWT', () {
    expect(Jetons(fauxJwt(42), 'r').utilisateurId, 42);
    expect(const Jetons('pas-un-jwt', 'r').utilisateurId, isNull);
  });

  test('changement de compte : PIN et mode du compte précédent effacés', () async {
    final s = StockageSession(CoffreMemoire());
    await s.enregistrerJetons(Jetons(fauxJwt(1), 'r1'));
    await s.definirPin('1111');
    await s.definirMode('locataire');
    await s.enregistrerJetons(Jetons(fauxJwt(1, suffixe: 'b'), 'r2'));
    expect(await s.aUnPin(), isTrue, reason: 'même compte : PIN conservé');

    await s.enregistrerJetons(Jetons(fauxJwt(2), 'r3'));
    expect(await s.aUnPin(), isFalse);
    expect(await s.mode(), isNull);
    expect(await s.utilisateurId(), 2);
  });
}
