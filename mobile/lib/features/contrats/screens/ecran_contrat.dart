import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/modeles/modeles.dart';
import '../../../core/outils/format.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/communs.dart';
import '../../paiements/widgets/carte_paiement.dart';
import '../providers/contrats_providers.dart';

/// Détail d'un contrat vu par le bailleur ou par le locataire ([locataire]).
class EcranContrat extends ConsumerWidget {
  const EcranContrat({super.key, required this.id, this.vue});
  final int id;

  /// Pour le mode locataire, la vue est fournie par l'écran appelant.
  final AsyncValue<Contrat>? vue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final valeur = vue ?? ref.watch(contratProvider(id)).whenData((lecture) => lecture.valeur);
    final estBailleur = vue == null;
    return Scaffold(
      appBar: AppBar(
        title: Text(valeur.value?.unite.nom ?? ''),
        actions: [
          if (estBailleur && valeur.value?.statut == 'actif')
            PopupMenuButton<String>(
              onSelected: (_) => _cloturer(context, ref, valeur.value!),
              itemBuilder: (_) => [PopupMenuItem(value: 'cloturer', child: Text(l.contratCloturer))],
            ),
        ],
      ),
      floatingActionButton: estBailleur && valeur.value?.statut == 'actif'
          ? FloatingActionButton.extended(
              key: const Key('encaisser'),
              onPressed: () => context.push('/b/contrats/$id/encaisser'),
              icon: const Icon(Icons.payments_outlined),
              label: Text(l.encaisserBouton),
            )
          : null,
      body: VueAsync(
        valeur: valeur,
        reessayer: () => ref.invalidate(contratProvider(id)),
        donnees: (c) => RefreshIndicator(
          onRefresh: () async => ref.invalidate(contratProvider(id)),
          child: ListView(padding: const EdgeInsets.only(bottom: 96), children: [
            _Entete(contrat: c),
            _Titre(l.contratEcheances),
            for (final e in c.echeances.where((e) => e.statut != 'annulee' || c.statut != 'actif'))
              ListTile(
                dense: true,
                title: Text(Format.moisAnnee(e.periodeDebut)),
                subtitle: e.montantPaye > 0 && e.restantDu > 0 ? Text(Format.montantDevise(e.restantDu, c.devise)) : null,
                trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                  Text(Format.montantDevise(e.montantDu, c.devise)),
                  const SizedBox(width: 8),
                  PastilleStatut(e.statut),
                ]),
              ),
            _Titre(l.contratPaiements),
            if (c.paiements.isEmpty) ListTile(title: Text(l.listeVide)),
            for (final p in c.paiements) CartePaiement(paiement: p, peutAnnuler: estBailleur && c.statut == 'actif', apresAnnulation: () => ref.invalidate(contratProvider(id))),
          ]),
        ),
      ),
    );
  }

  Future<void> _cloturer(BuildContext context, WidgetRef ref, Contrat c) async {
    final l = context.l10n;
    final date = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.parse(c.dateDebut), lastDate: DateTime(2100), helpText: l.contratDateSortie);
    if (date == null || !context.mounted) return;
    String? garantie;
    if (c.garantie?.statut == 'detenue') {
      garantie = await showDialog<String>(
        context: context,
        builder: (ctx) => SimpleDialog(title: Text(l.contratGarantie), children: [
          SimpleDialogOption(onPressed: () => Navigator.pop(ctx, 'restituee'), child: const Text('Restituée')),
          SimpleDialogOption(onPressed: () => Navigator.pop(ctx, 'imputee_sur_loyers'), child: const Text('Imputée sur les loyers impayés')),
        ]),
      );
      if (garantie == null) return;
    }
    try {
      await ref.read(contratsServiceProvider).cloturer(c.id, dateSortie: Format.dateIso(date), garantie: garantie);
      ref.invalidate(contratProvider(c.id));
    } catch (e) {
      if (context.mounted) afficherErreur(context, e);
    }
  }
}

class _Titre extends StatelessWidget {
  const _Titre(this.texte);
  final String texte;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
        child: Text(texte, style: Theme.of(context).textTheme.titleSmall),
      );
}

class _Entete extends StatelessWidget {
  const _Entete({required this.contrat});
  final Contrat contrat;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = contrat;
    final enRetard = c.enRetard > 0;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(c.locataire.nom, style: Theme.of(context).textTheme.titleMedium),
          Text('${c.unite.nom} · ${c.unite.propriete}'),
          const SizedBox(height: 12),
          Text(Format.montantDevise(c.loyer, c.devise), style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          if (c.statut != 'actif')
            Text(l.contratCloture)
          else
            Text(
              enRetard ? l.contratEnRetard(Format.montantDevise(c.enRetard, c.devise)) : l.contratAJour,
              style: TextStyle(color: enRetard ? ThemeCdl.retard : ThemeCdl.ok, fontWeight: FontWeight.w600),
            ),
          if (c.prochaineEcheance != null) Text(l.contratProchaineEcheance(Format.date(c.prochaineEcheance!.dateExigible))),
        ]),
      ),
    );
  }
}
