import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';

/// Faux serveur HTTP : chaque requête est passée à [repondre].
class FauxServeur implements HttpClientAdapter {
  FauxServeur(this.repondre);

  final Future<(int, Object?)> Function(RequestOptions options, Map<String, dynamic>? corps) repondre;
  final List<RequestOptions> requetes = [];

  @override
  Future<ResponseBody> fetch(RequestOptions options, Stream<Uint8List>? requestStream, Future<void>? cancelFuture) async {
    requetes.add(options);
    Map<String, dynamic>? corps;
    if (options.data is Map) corps = Map<String, dynamic>.from(options.data as Map);
    if (options.data is String && (options.data as String).isNotEmpty) corps = jsonDecode(options.data as String) as Map<String, dynamic>;
    final (statut, reponse) = await repondre(options, corps);
    return ResponseBody.fromString(
      reponse == null ? '' : jsonEncode(reponse),
      statut,
      headers: {Headers.contentTypeHeader: ['application/json']},
    );
  }

  @override
  void close({bool force = false}) {}
}

/// Simule une coupure réseau.
Never couperReseau(RequestOptions options) =>
    throw DioException(requestOptions: options, type: DioExceptionType.connectionError, message: 'hors ligne');

/// Fabrique un JWT non signé portant l'identifiant [sub] (suffisant côté client).
String fauxJwt(int sub, {String suffixe = ''}) {
  String b64(Map<String, dynamic> m) => base64Url.encode(utf8.encode(jsonEncode(m))).replaceAll('=', '');
  return '${b64({'alg': 'none'})}.${b64({'sub': '$sub', 'n': suffixe})}.signature';
}

Map<String, dynamic> paiementJson({int id = 1, int contratId = 7, int montant = 30000, String cle = 'k', String numero = 'CDL-2026-000001'}) => {
      'id': id,
      'contratId': contratId,
      'type': 'loyer',
      'montant': montant,
      'devise': 'USD',
      'datePaiement': '2026-10-27',
      'moyen': 'especes',
      'statut': 'valide',
      'cleIdempotence': cle,
      'recu': {'id': id, 'numero': numero, 'annule': false, 'lien': 'https://x/r/abc', 'messagePartage': 'Bonjour'},
    };
