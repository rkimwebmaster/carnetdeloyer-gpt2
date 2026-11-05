import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/session/session.dart';

/// Pavé de saisie d'un code PIN (4 à 6 chiffres).
class _ChampPin extends StatelessWidget {
  const _ChampPin({required this.controleur, required this.onValider, this.erreur});
  final TextEditingController controleur;
  final VoidCallback onValider;
  final String? erreur;

  @override
  Widget build(BuildContext context) => TextField(
        key: const Key('champPin'),
        controller: controleur,
        autofocus: true,
        obscureText: true,
        keyboardType: TextInputType.number,
        maxLength: 6,
        textAlign: TextAlign.center,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: const TextStyle(fontSize: 28, letterSpacing: 16),
        decoration: InputDecoration(counterText: '', errorText: erreur),
        onSubmitted: (_) => onValider(),
      );
}

/// Création du PIN juste après l'inscription ou sur un nouvel appareil (R-160, R-71).
class EcranCreationPin extends ConsumerStatefulWidget {
  const EcranCreationPin({super.key});

  @override
  ConsumerState<EcranCreationPin> createState() => _EcranCreationPinState();
}

class _EcranCreationPinState extends ConsumerState<EcranCreationPin> {
  final _champ = TextEditingController();
  String? _premier;
  String? _erreur;

  @override
  void dispose() {
    _champ.dispose();
    super.dispose();
  }

  Future<void> _valider() async {
    final pin = _champ.text;
    if (pin.length < 4) return;
    if (_premier == null) {
      setState(() {
        _premier = pin;
        _erreur = null;
        _champ.clear();
      });
      return;
    }
    if (pin != _premier) {
      setState(() {
        _premier = null;
        _erreur = context.l10n.authPinDifferent;
        _champ.clear();
      });
      return;
    }
    await ref.read(sessionProvider.notifier).creerPin(pin);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      body: SafeArea(
        child: ListView(padding: const EdgeInsets.all(24), children: [
          const SizedBox(height: 48),
          Text(_premier == null ? l.authTitrePinCreation : l.authTitrePinConfirmation,
              textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(l.authAidePinCreation, textAlign: TextAlign.center),
          const SizedBox(height: 24),
          _ChampPin(controleur: _champ, onValider: _valider, erreur: _erreur),
          const SizedBox(height: 24),
          FilledButton(key: const Key('validerPin'), onPressed: _valider, child: Text(l.actionValider)),
        ]),
      ),
    );
  }
}

/// R-141 : PIN ou biométrie déverrouillent l'app sans réseau.
class EcranVerrou extends ConsumerStatefulWidget {
  const EcranVerrou({super.key, this.biometrie});

  /// Remplaçable en test.
  final LocalAuthentication? biometrie;

  @override
  ConsumerState<EcranVerrou> createState() => _EcranVerrouState();
}

class _EcranVerrouState extends ConsumerState<EcranVerrou> {
  final _champ = TextEditingController();
  String? _erreur;
  bool _biometrieDisponible = false;

  @override
  void initState() {
    super.initState();
    _verifierBiometrie();
  }

  @override
  void dispose() {
    _champ.dispose();
    super.dispose();
  }

  LocalAuthentication get _auth => widget.biometrie ?? LocalAuthentication();

  Future<void> _verifierBiometrie() async {
    try {
      final ok = await _auth.canCheckBiometrics && await _auth.isDeviceSupported();
      if (mounted) setState(() => _biometrieDisponible = ok);
    } catch (_) {
      // Pas de biométrie (desktop, émulateur) : PIN seul.
    }
  }

  Future<void> _biometrieDemandee() async {
    try {
      final ok = await _auth.authenticate(localizedReason: context.l10n.authRaisonBiometrie);
      if (ok) ref.read(sessionProvider.notifier).deverrouillerParBiometrie();
    } catch (_) {}
  }

  Future<void> _valider() async {
    if (_champ.text.length < 4) return;
    final notifier = ref.read(sessionProvider.notifier);
    final ok = await notifier.deverrouiller(_champ.text);
    if (!ok && mounted) {
      setState(() {
        _erreur = context.l10n.authPinIncorrect(ref.read(sessionProvider).essaisRestants);
        _champ.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      body: SafeArea(
        child: ListView(padding: const EdgeInsets.all(24), children: [
          const SizedBox(height: 48),
          Icon(Icons.lock_outline, size: 48, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 16),
          Text(l.authTitreVerrou, textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 24),
          _ChampPin(controleur: _champ, onValider: _valider, erreur: _erreur),
          const SizedBox(height: 24),
          FilledButton(key: const Key('validerPin'), onPressed: _valider, child: Text(l.actionValider)),
          if (_biometrieDisponible)
            TextButton.icon(onPressed: _biometrieDemandee, icon: const Icon(Icons.fingerprint), label: Text(l.authBiometrie)),
          TextButton(onPressed: () => ref.read(sessionProvider.notifier).deconnecter(), child: Text(l.authSeDeconnecter)),
        ]),
      ),
    );
  }
}
