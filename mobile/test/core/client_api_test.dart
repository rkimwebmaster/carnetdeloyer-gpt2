import 'package:carnetdeloyer/core/api/client_api.dart';
import 'package:carnetdeloyer/core/erreurs/erreur_app.dart';
import 'package:carnetdeloyer/core/session/coffre.dart';
import 'package:flutter_test/flutter_test.dart';

import '../outils.dart';

void main() {
  late StockageSession stockage;

  setUp(() async {
    stockage = StockageSession(CoffreMemoire());
    await stockage.enregistrerJetons(Jetons(fauxJwt(1, suffixe: 'ancien'), 'refresh-1'));
  });

  test('ajoute le token Bearer', () async {
    final serveur = FauxServeur((o, _) async => (200, {'ok': o.headers['Authorization']}));
    final api = ClientApi(stockage: stockage, urlBase: 'http://t', adaptateur: serveur);
    final r = await api.get('/moi') as Map;
    expect(r['ok'], 'Bearer ${fauxJwt(1, suffixe: 'ancien')}');
    expect(serveur.requetes.single.uri.toString(), 'http://t/api/v1/moi');
  });

  test('R-141 : 401 => un seul rafraîchissement pour des requêtes simultanées, puis rejeu', () async {
    var rafraichissements = 0;
    final nouveau = fauxJwt(1, suffixe: 'nouveau');
    final serveur = FauxServeur((o, corps) async {
      if (o.path.endsWith('/auth/token/rafraichir')) {
        rafraichissements++;
        expect(corps!['refresh_token'], 'refresh-1');
        return (200, {'token': nouveau, 'refresh_token': 'refresh-2'});
      }
      final ok = o.headers['Authorization'] == 'Bearer $nouveau';
      return ok ? (200, {'chemin': o.path}) : (401, {'code': 'SESSION', 'message': 'expiré', 'erreurs': {}});
    });
    final api = ClientApi(stockage: stockage, urlBase: 'http://t', adaptateur: serveur);

    final r = await Future.wait([api.get('/a'), api.get('/b'), api.get('/c')]);
    expect(r.map((e) => (e as Map)['chemin']), ['/a', '/b', '/c']);
    expect(rafraichissements, 1);
    expect((await stockage.jetons())!.rafraichissement, 'refresh-2');
  });

  test('R-142 : refresh refusé => session effacée, callback appelé, ErreurSession', () async {
    var expiree = false;
    final serveur = FauxServeur((o, _) async => (401, {'code': 'SESSION', 'message': 'expiré', 'erreurs': {}}));
    final api = ClientApi(stockage: stockage, urlBase: 'http://t', adaptateur: serveur, surSessionExpiree: () => expiree = true);

    await expectLater(api.get('/moi'), throwsA(isA<ErreurSession>()));
    expect(expiree, isTrue);
    expect(await stockage.jetons(), isNull);
  });

  test('refresh impossible faute de réseau : la session est conservée', () async {
    final serveur = FauxServeur((o, _) async {
      if (o.path.endsWith('/rafraichir')) couperReseau(o);
      return (401, {'code': 'SESSION', 'message': 'expiré', 'erreurs': {}});
    });
    final api = ClientApi(stockage: stockage, urlBase: 'http://t', adaptateur: serveur);
    await expectLater(api.get('/moi'), throwsA(isA<ErreurReseau>()));
    expect(await stockage.jetons(), isNotNull);
  });

  test('erreurs métier traduites', () async {
    final serveur = FauxServeur((o, _) async => (409, {'code': 'UNITE_OCCUPEE', 'message': 'x', 'erreurs': {}}));
    final api = ClientApi(stockage: stockage, urlBase: 'http://t', adaptateur: serveur);
    await expectLater(api.post('/contrats', {}), throwsA(isA<ErreurMetier>().having((e) => e.code, 'code', 'UNITE_OCCUPEE')));
  });
}
