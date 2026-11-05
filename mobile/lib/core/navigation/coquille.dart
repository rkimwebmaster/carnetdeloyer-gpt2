import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/providers/auth_providers.dart';
import '../../features/paiements/providers/paiements_providers.dart';
import '../l10n/l10n.dart';
import '../session/fournisseurs.dart';
import '../session/mode_actif.dart';
import '../session/session.dart';
import '../widgets/communs.dart';

/// Coquille commune : barre du bas propre au mode, menu latéral avec bascule
/// de mode (R-145), bandeau hors ligne, synchronisation au retour du réseau.
class Coquille extends ConsumerWidget {
  const Coquille({super.key, required this.navigation, required this.mode});

  /// Une clé stable par mode : les écrans d'onglet ouvrent le menu de la coquille.
  static final _cles = {for (final m in ModeActif.values) m: GlobalKey<ScaffoldState>()};

  final StatefulNavigationShell navigation;
  final ModeActif mode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final enLigne = ref.watch(enLigneProvider).value ?? true;

    // R-136 : dès que le réseau revient, la file est envoyée.
    ref.listen(enLigneProvider, (avant, apres) {
      if (apres.value == true && avant?.value == false) ref.read(filePaiementsProvider).synchroniser();
    });

    final destinations = mode == ModeActif.bailleur
        ? [
            NavigationDestination(icon: const Icon(Icons.home_outlined), selectedIcon: const Icon(Icons.home), label: l.ongletAccueil),
            NavigationDestination(
              icon: const Icon(Icons.home_work_outlined),
              selectedIcon: const Icon(Icons.home_work),
              label: l.ongletBiens,
            ),
            NavigationDestination(
              icon: const Icon(Icons.payments_outlined),
              selectedIcon: const Icon(Icons.payments),
              label: l.ongletPaiements,
            ),
            NavigationDestination(
              icon: const Icon(Icons.storefront_outlined),
              selectedIcon: const Icon(Icons.storefront),
              label: l.ongletMarket,
            ),
            NavigationDestination(icon: const Icon(Icons.hotel_outlined), selectedIcon: const Icon(Icons.hotel), label: l.ongletHotels),
          ]
        : [
            NavigationDestination(icon: const Icon(Icons.home_outlined), selectedIcon: const Icon(Icons.home), label: l.ongletAccueil),
            NavigationDestination(icon: const Icon(Icons.key_outlined), selectedIcon: const Icon(Icons.key), label: l.ongletLocations),
            NavigationDestination(
              icon: const Icon(Icons.storefront_outlined),
              selectedIcon: const Icon(Icons.storefront),
              label: l.ongletMarket,
            ),
            NavigationDestination(icon: const Icon(Icons.hotel_outlined), selectedIcon: const Icon(Icons.hotel), label: l.ongletHotels),
          ];

    return CleMenu(
      cle: _cles[mode]!,
      child: Scaffold(
        key: _cles[mode],
        drawer: _Menu(mode: mode),
        body: Column(
          children: [
            BandeauHorsLigne(horsLigne: !enLigne),
            Expanded(child: navigation),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: navigation.currentIndex,
          destinations: destinations,
          onDestinationSelected: (i) => navigation.goBranch(i, initialLocation: i == navigation.currentIndex),
        ),
      ),
    );
  }
}

/// Transmet la clé du Scaffold de la coquille aux écrans d'onglet.
class CleMenu extends InheritedWidget {
  const CleMenu({super.key, required this.cle, required super.child});
  final GlobalKey<ScaffoldState> cle;

  @override
  bool updateShouldNotify(CleMenu ancien) => ancien.cle != cle;
}

/// Bouton « menu » des écrans d'onglet : ouvre le menu latéral de la coquille.
class BoutonMenu extends StatelessWidget {
  const BoutonMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final cle = context.dependOnInheritedWidgetOfExactType<CleMenu>()?.cle;
    if (cle == null) return const SizedBox.shrink();
    return IconButton(
      tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
      icon: const Icon(Icons.menu),
      onPressed: () => cle.currentState?.openDrawer(),
    );
  }
}

class _Menu extends ConsumerWidget {
  const _Menu({required this.mode});
  final ModeActif mode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final profil = ref.watch(profilProvider).value;
    final prefixe = mode == ModeActif.bailleur ? '/b' : '/l';
    void ouvrir(String chemin) {
      Navigator.pop(context);
      context.push('$prefixe$chemin');
    }

    return NavigationDrawer(
      children: [
        DrawerHeader(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(profil?.nom ?? '', style: Theme.of(context).textTheme.titleLarge),
              Text(mode == ModeActif.bailleur ? l.modeBailleur : l.modeLocataire),
            ],
          ),
        ),
        // R-145 : bascule accessible depuis le menu latéral.
        ListTile(
          key: const Key('basculerMode'),
          leading: const Icon(Icons.swap_horiz),
          title: Text(mode == ModeActif.bailleur ? l.modeBasculerVersLocataire : l.modeBasculerVersBailleur),
          onTap: () {
            Navigator.pop(context);
            ref.read(modeProvider.notifier).definir(mode == ModeActif.bailleur ? ModeActif.locataire : ModeActif.bailleur);
          },
        ),
        const Divider(),
        ListTile(leading: const Icon(Icons.account_balance_wallet_outlined), title: Text(l.menuWallet), onTap: () => ouvrir('/wallet')),
        if (mode == ModeActif.bailleur)
          ListTile(leading: const Icon(Icons.autorenew), title: Text(l.menuAbonnements), onTap: () => ouvrir('/abonnements')),
        ListTile(leading: const Icon(Icons.card_giftcard), title: Text(l.menuParrainage), onTap: () => ouvrir('/parrainage')),
        ListTile(leading: const Icon(Icons.person_outline), title: Text(l.menuProfil), onTap: () => ouvrir('/profil')),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.logout),
          title: Text(l.authSeDeconnecter),
          onTap: () {
            Navigator.pop(context);
            ref.read(sessionProvider.notifier).deconnecter();
          },
        ),
      ],
    );
  }
}

/// Écran d'attente.
class EcranChargement extends StatelessWidget {
  const EcranChargement({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: CircularProgressIndicator()));
}

/// Écran introuvable (lien obsolète).
class EcranIntrouvable extends StatelessWidget {
  const EcranIntrouvable({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(),
    body: EtatVide(message: context.l10n.erreurINTROUVABLE),
  );
}
