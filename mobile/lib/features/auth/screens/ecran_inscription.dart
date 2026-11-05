import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/session/session.dart';
import '../../../core/widgets/communs.dart';
import '../providers/auth_providers.dart';

/// R-160 : nom, puis code parrain facultatif. Le reste du profil se complète plus tard.
class EcranInscription extends ConsumerStatefulWidget {
  const EcranInscription({super.key, required this.telephone, required this.jeton});
  final String telephone;
  final String jeton;

  @override
  ConsumerState<EcranInscription> createState() => _EcranInscriptionState();
}

class _EcranInscriptionState extends ConsumerState<EcranInscription> {
  final _nom = TextEditingController();
  final _parrain = TextEditingController();
  bool _envoi = false;

  @override
  void dispose() {
    _nom.dispose();
    _parrain.dispose();
    super.dispose();
  }

  Future<void> _valider() async {
    if (_nom.text.trim().length < 2) return;
    setState(() => _envoi = true);
    try {
      final jetons = await ref.read(authServiceProvider).inscrire(
            telephone: widget.telephone,
            jeton: widget.jeton,
            nom: _nom.text.trim(),
            codeParrain: _parrain.text,
          );
      await ref.read(sessionProvider.notifier).connecter(jetons);
    } catch (e) {
      if (mounted) afficherErreur(context, e);
    } finally {
      if (mounted) setState(() => _envoi = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(),
      body: ListView(padding: const EdgeInsets.all(24), children: [
        Text(l.authTitreInscription, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 24),
        TextField(
          key: const Key('champNom'),
          controller: _nom,
          textCapitalization: TextCapitalization.words,
          autofillHints: const [AutofillHints.name],
          decoration: InputDecoration(labelText: l.authChampNom),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _parrain,
          textCapitalization: TextCapitalization.characters,
          decoration: InputDecoration(labelText: l.authChampParrain),
        ),
        const SizedBox(height: 24),
        FilledButton(onPressed: _envoi ? null : _valider, child: Text(l.actionContinuer)),
      ]),
    );
  }
}
