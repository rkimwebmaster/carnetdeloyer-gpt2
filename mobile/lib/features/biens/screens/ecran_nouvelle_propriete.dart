import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/outils/format.dart';
import '../../../core/widgets/communs.dart';
import '../providers/biens_providers.dart';

class _LigneUnite {
  final nom = TextEditingController();
  String categorie = 'appartement';
}

/// Création d'une propriété avec ses unités (R-10).
class EcranNouvellePropriete extends ConsumerStatefulWidget {
  const EcranNouvellePropriete({super.key});

  @override
  ConsumerState<EcranNouvellePropriete> createState() => _EcranNouvelleProprieteState();
}

class _EcranNouvelleProprieteState extends ConsumerState<EcranNouvellePropriete> {
  final _formulaire = GlobalKey<FormState>();
  final _nom = TextEditingController();
  final _quartier = TextEditingController();
  final _loyer = TextEditingController();
  String _type = 'simple';
  String _categorie = 'maison';
  String? _devise;
  final List<_LigneUnite> _unites = [_LigneUnite()];
  bool _envoi = false;

  @override
  void dispose() {
    for (final c in [_nom, _quartier, _loyer, ..._unites.map((u) => u.nom)]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _enregistrer() async {
    if (!_formulaire.currentState!.validate()) return;
    final devises = ref.read(devisesProvider).value ?? [];
    final decimales = devises.where((d) => d.code == _devise).firstOrNull?.decimales ?? Format.decimalesDe(_devise ?? 'USD');
    final loyer = _loyer.text.trim().isEmpty ? null : Format.versMineur(_loyer.text, decimales);
    setState(() => _envoi = true);
    try {
      final p = await ref.read(biensServiceProvider).creerPropriete(
            nom: _nom.text.trim(),
            type: _type,
            quartier: _quartier.text.trim().isEmpty ? null : _quartier.text.trim(),
            categorie: _type == 'simple' ? _categorie : null,
            loyerIndicatif: _type == 'simple' ? loyer : null,
            devise: loyer == null ? null : _devise,
            unites: [
              for (final u in _unites)
                if (u.nom.text.trim().isNotEmpty) {'nom': u.nom.text.trim(), 'categorie': u.categorie},
            ],
          );
      ref.invalidate(proprietesProvider);
      if (mounted) context.pushReplacement('/b/biens/proprietes/${p.id}');
    } catch (e) {
      if (mounted) afficherErreur(context, e);
    } finally {
      if (mounted) setState(() => _envoi = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final categories = (ref.watch(categoriesProvider).value ?? []).where((c) => !c.hotel).toList();
    final devises = ref.watch(devisesProvider).value ?? [];
    String? requis(String? v) => (v == null || v.trim().isEmpty) ? l.erreurVALIDATION : null;

    DropdownButtonFormField<String> choixCategorie(String valeur, ValueChanged<String> changer) => DropdownButtonFormField<String>(
          initialValue: categories.any((c) => c.code == valeur) ? valeur : null,
          decoration: InputDecoration(labelText: l.biensChampCategorie),
          items: [for (final c in categories) DropdownMenuItem(value: c.code, child: Row(children: [Icon(iconeCategorie(c.icone), size: 20), const SizedBox(width: 8), Text(c.libelle)]))],
          onChanged: (v) => changer(v!),
        );

    return Scaffold(
      appBar: AppBar(title: Text(l.biensNouvelle)),
      body: Form(
        key: _formulaire,
        child: ListView(padding: const EdgeInsets.all(16), children: [
          TextFormField(key: const Key('champNomPropriete'), controller: _nom, decoration: InputDecoration(labelText: l.biensChampNom), validator: requis),
          const SizedBox(height: 16),
          SegmentedButton<String>(
            segments: [
              ButtonSegment(value: 'simple', label: Text(l.biensTypeSimple)),
              ButtonSegment(value: 'immeuble', label: Text(l.biensTypeImmeuble)),
            ],
            selected: {_type},
            onSelectionChanged: (s) => setState(() => _type = s.first),
          ),
          const SizedBox(height: 16),
          TextFormField(controller: _quartier, decoration: InputDecoration(labelText: l.biensChampQuartier)),
          const SizedBox(height: 16),
          if (_type == 'simple') ...[
            choixCategorie(_categorie, (v) => setState(() => _categorie = v)),
            const SizedBox(height: 16),
            Row(children: [
              Expanded(
                flex: 2,
                child: TextFormField(controller: _loyer, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: InputDecoration(labelText: l.biensChampLoyer)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: _devise,
                  decoration: InputDecoration(labelText: l.biensChampDevise),
                  items: [for (final d in devises) DropdownMenuItem(value: d.code, child: Text(d.code))],
                  onChanged: (v) => setState(() => _devise = v),
                ),
              ),
            ]),
          ] else ...[
            Text(l.biensUnites, style: Theme.of(context).textTheme.titleMedium),
            for (final u in _unites) ...[
              const SizedBox(height: 12),
              TextFormField(controller: u.nom, decoration: InputDecoration(labelText: l.biensChampNomUnite)),
              const SizedBox(height: 8),
              choixCategorie(u.categorie, (v) => setState(() => u.categorie = v)),
            ],
            TextButton.icon(onPressed: () => setState(() => _unites.add(_LigneUnite())), icon: const Icon(Icons.add), label: Text(l.biensAjouterUnite)),
          ],
          const SizedBox(height: 24),
          FilledButton(key: const Key('enregistrerPropriete'), onPressed: _envoi ? null : _enregistrer, child: Text(l.actionEnregistrer)),
        ]),
      ),
    );
  }
}
