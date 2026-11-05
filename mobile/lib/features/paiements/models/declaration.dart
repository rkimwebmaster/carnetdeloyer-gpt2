import 'package:freezed_annotation/freezed_annotation.dart';

part 'declaration.freezed.dart';
part 'declaration.g.dart';

/// R-39 : « J'ai payé ».
@freezed
abstract class Declaration with _$Declaration {
  const factory Declaration({
    required int id,
    required int contratId,
    required int montant,
    required String devise,
    required String datePaiement,
    String? reference,
    required String statut,
    String? motifRefus,
    @Default('') String locataire,
    @Default('') String unite,
  }) = _Declaration;

  factory Declaration.fromJson(Map<String, dynamic> json) => _$DeclarationFromJson(json);
}
