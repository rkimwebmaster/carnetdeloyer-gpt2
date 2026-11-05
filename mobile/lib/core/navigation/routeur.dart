import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/abonnement/screens/ecran_abonnements.dart';
import '../../features/auth/screens/ecran_code.dart';
import '../../features/auth/screens/ecran_inscription.dart';
import '../../features/auth/screens/ecran_pin.dart';
import '../../features/auth/screens/ecran_telephone.dart';
import '../../features/biens/screens/ecran_biens.dart';
import '../../features/biens/screens/ecran_nouvelle_propriete.dart';
import '../../features/biens/screens/ecran_propriete.dart';
import '../../features/contrats/screens/ecran_contrat.dart';
import '../../features/contrats/screens/ecran_nouveau_contrat.dart';
import '../../features/home/screens/ecran_accueil.dart';
import '../../features/home/screens/ecran_choix_mode.dart';
import '../../features/home/screens/ecran_parrainage.dart';
import '../../features/hotel/screens/ecran_hotels.dart';
import '../../features/locations/screens/ecran_locations.dart';
import '../../features/market/screens/ecran_market.dart';
import '../../features/paiements/screens/ecran_encaisser.dart';
import '../../features/paiements/screens/ecran_paiements.dart';
import '../../features/wallet/screens/ecran_wallet.dart';
import '../session/mode_actif.dart';
import '../session/session.dart';
import 'coquille.dart';

/// Décide où aller selon la session et le mode (fonction pure, testée).
String? redirection({required StatutSession statut, required AsyncValue<ModeActif?> mode, required String chemin}) {
  final versAuth = chemin.startsWith('/auth');
  switch (statut) {
    case StatutSession.chargement:
      return chemin == '/chargement' ? null : '/chargement';
    case StatutSession.deconnecte:
      return versAuth ? null : '/auth';
    case StatutSession.pinACreer:
      return chemin == '/pin/creation' ? null : '/pin/creation';
    case StatutSession.verrouille:
      return chemin == '/verrou' ? null : '/verrou';
    case StatutSession.deverrouille:
      if (mode.isLoading) return chemin == '/chargement' ? null : '/chargement';
      final m = mode.value;
      // R-161 : première connexion, choix du mode.
      if (m == null) return chemin == '/mode' ? null : '/mode';
      final prefixe = m == ModeActif.bailleur ? '/b' : '/l';
      // R-145 : la bascule de mode remet la navigation à l'accueil du nouveau mode.
      if (!chemin.startsWith('$prefixe/')) return '$prefixe/accueil';
      return null;
  }
}

/// Notifie le routeur quand la session ou le mode change.
class _Rafraichissement extends ChangeNotifier {
  _Rafraichissement(Ref ref) {
    ref.listen(sessionProvider, (_, _) => notifyListeners());
    ref.listen(modeProvider, (_, _) => notifyListeners());
  }
}

int _id(GoRouterState s, String nom) => int.parse(s.pathParameters[nom]!);

/// Routes communes aux deux modes (sous-pages du menu latéral).
List<RouteBase> _pagesMenu() => [
      GoRoute(path: 'wallet', builder: (_, _) => const EcranWallet()),
      GoRoute(path: 'parrainage', builder: (_, _) => const EcranParrainage()),
      GoRoute(path: 'profil', builder: (_, _) => const EcranProfil()),
    ];

