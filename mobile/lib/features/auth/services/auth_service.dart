import '../../../core/api/client_api.dart';
import '../../../core/session/coffre.dart';

class ResultatOtp {
  const ResultatOtp({this.jetons, this.jetonInscription});

  /// Compte existant : connecté.
  final Jetons? jetons;

  /// Numéro inconnu : finir l'inscription avec ce jeton (R-160).
  final String? jetonInscription;
}

/// Appels d'authentification (R-71, R-160). Sans état.
class AuthService {
  const AuthService(this.api);
  final ClientApi api;

  Future<void> demanderCode(String telephone) => api.post('/auth/otp', {'telephone': telephone});

  Future<ResultatOtp> verifier(String telephone, String code) async {
    final r = await api.post('/auth/otp/verification', {'telephone': telephone, 'code': code}) as Map<String, dynamic>;
    if (r['inscriptionRequise'] == true) return ResultatOtp(jetonInscription: r['jetonInscription'] as String);
    return ResultatOtp(jetons: Jetons(r['token'] as String, r['refresh_token'] as String));
  }

  Future<Jetons> inscrire({required String telephone, required String jeton, required String nom, String? codeParrain}) async {
    final r = await api.post('/auth/inscription', {
      'telephone': telephone,
      'jetonInscription': jeton,
      'nom': nom,
      if (codeParrain != null && codeParrain.trim().isNotEmpty) 'codeParrain': codeParrain.trim(),
    }) as Map<String, dynamic>;
    return Jetons(r['token'] as String, r['refresh_token'] as String);
  }
}
