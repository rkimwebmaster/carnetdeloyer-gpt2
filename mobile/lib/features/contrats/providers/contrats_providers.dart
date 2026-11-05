import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/cache/lecture.dart';
import '../../../core/modeles/modeles.dart';
import '../../../core/session/fournisseurs.dart';
import '../../../core/session/session.dart';
import '../services/contrats_service.dart';

part 'contrats_providers.g.dart';

@riverpod
ContratsService contratsService(Ref ref) => ContratsService(ref.watch(clientApiProvider), ref.watch(lecteurProvider));

@riverpod
Future<Lecture<PageApi<Contrat>>> contrats(Ref ref, {String? statut, bool enRetard = false}) =>
    ref.watch(contratsServiceProvider).contrats(statut: statut, enRetard: enRetard);

@riverpod
Future<Lecture<Contrat>> contrat(Ref ref, int id) => ref.watch(contratsServiceProvider).contrat(id);

@riverpod
Future<Lecture<Encaissement>> encaissement(Ref ref, int contratId) => ref.watch(contratsServiceProvider).encaissement(contratId);
