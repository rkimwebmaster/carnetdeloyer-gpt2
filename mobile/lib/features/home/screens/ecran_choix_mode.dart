import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/session/mode_actif.dart';

/// R-161 : à la première connexion, une seule étape obligatoire : le mode par défaut.
class EcranChoixMode extends ConsumerWidget {
  const EcranChoixMode({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    Widget carte(ModeActif mode, IconData icone, String titre, String aide) => Card(
          child: ListTile(
            key: Key('mode_${mode.name}'),
            contentPadding: const EdgeInsets.all(16),
            leading: Icon(icone, size: 32),
            title: Text(titre),
            subtitle: Text(aide),
            onTap: () => ref.read(modeProvider.notifier).definir(mode),
          ),
        );

    return Scaffold(
      body: SafeArea(
        child: ListView(padding: const EdgeInsets.symmetric(vertical: 48), children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(l.modeTitreChoix, style: Theme.of(context).textTheme.titleLarge),
          ),
          Padding(padding: const EdgeInsets.fromLTRB(24, 8, 24, 24), child: Text(l.modeAideChoix)),
          carte(ModeActif.bailleur, Icons.key_outlined, l.modeBailleur, l.modeBailleurAide),
          carte(ModeActif.locataire, Icons.home_outlined, l.modeLocataire, l.modeLocataireAide),
        ]),
      ),
    );
  }
}
