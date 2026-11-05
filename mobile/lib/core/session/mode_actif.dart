import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'session.dart';

part 'mode_actif.g.dart';

/// R-144 : énumération extensible, stockée sur le téléphone. Sans effet sur les
/// droits : le serveur autorise chaque appel selon ce que l'utilisateur possède.
enum ModeActif { bailleur, locataire }

@Riverpod(keepAlive: true)
class Mode extends _$Mode {
  @override
  Future<ModeActif?> build() async {
    ref.watch(sessionProvider.select((s) => s.utilisateurId));
    final valeur = await ref.read(stockageSessionProvider).mode();
    return ModeActif.values.where((m) => m.name == valeur).firstOrNull;
  }

  /// R-145 : la bascule remet la navigation à zéro (géré par le routeur).
  Future<void> definir(ModeActif mode) async {
    await ref.read(stockageSessionProvider).definirMode(mode.name);
    state = AsyncData(mode);
    // Le serveur garde la dernière préférence pour un nouvel appareil (R-144).
    try {
      await ref.read(clientApiProvider).patch('/moi', {'modePrefere': mode.name});
    } catch (_) {
      // Hors ligne : la préférence locale suffit.
    }
  }
}
