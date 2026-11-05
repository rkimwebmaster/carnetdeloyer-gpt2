import 'package:carnetdeloyer/core/erreurs/erreur_app.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

DioException reponse(int statut, Object? corps) {
  final options = RequestOptions(path: '/x');
  return DioException(requestOptions: options, type: DioExceptionType.badResponse, response: Response(requestOptions: options, statusCode: statut, data: corps));
}

void main() {
  test('R-149 : erreurs typées depuis le format { code, message, erreurs }', () {
    expect(convertirErreur(reponse(401, {'code': 'SESSION', 'message': 'x', 'erreurs': {}})), isA<ErreurSession>());

    final v = convertirErreur(reponse(422, {'code': 'TELEPHONE_INVALIDE', 'message': 'm', 'erreurs': {'telephone': ['invalide']}}));
    expect(v, isA<ErreurValidation>());
    expect((v as ErreurValidation).champs['telephone'], ['invalide']);
    expect(v.code, 'TELEPHONE_INVALIDE');

    final m = convertirErreur(reponse(409, {'code': 'UNITE_OCCUPEE', 'message': 'occupée', 'erreurs': {}}));
    expect(m, isA<ErreurMetier>());
    expect(m.code, 'UNITE_OCCUPEE');
    expect((m as ErreurMetier).statut, 409);

    expect(convertirErreur(reponse(500, {'code': 'ERREUR_SERVEUR', 'message': 'x', 'erreurs': {}})), isA<ErreurServeur>());
    expect(convertirErreur(reponse(502, '<html>')), isA<ErreurServeur>());
    // Conversion monétaire indisponible (503) reste une erreur métier lisible.
    expect(convertirErreur(reponse(503, {'code': 'CONVERSION_INDISPONIBLE', 'message': 'x', 'erreurs': {}})).code, 'CONVERSION_INDISPONIBLE');
  });

  test('coupure réseau', () {
    final e = DioException(requestOptions: RequestOptions(path: '/x'), type: DioExceptionType.connectionError);
    expect(convertirErreur(e), isA<ErreurReseau>());
    expect(convertirErreur(DioException(requestOptions: RequestOptions(path: '/x'), type: DioExceptionType.receiveTimeout)), isA<ErreurReseau>());
  });
}
