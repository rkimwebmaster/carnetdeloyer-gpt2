import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/navigation/coquille.dart';
import '../../../core/modeles/modeles.dart';
import '../../../core/outils/format.dart';
import '../../../core/session/session.dart';
import '../../../core/widgets/communs.dart';

/// R-107 : vitrine Market (annonces des unités vacantes), sans photo en liste (R-84).
final annoncesProvider = FutureProvider.autoDispose<PageApi<Map<String, dynamic>>>(
  (ref) async => PageApi.depuis(await ref.watch(clientApiProvider).get('/market/annonces'), (j) => j),
);

class EcranMarket extends ConsumerWidget {
  const EcranMarket({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(leading: const BoutonMenu(), title: Text(l.marketTitre)),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(annoncesProvider.future),
        child: VueAsync(
          valeur: ref.watch(annoncesProvider),
          reessayer: () => ref.invalidate(annoncesProvider),
          donnees: (page) {
            if (page.elements.isEmpty) return ListView(children: [EtatVide(message: l.marketVide, icone: Icons.storefront_outlined)]);
            return ListView(children: [
              for (final a in page.elements)
                Card(
                  child: ListTile(
                    leading: Icon(iconeCategorie((a['categorie'] as Map)['icone'] as String)),
                    title: Text(a['titre'] as String),
                    subtitle: Text([
                      (a['zone'] as Map).values.whereType<String>().join(', '),
                      if (a['prix'] != null) Format.montant((a['prix'] as Map)['montant'] as int, (a['prix'] as Map)['devise'] as String),
                      if (a['description'] != null) a['description'] as String,
                    ].join('\n')),
                    isThreeLine: true,
                    trailing: IconButton(
                      tooltip: l.marketContacter,
                      icon: const Icon(Icons.call_outlined),
                      onPressed: () async {
                        try {
                          final c = await ref.read(clientApiProvider).post('/market/annonces/${a['id']}/contact') as Map;
                          await launchUrl(Uri.parse('https://wa.me/${(c['telephone'] as String).replaceAll('+', '')}'), mode: LaunchMode.externalApplication);
                        } catch (e) {
                          if (context.mounted) afficherErreur(context, e);
                        }
                      },
                    ),
                  ),
                ),
            ]);
          },
        ),
      ),
    );
  }
}
