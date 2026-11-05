import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/modeles/modeles.dart';
import '../../../core/outils/format.dart';
import '../../../core/widgets/communs.dart';
import '../providers/biens_providers.dart';

class EcranPropriete extends ConsumerWidget {
  const EcranPropriete({super.key, required this.id});
  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final valeur = ref.watch(proprieteProvider(id));
    return Scaffold(
      appBar: AppBar(title: Text(valeur.value?.valeur.nom ?? '')),
      body: VueAsync(
        valeur: valeur,
        reessayer: () => ref.invalidate(proprieteProvider(id)),
        donnees: (lecture) => RefreshIndicator(
          onRefresh: () => ref.refresh(proprieteProvider(id).future),
          child: ListView(padding: const EdgeInsets.only(bottom: 32), children: [
            if (lecture.valeur.quartier != null || lecture.valeur.adresse != null)
              ListTile(
                leading: const Icon(Icons.place_outlined),
                title: Text([lecture.valeur.adresse, lecture.valeur.quartier].whereType<String>().join(', ')),
              ),
            for (final unite in lecture.valeur.unites) _CarteUnite(unite: unite, proprieteId: id),
          ]),
        ),
      ),
    );
  }
}

class _CarteUnite extends ConsumerWidget {
  const _CarteUnite({required this.unite, required this.proprieteId});
  final Unite unite;
  final int proprieteId;

  Future<void> _publication(BuildContext context, WidgetRef ref) async {
    final service = ref.read(biensServiceProvider);
    try {
      if (unite.publieeMarket) {
        await service.retirer(unite.id);
      } else {
        await service.publier(unite.id, null);
      }
      ref.invalidate(proprieteProvider(proprieteId));
    } catch (e) {
      if (context.mounted) afficherErreur(context, e);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final loyer = unite.loyerIndicatif;
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          ListTile(
            leading: Icon(iconeCategorie(unite.categorie.icone)),
            title: Text(unite.nom),
            subtitle: Text([
              unite.vacante ? l.biensVacante : l.biensLouee(unite.locataire ?? ''),
              if (loyer != null && loyer.devise != null) Format.montant(loyer.montant, loyer.devise!),
              if (unite.publieeMarket) l.biensPubliee,
            ].join(' · ')),
            onTap: unite.contratActifId == null ? null : () => context.push('/b/contrats/${unite.contratActifId}'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Wrap(spacing: 8, children: [
              if (unite.vacante && !unite.categorie.hotel)
                TextButton.icon(
                  onPressed: () => context.push('/b/contrats/nouveau?uniteId=${unite.id}'),
                  icon: const Icon(Icons.description_outlined),
                  label: Text(l.biensLouer),
                ),
              if (unite.vacante && !unite.categorie.hotel)
                TextButton.icon(
                  onPressed: () => _publication(context, ref),
                  icon: Icon(unite.publieeMarket ? Icons.visibility_off_outlined : Icons.campaign_outlined),
                  label: Text(unite.publieeMarket ? l.biensRetirer : l.biensPublier),
                ),
              if (!unite.vacante && unite.contratActifId != null)
                TextButton.icon(
                  onPressed: () => context.push('/b/contrats/${unite.contratActifId}/encaisser'),
                  icon: const Icon(Icons.payments_outlined),
                  label: Text(l.encaisserBouton),
                ),
            ]),
          ),
        ]),
      ),
    );
  }
}
