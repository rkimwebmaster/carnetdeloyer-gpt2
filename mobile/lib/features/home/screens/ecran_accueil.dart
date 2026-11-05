import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/navigation/coquille.dart';
import '../../../core/outils/format.dart';
import '../../../core/session/fournisseurs.dart';
import '../../../core/session/mode_actif.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/communs.dart';
import '../../auth/providers/auth_providers.dart';

final tableauDeBordProvider = FutureProvider.autoDispose<Map<String, dynamic>>(
  (ref) async => (await ref.watch(lecteurProvider).lire('/tableau-de-bord', (j) => j as Map<String, dynamic>)).valeur,
);

final activitesProvider = FutureProvider.autoDispose.family<List<Map<String, dynamic>>, ModeActif>((ref, mode) async {
  final lecture = await ref.watch(lecteurProvider).lire('/activites', (j) => ((j as Map)['elements'] as List).cast<Map<String, dynamic>>(), parametres: {'mode': mode.name, 'parPage': 15});
  return lecture.valeur;
});

/// R-173 : texte d'une activité, traduit côté app à partir du code et des paramètres.
String texteActivite(Map<String, dynamic> a) {
  final p = (a['parametres'] as Map?) ?? const {};
  String m() => p['montant'] is int && p['devise'] is String ? Format.montant(p['montant'] as int, p['devise'] as String) : '';
  return switch (a['type']) {
    'paiement_enregistre' => 'Paiement de ${m()} enregistré${p['locataire'] != null ? ' (${p['locataire']})' : ''} · reçu ${p['recu'] ?? ''}',
    'paiement_annule' => 'Paiement de ${m()} annulé : ${p['motif'] ?? ''}',
    'declaration_recue' => '${p['locataire'] ?? 'Un locataire'} déclare avoir payé ${m()}',
    'declaration_validee' => 'Déclaration de ${m()} validée',
    'declaration_refusee' => 'Déclaration de ${m()} refusée : ${p['motif'] ?? ''}',
    'declaration_relance' => 'Rappel : déclaration de ${m()} en attente (${p['locataire'] ?? ''})',
    'contrat_cree' => 'Contrat créé : ${p['unite'] ?? ''} · ${p['locataire'] ?? ''}',
    'contrat_cloture' => 'Contrat clôturé : ${p['unite'] ?? ''}',
    'abonnement_paye' => 'Abonnement payé : ${p['unite'] ?? ''}',
    'abonnement_gratuit' => 'Première unité offerte 12 mois : ${p['unite'] ?? ''}',
    'abonnement_expire_bientot' => 'Abonnement de ${p['unite'] ?? ''} : expire dans ${p['jours'] ?? 0} jours',
    'gain_parrainage' => 'Gain de parrainage : ${p['montantUsd'] is int ? Format.montant(p['montantUsd'] as int, 'USD') : ''}',
    'annonce_publiee' => 'Annonce publiée : ${p['unite'] ?? ''}',
    'badge_obtenu' => 'Badge de vérification obtenu',
    _ => '${a['type']}',
  };
}

