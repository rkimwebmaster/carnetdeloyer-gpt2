import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/navigation/coquille.dart';
import '../../../core/outils/format.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/communs.dart';
import '../../contrats/screens/ecran_contrat.dart';
import '../providers/locations_providers.dart';
import '../services/locations_service.dart';

/// Mode locataire : mes contrats, avec rattachement des contrats créés à mon numéro.
class EcranLocations extends ConsumerWidget {
  const EcranLocations({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final rattachements = ref.watch(rattachementsProvider).value ?? const <Rattachement>[];
    final locations = ref.watch(mesLocationsProvider);

    return Scaffold(
      appBar: AppBar(leading: const BoutonMenu(), title: Text(l.locationsTitre)),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(rattachementsProvider);
          ref.invalidate(mesLocationsProvider);
        },
        child: ListView(padding: const EdgeInsets.only(bottom: 32), children: [
          if (rattachements.isNotEmpty) ...[
            Padding(padding: const EdgeInsets.fromLTRB(16, 16, 16, 4), child: Text(l.locationsARattacher, style: Theme.of(context).textTheme.titleSmall)),
            for (final r in rattachements)
              Card(
                child: ListTile(
                  title: Text(r.bailleur),
                  subtitle: Text(r.unites.join('\n')),
                  trailing: FilledButton.tonal(
                    onPressed: () async {
                      try {
                        await ref.read(locationsServiceProvider).rattacher(r.contactId);
                        ref.invalidate(rattachementsProvider);
                        ref.invalidate(mesLocationsProvider);
                      } catch (e) {
                        if (context.mounted) afficherErreur(context, e);
                      }
                    },
                    child: Text(l.locationsRattacher),
                  ),
                ),
              ),
          ],
          VueAsync(
            valeur: locations,
            reessayer: () => ref.invalidate(mesLocationsProvider),
            donnees: (lecture) {
              final liste = lecture.valeur.elements;
              if (liste.isEmpty && rattachements.isEmpty) return EtatVide(message: l.locationsAucune, icone: Icons.home_outlined);
              return Column(children: [
                for (final c in liste)
                  Card(
                    child: ListTile(
                      leading: Icon(iconeCategorie(c.unite.categorie.icone)),
                      title: Text('${c.unite.nom} · ${c.bailleur.nom}'),
                      subtitle: Text(c.statut != 'actif'
                          ? l.contratCloture
                          : c.enRetard > 0
                              ? l.contratEnRetard(Format.montantDevise(c.enRetard, c.devise))
                              : l.contratAJour),
                      trailing: c.enRetard > 0 ? const Icon(Icons.warning_amber, color: ThemeCdl.retard) : const Icon(Icons.chevron_right),
                      onTap: () => context.push('/l/locations/${c.id}'),
                    ),
                  ),
              ]);
            },
          ),
        ]),
      ),
    );
  }
}

/// Détail d'un contrat côté locataire, avec « J'ai payé » (R-39).
class EcranMaLocation extends ConsumerWidget {
  const EcranMaLocation({super.key, required this.id});
  final int id;

  Future<void> _declarer(BuildContext context, WidgetRef ref, int decimales, String symbole) async {
    final l = context.l10n;
    final montant = TextEditingController();
    final reference = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.declarerTitre),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(l.declarerAide),
          const SizedBox(height: 12),
          TextField(controller: montant, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: InputDecoration(labelText: l.encaisserMontant, suffixText: symbole)),
          const SizedBox(height: 12),
          TextField(controller: reference, decoration: InputDecoration(labelText: l.encaisserReference)),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l.actionFermer)),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l.actionValider)),
        ],
      ),
    );
    final valeur = Format.versMineur(montant.text, decimales);
    if (ok != true || valeur == null || valeur <= 0) return;
    try {
      await ref.read(locationsServiceProvider).declarer(id,
          montant: valeur, datePaiement: Format.dateIso(DateTime.now()), reference: reference.text.trim().isEmpty ? null : reference.text.trim());
      if (context.mounted) afficherMessage(context, l.declarerEnvoyee);
      ref.invalidate(maLocationProvider(id));
    } catch (e) {
      if (context.mounted) afficherErreur(context, e);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final valeur = ref.watch(maLocationProvider(id)).whenData((lecture) => lecture.valeur);
    final c = valeur.value;
    return Stack(children: [
      EcranContrat(id: id, vue: valeur),
      if (c != null && c.statut == 'actif')
        Positioned(
          right: 16,
          bottom: 16,
          child: SafeArea(
            child: FloatingActionButton.extended(
              key: const Key('jaiPaye'),
              onPressed: () => _declarer(context, ref, c.devise.decimales, c.devise.symbole),
              icon: const Icon(Icons.outbox_outlined),
              label: Text(context.l10n.declarerTitre),
            ),
          ),
        ),
    ]);
  }
}
