// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get nomApp => 'CarnetDeLoyer';

  @override
  String get actionContinuer => 'Continuer';

  @override
  String get actionValider => 'Valider';

  @override
  String get actionAnnuler => 'Annuler';

  @override
  String get actionEnregistrer => 'Enregistrer';

  @override
  String get actionReessayer => 'Réessayer';

  @override
  String get actionPlusTard => 'Plus tard';

  @override
  String get actionFermer => 'Fermer';

  @override
  String get actionSupprimer => 'Supprimer';

  @override
  String get actionPartager => 'Partager';

  @override
  String get actionVoirTout => 'Tout voir';

  @override
  String get actionSynchroniser => 'Synchroniser';

  @override
  String get chargement => 'Chargement…';

  @override
  String get listeVide => 'Rien à afficher pour l\'instant.';

  @override
  String get horsLigne => 'Hors ligne : données du dernier passage en ligne.';

  @override
  String get horsLigneAction => 'Connexion requise pour cette action.';

  @override
  String get authTitreTelephone => 'Votre numéro de téléphone';

  @override
  String get authAideTelephone => 'Format international, ex. +243 970 000 000';

  @override
  String get authChampTelephone => 'Téléphone';

  @override
  String get authTitreCode => 'Code reçu par SMS';

  @override
  String authAideCode(String telephone) {
    return 'Saisissez les 6 chiffres envoyés au $telephone.';
  }

  @override
  String get authChampCode => 'Code';

  @override
  String get authRenvoyer => 'Renvoyer le code';

  @override
  String get authTitreInscription => 'Bienvenue !';

  @override
  String get authChampNom => 'Votre nom';

  @override
  String get authChampParrain => 'Code parrain (facultatif)';

  @override
  String get authTitrePinCreation => 'Créez votre code PIN';

  @override
  String get authAidePinCreation =>
      '4 à 6 chiffres. Il déverrouille l\'app, même sans réseau.';

  @override
  String get authTitrePinConfirmation => 'Confirmez le code PIN';

  @override
  String get authPinDifferent => 'Les deux codes ne correspondent pas.';

  @override
  String get authTitreVerrou => 'Saisissez votre code PIN';

  @override
  String authPinIncorrect(int n) {
    return 'Code incorrect. Essais restants : $n';
  }

  @override
  String get authBiometrie => 'Utiliser l\'empreinte ou le visage';

  @override
  String get authRaisonBiometrie => 'Déverrouiller CarnetDeLoyer';

  @override
  String get authSeDeconnecter => 'Se déconnecter';

  @override
  String get modeTitreChoix => 'Comment utilisez-vous CarnetDeLoyer ?';

  @override
  String get modeAideChoix =>
      'Vous pourrez changer à tout moment depuis le menu.';

  @override
  String get modeBailleur => 'Je suis bailleur';

  @override
  String get modeBailleurAide => 'Je gère des biens et j\'encaisse des loyers.';

  @override
  String get modeLocataire => 'Je suis locataire';

  @override
  String get modeLocataireAide => 'Je consulte mes locations et mes reçus.';

  @override
  String get modeBasculerVersBailleur => 'Passer en mode bailleur';

  @override
  String get modeBasculerVersLocataire => 'Passer en mode locataire';

  @override
  String get ongletAccueil => 'Accueil';

  @override
  String get ongletBiens => 'Biens';

  @override
  String get ongletPaiements => 'Paiements';

  @override
  String get ongletMarket => 'Market';

  @override
  String get ongletHotels => 'Hôtels';

  @override
  String get ongletLocations => 'Mes locations';

  @override
  String get menuWallet => 'Wallet';

  @override
  String get menuAbonnements => 'Abonnements';

  @override
  String get menuStatistiques => 'Statistiques';

  @override
  String get menuParrainage => 'Parrainage';

  @override
  String get menuVerification => 'Vérification';

  @override
  String get menuProfil => 'Profil';

  @override
  String get menuParametres => 'Paramètres';

  @override
  String accueilBonjour(String nom) {
    return 'Bonjour $nom';
  }

  @override
  String get accueilUnites => 'Unités';

  @override
  String get accueilLouees => 'Louées';

  @override
  String get accueilVacantes => 'Vacantes';

  @override
  String get accueilEnRetard => 'En retard';

  @override
  String get accueilEncaisseMois => 'Encaissé ce mois';

  @override
  String get accueilActivite => 'Activité récente';

  @override
  String get accueilAucuneActivite => 'Aucune activité pour l\'instant.';

  @override
  String get accueilGuideTitre => 'Bien démarrer';

  @override
  String get accueilGuidePropriete => 'Ajoutez votre première propriété';

  @override
  String get accueilGuideMarket => 'Publiez une unité vacante sur le Market';

  @override
  String get accueilGuideEntreprise => 'Complétez vos infos entreprise';

  @override
  String get accueilGuideRattachement => 'Retrouvez vos contrats';

  @override
  String get biensTitre => 'Mes biens';

  @override
  String get biensAucun => 'Ajoutez votre première propriété pour commencer.';

  @override
  String get biensAjouter => 'Ajouter une propriété';

  @override
  String biensNombreUnites(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n unités',
      one: '1 unité',
      zero: 'Aucune unité',
    );
    return '$_temp0';
  }

  @override
  String get biensVacante => 'Vacante';

  @override
  String biensLouee(String nom) {
    return 'Louée à $nom';
  }

  @override
  String get biensNouvelle => 'Nouvelle propriété';

  @override
  String get biensChampNom => 'Nom de la propriété';

  @override
  String get biensChampType => 'Type';

  @override
  String get biensTypeSimple => 'Une seule maison';

  @override
  String get biensTypeImmeuble => 'Immeuble ou parcelle avec plusieurs unités';

  @override
  String get biensChampQuartier => 'Quartier';

  @override
  String get biensChampAdresse => 'Adresse';

  @override
  String get biensChampCategorie => 'Catégorie';

  @override
  String get biensChampLoyer => 'Loyer indicatif';

  @override
  String get biensChampDevise => 'Devise';

  @override
  String get biensUnites => 'Unités';

  @override
  String get biensAjouterUnite => 'Ajouter une unité';

  @override
  String get biensChampNomUnite => 'Nom de l\'unité';

  @override
  String get biensLouer => 'Créer un contrat';

  @override
  String get biensPublier => 'Publier sur le Market';

  @override
  String get biensRetirer => 'Retirer du Market';

  @override
  String get biensPubliee => 'Publiée sur le Market';

  @override
  String get contratsTitre => 'Contrats';

  @override
  String get contratNouveau => 'Nouveau contrat';

  @override
  String get contratChampLocataire => 'Nom du locataire';

  @override
  String get contratChampTelephone => 'Téléphone du locataire';

  @override
  String get contratChampLoyer => 'Loyer mensuel';

  @override
  String get contratChampDebut => 'Date de début';

  @override
  String get contratChampFin => 'Date de fin (facultative)';

  @override
  String get contratChampGarantie => 'Garantie (facultative)';

  @override
  String get contratSansFin => 'Sans date de fin : reconduction tacite';

  @override
  String contratEnRetard(String montant) {
    return 'En retard : $montant';
  }

  @override
  String get contratAJour => 'À jour';

  @override
  String contratProchaineEcheance(String date) {
    return 'Prochaine échéance : $date';
  }

  @override
  String get contratEcheances => 'Échéances';

  @override
  String get contratPaiements => 'Paiements';

  @override
  String get contratGarantie => 'Garantie';

  @override
  String get contratCloture => 'Clôturé';

  @override
  String get contratCloturer => 'Clôturer le contrat';

  @override
  String get contratDateSortie => 'Date de sortie';

  @override
  String get statutA_venir => 'À venir';

  @override
  String get statutPayee => 'Payée';

  @override
  String get statutPartielle => 'Partielle';

  @override
  String get statutEn_retard => 'En retard';

  @override
  String get statutAnnulee => 'Annulée';

  @override
  String get encaisserTitre => 'Encaisser';

  @override
  String get encaisserBouton => 'Encaisser';

  @override
  String get encaisserNombreMois => 'Nombre de mois';

  @override
  String get encaisserPartiel => 'Paiement partiel';

  @override
  String get encaisserMontant => 'Montant';

  @override
  String get encaisserTotal => 'Total';

  @override
  String get encaisserMoyen => 'Moyen de paiement';

  @override
  String get encaisserReference => 'Référence (facultative)';

  @override
  String get encaisserDate => 'Date du paiement';

  @override
  String get encaisserRienADu => 'Aucune échéance due sur ce contrat.';

  @override
  String encaisserSucces(String numero) {
    return 'Paiement enregistré. Reçu $numero.';
  }

  @override
  String get encaisserEnAttente =>
      'Hors ligne : paiement mis en file d\'attente.';

  @override
  String get moyenEspeces => 'Espèces';

  @override
  String get moyenMobile_money => 'Mobile money';

  @override
  String get moyenVirement => 'Virement';

  @override
  String get moyenAutre => 'Autre';

  @override
  String get moyenGarantie => 'Garantie';

  @override
  String get recuProvisoire =>
      'REÇU PROVISOIRE — en attente de synchronisation, non envoyé au locataire.';

  @override
  String get recuAnnule => 'Reçu annulé';

  @override
  String get recuEnvoyerWhatsapp => 'Envoyer par WhatsApp';

  @override
  String get recuEnvoyerSms => 'Envoyer par SMS';

  @override
  String get paiementsTitre => 'Paiements';

  @override
  String get paiementsFileTitre => 'En attente de synchronisation';

  @override
  String paiementsRejete(String motif) {
    return 'Refusé par le serveur : $motif';
  }

  @override
  String get paiementsDeclarations => 'Déclarations des locataires';

  @override
  String get paiementAnnuler => 'Annuler ce paiement';

  @override
  String get paiementMotif => 'Motif de l\'annulation';

  @override
  String get declarationValider => 'Valider';

  @override
  String get declarationRefuser => 'Refuser';

  @override
  String get declarationMotifRefus => 'Motif du refus';

  @override
  String get locationsTitre => 'Mes locations';

  @override
  String get locationsAucune =>
      'Aucun contrat rattaché à votre numéro pour l\'instant.';

  @override
  String get locationsRattacher => 'Rattacher';

  @override
  String get locationsARattacher => 'Contrats à confirmer';

  @override
  String get declarerTitre => 'J\'ai payé';

  @override
  String get declarerAide =>
      'Votre bailleur validera ce paiement. En attendant, votre solde ne change pas.';

  @override
  String get declarerEnvoyee => 'Déclaration envoyée à votre bailleur.';

  @override
  String get marketTitre => 'Market';

  @override
  String get marketVide =>
      'Aucune annonce pour l\'instant. Publiez une unité vacante ou parrainez un bailleur.';

  @override
  String get marketContacter => 'Contacter';

  @override
  String get hotelsTitre => 'Hôtels';

  @override
  String get hotelsVide => 'Aucun hôtel publié pour l\'instant.';

  @override
  String hotelsDes(String prix) {
    return 'À partir de $prix / nuit';
  }

  @override
  String get walletTitre => 'Wallet';

  @override
  String get walletTotal => 'Solde total';

  @override
  String get walletBailleur => 'Espace bailleur';

  @override
  String get walletLocataire => 'Espace locataire';

  @override
  String walletSeuil(String seuil) {
    return 'Le wallet est utilisable à partir de $seuil.';
  }

  @override
  String get abonnementsTitre => 'Abonnements';

  @override
  String get abonnementEtatNon_facture => 'Non facturée (vacante)';

  @override
  String get abonnementEtatGratuit => 'Gratuit';

  @override
  String get abonnementEtatActif => 'Actif';

  @override
  String get abonnementEtatGrace => 'À renouveler';

  @override
  String get abonnementEtatSuspendu => 'Suspendu';

  @override
  String abonnementJusquAu(String date) {
    return 'jusqu\'au $date';
  }

  @override
  String abonnementMontant(String usd, String pct) {
    return '$usd pour 12 mois ($pct % du loyer)';
  }

  @override
  String get abonnementPayerWallet => 'Payer avec le wallet';

  @override
  String get abonnementPayerMobile => 'J\'ai payé par mobile money';

  @override
  String get abonnementReference => 'Référence de la transaction';

  @override
  String get abonnementEnvoye => 'Paiement transmis pour validation.';

  @override
  String get abonnementSuspenduBandeau =>
      'Abonnement expiré : renouvelez-le pour enregistrer des paiements.';

  @override
  String get parrainageTitre => 'Parrainage';

  @override
  String get parrainageCode => 'Votre code parrain';

  @override
  String get parrainageAide =>
      'Gagnez 2 \$ pour chaque contrat payé par un bailleur que vous parrainez.';

  @override
  String get profilTitre => 'Profil';

  @override
  String get profilExporter => 'Télécharger mes données';

  @override
  String get profilSupprimer => 'Supprimer mon compte';

  @override
  String get erreurRESEAU => 'Pas de connexion internet.';

  @override
  String get erreurSESSION => 'Votre session a expiré. Reconnectez-vous.';

  @override
  String get erreurERREUR_SERVEUR =>
      'Le serveur rencontre un problème. Réessayez plus tard.';

  @override
  String get erreurVALIDATION => 'Vérifiez les informations saisies.';

  @override
  String get erreurINTROUVABLE => 'Élément introuvable.';

  @override
  String get erreurTELEPHONE_INVALIDE =>
      'Numéro invalide : utilisez le format international (+243…).';

  @override
  String get erreurOTP_INVALIDE => 'Code incorrect.';

  @override
  String get erreurOTP_EXPIRE => 'Code expiré : demandez un nouveau code.';

  @override
  String get erreurTROP_DE_DEMANDES =>
      'Trop de demandes. Réessayez dans un moment.';

  @override
  String get erreurCODE_PARRAIN_INCONNU => 'Code parrain inconnu.';

  @override
  String get erreurUNITE_OCCUPEE => 'Cette unité a déjà un contrat actif.';

  @override
  String get erreurUNITE_SUSPENDUE =>
      'Abonnement expiré : renouvelez-le pour enregistrer des paiements.';

  @override
  String get erreurPAIEMENT_SUPERIEUR_AU_DU =>
      'Le montant dépasse le total restant dû.';

  @override
  String get erreurDEVISE_INACTIVE => 'Cette devise n\'est plus proposée.';

  @override
  String get erreurCONTRAT_CLOTURE => 'Ce contrat est clôturé.';

  @override
  String get erreurWALLET_SEUIL_NON_ATTEINT =>
      'Le wallet est utilisable à partir de 11 \$.';

  @override
  String get erreurWALLET_SOLDE_INSUFFISANT => 'Solde du wallet insuffisant.';

  @override
  String get erreurCONVERSION_INDISPONIBLE =>
      'Conversion monétaire indisponible. Réessayez plus tard.';

  @override
  String get erreurCOORDONNEES_INTERDITES =>
      'Les numéros de téléphone et coordonnées sont interdits dans la description.';

  @override
  String get erreurHOTEL_RESERVE_ENTREPRISES =>
      'La catégorie Hôtel est réservée aux entreprises vérifiées.';

  @override
  String get erreurGenerique => 'Une erreur est survenue.';
}
