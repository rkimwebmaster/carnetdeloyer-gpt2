import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/l10n.dart';
import '../theme/theme.dart';

/// Affiche un AsyncValue : chargement, erreur traduite avec bouton Réessayer, données.
class VueAsync<T> extends StatelessWidget {
  const VueAsync({super.key, required this.valeur, required this.donnees, this.reessayer});

  final AsyncValue<T> valeur;
  final Widget Function(T) donnees;
  final VoidCallback? reessayer;

  @override
  Widget build(BuildContext context) {
    return switch (valeur) {
      AsyncData(:final value) => donnees(value),
      AsyncError(:final error) => EtatErreur(erreur: error, reessayer: reessayer),
      _ => const Center(child: CircularProgressIndicator()),
    };
  }
}

class EtatErreur extends StatelessWidget {
  const EtatErreur({super.key, required this.erreur, this.reessayer});

  final Object erreur;
  final VoidCallback? reessayer;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.cloud_off_outlined, size: 40),
          const SizedBox(height: 12),
          Text(messageErreur(l, erreur), textAlign: TextAlign.center),
          if (reessayer != null) ...[
            const SizedBox(height: 12),
            OutlinedButton(onPressed: reessayer, child: Text(l.actionReessayer)),
          ],
        ]),
      ),
    );
  }
}

class EtatVide extends StatelessWidget {
  const EtatVide({super.key, required this.message, this.icone = Icons.inbox_outlined, this.action});

  final String message;
  final IconData icone;
  final Widget? action;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(icone, size: 48, color: Theme.of(context).colorScheme.outline),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            if (action != null) ...[const SizedBox(height: 16), action!],
          ]),
        ),
      );
}

/// Pastille de statut d'échéance (R-22).
class PastilleStatut extends StatelessWidget {
  const PastilleStatut(this.statut, {super.key});

  final String statut;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final libelle = switch (statut) {
      'payee' => l.statutPayee,
      'partielle' => l.statutPartielle,
      'en_retard' => l.statutEn_retard,
      'annulee' => l.statutAnnulee,
      _ => l.statutA_venir,
    };
    final couleur = ThemeCdl.statut(statut, Theme.of(context).colorScheme);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: couleur.withValues(alpha: .12), borderRadius: BorderRadius.circular(12)),
      child: Text(libelle, style: TextStyle(color: couleur, fontWeight: FontWeight.w600, fontSize: 12)),
    );
  }
}

/// Icône d'une catégorie d'unité (R-83). Les noms viennent du back-office.
IconData iconeCategorie(String nom) => switch (nom) {
      'house' => Icons.house_outlined,
      'apartment' => Icons.apartment_outlined,
      'bed' => Icons.bed_outlined,
      'single_bed' => Icons.single_bed_outlined,
      'storefront' => Icons.storefront_outlined,
      'business_center' => Icons.business_center_outlined,
      'warehouse' => Icons.warehouse_outlined,
      'landscape' => Icons.landscape_outlined,
      'hotel' => Icons.hotel_outlined,
      _ => Icons.home_work_outlined,
    };

void afficherErreur(BuildContext context, Object erreur) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(messageErreur(context.l10n, erreur))));
}

void afficherMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

/// R-150 : bandeau hors ligne global.
class BandeauHorsLigne extends ConsumerWidget {
  const BandeauHorsLigne({super.key, required this.horsLigne});

  final bool horsLigne;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!horsLigne) return const SizedBox.shrink();
    return Material(
      color: Theme.of(context).colorScheme.tertiaryContainer,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Row(children: [
            const Icon(Icons.wifi_off, size: 18),
            const SizedBox(width: 8),
            Expanded(child: Text(context.l10n.horsLigne, style: Theme.of(context).textTheme.bodySmall)),
          ]),
        ),
      ),
    );
  }
}
