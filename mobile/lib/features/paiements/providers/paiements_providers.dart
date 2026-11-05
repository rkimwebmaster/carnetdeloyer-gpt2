import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/cache/base_locale.dart';
import '../../../core/cache/lecture.dart';
import '../../../core/modeles/modeles.dart';
import '../../../core/session/fournisseurs.dart';
import '../../../core/session/session.dart';
import '../models/declaration.dart';
import '../services/file_paiements.dart';
import '../services/paiements_service.dart';

part 'paiements_providers.g.dart';

@Riverpod(keepAlive: true)
FilePaiements filePaiements(Ref ref) {
  final id = ref.watch(sessionProvider.select((s) => s.utilisateurId)) ?? 0;
  return FilePaiements(api: ref.watch(clientApiProvider), base: ref.watch(baseLocaleProvider), utilisateurId: id);
}

/// Paiements pas encore confirmés (en attente ou rejetés).
/// Déclaré à la main : le type de ligne Drift est lui-même généré.
final fileEnAttenteProvider = StreamProvider.autoDispose<List<PaiementEnAttente>>((ref) => ref.watch(filePaiementsProvider).observer());

@riverpod
PaiementsService paiementsService(Ref ref) => PaiementsService(ref.watch(clientApiProvider), ref.watch(lecteurProvider));

@riverpod
Future<Lecture<PageApi<Paiement>>> paiements(Ref ref) => ref.watch(paiementsServiceProvider).paiements();

@riverpod
Future<PageApi<Declaration>> declarations(Ref ref) => ref.watch(paiementsServiceProvider).declarations();