/// Accueil bailleur : chiffres clés, guide de démarrage (R-162) et fil d'activité.
class EcranAccueilBailleur extends ConsumerWidget {
  const EcranAccueilBailleur({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final profil = ref.watch(profilProvider).value;
    final tdb = ref.watch(tableauDeBordProvider);
    return Scaffold(
      appBar: AppBar(leading: const BoutonMenu(), title: Text(profil == null ? l.nomApp : l.accueilBonjour(profil.nom))),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(tableauDeBordProvider);
          ref.invalidate(activitesProvider(ModeActif.bailleur));
        },
        child: ListView(padding: const EdgeInsets.only(bottom: 24), children: [
          VueAsync(
            valeur: tdb,
            reessayer: () => ref.invalidate(tableauDeBordProvider),
            donnees: (t) {
              if (t['unites'] == 0) {
                // R-162 : guide de démarrage, sans blocage.
                return Card(
                  child: Column(children: [
                    ListTile(title: Text(l.accueilGuideTitre, style: Theme.of(context).textTheme.titleMedium)),
                    ListTile(leading: const Icon(Icons.add_home_outlined), title: Text(l.accueilGuidePropriete), onTap: () => context.push('/b/biens/nouvelle')),
                    ListTile(leading: const Icon(Icons.campaign_outlined), title: Text(l.accueilGuideMarket)),
                    ListTile(leading: const Icon(Icons.business_outlined), title: Text(l.accueilGuideEntreprise), onTap: () => context.push('/b/profil')),
                  ]),
                );
              }
              List<Widget> montants(List<dynamic> liste, Color? couleur) => [
                    for (final m in liste)
                      Text(Format.montant((m as Map)['montant'] as int, m['devise'] as String),
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(color: couleur)),
                  ];
              return Column(children: [
                Row(children: [
                  _Tuile(titre: l.accueilUnites, valeur: '${t['unites']}'),
                  _Tuile(titre: l.accueilLouees, valeur: '${t['unitesLouees']}'),
                  _Tuile(titre: l.accueilVacantes, valeur: '${t['unitesVacantes']}'),
                ]),
                Card(
                  child: ListTile(
                    title: Text(l.accueilEnRetard),
                    subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: (t['enRetard'] as List).isEmpty ? [Text(l.contratAJour)] : montants(t['enRetard'] as List, ThemeCdl.retard)),
                    trailing: Text('${t['contratsEnRetard']}'),
                  ),
                ),
                Card(
                  child: ListTile(
                    title: Text(l.accueilEncaisseMois),
                    subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: (t['encaisseCeMois'] as List).isEmpty ? [const Text('—')] : montants(t['encaisseCeMois'] as List, null)),
                  ),
                ),
              ]);
            },
          ),
          const _FilActivite(mode: ModeActif.bailleur),
        ]),
      ),
    );
  }
}

class _Tuile extends StatelessWidget {
  const _Tuile({required this.titre, required this.valeur});
  final String titre;
  final String valeur;

  @override
  Widget build(BuildContext context) => Expanded(
        child: Card(
          margin: const EdgeInsets.fromLTRB(16, 8, 0, 8),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(children: [Text(valeur, style: Theme.of(context).textTheme.headlineSmall), Text(titre, style: Theme.of(context).textTheme.bodySmall)]),
          ),
        ),
      );
}

class _FilActivite extends ConsumerWidget {
  const _FilActivite({required this.mode});
  final ModeActif mode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final activites = ref.watch(activitesProvider(mode)).value ?? const [];
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Padding(padding: const EdgeInsets.fromLTRB(16, 16, 16, 4), child: Text(l.accueilActivite, style: Theme.of(context).textTheme.titleSmall)),
      if (activites.isEmpty) ListTile(title: Text(l.accueilAucuneActivite)),
      for (final a in activites)
        ListTile(
          dense: true,
          leading: const Icon(Icons.bolt_outlined),
          title: Text(texteActivite(a)),
          subtitle: Text(Format.date((a['creeLe'] as String).substring(0, 10))),
        ),
    ]);
  }
}

/// Accueil locataire : guide de rattachement et activité de ses contrats.
class EcranAccueilLocataire extends ConsumerWidget {
  const EcranAccueilLocataire({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final profil = ref.watch(profilProvider).value;
    return Scaffold(
      appBar: AppBar(leading: const BoutonMenu(), title: Text(profil == null ? l.nomApp : l.accueilBonjour(profil.nom))),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(activitesProvider(ModeActif.locataire)),
        child: ListView(children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.link),
              title: Text(l.accueilGuideRattachement),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.go('/l/locations'),
            ),
          ),
          const _FilActivite(mode: ModeActif.locataire),
        ]),
      ),
    );
  }
}
