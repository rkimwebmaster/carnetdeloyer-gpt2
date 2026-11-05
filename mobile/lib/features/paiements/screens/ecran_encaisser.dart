import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/outils/format.dart';
import '../../../core/widgets/communs.dart';
import '../../contrats/providers/contrats_providers.dart';
import '../../contrats/services/contrats_service.dart';
import '../providers/paiements_providers.dart';
import '../services/file_paiements.dart';
import '../widgets/carte_paiement.dart';

/// « Encaisser » : montant pré-rempli depuis la prochaine échéance due (R-24),
/// aperçu « loyer × nombre de mois » pour une avance (R-25), paiement partiel (R-26).
/// L'aperçu est une simple multiplication d'affichage ; le serveur décide (R-135).
class EcranEncaisser extends ConsumerStatefulWidget {
  const EcranEncaisser({super.key, required this.contratId});
  final int contratId;

  @override
  ConsumerState<EcranEncaisser> createState() => _EcranEncaisserState();
}

class _EcranEncaisserState extends ConsumerState<EcranEncaisser> {
  final _montantPartiel = TextEditingController();
  final _reference = TextEditingController();
  int _mois = 1;
  bool _partiel = false;
  String _moyen = 'especes';
  DateTime _date = DateTime.now();
  bool _envoi = false;

  @override
  void dispose() {
    _montantPartiel.dispose();
    _reference.dispose();
    super.dispose();
  }

  int? _montant(Encaissement e) {
    if (_partiel) return Format.versMineur(_montantPartiel.text, e.devise.decimales);
    // Le 1er mois peut être partiellement payé : on part du restant de l'échéance due.
    final total = e.montantPropose + (_mois - 1) * e.loyer;
    return total > e.restantDu ? e.restantDu : total;
  }

  Future<void> _encaisser(Encaissement e, String libelle) async {
    final montant = _montant(e);
    if (montant == null || montant <= 0) {
      afficherMessage(context, context.l10n.erreurVALIDATION);
      return;
    }
    setState(() => _envoi = true);
    final l = context.l10n;
    try {
      final r = await ref.read(filePaiementsProvider).encaisser(SaisiePaiement(
            contratId: widget.contratId,
            montant: montant,
            devise: e.devise.code,
            datePaiement: Format.dateIso(_date),
            moyen: _moyen,
            reference: _reference.text.trim().isEmpty ? null : _reference.text.trim(),
            libelle: libelle,
          ));
      if (!mounted) return;
      ref.invalidate(contratProvider(widget.contratId));
      ref.invalidate(encaissementProvider(widget.contratId));
      ref.invalidate(paiementsProvider);
      switch (r) {
        case PaiementConfirme(:final paiement):
          await _afficherRecu(paiement.recu?.numero ?? '', () => partagerRecu(paiement.recu!));
        case PaiementEnFile():
          afficherMessage(context, l.encaisserEnAttente);
      }
      if (mounted) context.pop();
    } catch (err) {
      if (mounted) afficherErreur(context, err);
    } finally {
      if (mounted) setState(() => _envoi = false);
    }
  }

  Future<void> _afficherRecu(String numero, VoidCallback partager) => showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          icon: const Icon(Icons.check_circle_outline, size: 40),
          content: Text(ctx.l10n.encaisserSucces(numero), textAlign: TextAlign.center),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: Text(ctx.l10n.actionFermer)),
            FilledButton.icon(
              onPressed: () {
                Navigator.pop(ctx);
                partager();
              },
              icon: const Icon(Icons.share_outlined),
              label: Text(ctx.l10n.recuEnvoyerWhatsapp),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final valeur = ref.watch(encaissementProvider(widget.contratId));
    final contrat = ref.watch(contratProvider(widget.contratId)).value?.valeur;
    return Scaffold(
      appBar: AppBar(title: Text(l.encaisserTitre)),
      body: VueAsync(
        valeur: valeur,
        reessayer: () => ref.invalidate(encaissementProvider(widget.contratId)),
        donnees: (lecture) {
          final e = lecture.valeur;
          if (e.restantDu == 0) return EtatVide(message: l.encaisserRienADu, icone: Icons.task_alt);
          final montant = _montant(e);
          final libelle = contrat == null ? '' : '${contrat.unite.nom} · ${contrat.locataire.nom}';
          return ListView(padding: const EdgeInsets.all(16), children: [
            if (contrat != null) Text(libelle, style: Theme.of(context).textTheme.titleMedium),
            if (e.prochaineEcheance != null) Text(Format.moisAnnee(e.prochaineEcheance!.periodeDebut)),
            const SizedBox(height: 16),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l.encaisserPartiel),
              value: _partiel,
              onChanged: (v) => setState(() => _partiel = v),
            ),
            if (_partiel)
              TextField(
                key: const Key('champMontantPartiel'),
                controller: _montantPartiel,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: l.encaisserMontant, suffixText: e.devise.symbole),
                onChanged: (_) => setState(() {}),
              )
            else
              Row(children: [
                Expanded(child: Text(l.encaisserNombreMois)),
                IconButton.outlined(key: const Key('moinsMois'), onPressed: _mois > 1 ? () => setState(() => _mois--) : null, icon: const Icon(Icons.remove)),
                Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Text('$_mois', style: Theme.of(context).textTheme.titleLarge)),
                IconButton.outlined(key: const Key('plusMois'), onPressed: _mois < e.moisMaximum ? () => setState(() => _mois++) : null, icon: const Icon(Icons.add)),
              ]),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _moyen,
              decoration: InputDecoration(labelText: l.encaisserMoyen),
              items: [for (final m in ['especes', 'mobile_money', 'virement', 'autre']) DropdownMenuItem(value: m, child: Text(libelleMoyen(l, m)))],
              onChanged: (v) => setState(() => _moyen = v!),
            ),
            const SizedBox(height: 16),
            TextField(controller: _reference, decoration: InputDecoration(labelText: l.encaisserReference)),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.event_outlined),
              title: Text(l.encaisserDate),
              subtitle: Text(Format.date(Format.dateIso(_date))),
              onTap: () async {
                final d = await showDatePicker(context: context, initialDate: _date, firstDate: DateTime(2000), lastDate: DateTime.now());
                if (d != null) setState(() => _date = d);
              },
            ),
            const Divider(height: 32),
            Row(children: [
              Expanded(child: Text(l.encaisserTotal, style: Theme.of(context).textTheme.titleMedium)),
              Text(
                montant == null ? '—' : Format.montantDevise(montant, e.devise),
                key: const Key('totalEncaisser'),
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ]),
            const SizedBox(height: 24),
            FilledButton(key: const Key('validerEncaissement'), onPressed: _envoi ? null : () => _encaisser(e, libelle), child: Text(l.encaisserBouton)),
          ]);
        },
      ),
    );
  }
}
