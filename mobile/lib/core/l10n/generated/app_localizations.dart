import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('fr')];

  /// No description provided for @nomApp.
  ///
  /// In fr, this message translates to:
  /// **'CarnetDeLoyer'**
  String get nomApp;

  /// No description provided for @actionContinuer.
  ///
  /// In fr, this message translates to:
  /// **'Continuer'**
  String get actionContinuer;

  /// No description provided for @actionValider.
  ///
  /// In fr, this message translates to:
  /// **'Valider'**
  String get actionValider;

  /// No description provided for @actionAnnuler.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get actionAnnuler;

  /// No description provided for @actionEnregistrer.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer'**
  String get actionEnregistrer;

  /// No description provided for @actionReessayer.
  ///
  /// In fr, this message translates to:
  /// **'Réessayer'**
  String get actionReessayer;

  /// No description provided for @actionPlusTard.
  ///
  /// In fr, this message translates to:
  /// **'Plus tard'**
  String get actionPlusTard;

  /// No description provided for @actionFermer.
  ///
  /// In fr, this message translates to:
  /// **'Fermer'**
  String get actionFermer;

  /// No description provided for @actionSupprimer.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer'**
  String get actionSupprimer;

  /// No description provided for @actionPartager.
  ///
  /// In fr, this message translates to:
  /// **'Partager'**
  String get actionPartager;

  /// No description provided for @actionVoirTout.
  ///
  /// In fr, this message translates to:
  /// **'Tout voir'**
  String get actionVoirTout;

  /// No description provided for @actionSynchroniser.
  ///
  /// In fr, this message translates to:
  /// **'Synchroniser'**
  String get actionSynchroniser;

  /// No description provided for @chargement.
  ///
  /// In fr, this message translates to:
  /// **'Chargement…'**
  String get chargement;

  /// No description provided for @listeVide.
  ///
  /// In fr, this message translates to:
  /// **'Rien à afficher pour l\'instant.'**
  String get listeVide;

  /// No description provided for @horsLigne.
  ///
  /// In fr, this message translates to:
  /// **'Hors ligne : données du dernier passage en ligne.'**
  String get horsLigne;

  /// No description provided for @horsLigneAction.
  ///
  /// In fr, this message translates to:
  /// **'Connexion requise pour cette action.'**
  String get horsLigneAction;

  /// No description provided for @authTitreTelephone.
  ///
  /// In fr, this message translates to:
  /// **'Votre numéro de téléphone'**
  String get authTitreTelephone;

  /// No description provided for @authAideTelephone.
  ///
  /// In fr, this message translates to:
  /// **'Format international, ex. +243 970 000 000'**
  String get authAideTelephone;

  /// No description provided for @authChampTelephone.
  ///
  /// In fr, this message translates to:
  /// **'Téléphone'**
  String get authChampTelephone;

  /// No description provided for @authTitreCode.
  ///
  /// In fr, this message translates to:
  /// **'Code reçu par SMS'**
  String get authTitreCode;

  /// No description provided for @authAideCode.
  ///
  /// In fr, this message translates to:
  /// **'Saisissez les 6 chiffres envoyés au {telephone}.'**
  String authAideCode(String telephone);

  /// No description provided for @authChampCode.
  ///
  /// In fr, this message translates to:
  /// **'Code'**
  String get authChampCode;

  /// No description provided for @authRenvoyer.
  ///
  /// In fr, this message translates to:
  /// **'Renvoyer le code'**
  String get authRenvoyer;

  /// No description provided for @authTitreInscription.
  ///
  /// In fr, this message translates to:
  /// **'Bienvenue !'**
  String get authTitreInscription;

  /// No description provided for @authChampNom.
  ///
  /// In fr, this message translates to:
  /// **'Votre nom'**
  String get authChampNom;

  /// No description provided for @authChampParrain.
  ///
  /// In fr, this message translates to:
  /// **'Code parrain (facultatif)'**
  String get authChampParrain;

  /// No description provided for @authTitrePinCreation.
  ///
  /// In fr, this message translates to:
  /// **'Créez votre code PIN'**
  String get authTitrePinCreation;

  /// No description provided for @authAidePinCreation.
  ///
  /// In fr, this message translates to:
  /// **'4 à 6 chiffres. Il déverrouille l\'app, même sans réseau.'**
  String get authAidePinCreation;

  /// No description provided for @authTitrePinConfirmation.
  ///
  /// In fr, this message translates to:
  /// **'Confirmez le code PIN'**
  String get authTitrePinConfirmation;

  /// No description provided for @authPinDifferent.
  ///
  /// In fr, this message translates to:
  /// **'Les deux codes ne correspondent pas.'**
  String get authPinDifferent;

  /// No description provided for @authTitreVerrou.
  ///
  /// In fr, this message translates to:
  /// **'Saisissez votre code PIN'**
  String get authTitreVerrou;

  /// No description provided for @authPinIncorrect.
  ///
  /// In fr, this message translates to:
  /// **'Code incorrect. Essais restants : {n}'**
  String authPinIncorrect(int n);

  /// No description provided for @authBiometrie.
  ///
  /// In fr, this message translates to:
  /// **'Utiliser l\'empreinte ou le visage'**
  String get authBiometrie;

  /// No description provided for @authRaisonBiometrie.
  ///
  /// In fr, this message translates to:
  /// **'Déverrouiller CarnetDeLoyer'**
  String get authRaisonBiometrie;

  /// No description provided for @authSeDeconnecter.
  ///
  /// In fr, this message translates to:
  /// **'Se déconnecter'**
  String get authSeDeconnecter;

  /// No description provided for @modeTitreChoix.
  ///
  /// In fr, this message translates to:
  /// **'Comment utilisez-vous CarnetDeLoyer ?'**
  String get modeTitreChoix;

  /// No description provided for @modeAideChoix.
  ///
  /// In fr, this message translates to:
  /// **'Vous pourrez changer à tout moment depuis le menu.'**
  String get modeAideChoix;

  /// No description provided for @modeBailleur.
  ///
  /// In fr, this message translates to:
  /// **'Je suis bailleur'**
  String get modeBailleur;

  /// No description provided for @modeBailleurAide.
  ///
  /// In fr, this message translates to:
  /// **'Je gère des biens et j\'encaisse des loyers.'**
  String get modeBailleurAide;

  /// No description provided for @modeLocataire.
  ///
  /// In fr, this message translates to:
  /// **'Je suis locataire'**
  String get modeLocataire;

  /// No description provided for @modeLocataireAide.
  ///
  /// In fr, this message translates to:
  /// **'Je consulte mes locations et mes reçus.'**
  String get modeLocataireAide;

  /// No description provided for @modeBasculerVersBailleur.
  ///
  /// In fr, this message translates to:
  /// **'Passer en mode bailleur'**
  String get modeBasculerVersBailleur;

  /// No description provided for @modeBasculerVersLocataire.
  ///
  /// In fr, this message translates to:
  /// **'Passer en mode locataire'**
  String get modeBasculerVersLocataire;

  /// No description provided for @ongletAccueil.
  ///
  /// In fr, this message translates to:
  /// **'Accueil'**
  String get ongletAccueil;

  /// No description provided for @ongletBiens.
  ///
  /// In fr, this message translates to:
  /// **'Biens'**
  String get ongletBiens;

  /// No description provided for @ongletPaiements.
  ///
  /// In fr, this message translates to:
  /// **'Paiements'**
  String get ongletPaiements;

  /// No description provided for @ongletMarket.
  ///
  /// In fr, this message translates to:
  /// **'Market'**
  String get ongletMarket;

  /// No description provided for @ongletHotels.
  ///
  /// In fr, this message translates to:
  /// **'Hôtels'**
  String get ongletHotels;

  /// No description provided for @ongletLocations.
  ///
  /// In fr, this message translates to:
  /// **'Mes locations'**
  String get ongletLocations;

  /// No description provided for @menuWallet.
  ///
  /// In fr, this message translates to:
  /// **'Wallet'**
  String get menuWallet;

  /// No description provided for @menuAbonnements.
  ///
  /// In fr, this message translates to:
  /// **'Abonnements'**
  String get menuAbonnements;

  /// No description provided for @menuStatistiques.
  ///
  /// In fr, this message translates to:
  /// **'Statistiques'**
  String get menuStatistiques;

  /// No description provided for @menuParrainage.
  ///
  /// In fr, this message translates to:
  /// **'Parrainage'**
  String get menuParrainage;

  /// No description provided for @menuVerification.
  ///
  /// In fr, this message translates to:
  /// **'Vérification'**
  String get menuVerification;

  /// No description provided for @menuProfil.
  ///
  /// In fr, this message translates to:
  /// **'Profil'**
  String get menuProfil;

  /// No description provided for @menuParametres.
  ///
  /// In fr, this message translates to:
  /// **'Paramètres'**
  String get menuParametres;

  /// No description provided for @accueilBonjour.
  ///
  /// In fr, this message translates to:
  /// **'Bonjour {nom}'**
  String accueilBonjour(String nom);

  /// No description provided for @accueilUnites.
  ///
  /// In fr, this message translates to:
  /// **'Unités'**
  String get accueilUnites;

  /// No description provided for @accueilLouees.
  ///
  /// In fr, this message translates to:
  /// **'Louées'**
  String get accueilLouees;

  /// No description provided for @accueilVacantes.
  ///
  /// In fr, this message translates to:
  /// **'Vacantes'**
  String get accueilVacantes;

  /// No description provided for @accueilEnRetard.
  ///
  /// In fr, this message translates to:
  /// **'En retard'**
  String get accueilEnRetard;

  /// No description provided for @accueilEncaisseMois.
  ///
  /// In fr, this message translates to:
  /// **'Encaissé ce mois'**
  String get accueilEncaisseMois;

  /// No description provided for @accueilActivite.
  ///
  /// In fr, this message translates to:
  /// **'Activité récente'**
  String get accueilActivite;

  /// No description provided for @accueilAucuneActivite.
  ///
  /// In fr, this message translates to:
  /// **'Aucune activité pour l\'instant.'**
  String get accueilAucuneActivite;

  /// No description provided for @accueilGuideTitre.
  ///
  /// In fr, this message translates to:
  /// **'Bien démarrer'**
  String get accueilGuideTitre;

  /// No description provided for @accueilGuidePropriete.
  ///
  /// In fr, this message translates to:
  /// **'Ajoutez votre première propriété'**
  String get accueilGuidePropriete;

  /// No description provided for @accueilGuideMarket.
  ///
  /// In fr, this message translates to:
  /// **'Publiez une unité vacante sur le Market'**
  String get accueilGuideMarket;

  /// No description provided for @accueilGuideEntreprise.
  ///
  /// In fr, this message translates to:
  /// **'Complétez vos infos entreprise'**
  String get accueilGuideEntreprise;

  /// No description provided for @accueilGuideRattachement.
  ///
  /// In fr, this message translates to:
  /// **'Retrouvez vos contrats'**
  String get accueilGuideRattachement;

  /// No description provided for @biensTitre.
  ///
  /// In fr, this message translates to:
  /// **'Mes biens'**
  String get biensTitre;

  /// No description provided for @biensAucun.
  ///
  /// In fr, this message translates to:
  /// **'Ajoutez votre première propriété pour commencer.'**
  String get biensAucun;

  /// No description provided for @biensAjouter.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter une propriété'**
  String get biensAjouter;

  /// No description provided for @biensNombreUnites.
  ///
  /// In fr, this message translates to:
  /// **'{n, plural, =0{Aucune unité} =1{1 unité} other{{n} unités}}'**
  String biensNombreUnites(int n);

  /// No description provided for @biensVacante.
  ///
  /// In fr, this message translates to:
  /// **'Vacante'**
  String get biensVacante;

  /// No description provided for @biensLouee.
  ///
  /// In fr, this message translates to:
  /// **'Louée à {nom}'**
  String biensLouee(String nom);

  /// No description provided for @biensNouvelle.
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle propriété'**
  String get biensNouvelle;

  /// No description provided for @biensChampNom.
  ///
  /// In fr, this message translates to:
  /// **'Nom de la propriété'**
  String get biensChampNom;

  /// No description provided for @biensChampType.
  ///
  /// In fr, this message translates to:
  /// **'Type'**
  String get biensChampType;

  /// No description provided for @biensTypeSimple.
  ///
  /// In fr, this message translates to:
  /// **'Une seule maison'**
  String get biensTypeSimple;

  /// No description provided for @biensTypeImmeuble.
  ///
  /// In fr, this message translates to:
  /// **'Immeuble ou parcelle avec plusieurs unités'**
  String get biensTypeImmeuble;

  /// No description provided for @biensChampQuartier.
  ///
  /// In fr, this message translates to:
  /// **'Quartier'**
  String get biensChampQuartier;

  /// No description provided for @biensChampAdresse.
  ///
  /// In fr, this message translates to:
  /// **'Adresse'**
  String get biensChampAdresse;

  /// No description provided for @biensChampCategorie.
  ///
  /// In fr, this message translates to:
  /// **'Catégorie'**
  String get biensChampCategorie;

  /// No description provided for @biensChampLoyer.
  ///
  /// In fr, this message translates to:
  /// **'Loyer indicatif'**
  String get biensChampLoyer;

  /// No description provided for @biensChampDevise.
  ///
  /// In fr, this message translates to:
  /// **'Devise'**
  String get biensChampDevise;

  /// No description provided for @biensUnites.
  ///
  /// In fr, this message translates to:
  /// **'Unités'**
  String get biensUnites;

  /// No description provided for @biensAjouterUnite.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter une unité'**
  String get biensAjouterUnite;

  /// No description provided for @biensChampNomUnite.
  ///
  /// In fr, this message translates to:
  /// **'Nom de l\'unité'**
  String get biensChampNomUnite;

  /// No description provided for @biensLouer.
  ///
  /// In fr, this message translates to:
  /// **'Créer un contrat'**
  String get biensLouer;

  /// No description provided for @biensPublier.
  ///
  /// In fr, this message translates to:
  /// **'Publier sur le Market'**
  String get biensPublier;

  /// No description provided for @biensRetirer.
  ///
  /// In fr, this message translates to:
  /// **'Retirer du Market'**
  String get biensRetirer;

  /// No description provided for @biensPubliee.
  ///
  /// In fr, this message translates to:
  /// **'Publiée sur le Market'**
  String get biensPubliee;

  /// No description provided for @contratsTitre.
  ///
  /// In fr, this message translates to:
  /// **'Contrats'**
  String get contratsTitre;

  /// No description provided for @contratNouveau.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau contrat'**
  String get contratNouveau;

  /// No description provided for @contratChampLocataire.
  ///
  /// In fr, this message translates to:
  /// **'Nom du locataire'**
  String get contratChampLocataire;

  /// No description provided for @contratChampTelephone.
  ///
  /// In fr, this message translates to:
  /// **'Téléphone du locataire'**
  String get contratChampTelephone;

  /// No description provided for @contratChampLoyer.
  ///
  /// In fr, this message translates to:
  /// **'Loyer mensuel'**
  String get contratChampLoyer;

  /// No description provided for @contratChampDebut.
  ///
  /// In fr, this message translates to:
  /// **'Date de début'**
  String get contratChampDebut;

  /// No description provided for @contratChampFin.
  ///
  /// In fr, this message translates to:
  /// **'Date de fin (facultative)'**
  String get contratChampFin;

  /// No description provided for @contratChampGarantie.
  ///
  /// In fr, this message translates to:
  /// **'Garantie (facultative)'**
  String get contratChampGarantie;

  /// No description provided for @contratSansFin.
  ///
  /// In fr, this message translates to:
  /// **'Sans date de fin : reconduction tacite'**
  String get contratSansFin;

  /// No description provided for @contratEnRetard.
  ///
  /// In fr, this message translates to:
  /// **'En retard : {montant}'**
  String contratEnRetard(String montant);

  /// No description provided for @contratAJour.
  ///
  /// In fr, this message translates to:
  /// **'À jour'**
  String get contratAJour;

  /// No description provided for @contratProchaineEcheance.
  ///
  /// In fr, this message translates to:
  /// **'Prochaine échéance : {date}'**
  String contratProchaineEcheance(String date);

  /// No description provided for @contratEcheances.
  ///
  /// In fr, this message translates to:
  /// **'Échéances'**
  String get contratEcheances;

  /// No description provided for @contratPaiements.
  ///
  /// In fr, this message translates to:
  /// **'Paiements'**
  String get contratPaiements;

  /// No description provided for @contratGarantie.
  ///
  /// In fr, this message translates to:
  /// **'Garantie'**
  String get contratGarantie;

  /// No description provided for @contratCloture.
  ///
  /// In fr, this message translates to:
  /// **'Clôturé'**
  String get contratCloture;

  /// No description provided for @contratCloturer.
  ///
  /// In fr, this message translates to:
  /// **'Clôturer le contrat'**
  String get contratCloturer;

  /// No description provided for @contratDateSortie.
  ///
  /// In fr, this message translates to:
  /// **'Date de sortie'**
  String get contratDateSortie;

  /// No description provided for @statutA_venir.
  ///
  /// In fr, this message translates to:
  /// **'À venir'**
  String get statutA_venir;

  /// No description provided for @statutPayee.
  ///
  /// In fr, this message translates to:
  /// **'Payée'**
  String get statutPayee;

  /// No description provided for @statutPartielle.
  ///
  /// In fr, this message translates to:
  /// **'Partielle'**
  String get statutPartielle;

  /// No description provided for @statutEn_retard.
  ///
  /// In fr, this message translates to:
  /// **'En retard'**
  String get statutEn_retard;

  /// No description provided for @statutAnnulee.
  ///
  /// In fr, this message translates to:
  /// **'Annulée'**
  String get statutAnnulee;

  /// No description provided for @encaisserTitre.
  ///
  /// In fr, this message translates to:
  /// **'Encaisser'**
  String get encaisserTitre;

  /// No description provided for @encaisserBouton.
  ///
  /// In fr, this message translates to:
  /// **'Encaisser'**
  String get encaisserBouton;

  /// No description provided for @encaisserNombreMois.
  ///
  /// In fr, this message translates to:
  /// **'Nombre de mois'**
  String get encaisserNombreMois;

  /// No description provided for @encaisserPartiel.
  ///
  /// In fr, this message translates to:
  /// **'Paiement partiel'**
  String get encaisserPartiel;

  /// No description provided for @encaisserMontant.
  ///
  /// In fr, this message translates to:
  /// **'Montant'**
  String get encaisserMontant;

  /// No description provided for @encaisserTotal.
  ///
  /// In fr, this message translates to:
  /// **'Total'**
  String get encaisserTotal;

  /// No description provided for @encaisserMoyen.
  ///
  /// In fr, this message translates to:
  /// **'Moyen de paiement'**
  String get encaisserMoyen;

  /// No description provided for @encaisserReference.
  ///
  /// In fr, this message translates to:
  /// **'Référence (facultative)'**
  String get encaisserReference;

  /// No description provided for @encaisserDate.
  ///
  /// In fr, this message translates to:
  /// **'Date du paiement'**
  String get encaisserDate;

  /// No description provided for @encaisserRienADu.
  ///
  /// In fr, this message translates to:
  /// **'Aucune échéance due sur ce contrat.'**
  String get encaisserRienADu;

  /// No description provided for @encaisserSucces.
  ///
  /// In fr, this message translates to:
  /// **'Paiement enregistré. Reçu {numero}.'**
  String encaisserSucces(String numero);

  /// No description provided for @encaisserEnAttente.
  ///
  /// In fr, this message translates to:
  /// **'Hors ligne : paiement mis en file d\'attente.'**
  String get encaisserEnAttente;

  /// No description provided for @moyenEspeces.
  ///
  /// In fr, this message translates to:
  /// **'Espèces'**
  String get moyenEspeces;

  /// No description provided for @moyenMobile_money.
  ///
  /// In fr, this message translates to:
  /// **'Mobile money'**
  String get moyenMobile_money;

  /// No description provided for @moyenVirement.
  ///
  /// In fr, this message translates to:
  /// **'Virement'**
  String get moyenVirement;

  /// No description provided for @moyenAutre.
  ///
  /// In fr, this message translates to:
  /// **'Autre'**
  String get moyenAutre;

  /// No description provided for @moyenGarantie.
  ///
  /// In fr, this message translates to:
  /// **'Garantie'**
  String get moyenGarantie;

  /// No description provided for @recuProvisoire.
  ///
  /// In fr, this message translates to:
  /// **'REÇU PROVISOIRE — en attente de synchronisation, non envoyé au locataire.'**
  String get recuProvisoire;

  /// No description provided for @recuAnnule.
  ///
  /// In fr, this message translates to:
  /// **'Reçu annulé'**
  String get recuAnnule;

  /// No description provided for @recuEnvoyerWhatsapp.
  ///
  /// In fr, this message translates to:
  /// **'Envoyer par WhatsApp'**
  String get recuEnvoyerWhatsapp;

  /// No description provided for @recuEnvoyerSms.
  ///
  /// In fr, this message translates to:
  /// **'Envoyer par SMS'**
  String get recuEnvoyerSms;

  /// No description provided for @paiementsTitre.
  ///
  /// In fr, this message translates to:
  /// **'Paiements'**
  String get paiementsTitre;

  /// No description provided for @paiementsFileTitre.
  ///
  /// In fr, this message translates to:
  /// **'En attente de synchronisation'**
  String get paiementsFileTitre;

  /// No description provided for @paiementsRejete.
  ///
  /// In fr, this message translates to:
  /// **'Refusé par le serveur : {motif}'**
  String paiementsRejete(String motif);

  /// No description provided for @paiementsDeclarations.
  ///
  /// In fr, this message translates to:
  /// **'Déclarations des locataires'**
  String get paiementsDeclarations;

  /// No description provided for @paiementAnnuler.
  ///
  /// In fr, this message translates to:
  /// **'Annuler ce paiement'**
  String get paiementAnnuler;

  /// No description provided for @paiementMotif.
  ///
  /// In fr, this message translates to:
  /// **'Motif de l\'annulation'**
  String get paiementMotif;

  /// No description provided for @declarationValider.
  ///
  /// In fr, this message translates to:
  /// **'Valider'**
  String get declarationValider;

  /// No description provided for @declarationRefuser.
  ///
  /// In fr, this message translates to:
  /// **'Refuser'**
  String get declarationRefuser;

  /// No description provided for @declarationMotifRefus.
  ///
  /// In fr, this message translates to:
  /// **'Motif du refus'**
  String get declarationMotifRefus;

  /// No description provided for @locationsTitre.
  ///
  /// In fr, this message translates to:
  /// **'Mes locations'**
  String get locationsTitre;

  /// No description provided for @locationsAucune.
  ///
  /// In fr, this message translates to:
  /// **'Aucun contrat rattaché à votre numéro pour l\'instant.'**
  String get locationsAucune;

  /// No description provided for @locationsRattacher.
  ///
  /// In fr, this message translates to:
  /// **'Rattacher'**
  String get locationsRattacher;

  /// No description provided for @locationsARattacher.
  ///
  /// In fr, this message translates to:
  /// **'Contrats à confirmer'**
  String get locationsARattacher;

  /// No description provided for @declarerTitre.
  ///
  /// In fr, this message translates to:
  /// **'J\'ai payé'**
  String get declarerTitre;

  /// No description provided for @declarerAide.
  ///
  /// In fr, this message translates to:
  /// **'Votre bailleur validera ce paiement. En attendant, votre solde ne change pas.'**
  String get declarerAide;

  /// No description provided for @declarerEnvoyee.
  ///
  /// In fr, this message translates to:
  /// **'Déclaration envoyée à votre bailleur.'**
  String get declarerEnvoyee;

  /// No description provided for @marketTitre.
  ///
  /// In fr, this message translates to:
  /// **'Market'**
  String get marketTitre;

  /// No description provided for @marketVide.
  ///
  /// In fr, this message translates to:
  /// **'Aucune annonce pour l\'instant. Publiez une unité vacante ou parrainez un bailleur.'**
  String get marketVide;

  /// No description provided for @marketContacter.
  ///
  /// In fr, this message translates to:
  /// **'Contacter'**
  String get marketContacter;

  /// No description provided for @hotelsTitre.
  ///
  /// In fr, this message translates to:
  /// **'Hôtels'**
  String get hotelsTitre;

  /// No description provided for @hotelsVide.
  ///
  /// In fr, this message translates to:
  /// **'Aucun hôtel publié pour l\'instant.'**
  String get hotelsVide;

  /// No description provided for @hotelsDes.
  ///
  /// In fr, this message translates to:
  /// **'À partir de {prix} / nuit'**
  String hotelsDes(String prix);

  /// No description provided for @walletTitre.
  ///
  /// In fr, this message translates to:
  /// **'Wallet'**
  String get walletTitre;

  /// No description provided for @walletTotal.
  ///
  /// In fr, this message translates to:
  /// **'Solde total'**
  String get walletTotal;

  /// No description provided for @walletBailleur.
  ///
  /// In fr, this message translates to:
  /// **'Espace bailleur'**
  String get walletBailleur;

  /// No description provided for @walletLocataire.
  ///
  /// In fr, this message translates to:
  /// **'Espace locataire'**
  String get walletLocataire;

  /// No description provided for @walletSeuil.
  ///
  /// In fr, this message translates to:
  /// **'Le wallet est utilisable à partir de {seuil}.'**
  String walletSeuil(String seuil);

  /// No description provided for @abonnementsTitre.
  ///
  /// In fr, this message translates to:
  /// **'Abonnements'**
  String get abonnementsTitre;

  /// No description provided for @abonnementEtatNon_facture.
  ///
  /// In fr, this message translates to:
  /// **'Non facturée (vacante)'**
  String get abonnementEtatNon_facture;

  /// No description provided for @abonnementEtatGratuit.
  ///
  /// In fr, this message translates to:
  /// **'Gratuit'**
  String get abonnementEtatGratuit;

  /// No description provided for @abonnementEtatActif.
  ///
  /// In fr, this message translates to:
  /// **'Actif'**
  String get abonnementEtatActif;

  /// No description provided for @abonnementEtatGrace.
  ///
  /// In fr, this message translates to:
  /// **'À renouveler'**
  String get abonnementEtatGrace;

  /// No description provided for @abonnementEtatSuspendu.
  ///
  /// In fr, this message translates to:
  /// **'Suspendu'**
  String get abonnementEtatSuspendu;

  /// No description provided for @abonnementJusquAu.
  ///
  /// In fr, this message translates to:
  /// **'jusqu\'au {date}'**
  String abonnementJusquAu(String date);

  /// No description provided for @abonnementMontant.
  ///
  /// In fr, this message translates to:
  /// **'{usd} pour 12 mois ({pct} % du loyer)'**
  String abonnementMontant(String usd, String pct);

  /// No description provided for @abonnementPayerWallet.
  ///
  /// In fr, this message translates to:
  /// **'Payer avec le wallet'**
  String get abonnementPayerWallet;

  /// No description provided for @abonnementPayerMobile.
  ///
  /// In fr, this message translates to:
  /// **'J\'ai payé par mobile money'**
  String get abonnementPayerMobile;

  /// No description provided for @abonnementReference.
  ///
  /// In fr, this message translates to:
  /// **'Référence de la transaction'**
  String get abonnementReference;

  /// No description provided for @abonnementEnvoye.
  ///
  /// In fr, this message translates to:
  /// **'Paiement transmis pour validation.'**
  String get abonnementEnvoye;

  /// No description provided for @abonnementSuspenduBandeau.
  ///
  /// In fr, this message translates to:
  /// **'Abonnement expiré : renouvelez-le pour enregistrer des paiements.'**
  String get abonnementSuspenduBandeau;

  /// No description provided for @parrainageTitre.
  ///
  /// In fr, this message translates to:
  /// **'Parrainage'**
  String get parrainageTitre;

  /// No description provided for @parrainageCode.
  ///
  /// In fr, this message translates to:
  /// **'Votre code parrain'**
  String get parrainageCode;

  /// No description provided for @parrainageAide.
  ///
  /// In fr, this message translates to:
  /// **'Gagnez 2 \$ pour chaque contrat payé par un bailleur que vous parrainez.'**
  String get parrainageAide;

  /// No description provided for @profilTitre.
  ///
  /// In fr, this message translates to:
  /// **'Profil'**
  String get profilTitre;

  /// No description provided for @profilExporter.
  ///
  /// In fr, this message translates to:
  /// **'Télécharger mes données'**
  String get profilExporter;

  /// No description provided for @profilSupprimer.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer mon compte'**
  String get profilSupprimer;

  /// No description provided for @erreurRESEAU.
  ///
  /// In fr, this message translates to:
  /// **'Pas de connexion internet.'**
  String get erreurRESEAU;

  /// No description provided for @erreurSESSION.
  ///
  /// In fr, this message translates to:
  /// **'Votre session a expiré. Reconnectez-vous.'**
  String get erreurSESSION;

  /// No description provided for @erreurERREUR_SERVEUR.
  ///
  /// In fr, this message translates to:
  /// **'Le serveur rencontre un problème. Réessayez plus tard.'**
  String get erreurERREUR_SERVEUR;

  /// No description provided for @erreurVALIDATION.
  ///
  /// In fr, this message translates to:
  /// **'Vérifiez les informations saisies.'**
  String get erreurVALIDATION;

  /// No description provided for @erreurINTROUVABLE.
  ///
  /// In fr, this message translates to:
  /// **'Élément introuvable.'**
  String get erreurINTROUVABLE;

  /// No description provided for @erreurTELEPHONE_INVALIDE.
  ///
  /// In fr, this message translates to:
  /// **'Numéro invalide : utilisez le format international (+243…).'**
  String get erreurTELEPHONE_INVALIDE;

  /// No description provided for @erreurOTP_INVALIDE.
  ///
  /// In fr, this message translates to:
  /// **'Code incorrect.'**
  String get erreurOTP_INVALIDE;

  /// No description provided for @erreurOTP_EXPIRE.
  ///
  /// In fr, this message translates to:
  /// **'Code expiré : demandez un nouveau code.'**
  String get erreurOTP_EXPIRE;

  /// No description provided for @erreurTROP_DE_DEMANDES.
  ///
  /// In fr, this message translates to:
  /// **'Trop de demandes. Réessayez dans un moment.'**
  String get erreurTROP_DE_DEMANDES;

  /// No description provided for @erreurCODE_PARRAIN_INCONNU.
  ///
  /// In fr, this message translates to:
  /// **'Code parrain inconnu.'**
  String get erreurCODE_PARRAIN_INCONNU;

  /// No description provided for @erreurUNITE_OCCUPEE.
  ///
  /// In fr, this message translates to:
  /// **'Cette unité a déjà un contrat actif.'**
  String get erreurUNITE_OCCUPEE;

  /// No description provided for @erreurUNITE_SUSPENDUE.
  ///
  /// In fr, this message translates to:
  /// **'Abonnement expiré : renouvelez-le pour enregistrer des paiements.'**
  String get erreurUNITE_SUSPENDUE;

  /// No description provided for @erreurPAIEMENT_SUPERIEUR_AU_DU.
  ///
  /// In fr, this message translates to:
  /// **'Le montant dépasse le total restant dû.'**
  String get erreurPAIEMENT_SUPERIEUR_AU_DU;

  /// No description provided for @erreurDEVISE_INACTIVE.
  ///
  /// In fr, this message translates to:
  /// **'Cette devise n\'est plus proposée.'**
  String get erreurDEVISE_INACTIVE;

  /// No description provided for @erreurCONTRAT_CLOTURE.
  ///
  /// In fr, this message translates to:
  /// **'Ce contrat est clôturé.'**
  String get erreurCONTRAT_CLOTURE;

  /// No description provided for @erreurWALLET_SEUIL_NON_ATTEINT.
  ///
  /// In fr, this message translates to:
  /// **'Le wallet est utilisable à partir de 11 \$.'**
  String get erreurWALLET_SEUIL_NON_ATTEINT;

  /// No description provided for @erreurWALLET_SOLDE_INSUFFISANT.
  ///
  /// In fr, this message translates to:
  /// **'Solde du wallet insuffisant.'**
  String get erreurWALLET_SOLDE_INSUFFISANT;

  /// No description provided for @erreurCONVERSION_INDISPONIBLE.
  ///
  /// In fr, this message translates to:
  /// **'Conversion monétaire indisponible. Réessayez plus tard.'**
  String get erreurCONVERSION_INDISPONIBLE;

  /// No description provided for @erreurCOORDONNEES_INTERDITES.
  ///
  /// In fr, this message translates to:
  /// **'Les numéros de téléphone et coordonnées sont interdits dans la description.'**
  String get erreurCOORDONNEES_INTERDITES;

  /// No description provided for @erreurHOTEL_RESERVE_ENTREPRISES.
  ///
  /// In fr, this message translates to:
  /// **'La catégorie Hôtel est réservée aux entreprises vérifiées.'**
  String get erreurHOTEL_RESERVE_ENTREPRISES;

  /// No description provided for @erreurGenerique.
  ///
  /// In fr, this message translates to:
  /// **'Une erreur est survenue.'**
  String get erreurGenerique;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