final routeurProvider = Provider<GoRouter>((ref) {
  final rafraichir = _Rafraichissement(ref);
  ref.onDispose(rafraichir.dispose);

  return GoRouter(
    initialLocation: '/chargement',
    refreshListenable: rafraichir,
    redirect: (context, etat) => redirection(
      statut: ref.read(sessionProvider).statut,
      mode: ref.read(modeProvider),
      chemin: etat.matchedLocation,
    ),
    errorBuilder: (_, _) => const EcranIntrouvable(),
    routes: [
      GoRoute(path: '/chargement', builder: (_, _) => const EcranChargement()),
      GoRoute(path: '/auth', builder: (_, _) => const EcranTelephone(), routes: [
        GoRoute(path: 'code', builder: (_, s) => EcranCode(telephone: s.extra! as String)),
        GoRoute(path: 'inscription', builder: (_, s) {
          final (telephone, jeton) = s.extra! as (String, String);
          return EcranInscription(telephone: telephone, jeton: jeton);
        }),
      ]),
      GoRoute(path: '/pin/creation', builder: (_, _) => const EcranCreationPin()),
      GoRoute(path: '/verrou', builder: (_, _) => const EcranVerrou()),
      GoRoute(path: '/mode', builder: (_, _) => const EcranChoixMode()),

      // Mode bailleur : Accueil, Biens, Paiements, Market, Hôtels.
      StatefulShellRoute.indexedStack(
        builder: (_, _, nav) => Coquille(navigation: nav, mode: ModeActif.bailleur),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(path: '/b/accueil', builder: (_, _) => const EcranAccueilBailleur(), routes: [
              ..._pagesMenu(),
              GoRoute(path: 'abonnements', builder: (_, _) => const EcranAbonnements()),
            ]),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/b/biens', builder: (_, _) => const EcranBiens(), routes: [
              GoRoute(path: 'nouvelle', builder: (_, _) => const EcranNouvellePropriete()),
              GoRoute(path: 'proprietes/:id', builder: (_, s) => EcranPropriete(id: _id(s, 'id'))),
            ]),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/b/paiements', builder: (_, _) => const EcranPaiements()),
          ]),
          StatefulShellBranch(routes: [GoRoute(path: '/b/market', builder: (_, _) => const EcranMarket())]),
          StatefulShellBranch(routes: [GoRoute(path: '/b/hotels', builder: (_, _) => const EcranHotels())]),
        ],
      ),
      // Pages bailleur hors onglets (plein écran).
      GoRoute(path: '/b/contrats/nouveau', builder: (_, s) => EcranNouveauContrat(uniteId: int.parse(s.uri.queryParameters['uniteId']!))),
      GoRoute(path: '/b/contrats/:id', builder: (_, s) => EcranContrat(id: _id(s, 'id')), routes: [
        GoRoute(path: 'encaisser', builder: (_, s) => EcranEncaisser(contratId: _id(s, 'id'))),
      ]),
      GoRoute(path: '/b/wallet', redirect: (_, _) => '/b/accueil/wallet'),
      GoRoute(path: '/b/abonnements', redirect: (_, _) => '/b/accueil/abonnements'),
      GoRoute(path: '/b/parrainage', redirect: (_, _) => '/b/accueil/parrainage'),
      GoRoute(path: '/b/profil', redirect: (_, _) => '/b/accueil/profil'),

      // Mode locataire : Accueil, Mes locations, Market, Hôtels.
      StatefulShellRoute.indexedStack(
        builder: (_, _, nav) => Coquille(navigation: nav, mode: ModeActif.locataire),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(path: '/l/accueil', builder: (_, _) => const EcranAccueilLocataire(), routes: _pagesMenu()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/l/locations', builder: (_, _) => const EcranLocations(), routes: [
              GoRoute(path: ':id', builder: (_, s) => EcranMaLocation(id: _id(s, 'id'))),
            ]),
          ]),
          StatefulShellBranch(routes: [GoRoute(path: '/l/market', builder: (_, _) => const EcranMarket())]),
          StatefulShellBranch(routes: [GoRoute(path: '/l/hotels', builder: (_, _) => const EcranHotels())]),
        ],
      ),
      GoRoute(path: '/l/wallet', redirect: (_, _) => '/l/accueil/wallet'),
      GoRoute(path: '/l/parrainage', redirect: (_, _) => '/l/accueil/parrainage'),
      GoRoute(path: '/l/profil', redirect: (_, _) => '/l/accueil/profil'),
    ],
  );
});
