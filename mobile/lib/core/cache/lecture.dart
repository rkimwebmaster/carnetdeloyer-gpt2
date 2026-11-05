import '../api/client_api.dart';
import '../erreurs/erreur_app.dart';
import 'base_locale.dart';

/// Résultat d'une lecture : la valeur et sa provenance.
class Lecture<T> {
  const Lecture(this.valeur, {this.depuisCache = false});
  final T valeur;

  /// Vrai si le réseau a échoué et que la valeur vient du cache (R-138).
  final bool depuisCache;
}

/// R-80 : lecture réseau d'abord, cache local en secours.
class LecteurCache {
  LecteurCache(this.api, this.base, this.utilisateurId);

  final ClientApi api;
  final BaseLocale base;
  final int utilisateurId;

  Future<Lecture<T>> lire<T>(String chemin, T Function(dynamic json) convertir, {Map<String, dynamic>? parametres}) async {
    final cle = parametres == null ? chemin : '$chemin?${Uri(queryParameters: parametres.map((k, v) => MapEntry(k, '$v'))).query}';
    try {
      final json = await api.get(chemin, parametres: parametres);
      await base.mettreEnCache(utilisateurId, cle, json);
      return Lecture(convertir(json));
    } on ErreurReseau {
      final json = await base.lireCache(utilisateurId, cle);
      if (json == null) rethrow;
      return Lecture(convertir(json), depuisCache: true);
    }
  }
}
