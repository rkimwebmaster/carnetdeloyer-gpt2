import 'package:dio/dio.dart';

import '../erreurs/erreur_app.dart';
import '../session/coffre.dart';

/// Client HTTP de l'API /api/v1 (R-119), seul point de contact avec le serveur.
///
/// - ajoute le token Bearer ;
/// - R-141 : rafraîchit automatiquement le token sur un 401, une seule fois,
///   puis rejoue la requête ; les requêtes concurrentes attendent ce rafraîchissement ;
/// - R-142 : si le rafraîchissement échoue, la session est effacée (la file de
///   paiements hors ligne, elle, est conservée) et [surSessionExpiree] est appelé ;
/// - R-149 : toute erreur sort en [ErreurApp].
class ClientApi {
  ClientApi({
    required this.stockage,
    required String urlBase,
    HttpClientAdapter? adaptateur,
    this.surSessionExpiree,
  })  : dio = Dio(_options('$urlBase/api/v1')),
        _dioRafraichissement = Dio(_options('$urlBase/api/v1')) {
    if (adaptateur != null) {
      dio.httpClientAdapter = adaptateur;
      _dioRafraichissement.httpClientAdapter = adaptateur;
    }
    dio.interceptors.add(QueuedInterceptorsWrapper(onRequest: _ajouterJeton, onError: _surErreur));
  }

  static const cheminRafraichissement = '/auth/token/rafraichir';

  final StockageSession stockage;
  final Dio dio;
  final Dio _dioRafraichissement;
  void Function()? surSessionExpiree;

  static BaseOptions _options(String base) => BaseOptions(
        baseUrl: base,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 30),
        headers: {'Accept': 'application/json'},
        contentType: 'application/json',
      );

  Future<dynamic> get(String chemin, {Map<String, dynamic>? parametres}) =>
      _executer(() => dio.get<dynamic>(chemin, queryParameters: parametres));

  Future<dynamic> post(String chemin, [Object? corps]) => _executer(() => dio.post<dynamic>(chemin, data: corps));

  Future<dynamic> put(String chemin, [Object? corps]) => _executer(() => dio.put<dynamic>(chemin, data: corps));

  Future<dynamic> patch(String chemin, [Object? corps]) => _executer(() => dio.patch<dynamic>(chemin, data: corps));

  Future<dynamic> delete(String chemin) => _executer(() => dio.delete<dynamic>(chemin));

  /// Variante qui renvoie aussi le statut HTTP (ex. 201 / 200 pour l'idempotence).
  Future<(int, dynamic)> postAvecStatut(String chemin, [Object? corps]) async {
    try {
      final r = await dio.post<dynamic>(chemin, data: corps);
      return (r.statusCode ?? 0, r.data);
    } catch (e) {
      throw convertirErreur(e);
    }
  }

  Future<dynamic> _executer(Future<Response<dynamic>> Function() appel) async {
    try {
      return (await appel()).data;
    } catch (e) {
      throw convertirErreur(e);
    }
  }

  Future<void> _ajouterJeton(RequestOptions options, RequestInterceptorHandler handler) async {
    final jetons = await stockage.jetons();
    if (jetons != null) options.headers['Authorization'] = 'Bearer ${jetons.acces}';
    handler.next(options);
  }

  Future<void> _surErreur(DioException erreur, ErrorInterceptorHandler handler) async {
    final options = erreur.requestOptions;
    final estUn401 = erreur.response?.statusCode == 401;
    if (!estUn401 || options.extra['dejaRejouee'] == true || options.path.startsWith('/auth/')) {
      return handler.next(erreur);
    }

    final jetons = await stockage.jetons();
    if (jetons == null) return handler.next(erreur);

    // Une requête précédente de la file a peut-être déjà rafraîchi le token.
    final jetonUtilise = (options.headers['Authorization'] as String?)?.replaceFirst('Bearer ', '');
    var jetonCourant = jetons.acces;
    if (jetonUtilise == jetonCourant) {
      try {
        jetonCourant = (await _rafraichir(jetons.rafraichissement)).acces;
      } on ErreurApp catch (e) {
        return handler.reject(DioException(requestOptions: options, response: erreur.response, error: e));
      }
    }

    try {
      options.headers['Authorization'] = 'Bearer $jetonCourant';
      options.extra['dejaRejouee'] = true;
      handler.resolve(await dio.fetch<dynamic>(options));
    } on DioException catch (e) {
      handler.next(e);
    }
  }

  /// Lève [ErreurSession] si le refresh est refusé, [ErreurReseau] sinon.
  Future<Jetons> _rafraichir(String refresh) async {
    try {
      final r = await _dioRafraichissement.post<dynamic>(cheminRafraichissement, data: {'refresh_token': refresh});
      final data = r.data as Map;
      final jetons = Jetons(data['token'] as String, data['refresh_token'] as String);
      await stockage.enregistrerJetons(jetons);
      return jetons;
    } on DioException catch (e) {
      final erreur = convertirErreur(e);
      if (erreur is ErreurSession) {
        await stockage.effacerJetons();
        surSessionExpiree?.call();
      }
      throw erreur;
    }
  }
}
