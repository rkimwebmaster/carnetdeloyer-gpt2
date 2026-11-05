import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/modeles/modeles.dart';
import '../../../core/outils/format.dart';
import '../../../core/widgets/communs.dart';
import '../../biens/providers/biens_providers.dart';
import '../providers/contrats_providers.dart';

/// Création d'un contrat : devise et loyer pré-remplis (R-16, R-17).
class EcranNouveauContrat extends ConsumerStatefulWidget {
  const EcranNouveauContrat({super.key, required this.uniteId});
  final int uniteId;

  @override
  ConsumerState<EcranNouveauContrat> createState() => _EcranNouveauContratState();
}

class _EcranNouveauContratState extends ConsumerState<EcranNouveauContrat> {
  final _formulaire = GlobalKey<FormState>();
  final _nom = TextEditingController();
  final _telephone = TextEditingController(text: '+243');
  final _loyer = TextEditingController();
  final _garantie = TextEditingController();
  Devise? _devise;
  DateTime _debut = DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime? _fin;
  bool _envoi = false;

  @override
  void initState() {
    super.initState();
    _preRemplir();
  }

  @override
  void dispose() {
    for (final c in [_nom, _telephone, _loyer, _garantie]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _preRemplir() async {
    try {
      final p = await ref.read(contratsServiceProvider).proposition(widget.uniteId);
      if (!mounted) return;
      setState(() {
        _devise = p.devise;
        if (p.loyer != null && p.devise != null) _loyer.text = Format.versSaisie(p.loyer!, p.devise!.decimales);
      });
    } catch (_) {
      // Pré-remplissage facultatif.
    }
  }

  Future<void> _choisirDate({required bool debut}) async {
    final d = await showDatePicker(
      context: context,
      initialDate: debut ? _debut : (_fin ?? _debut.add(const Duration(days: 365))),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (d != null) setState(() => debut ? _debut = d : _fin = d);
  }

  Future<void> _enregistrer() async {
    if (!_formulaire.currentState!.validate() || _devise == null) return;
    setState(() => _envoi = true);
    try {
      final telephone = _telephone.text.replaceAll(RegExp(r'[\s\-.()]'), '');
      final c = await ref.read(contratsServiceProvider).creer(
            uniteId: widget.uniteId,
            locataireNom: _nom.text.trim(),
            locataireTelephone: telephone.length > 5 ? telephone : null,
            devise: _devise!.code,
            loyer: Format.versMineur(_loyer.text, _devise!.decimales)!,
            dateDebut: Format.dateIso(_debut),
            dateFin: _fin == null ? null : Format.dateIso(_fin!),
            garantie: _garantie.text.trim().isEmpty ? 0 : Format.versMineur(_garantie.text, _devise!.decimales) ?? 0,
          );
      ref.invalidate(proprietesProvider);
      if (mounted) context.pushReplacement('/b/contrats/${c.id}');
    } catch (e) {
      if (mounted) afficherErreur(context, e);
    } finally {
      if (mounted) setState(() => _envoi = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final devises = ref.watch(devisesProvider).value ?? [];
    String? montantValide(String? v) =>
        _devise != null && v != null && (Format.versMineur(v, _devise!.decimales) ?? 0) > 0 ? null : l.erreurVALIDATION;

    return Scaffold(
      appBar: AppBar(title: Text(l.contratNouveau)),
      body: Form(
        key: _formulaire,
        child: ListView(padding: const EdgeInsets.all(16), children: [
          TextFormField(
            key: const Key('champLocataire'),
            controller: _nom,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(labelText: l.contratChampLocataire),
            validator: (v) => (v ?? '').trim().length < 2 ? l.erreurVALIDATION : null,
          ),
          const SizedBox(height: 16),
          TextFormField(controller: _telephone, keyboardType: TextInputType.phone, decoration: InputDecoration(labelText: l.contratChampTelephone)),
          const SizedBox(height: 16),
          Row(children: [
            Expanded(
              flex: 2,
              child: TextFormField(
                key: const Key('champLoyer'),
                controller: _loyer,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: l.contratChampLoyer),
                validator: montantValide,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: DropdownButtonFormField<String>(
                initialValue: _devise?.code,
                decoration: InputDecoration(labelText: l.biensChampDevise),
                items: [for (final d in devises) DropdownMenuItem(value: d.code, child: Text(d.code))],
                onChanged: (v) => setState(() => _devise = devises.firstWhere((d) => d.code == v)),
                validator: (v) => v == null ? l.erreurVALIDATION : null,
              ),
            ),
          ]),
          const SizedBox(height: 16),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.event_outlined),
            title: Text(l.contratChampDebut),
            subtitle: Text(Format.date(Format.dateIso(_debut))),
            onTap: () => _choisirDate(debut: true),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.event_busy_outlined),
            title: Text(l.contratChampFin),
            subtitle: Text(_fin == null ? l.contratSansFin : Format.date(Format.dateIso(_fin!))),
            trailing: _fin == null ? null : IconButton(icon: const Icon(Icons.clear), onPressed: () => setState(() => _fin = null)),
            onTap: () => _choisirDate(debut: false),
          ),
          const SizedBox(height: 8),
          TextFormField(controller: _garantie, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: InputDecoration(labelText: l.contratChampGarantie)),
          const SizedBox(height: 24),
          FilledButton(key: const Key('enregistrerContrat'), onPressed: _envoi ? null : _enregistrer, child: Text(l.actionEnregistrer)),
        ]),
      ),
    );
  }
}
