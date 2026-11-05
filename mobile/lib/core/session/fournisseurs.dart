import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../cache/lecture.dart';
import 'session.dart';

part 'fournisseurs.g.dart';

/// Lecteur avec cache pour l'utilisateur connecté.
@riverpod
LecteurCache lecteur(Ref ref) {
  final id = ref.watch(sessionProvider.select((s) => s.utilisateurId)) ?? 0;
  return LecteurCache(ref.watch(clientApiProvider), ref.watch(baseLocaleProvider), id);
}

/// Vrai si le téléphone a une connexion réseau (indicatif : le serveur peut
/// rester injoignable ; les appels gèrent ce cas).
@Riverpod(keepAlive: true)
Stream<bool> enLigne(Ref ref) async* {
  final connectivite = Connectivity();
  bool depuis(List<ConnectivityResult> r) => r.any((c) => c != ConnectivityResult.none);
  yield depuis(await connectivite.checkConnectivity());
  yield* connectivite.onConnectivityChanged.map(depuis);
}
