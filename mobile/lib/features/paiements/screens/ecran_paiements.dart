import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/cache/base_locale.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/navigation/coquille.dart';
import '../../../core/outils/format.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/communs.dart';
import '../models/declaration.dart';
import '../providers/paiements_providers.dart';
import '../widgets/carte_paiement.dart';

/// Onglet Paiements : file hors ligne, déclarations à traiter, historique.
class EcranPaiements extends ConsumerWidget {
  const EcranPaiements({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final file = ref.watch(fileEnAttenteProvider).value ?? const <PaiementEnAttente>[];
    final declarations = ref.watch(declarationsProvider).value?.elements ?? const <Declaration>[];
    final paiements = ref.watch(paiementsProvider);

    Future<void> rafraichir() async {
      await ref.read(filePaiementsProvider).synchroniser();
      ref.invalidate(declarationsProvider);
      ref.invalidate(paiementsProvider);
    }

    return Scaffold(
      appBar: AppBar(leading: const BoutonMenu(), title: Text(l.paiementsTitre), actions: [
        if (file.isNotEmpty) IconButton(tooltip: l.actionSynchroniser, onPressed: rafraichir, icon: const Icon(Icons.sync)),
      ]),
      body: RefreshIndicator(
        onRefresh: rafraichir,
        child: ListView(padding: const EdgeInsets.only(bottom: 32), children: [
          if (file.isNotEmpty) ...[
            _Section(l.paiementsFileTitre),
            for (final p in file) _LigneFile(paiement: p),
          ],
          if (declarations.isNotEmpty) ...[
            _Section(l.paiementsDeclarations),
            for (final d in declarations) _LigneDeclaration(declaration: d),
          ],
          VueAsync(
            valeur: paiements,
            reessayer: () => ref.invalidate(paiementsProvider),
            donnees: (lecture) => Column(children: [
              if (lecture.depuisCache) ListTile(leading: const Icon(Icons.wifi_off), title: Text(l.horsLigne)),
              if (lecture.valeur.elements.isEmpty && file.isEmpty) EtatVide(message: l.listeVide, icone: Icons.receipt_long_outlined),
              for (final p in lecture.valeur.elements)
                CartePaiement(paiement: p, peutAnnuler: true, apresAnnulation: () => ref.invalidate(paiementsProvider)),
            ]),
          ),
        ]),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section(this.titre);
  final String titre;

  @override
  Widget build(BuildContext context) =>
      Padding(padding: const EdgeInsets.fromLTRB(16, 16, 16, 4), child: Text(titre, style: Theme.of(context).textTheme.titleSmall));
}

/// R-136 : « reçu provisoire » non envoyé au locataire, supprimable (R-36).
class _LigneFile extends ConsumerWidget {
  const _LigneFile({required this.paiement});
  final PaiementEnAttente paiement;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final rejete = paiement.etat == 'rejete';
    return Card(
      color: rejete ? Theme.of(context).colorScheme.errorContainer : null,
      child: ListTile(
        leading: Icon(rejete ? Icons.error_outline : Icons.schedule, color: rejete ? ThemeCdl.retard : ThemeCdl.attente),
        title: Text('${Format.montant(paiement.montant, paiement.devise)} · ${paiement.libelle}'),
        subtitle: Text(rejete ? l.paiementsRejete(paiement.motifRejet ?? '') : l.recuProvisoire),
        trailing: IconButton(
          tooltip: l.actionSupprimer,
          icon: const Icon(Icons.delete_outline),
          onPressed: () => ref.read(filePaiementsProvider).supprimer(paiement.id),
        ),
      ),
    );
  }
}

/// R-40 : validation ou refus motivé par le bailleur.
class _LigneDeclaration extends ConsumerWidget {
  const _LigneDeclaration({required this.declaration});
  final Declaration declaration;

  Future<void> _agir(BuildContext context, WidgetRef ref, bool valider) async {
    final l = context.l10n;
    final service = ref.read(paiementsServiceProvider);
    try {
      if (valider) {
        await service.validerDeclaration(declaration.id);
      } else {
        final motif = TextEditingController();
        final ok = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(l.declarationRefuser),
            content: TextField(controller: motif, autofocus: true, decoration: InputDecoration(labelText: l.declarationMotifRefus)),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l.actionFermer)),
              FilledButton(onPressed: () => Navigator.pop(ctx, motif.text.trim().isNotEmpty), child: Text(l.actionValider)),
            ],
          ),
        );
        if (ok != true) return;
        await service.refuserDeclaration(declaration.id, motif.text.trim());
      }
      ref.invalidate(declarationsProvider);
      ref.invalidate(paiementsProvider);
    } catch (e) {
      if (context.mounted) afficherErreur(context, e);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final d = declaration;
    return Card(
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        ListTile(
          leading: const Icon(Icons.mark_email_unread_outlined),
          title: Text('${Format.montant(d.montant, d.devise)} · ${d.locataire}'),
          subtitle: Text([d.unite, Format.date(d.datePaiement), if (d.reference != null) d.reference!].join(' · ')),
        ),
        OverflowBar(alignment: MainAxisAlignment.end, children: [
          TextButton(onPressed: () => _agir(context, ref, false), child: Text(l.declarationRefuser)),
          FilledButton.tonal(onPressed: () => _agir(context, ref, true), child: Text(l.declarationValider)),
          const SizedBox(width: 8),
        ]),
      ]),
    );
  }
}
