import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/outils/format.dart';
import '../../../core/session/fournisseurs.dart';
import '../../../core/widgets/communs.dart';

/// R-147 : soldes par espace et total, en USD ; journal d'écritures.
final walletProvider = FutureProvider.autoDispose<Map<String, dynamic>>(
  (ref) async => (await ref.watch(lecteurProvider).lire('/wallet', (j) => j as Map<String, dynamic>)).valeur,
);

class EcranWallet extends ConsumerWidget {
  const EcranWallet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.walletTitre)),
      body: VueAsync(
        valeur: ref.watch(walletProvider),
        reessayer: () => ref.invalidate(walletProvider),
        donnees: (w) {
          final soldes = w['soldes'] as Map;
          final ecritures = ((w['ecritures'] as Map)['elements'] as List).cast<Map>();
          return ListView(children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(l.walletTotal),
                  Text(Format.montant(w['total'] as int, 'USD'), style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 8),
                  Text('${l.walletBailleur} : ${Format.montant(soldes['bailleur'] as int, 'USD')}'),
                  Text('${l.walletLocataire} : ${Format.montant(soldes['locataire'] as int, 'USD')}'),
                  if (w['utilisable'] != true) ...[
                    const SizedBox(height: 8),
                    Text(l.walletSeuil(Format.montant(w['seuil'] as int, 'USD')), style: Theme.of(context).textTheme.bodySmall),
                  ],
                ]),
              ),
            ),
            for (final e in ecritures)
              ListTile(
                leading: Icon(e['sens'] == 'credit' ? Icons.add_circle_outline : Icons.remove_circle_outline),
                title: Text('${e['sens'] == 'credit' ? '+' : '−'} ${Format.montant(e['montant'] as int, 'USD')}'),
                subtitle: Text('${e['motif']} · ${Format.date((e['creeLe'] as String).substring(0, 10))}'),
              ),
          ]);
        },
      ),
    );
  }
}
