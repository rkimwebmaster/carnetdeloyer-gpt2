import 'package:drift/drift.dart' show Value;
import 'package:uuid/uuid.dart';

import '../../../core/api/client_api.dart';
import '../../../core/cache/base_locale.dart';
import '../../../core/erreurs/erreur_app.dart';
import '../../../core/modeles/modeles.dart';

/// Saisie d'un paiement à encaisser.
class SaisiePaiement {
  const SaisiePaiement({
    required this.contratId,
    required this.montant,
    required this.devise,
    required this.datePaiement,
    required this.moyen,
    required this.libelle,
    this.reference,
  });

  final int contratId;
  final int montant;
  final String devise;
  final String datePaiement;
  final String moyen;
  final String libelle;
  final String? reference;
}

/// Résultat d'un encaissement : confirmé par le serveur, ou en file d'attente.
sealed class ResultatEncaissement {
  const ResultatEncaissement();
}

final class PaiementConfirme extends ResultatEncaissement {
  const PaiementConfirme(this.paiement);
  final Paiement paiement;
}

/// R-136 : reçu provisoire, jamais envoyé au locataire.
final class PaiementEnFile extends ResultatEncaissement {
  const PaiementEnFile(this.id);
  final String id;
}

/// R-136 à R-139 : file d'attente (outbox) des paiements.
///
/// - chaque paiement reçoit un UUID au moment de la saisie (clé d'idempotence) ;
/// - il est d'abord écrit dans la file locale, puis envoyé ;
/// - l'envoi se fait dans l'ordre de saisie ; un rejet métier n'arrête pas la file ;
///   un problème réseau ou de session l'interrompt (les suivants attendent) ;
/// - la file est liée à l'utilisateur et n'est jamais envoyée sous un autre compte.
class FilePaiements {
  FilePaiements({required this.api, required this.base, required this.utilisateurId, Uuid? uuid}) : _uuid = uuid ?? const Uuid();

  final ClientApi api;
  final BaseLocale base;
  final int utilisateurId;
  final Uuid _uuid;
  Future<int>? _synchronisationEnCours;

  /// Écrit d'abord dans la file, puis tente l'envoi immédiat.
  Future<ResultatEncaissement> encaisser(SaisiePaiement saisie) async {
    final id = _uuid.v4();
    await base.ajouterPaiement(PaiementsEnAttenteCompanion.insert(
      id: id,
      utilisateurId: utilisateurId,
      contratId: saisie.contratId,
      montant: saisie.montant,
      devise: saisie.devise,
      datePaiement: saisie.datePaiement,
      moyen: saisie.moyen,
      reference: Value(saisie.reference),
      libelle: saisie.libelle,
      creeLe: DateTime.now(),
    ));

    // Les paiements plus anciens passent d'abord (ordre de saisie).
    await synchroniser();
    final ligne = (await base.aEnvoyer(utilisateurId)).where((p) => p.id == id).firstOrNull;
    if (ligne != null) return PaiementEnFile(id);

    final rejete = await _ligne(id);
    if (rejete != null && rejete.etat == 'rejete') {
      // Rejet immédiat (montant supérieur au dû...) : on le montre comme une erreur
      // et on le retire de la file, rien n'a été enregistré.
      await base.supprimerNonSynchronise(id, utilisateurId);
      throw ErreurMetier(rejete.codeRejet ?? 'REJETE', rejete.motifRejet ?? '', 422);
    }
    return PaiementConfirme(_derniersConfirmes[id]!);
  }

  final Map<String, Paiement> _derniersConfirmes = {};

  /// Envoie les paiements en attente. Renvoie le nombre de paiements confirmés.
  /// Deux appels simultanés partagent le même envoi.
  Future<int> synchroniser() => _synchronisationEnCours ??= _envoyer().whenComplete(() => _synchronisationEnCours = null);

  Future<int> _envoyer() async {
    var confirmes = 0;
    for (final p in await base.aEnvoyer(utilisateurId)) {
      try {
        final (_, corps) = await api.postAvecStatut('/contrats/${p.contratId}/paiements', {
          'montant': p.montant,
          'datePaiement': p.datePaiement,
          'moyen': p.moyen,
          'reference': ?p.reference,
          'cleIdempotence': p.id,
        });
        // 201 (créé) ou 200 (déjà reçu : la clé protège du doublon, R-137).
        final paiement = Paiement.fromJson(corps as Map<String, dynamic>);
        _derniersConfirmes[p.id] = paiement;
        await base.marquerEnvoye(p.id, paiement.recu?.numero);
        confirmes++;
      } on ErreurReseau {
        break;
      } on ErreurSession {
        break;
      } on ErreurServeur {
        break;
      } on ErreurApp catch (e) {
        // Rejet métier (contrat clôturé, unité suspendue...) : le bailleur décide.
        await base.marquerRejete(p.id, e.code, e.message);
      }
    }
    return confirmes;
  }

  Future<PaiementEnAttente?> _ligne(String id) async =>
      (await (base.select(base.paiementsEnAttente)..where((p) => p.id.equals(id))).get()).firstOrNull;

  Stream<List<PaiementEnAttente>> observer() => base.observerFile(utilisateurId);

  /// R-36 : un paiement non synchronisé peut être supprimé librement.
  Future<void> supprimer(String id) => base.supprimerNonSynchronise(id, utilisateurId);
}
