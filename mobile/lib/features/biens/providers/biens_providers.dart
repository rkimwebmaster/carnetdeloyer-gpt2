import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/cache/lecture.dart';
import '../../../core/modeles/modeles.dart';
import '../../../core/session/fournisseurs.dart';
import '../../../core/session/session.dart';
import '../services/biens_service.dart';

part 'biens_providers.g.dart';

@riverpod
BiensService biensService(Ref ref) => BiensService(ref.watch(clientApiProvider), ref.watch(lecteurProvider));

@riverpod
Future<Lecture<PageApi<Propriete>>> proprietes(Ref ref) => ref.watch(biensServiceProvider).proprietes();

@riverpod
Future<Lecture<Propriete>> propriete(Ref ref, int id) => ref.watch(biensServiceProvider).propriete(id);

@riverpod
Future<Lecture<Unite>> unite(Ref ref, int id) => ref.watch(biensServiceProvider).unite(id);

@Riverpod(keepAlive: true)
Future<List<Devise>> devises(Ref ref) async => (await ref.watch(biensServiceProvider).devises()).valeur;

@Riverpod(keepAlive: true)
Future<List<Categorie>> categories(Ref ref) async => (await ref.watch(biensServiceProvider).categories()).valeur;
