// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'modeles.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Devise _$DeviseFromJson(Map<String, dynamic> json) => _Devise(
  code: json['code'] as String,
  nom: json['nom'] as String,
  symbole: json['symbole'] as String,
  decimales: (json['decimales'] as num).toInt(),
  active: json['active'] as bool? ?? true,
);

Map<String, dynamic> _$DeviseToJson(_Devise instance) => <String, dynamic>{
  'code': instance.code,
  'nom': instance.nom,
  'symbole': instance.symbole,
  'decimales': instance.decimales,
  'active': instance.active,
};

_Montant _$MontantFromJson(Map<String, dynamic> json) => _Montant(
  montant: (json['montant'] as num).toInt(),
  devise: json['devise'] as String?,
);

Map<String, dynamic> _$MontantToJson(_Montant instance) => <String, dynamic>{
  'montant': instance.montant,
  'devise': instance.devise,
};

_Categorie _$CategorieFromJson(Map<String, dynamic> json) => _Categorie(
  code: json['code'] as String,
  libelle: json['libelle'] as String,
  icone: json['icone'] as String,
  hotel: json['hotel'] as bool? ?? false,
);

Map<String, dynamic> _$CategorieToJson(_Categorie instance) =>
    <String, dynamic>{
      'code': instance.code,
      'libelle': instance.libelle,
      'icone': instance.icone,
      'hotel': instance.hotel,
    };

_EtatAbonnementUnite _$EtatAbonnementUniteFromJson(Map<String, dynamic> json) =>
    _EtatAbonnementUnite(
      etat: json['etat'] as String,
      fin: json['fin'] as String?,
    );

Map<String, dynamic> _$EtatAbonnementUniteToJson(
  _EtatAbonnementUnite instance,
) => <String, dynamic>{'etat': instance.etat, 'fin': instance.fin};

