import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/session/fournisseurs.dart';
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

  Future<void> _changerTelephone(BuildContext context, WidgetRef ref, String actuel) async {
    final l = context.l10n;
    final telephone = TextEditingController(text: actuel);
    final code = TextEditingController();
    var occupe = false;
    final route = DialogRoute<void>(context: context, builder: (ctx) => StatefulBuilder(builder: (ctx, modifier) => AlertDialog(
      title: Text(l.profilChangerTelephone),
      content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text(l.profilTelephoneAide),
        TextField(key: const Key('nouveauTelephone'), controller: telephone, keyboardType: TextInputType.phone, enabled: !occupe, decoration: InputDecoration(labelText: l.authChampTelephone)),
        TextButton(
          onPressed: occupe ? null : () async {
            modifier(() => occupe = true);
            try {
              await ref.read(authServiceProvider).demanderCode(telephone.text.trim());
              if (ctx.mounted) afficherMessage(ctx, l.profilCodeEnvoye);
            } catch (e) {
              if (ctx.mounted) afficherErreur(ctx, e);
            } finally {
              if (ctx.mounted) modifier(() => occupe = false);
            }
          },
          child: Text(l.profilEnvoyerCode),
        ),
        TextField(key: const Key('codeNouveauTelephone'), controller: code, keyboardType: TextInputType.number, enabled: !occupe, maxLength: 6, decoration: InputDecoration(labelText: l.authChampCode)),
      ])),
      actions: [
        TextButton(onPressed: occupe ? null : () => Navigator.pop(ctx), child: Text(l.actionFermer)),
        FilledButton(onPressed: occupe ? null : () async {
          modifier(() => occupe = true);
          try {
            await ref.read(authServiceProvider).changerTelephone(telephone.text.trim(), code.text.trim());
            await ref.read(lecteurProvider).effacer('/moi');
            ref.invalidate(lecteurProvider);
            ref.invalidate(profilProvider);
            if (ctx.mounted) Navigator.pop(ctx);
          } catch (e) {
            if (ctx.mounted) afficherErreur(ctx, e);
          } finally {
            if (ctx.mounted) modifier(() => occupe = false);
          }
        }, child: Text(l.actionValider)),
      ],
    )));
    await Navigator.of(context).push(route);
    await route.completed;
    telephone.dispose();
    code.dispose();
  }

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
          ListTile(leading: const Icon(Icons.phone_outlined), title: Text(l.profilChangerTelephone), onTap: () => _changerTelephone(context, ref, p.telephone ?? '')),
          if (p.pays != null) ListTile(leading: const Icon(Icons.public), title: Text(p.pays!.nom)),
          if (p.espaceBailleur != null) ListTile(leading: const Icon(Icons.business_outlined), title: Text(p.espaceBailleur!.nomAffiche), subtitle: Text(p.espaceBailleur!.badge ?? '')),
        ]),
      ),
    );
  }
}
