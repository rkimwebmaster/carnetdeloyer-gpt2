import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/navigation/coquille.dart';
import '../../../core/widgets/communs.dart';
import '../providers/biens_providers.dart';

/// Onglet Biens (mode bailleur).
class EcranBiens extends ConsumerWidget {
  const EcranBiens({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final proprietes = ref.watch(proprietesProvider);
    return Scaffold(
      appBar: AppBar(leading: const BoutonMenu(), title: Text(l.biensTitre)),
      floatingActionButton: FloatingActionButton.extended(
        key: const Key('ajouterPropriete'),
        onPressed: () => context.push('/b/biens/nouvelle'),
        icon: const Icon(Icons.add),
        label: Text(l.biensAjouter),
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(proprietesProvider.future),
        child: VueAsync(
          valeur: proprietes,
          reessayer: () => ref.invalidate(proprietesProvider),
          donnees: (lecture) {
            final liste = lecture.valeur.elements;
            if (liste.isEmpty) return ListView(children: [EtatVide(message: l.biensAucun, icone: Icons.home_work_outlined)]);
            return ListView.builder(
              padding: const EdgeInsets.only(bottom: 96),
              itemCount: liste.length + (lecture.depuisCache ? 1 : 0),
              itemBuilder: (context, i) {
                if (lecture.depuisCache && i == 0) return ListTile(leading: const Icon(Icons.wifi_off), title: Text(l.horsLigne));
                final p = liste[i - (lecture.depuisCache ? 1 : 0)];
                return Card(
                  child: ListTile(
                    leading: Icon(p.type == 'simple' ? Icons.house_outlined : Icons.apartment_outlined),
                    title: Text(p.nom),
                    subtitle: Text([if (p.quartier != null) p.quartier!, l.biensNombreUnites(p.nombreUnites)].join(' · ')),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push('/b/biens/proprietes/${p.id}'),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