_Unite _$UniteFromJson(Map<String, dynamic> json) => _Unite(
  id: (json['id'] as num).toInt(),
  nom: json['nom'] as String,
  categorie: Categorie.fromJson(json['categorie'] as Map<String, dynamic>),
  proprieteId: (json['proprieteId'] as num).toInt(),
  propriete: json['propriete'] as String?,
  loyerIndicatif: json['loyerIndicatif'] == null
      ? null
      : Montant.fromJson(json['loyerIndicatif'] as Map<String, dynamic>),
  vacante: json['vacante'] as bool,
  contratActifId: (json['contratActifId'] as num?)?.toInt(),
  locataire: json['locataire'] as String?,
  publieeMarket: json['publieeMarket'] as bool? ?? false,
  descriptionMarket: json['descriptionMarket'] as String?,
  abonnement: EtatAbonnementUnite.fromJson(
    json['abonnement'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$UniteToJson(_Unite instance) => <String, dynamic>{
  'id': instance.id,
  'nom': instance.nom,
  'categorie': instance.categorie.toJson(),
  'proprieteId': instance.proprieteId,
  'propriete': instance.propriete,
  'loyerIndicatif': instance.loyerIndicatif?.toJson(),
  'vacante': instance.vacante,
  'contratActifId': instance.contratActifId,
  'locataire': instance.locataire,
  'publieeMarket': instance.publieeMarket,
  'descriptionMarket': instance.descriptionMarket,
  'abonnement': instance.abonnement.toJson(),
};

_Propriete _$ProprieteFromJson(Map<String, dynamic> json) => _Propriete(
  id: (json['id'] as num).toInt(),
  nom: json['nom'] as String,
  type: json['type'] as String,
  adresse: json['adresse'] as String?,
  quartier: json['quartier'] as String?,
  latitude: (json['latitude'] as num?)?.toDouble(),
  longitude: (json['longitude'] as num?)?.toDouble(),
  nombreUnites: (json['nombreUnites'] as num?)?.toInt() ?? 0,
  unites:
      (json['unites'] as List<dynamic>?)
          ?.map((e) => Unite.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <Unite>[],
);

Map<String, dynamic> _$ProprieteToJson(_Propriete instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nom': instance.nom,
      'type': instance.type,
      'adresse': instance.adresse,
      'quartier': instance.quartier,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'nombreUnites': instance.nombreUnites,
      'unites': instance.unites.map((e) => e.toJson()).toList(),
    };

_Echeance _$EcheanceFromJson(Map<String, dynamic> json) => _Echeance(
  id: (json['id'] as num).toInt(),
  periodeDebut: json['periodeDebut'] as String,
  periodeFin: json['periodeFin'] as String,
  dateExigible: json['dateExigible'] as String,
  montantDu: (json['montantDu'] as num).toInt(),
  montantPaye: (json['montantPaye'] as num).toInt(),
  restantDu: (json['restantDu'] as num).toInt(),
  statut: json['statut'] as String,
);

Map<String, dynamic> _$EcheanceToJson(_Echeance instance) => <String, dynamic>{
  'id': instance.id,
  'periodeDebut': instance.periodeDebut,
  'periodeFin': instance.periodeFin,
  'dateExigible': instance.dateExigible,
  'montantDu': instance.montantDu,
  'montantPaye': instance.montantPaye,
  'restantDu': instance.restantDu,
  'statut': instance.statut,
};

_Recu _$RecuFromJson(Map<String, dynamic> json) => _Recu(
  id: (json['id'] as num).toInt(),
  numero: json['numero'] as String,
  annule: json['annule'] as bool,
  lien: json['lien'] as String,
  messagePartage: json['messagePartage'] as String? ?? '',
);

Map<String, dynamic> _$RecuToJson(_Recu instance) => <String, dynamic>{
  'id': instance.id,
  'numero': instance.numero,
  'annule': instance.annule,
  'lien': instance.lien,
  'messagePartage': instance.messagePartage,
};

_Paiement _$PaiementFromJson(Map<String, dynamic> json) => _Paiement(
  id: (json['id'] as num).toInt(),
  contratId: (json['contratId'] as num).toInt(),
  type: json['type'] as String,
  montant: (json['montant'] as num).toInt(),
  devise: json['devise'] as String,
  datePaiement: json['datePaiement'] as String,
  moyen: json['moyen'] as String,
  reference: json['reference'] as String?,
  statut: json['statut'] as String,
  motifAnnulation: json['motifAnnulation'] as String?,
  cleIdempotence: json['cleIdempotence'] as String,
  saisiPar: json['saisiPar'] as String? ?? '',
  locataire: json['locataire'] as String? ?? '',
  unite: json['unite'] as String? ?? '',
  recu: json['recu'] == null
      ? null
      : Recu.fromJson(json['recu'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PaiementToJson(_Paiement instance) => <String, dynamic>{
  'id': instance.id,
  'contratId': instance.contratId,
  'type': instance.type,
  'montant': instance.montant,
  'devise': instance.devise,
  'datePaiement': instance.datePaiement,
  'moyen': instance.moyen,
  'reference': instance.reference,
  'statut': instance.statut,
  'motifAnnulation': instance.motifAnnulation,
  'cleIdempotence': instance.cleIdempotence,
  'saisiPar': instance.saisiPar,
  'locataire': instance.locataire,
  'unite': instance.unite,
  'recu': instance.recu?.toJson(),
};

_ContactLocataire _$ContactLocataireFromJson(Map<String, dynamic> json) =>
    _ContactLocataire(
      id: (json['id'] as num).toInt(),
      nom: json['nom'] as String,
      telephone: json['telephone'] as String?,
      inscrit: json['inscrit'] as bool? ?? false,
    );

Map<String, dynamic> _$ContactLocataireToJson(_ContactLocataire instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nom': instance.nom,
      'telephone': instance.telephone,
      'inscrit': instance.inscrit,
    };

_UniteContrat _$UniteContratFromJson(Map<String, dynamic> json) =>
    _UniteContrat(
      id: (json['id'] as num).toInt(),
      nom: json['nom'] as String,
      propriete: json['propriete'] as String,
      categorie: Categorie.fromJson(json['categorie'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UniteContratToJson(_UniteContrat instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nom': instance.nom,
      'propriete': instance.propriete,
      'categorie': instance.categorie.toJson(),
    };

_BailleurContrat _$BailleurContratFromJson(Map<String, dynamic> json) =>
    _BailleurContrat(
      nom: json['nom'] as String,
      badge: json['badge'] as String?,
      telephone: json['telephone'] as String?,
    );

Map<String, dynamic> _$BailleurContratToJson(_BailleurContrat instance) =>
    <String, dynamic>{
      'nom': instance.nom,
      'badge': instance.badge,
      'telephone': instance.telephone,
    };

_Garantie _$GarantieFromJson(Map<String, dynamic> json) => _Garantie(
  montant: (json['montant'] as num).toInt(),
  statut: json['statut'] as String,
  retenue: (json['retenue'] as num?)?.toInt() ?? 0,
  motif: json['motif'] as String?,
);

Map<String, dynamic> _$GarantieToJson(_Garantie instance) => <String, dynamic>{
  'montant': instance.montant,
  'statut': instance.statut,
  'retenue': instance.retenue,
  'motif': instance.motif,
};

_Contrat _$ContratFromJson(Map<String, dynamic> json) => _Contrat(
  id: (json['id'] as num).toInt(),
  statut: json['statut'] as String,
  unite: UniteContrat.fromJson(json['unite'] as Map<String, dynamic>),
  locataire: ContactLocataire.fromJson(
    json['locataire'] as Map<String, dynamic>,
  ),
  bailleur: BailleurContrat.fromJson(json['bailleur'] as Map<String, dynamic>),
  devise: Devise.fromJson(json['devise'] as Map<String, dynamic>),
  loyer: (json['loyer'] as num).toInt(),
  dateDebut: json['dateDebut'] as String,
  dateFin: json['dateFin'] as String?,
  dateSortie: json['dateSortie'] as String?,
  enRetard: (json['enRetard'] as num).toInt(),
  restantDu: (json['restantDu'] as num).toInt(),
  prochaineEcheance: json['prochaineEcheance'] == null
      ? null
      : Echeance.fromJson(json['prochaineEcheance'] as Map<String, dynamic>),
  garantie: json['garantie'] == null
      ? null
      : Garantie.fromJson(json['garantie'] as Map<String, dynamic>),
  echeances:
      (json['echeances'] as List<dynamic>?)
          ?.map((e) => Echeance.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <Echeance>[],
  paiements:
      (json['paiements'] as List<dynamic>?)
          ?.map((e) => Paiement.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <Paiement>[],
);

Map<String, dynamic> _$ContratToJson(_Contrat instance) => <String, dynamic>{
  'id': instance.id,
  'statut': instance.statut,
  'unite': instance.unite.toJson(),
  'locataire': instance.locataire.toJson(),
  'bailleur': instance.bailleur.toJson(),
  'devise': instance.devise.toJson(),
  'loyer': instance.loyer,
  'dateDebut': instance.dateDebut,
  'dateFin': instance.dateFin,
  'dateSortie': instance.dateSortie,
  'enRetard': instance.enRetard,
  'restantDu': instance.restantDu,
  'prochaineEcheance': instance.prochaineEcheance?.toJson(),
  'garantie': instance.garantie?.toJson(),
  'echeances': instance.echeances.map((e) => e.toJson()).toList(),
  'paiements': instance.paiements.map((e) => e.toJson()).toList(),
};
