import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/navigation/coquille.dart';
import '../../../core/modeles/modeles.dart';
import '../../../core/outils/format.dart';
import '../../../core/session/session.dart';
import '../../../core/widgets/communs.dart';

/// R-97 : vitrine des hôtels (position exacte, prix, contact).
final hotelsProvider = FutureProvider.autoDispose<PageApi<Map<String, dynamic>>>(
  (ref) async => PageApi.depuis(await ref.watch(clientApiProvider).get('/hotels'), (j) => j),
);

class EcranHotels extends ConsumerWidget {
  const EcranHotels({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(leading: const BoutonMenu(), title: Text(l.hotelsTitre)),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(hotelsProvider.future),
        child: VueAsync(
          valeur: ref.watch(hotelsProvider),
          reessayer: () => ref.invalidate(hotelsProvider),
          donnees: (page) {
            if (page.elements.isEmpty) return ListView(children: [EtatVide(message: l.hotelsVide, icone: Icons.hotel_outlined)]);
            return ListView(children: [
              for (final h in page.elements)
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.hotel_outlined),
                    title: Text(h['nom'] as String),
                    subtitle: Text([
                      [h['quartier'], h['ville']].whereType<String>().join(', '),
                      if (h['prixParNuitDes'] != null)
                        l.hotelsDes(Format.montant((h['prixParNuitDes'] as Map)['montant'] as int, (h['prixParNuitDes'] as Map)['devise'] as String)),
                    ].join('\n')),
                    trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                      if (h['latitude'] != null)
                        IconButton(
                          icon: const Icon(Icons.map_outlined),
                          onPressed: () => launchUrl(Uri.parse('https://www.google.com/maps/search/?api=1&query=${h['latitude']},${h['longitude']}'), mode: LaunchMode.externalApplication),
                        ),
                      IconButton(
                        icon: const Icon(Icons.call_outlined),
                        onPressed: () => launchUrl(Uri.parse('tel:${(h['contact'] as Map)['telephone']}')),
                      ),
                    ]),
                  ),
                ),
            ]);
          },
        ),
      ),
    );
  }
}
