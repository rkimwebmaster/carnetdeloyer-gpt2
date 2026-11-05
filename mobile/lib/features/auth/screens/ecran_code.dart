import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/session/session.dart';
import '../../../core/widgets/communs.dart';
import '../providers/auth_providers.dart';

/// R-71 : code OTP reçu par SMS.
class EcranCode extends ConsumerStatefulWidget {
  const EcranCode({super.key, required this.telephone});
  final String telephone;

  @override
  ConsumerState<EcranCode> createState() => _EcranCodeState();
}

class _EcranCodeState extends ConsumerState<EcranCode> {
  final _champ = TextEditingController();
  bool _envoi = false;

  @override
  void dispose() {
    _champ.dispose();
    super.dispose();
  }

  Future<void> _valider() async {
    if (_champ.text.length != 6) return;
    setState(() => _envoi = true);
    try {
      final r = await ref.read(authServiceProvider).verifier(widget.telephone, _champ.text);
      if (!mounted) return;
      if (r.jetons != null) {
        await ref.read(sessionProvider.notifier).connecter(r.jetons!);
      } else {
        context.pushReplacement('/auth/inscription', extra: (widget.telephone, r.jetonInscription!));
      }
    } catch (e) {
      if (mounted) afficherErreur(context, e);
    } finally {
      if (mounted) setState(() => _envoi = false);
    }
  }

  Future<void> _renvoyer() async {
    try {
      await ref.read(authServiceProvider).demanderCode(widget.telephone);
    } catch (e) {
      if (mounted) afficherErreur(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(),
      body: ListView(padding: const EdgeInsets.all(24), children: [
        Text(l.authTitreCode, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(l.authAideCode(widget.telephone)),
        const SizedBox(height: 24),
        TextField(
          key: const Key('champCode'),
          controller: _champ,
          keyboardType: TextInputType.number,
          maxLength: 6,
          autofillHints: const [AutofillHints.oneTimeCode],
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 28, letterSpacing: 12),
          decoration: InputDecoration(labelText: l.authChampCode, counterText: ''),
          onChanged: (v) {
            if (v.length == 6) _valider();
          },
        ),
        const SizedBox(height: 24),
        FilledButton(onPressed: _envoi ? null : _valider, child: Text(l.actionValider)),
        TextButton(onPressed: _renvoyer, child: Text(l.authRenvoyer)),
      ]),
    );
  }
}
