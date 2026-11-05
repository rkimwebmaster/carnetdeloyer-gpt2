import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../api/client_api.dart';
import '../cache/base_locale.dart';
import '../config/environnement.dart';
import 'coffre.dart';

part 'session.g.dart';

/// Les services sont exposés via des providers pour être remplacés en test (R-134).
@Riverpod(keepAlive: true)
Coffre coffre(Ref ref) => CoffreSecurise();

@Riverpod(keepAlive: true)
StockageSession stockageSession(Ref ref) => StockageSession(ref.watch(coffreProvider));

@Riverpod(keepAlive: true)
BaseLocale baseLocale(Ref ref) {
  final base = BaseLocale();
  ref.onDispose(base.close);
  return base;
}

@Riverpod(keepAlive: true)
ClientApi clientApi(Ref ref) {
  final client = ClientApi(stockage: ref.watch(stockageSessionProvider), urlBase: Config.urlApi);
  // R-142 : refresh expiré => retour à l'OTP, file d'attente conservée.
  client.surSessionExpiree = () => ref.read(sessionProvider.notifier).expirer();
  return client;
}

enum StatutSession {
  /// Lecture du coffre en cours.
  chargement,

  /// Aucun compte : téléphone + OTP (R-71).
  deconnecte,

  /// Connecté sur cet appareil mais sans PIN : création obligatoire.
  pinACreer,

  /// Connecté, PIN ou biométrie requis (fonctionne sans réseau, R-141).
  verrouille,

  /// Utilisable.
  deverrouille,
}

class EtatSession {
  const EtatSession(this.statut, {this.utilisateurId, this.essaisRestants = EtatSession.essaisMax});

  static const essaisMax = 5;
  final StatutSession statut;
  final int? utilisateurId;
  final int essaisRestants;
}

@Riverpod(keepAlive: true)
class Session extends _$Session {
  @override
  EtatSession build() {
    _charger();
    return const EtatSession(StatutSession.chargement);
  }

  StockageSession get _stockage => ref.read(stockageSessionProvider);

  Future<void> _charger() async {
    final jetons = await _stockage.jetons();
    final id = await _stockage.utilisateurId();
    if (jetons == null) {
      state = EtatSession(StatutSession.deconnecte, utilisateurId: id);
    } else {
      state = EtatSession(await _stockage.aUnPin() ? StatutSession.verrouille : StatutSession.pinACreer, utilisateurId: jetons.utilisateurId ?? id);
    }
  }

  /// Après l'OTP (connexion ou inscription).
  Future<void> connecter(Jetons jetons) async {
    await _stockage.enregistrerJetons(jetons);
    state = EtatSession(await _stockage.aUnPin() ? StatutSession.deverrouille : StatutSession.pinACreer, utilisateurId: jetons.utilisateurId);
  }

  Future<void> creerPin(String pin) async {
    await _stockage.definirPin(pin);
    state = EtatSession(StatutSession.deverrouille, utilisateurId: state.utilisateurId);
  }

  /// R-141 : déverrouillage sans réseau. Après 5 échecs, retour à l'OTP.
  Future<bool> deverrouiller(String pin) async {
    if (await _stockage.verifierPin(pin)) {
      state = EtatSession(StatutSession.deverrouille, utilisateurId: state.utilisateurId);
      return true;
    }
    final restants = state.essaisRestants - 1;
    if (restants <= 0) {
      await _stockage.effacerPin();
      await _stockage.effacerJetons();
      state = EtatSession(StatutSession.deconnecte, utilisateurId: state.utilisateurId);
    } else {
      state = EtatSession(StatutSession.verrouille, utilisateurId: state.utilisateurId, essaisRestants: restants);
    }
    return false;
  }

  /// Biométrie réussie (vérifiée par le système).
  void deverrouillerParBiometrie() {
    if (state.statut == StatutSession.verrouille) {
      state = EtatSession(StatutSession.deverrouille, utilisateurId: state.utilisateurId);
    }
  }

  void verrouiller() {
    if (state.statut == StatutSession.deverrouille) {
      state = EtatSession(StatutSession.verrouille, utilisateurId: state.utilisateurId);
    }
  }

  /// R-142 : la file d'attente est conservée ; elle sera envoyée après reconnexion
  /// au même compte (R-139).
  void expirer() {
    state = EtatSession(StatutSession.deconnecte, utilisateurId: state.utilisateurId);
  }

  Future<void> deconnecter() async {
    await _stockage.effacerJetons();
    await _stockage.effacerPin();
    await _stockage.definirMode(null);
    state = EtatSession(StatutSession.deconnecte, utilisateurId: state.utilisateurId);
  }
}
