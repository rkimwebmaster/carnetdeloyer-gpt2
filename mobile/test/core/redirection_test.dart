import 'package:carnetdeloyer/core/navigation/routeur.dart';
import 'package:carnetdeloyer/core/session/mode_actif.dart';
import 'package:carnetdeloyer/core/session/session.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

String? r(StatutSession s, String chemin, [ModeActif? mode, bool chargementMode = false]) => redirection(
      statut: s,
      mode: chargementMode ? const AsyncLoading() : AsyncData(mode),
      chemin: chemin,
    );

void main() {
  test('R-09 : sans compte, tout mène à l\'authentification', () {
    expect(r(StatutSession.deconnecte, '/b/accueil'), '/auth');
    expect(r(StatutSession.deconnecte, '/l/locations/3'), '/auth');
    expect(r(StatutSession.deconnecte, '/auth/code'), isNull);
  });

  test('PIN à créer puis verrou', () {
    expect(r(StatutSession.pinACreer, '/b/accueil'), '/pin/creation');
    expect(r(StatutSession.verrouille, '/b/biens'), '/verrou');
    expect(r(StatutSession.verrouille, '/verrou'), isNull);
  });

  test('R-161 : choix du mode à la première connexion', () {
    expect(r(StatutSession.deverrouille, '/auth'), '/mode');
    expect(r(StatutSession.deverrouille, '/mode'), isNull);
    expect(r(StatutSession.deverrouille, '/x', null, true), '/chargement');
  });

  test('R-145 : chaque mode a ses écrans ; la bascule remet à l\'accueil', () {
    expect(r(StatutSession.deverrouille, '/mode', ModeActif.bailleur), '/b/accueil');
    expect(r(StatutSession.deverrouille, '/b/contrats/4', ModeActif.bailleur), isNull);
    expect(r(StatutSession.deverrouille, '/b/contrats/4', ModeActif.locataire), '/l/accueil');
    expect(r(StatutSession.deverrouille, '/l/locations/4', ModeActif.bailleur), '/b/accueil');
    expect(r(StatutSession.deverrouille, '/l/locations/4', ModeActif.locataire), isNull);
  });
}
