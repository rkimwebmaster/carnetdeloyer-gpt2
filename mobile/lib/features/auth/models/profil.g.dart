// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profil.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PaysProfil _$PaysProfilFromJson(Map<String, dynamic> json) => _PaysProfil(
  id: (json['id'] as num).toInt(),
  nom: json['nom'] as String,
  codeIso: json['codeIso'] as String,
  deviseParDefaut: json['deviseParDefaut'] as String?,
);

Map<String, dynamic> _$PaysProfilToJson(_PaysProfil instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nom': instance.nom,
      'codeIso': instance.codeIso,
      'deviseParDefaut': instance.deviseParDefaut,
    };

_EspaceProfil _$EspaceProfilFromJson(Map<String, dynamic> json) =>
    _EspaceProfil(
      id: (json['id'] as num).toInt(),
      nomAffiche: json['nomAffiche'] as String,
      raisonSociale: json['raisonSociale'] as String?,
      badge: json['badge'] as String?,
    );

Map<String, dynamic> _$EspaceProfilToJson(_EspaceProfil instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nomAffiche': instance.nomAffiche,
      'raisonSociale': instance.raisonSociale,
      'badge': instance.badge,
    };

_Profil _$ProfilFromJson(Map<String, dynamic> json) => _Profil(
  id: (json['id'] as num).toInt(),
  nom: json['nom'] as String,
  telephone: json['telephone'] as String?,
  email: json['email'] as String?,
  pays: json['pays'] == null
      ? null
      : PaysProfil.fromJson(json['pays'] as Map<String, dynamic>),
  modePrefere: json['modePrefere'] as String?,
  codeParrainage: json['codeParrainage'] as String,
  espaceBailleur: json['espaceBailleur'] == null
      ? null
      : EspaceProfil.fromJson(json['espaceBailleur'] as Map<String, dynamic>),
  roles:
      (json['roles'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
);

Map<String, dynamic> _$ProfilToJson(_Profil instance) => <String, dynamic>{
  'id': instance.id,
  'nom': instance.nom,
  'telephone': instance.telephone,
  'email': instance.email,
  'pays': instance.pays?.toJson(),
  'modePrefere': instance.modePrefere,
  'codeParrainage': instance.codeParrainage,
  'espaceBailleur': instance.espaceBailleur?.toJson(),
  'roles': instance.roles,
};
