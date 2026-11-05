import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/widgets/communs.dart';
import '../../auth/providers/auth_providers.dart';

class EcranParrainage extends ConsumerWidget {
  const EcranParrainage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.parrainageTitre)),
      body: VueAsync(
        valeur: ref.watch(profilProvider),
        donnees: (p) => ListView(padding: const EdgeInsets.all(24), children: [
          Text(l.parrainageAide),
          const SizedBox(height: 24),
          Text(l.parrainageCode, textAlign: TextAlign.center),
          SelectableText(p.codeParrainage, textAlign: TextAlign.center, style: Theme.of(context).textTheme.displaySmall),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () => Clipboard.setData(ClipboardData(text: p.codeParrainage)),
            icon: const Icon(Icons.copy),
            label: Text(l.actionPartager),
          ),
        ]),
      ),
    );
  }
}

class EcranProfil extends ConsumerWidget {
  const EcranProfil({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.profilTitre)),
      body: VueAsync(
        valeur: ref.watch(profilProvider),
        reessayer: () => ref.invalidate(profilProvider),
        donnees: (p) => ListView(children: [
          ListTile(leading: const Icon(Icons.person_outline), title: Text(p.nom), subtitle: Text(p.telephone ?? '')),
          if (p.pays != null) ListTile(leading: const Icon(Icons.public), title: Text(p.pays!.nom)),
          if (p.espaceBailleur != null) ListTile(leading: const Icon(Icons.business_outlined), title: Text(p.espaceBailleur!.nomAffiche), subtitle: Text(p.espaceBailleur!.badge ?? '')),
        ]),
      ),
    );
  }
}
