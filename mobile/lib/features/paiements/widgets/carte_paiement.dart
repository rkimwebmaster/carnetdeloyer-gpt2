import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/modeles/modeles.dart';
import '../../../core/outils/format.dart';
import '../../../core/widgets/communs.dart';
import '../providers/paiements_providers.dart';

String libelleMoyen(AppLocalizations l, String moyen) => switch (moyen) {
      'especes' => l.moyenEspeces,
      'mobile_money' => l.moyenMobile_money,
      'virement' => l.moyenVirement,
      'garantie' => l.moyenGarantie,
      _ => l.moyenAutre,
    };

/// R-74 : partage du reçu par WhatsApp ou SMS depuis le téléphone du bailleur.
Future<void> partagerRecu(Recu recu, {String? telephone, bool sms = false}) async {
  final texte = Uri.encodeComponent(recu.messagePartage.isEmpty ? recu.lien : recu.messagePartage);
  final numero = (telephone ?? '').replaceAll('+', '');
  final uri = sms ? Uri.parse('sms:${telephone ?? ''}?body=$texte') : Uri.parse('https://wa.me/$numero?text=$texte');
  await launchUrl(uri, mode: LaunchMode.externalApplication);
}

class CartePaiement extends ConsumerWidget {
  const CartePaiement({super.key, required this.paiement, this.peutAnnuler = false, this.apresAnnulation, this.telephoneLocataire});

  final Paiement paiement;
  final bool peutAnnuler;
  final VoidCallback? apresAnnulation;
  final String? telephoneLocataire;

  Future<void> _annuler(BuildContext context, WidgetRef ref) async {
    final l = context.l10n;
    final motif = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.paiementAnnuler),
        content: TextField(controller: motif, autofocus: true, decoration: InputDecoration(labelText: l.paiementMotif)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l.actionFermer)),
          FilledButton(onPressed: () => Navigator.pop(ctx, motif.text.trim().isNotEmpty), child: Text(l.actionValider)),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await ref.read(paiementsServiceProvider).annuler(paiement.id, motif.text.trim());
      apresAnnulation?.call();
    } catch (e) {
      if (context.mounted) afficherErreur(context, e);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final p = paiement;
    final annule = p.statut == 'annule';
    final style = annule ? const TextStyle(decoration: TextDecoration.lineThrough) : null;
    return ListTile(
      leading: Icon(p.type == 'garantie' ? Icons.shield_outlined : Icons.receipt_long_outlined),
      title: Text(Format.montant(p.montant, p.devise), style: style),
      subtitle: Text([
        Format.date(p.datePaiement),
        libelleMoyen(l, p.moyen),
        if (p.recu != null) p.recu!.numero,
        if (annule) '${l.recuAnnule} : ${p.motifAnnulation ?? ''}',
      ].join(' · ')),
      trailing: PopupMenuButton<String>(
        onSelected: (choix) => switch (choix) {
          'whatsapp' => partagerRecu(p.recu!, telephone: telephoneLocataire),
          'sms' => partagerRecu(p.recu!, telephone: telephoneLocataire, sms: true),
          'annuler' => _annuler(context, ref),
          _ => null,
        },
        itemBuilder: (_) => [
          if (p.recu != null && !annule) PopupMenuItem(value: 'whatsapp', child: Text(l.recuEnvoyerWhatsapp)),
          if (p.recu != null && !annule) PopupMenuItem(value: 'sms', child: Text(l.recuEnvoyerSms)),
          if (peutAnnuler && !annule) PopupMenuItem(value: 'annuler', child: Text(l.paiementAnnuler)),
        ],
      ),
    );
  }
}
