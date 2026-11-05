import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/widgets/communs.dart';
import '../providers/auth_providers.dart';

/// R-160 : inscription en moins d'une minute — étape 1, le téléphone.
class EcranTelephone extends ConsumerStatefulWidget {
  const EcranTelephone({super.key});

  @override
  ConsumerState<EcranTelephone> createState() => _EcranTelephoneState();
}

class _EcranTelephoneState extends ConsumerState<EcranTelephone> {
  final _champ = TextEditingController(text: '+243');
  bool _envoi = false;

  @override
  void dispose() {
    _champ.dispose();
    super.dispose();
  }

  Future<void> _continuer() async {
    final telephone = _champ.text.replaceAll(RegExp(r'[\s\-.()]'), '');
    setState(() => _envoi = true);
    try {
      await ref.read(authServiceProvider).demanderCode(telephone);
      if (mounted) context.push('/auth/code', extra: telephone);
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
      body: SafeArea(
        child: ListView(padding: const EdgeInsets.all(24), children: [
          const SizedBox(height: 32),
          Icon(Icons.menu_book_rounded, size: 56, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 16),
          Text(l.nomApp, textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 32),
          Text(l.authTitreTelephone, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          TextField(
            key: const Key('champTelephone'),
            controller: _champ,
            keyboardType: TextInputType.phone,
            autofillHints: const [AutofillHints.telephoneNumber],
            decoration: InputDecoration(labelText: l.authChampTelephone, helperText: l.authAideTelephone),
            onSubmitted: (_) => _continuer(),
          ),
          const SizedBox(height: 24),
          FilledButton(onPressed: _envoi ? null : _continuer, child: Text(l.actionContinuer)),
        ]),
      ),
    );
  }
}
