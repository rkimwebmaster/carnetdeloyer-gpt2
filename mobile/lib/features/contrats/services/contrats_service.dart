import '../../../core/api/client_api.dart';
import '../../../core/cache/lecture.dart';
import '../../../core/modeles/modeles.dart';

/// Données du formulaire « Encaisser » calculées par le serveur (R-24, R-25, R-135).
class Encaissement {
  const Encaissement({
    required this.devise,
    required this.loyer,
    required this.montantPropose,
    required this.restantDu,
    required this.moisMaximum,
    this.prochaineEcheance,
    this.garantieAttendue,
  });

  factory Encaissement.fromJson(Map<String, dynamic> j) => Encaissement(
        devise: Devise.fromJson(j['devise'] as Map<String, dynamic>),
        loyer: j['loyer'] as int,
        montantPropose: j['montantPropose'] as int,
        restantDu: j['restantDu'] as int,
        moisMaximum: j['moisMaximum'] as int,
        prochaineEcheance: j['prochaineEcheance'] == null ? null : Echeance.fromJson(j['prochaineEcheance'] as Map<String, dynamic>),
        garantieAttendue: j['garantieAttendue'] as int?,
      );

  final Devise devise;
  final int loyer;
  final int montantPropose;
  final int restantDu;
  final int moisMaximum;
  final Echeance? prochaineEcheance;
  final int? garantieAttendue;

  Map<String, dynamic> toJson() => {
        'devise': devise.toJson(),
        'loyer': loyer,
        'montantPropose': montantPropose,
        'restantDu': restantDu,
        'moisMaximum': moisMaximum,
        'prochaineEcheance': prochaineEcheance?.toJson(),
        'garantieAttendue': garantieAttendue,
      };
}

class ContratsService {
  const ContratsService(this.api, this.lecteur);
  final ClientApi api;
  final LecteurCache lecteur;

  Future<Lecture<PageApi<Contrat>>> contrats({String? statut, bool enRetard = false}) => lecteur.lire(
        '/contrats',
        (j) => PageApi.depuis(j, Contrat.fromJson),
        parametres: {'parPage': 50, 'statut': ?statut, if (enRetard) 'enRetard': 1},
      );

  Future<Lecture<Contrat>> contrat(int id) => lecteur.lire('/contrats/$id', (j) => Contrat.fromJson(j as Map<String, dynamic>));

  Future<Lecture<Encaissement>> encaissement(int id) =>
      lecteur.lire('/contrats/$id/encaissement', (j) => Encaissement.fromJson(j as Map<String, dynamic>));

  /// R-17 : devise et loyer proposés pour une unité.
  Future<({Devise? devise, int? loyer})> proposition(int uniteId) async {
    final j = await api.get('/unites/$uniteId/contrat/proposition') as Map<String, dynamic>;
    return (devise: j['devise'] == null ? null : Devise.fromJson(j['devise'] as Map<String, dynamic>), loyer: j['loyer'] as int?);
  }

  Future<Contrat> creer({
    required int uniteId,
    required String locataireNom,
    String? locataireTelephone,
    required String devise,
    required int loyer,
    required String dateDebut,
    String? dateFin,
    int garantie = 0,
  }) async =>
      Contrat.fromJson(await api.post('/contrats', {
        'uniteId': uniteId,
        'locataireNom': locataireNom,
        if (locataireTelephone != null && locataireTelephone.trim().isNotEmpty) 'locataireTelephone': locataireTelephone.trim(),
        'devise': devise,
        'loyer': loyer,
        'dateDebut': dateDebut,
        'dateFin': ?dateFin,
        'garantie': garantie,
      }) as Map<String, dynamic>);

  Future<Map<String, dynamic>> cloturer(int id, {required String dateSortie, int? montantDerniereEcheance, String? garantie, int montantRetenu = 0, String? motif}) async =>
      await api.post('/contrats/$id/cloture', {
        'dateSortie': dateSortie,
        'montantDerniereEcheance': ?montantDerniereEcheance,
        'garantie': ?garantie,
        'montantRetenu': montantRetenu,
        'motif': ?motif,
      }) as Map<String, dynamic>;
}
