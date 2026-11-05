// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'declaration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Declaration _$DeclarationFromJson(Map<String, dynamic> json) => _Declaration(
  id: (json['id'] as num).toInt(),
  contratId: (json['contratId'] as num).toInt(),
  montant: (json['montant'] as num).toInt(),
  devise: json['devise'] as String,
  datePaiement: json['datePaiement'] as String,
  reference: json['reference'] as String?,
  statut: json['statut'] as String,
  motifRefus: json['motifRefus'] as String?,
  locataire: json['locataire'] as String? ?? '',
  unite: json['unite'] as String? ?? '',
);

Map<String, dynamic> _$DeclarationToJson(_Declaration instance) =>
    <String, dynamic>{
      'id': instance.id,
      'contratId': instance.contratId,
      'montant': instance.montant,
      'devise': instance.devise,
      'datePaiement': instance.datePaiement,
      'reference': instance.reference,
      'statut': instance.statut,
      'motifRefus': instance.motifRefus,
      'locataire': instance.locataire,
      'unite': instance.unite,
    };
