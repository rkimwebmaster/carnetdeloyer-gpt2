import 'package:freezed_annotation/freezed_annotation.dart';

part 'modeles.freezed.dart';
part 'modeles.g.dart';

/// R-130 : modèles métier partagés. Montants en unité mineure (R-14) ;
/// statuts et soldes calculés par le serveur (R-135).

@freezed
abstract class Devise with _$Devise {
  const factory Devise({
    required String code,
    required String nom,
    required String symbole,
    required int decimales,
    @Default(true) bool active,
  }) = _Devise;

  factory Devise.fromJson(Map<String, dynamic> json) => _$DeviseFromJson(json);
}

@freezed
abstract class Montant with _$Montant {
  const factory Montant({required int montant, String? devise}) = _Montant;

  factory Montant.fromJson(Map<String, dynamic> json) => _$MontantFromJson(json);
}

@freezed
abstract class Categorie with _$Categorie {
  const factory Categorie({
    required String code,
    required String libelle,
    required String icone,
    @Default(false) bool hotel,
  }) = _Categorie;

  factory Categorie.fromJson(Map<String, dynamic> json) => _$CategorieFromJson(json);
}

@freezed
abstract class EtatAbonnementUnite with _$EtatAbonnementUnite {
  const factory EtatAbonnementUnite({required String etat, String? fin}) = _EtatAbonnementUnite;

  factory EtatAbonnementUnite.fromJson(Map<String, dynamic> json) => _$EtatAbonnementUniteFromJson(json);
}

@freezed
abstract class Unite with _$Unite {
  const factory Unite({
    required int id,
    required String nom,
    required Categorie categorie,
    required int proprieteId,
    String? propriete,
    Montant? loyerIndicatif,
    required bool vacante,
    int? contratActifId,
    String? locataire,
    @Default(false) bool publieeMarket,
    String? descriptionMarket,
    required EtatAbonnementUnite abonnement,
  }) = _Unite;

  factory Unite.fromJson(Map<String, dynamic> json) => _$UniteFromJson(json);
}

@freezed
abstract class Propriete with _$Propriete {
  const factory Propriete({
    required int id,
    required String nom,
    required String type,
    String? adresse,
    String? quartier,
    double? latitude,
    double? longitude,
    @Default(0) int nombreUnites,
    @Default(<Unite>[]) List<Unite> unites,
  }) = _Propriete;

  factory Propriete.fromJson(Map<String, dynamic> json) => _$ProprieteFromJson(json);
}

@freezed
abstract class Echeance with _$Echeance {
  const factory Echeance({
    required int id,
    required String periodeDebut,
    required String periodeFin,
    required String dateExigible,
    required int montantDu,
    required int montantPaye,
    required int restantDu,

    /// a_venir | payee | partielle | en_retard | annulee (R-22)
    required String statut,
  }) = _Echeance;

  factory Echeance.fromJson(Map<String, dynamic> json) => _$EcheanceFromJson(json);
}

@freezed
abstract class Recu with _$Recu {
  const factory Recu({
    required int id,
    required String numero,
    required bool annule,
    required String lien,
    @Default('') String messagePartage,
  }) = _Recu;

  factory Recu.fromJson(Map<String, dynamic> json) => _$RecuFromJson(json);
}

@freezed
abstract class Paiement with _$Paiement {
  const factory Paiement({
    required int id,
    required int contratId,
    required String type,
    required int montant,
    required String devise,
    required String datePaiement,
    required String moyen,
    String? reference,
    required String statut,
    String? motifAnnulation,
    required String cleIdempotence,
    @Default('') String saisiPar,
    @Default('') String locataire,
    @Default('') String unite,
    Recu? recu,
  }) = _Paiement;

  factory Paiement.fromJson(Map<String, dynamic> json) => _$PaiementFromJson(json);
}

@freezed
abstract class ContactLocataire with _$ContactLocataire {
  const factory ContactLocataire({required int id, required String nom, String? telephone, @Default(false) bool inscrit}) = _ContactLocataire;

  factory ContactLocataire.fromJson(Map<String, dynamic> json) => _$ContactLocataireFromJson(json);
}

@freezed
abstract class UniteContrat with _$UniteContrat {
  const factory UniteContrat({required int id, required String nom, required String propriete, required Categorie categorie}) = _UniteContrat;

  factory UniteContrat.fromJson(Map<String, dynamic> json) => _$UniteContratFromJson(json);
}

@freezed
abstract class BailleurContrat with _$BailleurContrat {
  const factory BailleurContrat({required String nom, String? badge, String? telephone}) = _BailleurContrat;

  factory BailleurContrat.fromJson(Map<String, dynamic> json) => _$BailleurContratFromJson(json);
}

@freezed
abstract class Garantie with _$Garantie {
  const factory Garantie({required int montant, required String statut, @Default(0) int retenue, String? motif}) = _Garantie;

  factory Garantie.fromJson(Map<String, dynamic> json) => _$GarantieFromJson(json);
}

@freezed
abstract class Contrat with _$Contrat {
  const factory Contrat({
    required int id,
    required String statut,
    required UniteContrat unite,
    required ContactLocataire locataire,
    required BailleurContrat bailleur,
    required Devise devise,
    required int loyer,
    required String dateDebut,
    String? dateFin,
    String? dateSortie,
    required int enRetard,
    required int restantDu,
    Echeance? prochaineEcheance,
    Garantie? garantie,
    @Default(<Echeance>[]) List<Echeance> echeances,
    @Default(<Paiement>[]) List<Paiement> paiements,
  }) = _Contrat;

  factory Contrat.fromJson(Map<String, dynamic> json) => _$ContratFromJson(json);
}

/// Réponse paginée de l'API (R-151).
class PageApi<T> {
  const PageApi(this.elements, this.page, this.total);

  factory PageApi.depuis(dynamic json, T Function(Map<String, dynamic>) convertir) {
    final m = json as Map<String, dynamic>;
    return PageApi(
      (m['elements'] as List).map((e) => convertir(e as Map<String, dynamic>)).toList(),
      m['page'] as int,
      m['total'] as int,
    );
  }

  final List<T> elements;
  final int page;
  final int total;
}
