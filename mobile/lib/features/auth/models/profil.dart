import 'package:freezed_annotation/freezed_annotation.dart';

part 'profil.freezed.dart';
part 'profil.g.dart';

@freezed
abstract class PaysProfil with _$PaysProfil {
  const factory PaysProfil({required int id, required String nom, required String codeIso, String? deviseParDefaut}) = _PaysProfil;

  factory PaysProfil.fromJson(Map<String, dynamic> json) => _$PaysProfilFromJson(json);
}

@freezed
abstract class EspaceProfil with _$EspaceProfil {
  const factory EspaceProfil({required int id, required String nomAffiche, String? raisonSociale, String? badge}) = _EspaceProfil;

  factory EspaceProfil.fromJson(Map<String, dynamic> json) => _$EspaceProfilFromJson(json);
}

@freezed
abstract class Profil with _$Profil {
  const factory Profil({
    required int id,
    required String nom,
    String? telephone,
    String? email,
    PaysProfil? pays,
    String? modePrefere,
    required String codeParrainage,
    EspaceProfil? espaceBailleur,
    @Default(<String>[]) List<String> roles,
  }) = _Profil;

  factory Profil.fromJson(Map<String, dynamic> json) => _$ProfilFromJson(json);
}
