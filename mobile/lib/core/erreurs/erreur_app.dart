import 'package:dio/dio.dart';

/// R-149 : toute réponse d'erreur devient une erreur typée.
sealed class ErreurApp implements Exception {
  const ErreurApp(this.code, this.message);

  /// Code métier stable renvoyé par l'API (traduit côté app, R-150).
  final String code;

  /// Message technique (secours si le code n'est pas traduit).
  final String message;

  @override
  String toString() => '$runtimeType($code): $message';
}

/// Pas de réseau ou serveur injoignable.
final class ErreurReseau extends ErreurApp {
  const ErreurReseau([String message = 'Réseau indisponible']) : super('RESEAU', message);
}

/// Session absente ou expirée (401) : il faut se reconnecter (R-142).
final class ErreurSession extends ErreurApp {
  const ErreurSession([String message = 'Session expirée']) : super('SESSION', message);
}

/// Données invalides, avec les erreurs par champ.
final class ErreurValidation extends ErreurApp {
  const ErreurValidation(super.code, super.message, this.champs);
  final Map<String, List<String>> champs;
}

/// Règle métier refusée (ex. UNITE_OCCUPEE, PAIEMENT_SUPERIEUR_AU_DU).
final class ErreurMetier extends ErreurApp {
  const ErreurMetier(super.code, super.message, this.statut);
  final int statut;
}

/// Erreur serveur (5xx) ou réponse illisible.
final class ErreurServeur extends ErreurApp {
  const ErreurServeur([super.code = 'ERREUR_SERVEUR', super.message = 'Erreur serveur']);
}

/// Convertit n'importe quelle exception (Dio ou autre) en [ErreurApp].
ErreurApp convertirErreur(Object erreur) {
  if (erreur is ErreurApp) return erreur;
  if (erreur is DioException) {
    final inner = erreur.error;
    if (inner is ErreurApp) return inner;
    switch (erreur.type) {
      case DioExceptionType.connectionError:
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return const ErreurReseau();
      case DioExceptionType.badResponse:
        return _depuisReponse(erreur.response);
      default:
        return ErreurReseau(erreur.message ?? 'Réseau indisponible');
    }
  }

  return ErreurServeur('INCONNUE', erreur.toString());
}

ErreurApp _depuisReponse(Response<dynamic>? reponse) {
  final statut = reponse?.statusCode ?? 0;
  final corps = reponse?.data;
  final code = corps is Map && corps['code'] is String ? corps['code'] as String : 'ERREUR_HTTP';
  final message = corps is Map && corps['message'] is String ? corps['message'] as String : 'Erreur $statut';

  if (statut == 401) return ErreurSession(message);
  if (statut >= 500 && code != 'CONVERSION_INDISPONIBLE') return ErreurServeur(code, message);

  final champs = <String, List<String>>{};
  final brut = corps is Map ? corps['erreurs'] : null;
  if (brut is Map) {
    brut.forEach((cle, valeur) {
      if (valeur is List) champs['$cle'] = valeur.map((e) => '$e').toList();
    });
  }
  if (statut == 422 && champs.isNotEmpty) return ErreurValidation(code, message, champs);

  return ErreurMetier(code, message, statut);
}
