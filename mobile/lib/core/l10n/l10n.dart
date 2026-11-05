import 'package:flutter/widgets.dart';

import '../erreurs/erreur_app.dart';
import 'generated/app_localizations.dart';

export 'generated/app_localizations.dart';

extension ContexteL10n on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

/// R-150 : chaque code a son message traduit, avec un message de secours.
String messageErreur(AppLocalizations l, Object erreur) {
  final e = erreur is ErreurApp ? erreur : convertirErreur(erreur);
  return switch (e.code) {
    'RESEAU' => l.erreurRESEAU,
    'SESSION' => l.erreurSESSION,
    'ERREUR_SERVEUR' => l.erreurERREUR_SERVEUR,
    'VALIDATION' => l.erreurVALIDATION,
    'INTROUVABLE' => l.erreurINTROUVABLE,
    'TELEPHONE_INVALIDE' => l.erreurTELEPHONE_INVALIDE,
    'OTP_INVALIDE' => l.erreurOTP_INVALIDE,
    'OTP_EXPIRE' => l.erreurOTP_EXPIRE,
    'TROP_DE_DEMANDES' => l.erreurTROP_DE_DEMANDES,
    'CODE_PARRAIN_INCONNU' => l.erreurCODE_PARRAIN_INCONNU,
    'UNITE_OCCUPEE' => l.erreurUNITE_OCCUPEE,
    'UNITE_SUSPENDUE' => l.erreurUNITE_SUSPENDUE,
    'PAIEMENT_SUPERIEUR_AU_DU' => l.erreurPAIEMENT_SUPERIEUR_AU_DU,
    'DEVISE_INACTIVE' => l.erreurDEVISE_INACTIVE,
    'CONTRAT_CLOTURE' => l.erreurCONTRAT_CLOTURE,
    'WALLET_SEUIL_NON_ATTEINT' => l.erreurWALLET_SEUIL_NON_ATTEINT,
    'WALLET_SOLDE_INSUFFISANT' => l.erreurWALLET_SOLDE_INSUFFISANT,
    'CONVERSION_INDISPONIBLE' => l.erreurCONVERSION_INDISPONIBLE,
    'COORDONNEES_INTERDITES' => l.erreurCOORDONNEES_INTERDITES,
    'HOTEL_RESERVE_ENTREPRISES' => l.erreurHOTEL_RESERVE_ENTREPRISES,
    // Secours : le message du serveur s'il existe, sinon un message générique.
    _ => e.message.isNotEmpty ? e.message : l.erreurGenerique,
  };
}
