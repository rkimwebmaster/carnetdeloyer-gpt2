import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/cache/lecture.dart';
import '../../../core/modeles/modeles.dart';
import '../../../core/session/fournisseurs.dart';
import '../../../core/session/session.dart';
import '../services/locations_service.dart';

part 'locations_providers.g.dart';

@riverpod
LocationsService locationsService(Ref ref) => LocationsService(ref.watch(clientApiProvider), ref.watch(lecteurProvider));

@riverpod
Future<Lecture<PageApi<Contrat>>> mesLocations(Ref ref) => ref.watch(locationsServiceProvider).contrats();

@riverpod
Future<Lecture<Contrat>> maLocation(Ref ref, int id) => ref.watch(locationsServiceProvider).contrat(id);

@riverpod
Future<List<Rattachement>> rattachements(Ref ref) => ref.watch(locationsServiceProvider).aRattacher();
