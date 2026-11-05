import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/modeles/modeles.dart';
import '../../../core/outils/format.dart';
import '../../../core/session/session.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/communs.dart';

final abonnementsProvider = FutureProvider.autoDispose<List<Unite>>(
  (ref) async => [for (final u in await ref.watch(clientApiProvider).get('/abonnements') as List) Unite.fromJson(u as Map<String, dynamic>)],
);

final abonnementUniteProvider = FutureProvider.autoDispose.family<Map<String, dynamic>, int>(
  (ref, id) async => await ref.watch(clientApiProvider).get('/unites/$id/abonnement') as Map<String, dynamic>,
);

String libelleEtat(AppLocalizations l, String etat) => switch (etat) {
      'gratuit' => l.abonnementEtatGratuit,
      'actif' => l.abonnementEtatActif,
      'grace' => l.abonnementEtatGrace,
      'suspendu' => l.abonnementEtatSuspendu,
      _ => l.abonnementEtatNon_facture,
    };

/// Section 6 : un abonnement par unité louée, montant exact avant de payer (R-68).
class EcranAbonnements extends ConsumerWidget {
  const EcranAbonnements({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.abonnementsTitre)),
      body: VueAsync(
        valeur: ref.watch(abonnementsProvider),
        reessayer: () => ref.invalidate(abonnementsProvider),
        donnees: (unites) => unites.isEmpty
            ? EtatVide(message: l.listeVide)
            : ListView(children: [for (final u in unites) _CarteAbonnement(unite: u)]),
      ),
    );
  }
}

class _CarteAbonnement extends ConsumerWidget {
  const _CarteAbonnement({required this.unite});
  final Unite unite;

  Future<void> _payer(BuildContext context, WidgetRef ref, String source) async {
    final l = context.l10n;
    String? reference;
    if (source == 'manuel') {
      final champ = TextEditingController();
      final ok = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(l.abonnementPayerMobile),
          content: TextField(controller: champ, autofocus: true, decoration: InputDecoration(labelText: l.abonnementReference)),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l.actionFermer)),
            FilledButton(onPressed: () => Navigator.pop(ctx, champ.text.trim().isNotEmpty), child: Text(l.actionValider)),
          ],
        ),
      );
      if (ok != true) return;
      reference = champ.text.trim();
    }
    try {
      await ref.read(clientApiProvider).post('/unites/${unite.id}/abonnement/paiements', {'source': source, 'referenceTransaction': ?reference});
      ref.invalidate(abonnementsProvider);
      ref.invalidate(abonnementUniteProvider(unite.id));
      if (context.mounted) afficherMessage(context, l.abonnementEnvoye);
    } catch (e) {
      if (context.mounted) afficherErreur(context, e);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final etat = unite.abonnement.etat;
    final alerte = etat == 'grace' || etat == 'suspendu';
    final detail = ref.watch(abonnementUniteProvider(unite.id)).value;
    final devis = detail?['devis'] as Map<String, dynamic>?;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(iconeCategorie(unite.categorie.icone)),
            title: Text(unite.nom),
            subtitle: Text([
              libelleEtat(l, etat),
              if (unite.abonnement.fin != null) l.abonnementJusquAu(Format.date(unite.abonnement.fin!)),
            ].join(' · '), style: TextStyle(color: alerte ? ThemeCdl.retard : null)),
          ),
          if (devis != null) ...[
            Text(l.abonnementMontant(Format.montant(devis['montantUsd'] as int, 'USD'), '${devis['pourcentage']}')),
            const SizedBox(height: 8),
            Wrap(spacing: 8, children: [
              FilledButton.tonal(onPressed: () => _payer(context, ref, 'wallet'), child: Text(l.abonnementPayerWallet)),
              OutlinedButton(onPressed: () => _payer(context, ref, 'manuel'), child: Text(l.abonnementPayerMobile)),
            ]),
          ] else if (detail?['devisIndisponible'] == 'CONVERSION_INDISPONIBLE')
            Text(l.erreurCONVERSION_INDISPONIBLE),
        ]),
      ),
    );
  }
}
