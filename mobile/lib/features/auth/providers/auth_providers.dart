import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/session/fournisseurs.dart';
import '../../../core/session/session.dart';
import '../models/profil.dart';
import '../services/auth_service.dart';

part 'auth_providers.g.dart';

@riverpod
AuthService authService(Ref ref) => AuthService(ref.watch(clientApiProvider));

/// Profil de l'utilisateur connecté (consultable hors ligne).
@Riverpod(keepAlive: true)
Future<Profil> profil(Ref ref) async {
  ref.watch(sessionProvider.select((s) => s.utilisateurId));
  final lecture = await ref.watch(lecteurProvider).lire('/moi', (j) => Profil.fromJson(j as Map<String, dynamic>));
  return lecture.valeur;
}
