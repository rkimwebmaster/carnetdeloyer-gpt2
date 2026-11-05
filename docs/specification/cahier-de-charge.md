CarnetDeLoyer — Spécification fonctionnelle v2.1
Nov 4, 2026 · @Kilenge22 
1. Vision et principes
CarnetDeLoyer remplace le cahier de loyers papier : le bailleur suit ses loyers, ses locataires et ses reçus depuis son téléphone, et paie un abonnement par unité gérée. Chaque règle de ce document porte un numéro (R-xx) pour être citée par l'équipe.
• R-01 Client payant : le bailleur paie la gestion ; un locataire ne paie jamais pour son contrat. Le déblocage d'annonces du Market (R-106) est un service séparé, payé par le chercheur.
• R-02 Autonomie du bailleur : l'application est 100 % utilisable par le bailleur seul. Un locataire qui n'installe pas l'app existe comme simple contact créé par le bailleur.
• R-03 Pas de flux d'argent des loyers jusqu'à la v0.9 : l'app enregistre des paiements faits ailleurs (espèces, mobile money, virement).
• R-04 Chaîne métier à protéger : User → Propriété → Unité → Contrat → Échéance → Paiement → Reçu → Notification.
• R-05 Aucune donnée prise en otage : un bailleur qui ne paie plus garde l'accès en lecture à tout son historique.
• R-06 Aucune suppression de preuve : paiements, reçus et contrats ne sont jamais effacés, seulement annulés ou clôturés.
• R-07 Ouverture mondiale : aucune limitation par pays ou par ville, via l'API interne pays, villes et devises.
• R-08 Positionnement B2B : la cible prioritaire est le propriétaire professionnel qui fait de l'immobilier son activité, sans abandonner les petits bailleurs.
• R-09 Inscription obligatoire : toute personne qui installe l'app crée un compte à l'ouverture. Toutes les actions sont ainsi tracées à un utilisateur identifié.
2. Feuille de route
La v0.1 lance la location, le revenu d'abonnement et les vitrines du Market et des Hôtels ; la v0.5 et la v0.9 ajoutent des sources de revenus en réutilisant la même chaîne.
Chaque version s'appuie sur la précédente : les hôtels réutilisent les unités et le wallet, le Market se remplit avec les unités vacantes des bailleurs déjà inscrits.
3. v0.1 — Modèle de données
Une propriété contient des unités, et chaque contrat porte sur une seule unité.
Entité
Rôle
Règles clés
Utilisateur
Personne qui se connecte
Identifiée par son téléphone ; un compte, deux modes (bailleur et locataire)
Espace bailleur
Possède propriétés, abonnements et wallet
Séparé de l'utilisateur dès la v0.1 pour accueillir des gérants plus tard
Propriété
Parcelle ou immeuble
Adresse, ville, pays, coordonnées GPS
Unité
Logement, chambre, boutique, bureau, terrain, chambre d'hôtel
Catégorie avec icône, loyer indicatif, photos facultatives
Contrat
Location (ou séjour, ou achat) d'une unité
Clé étrangère vers la devise, montant propre, un locataire titulaire (Contact), dates de début et de fin, périodicité, jour de paiement
Échéance
Montant dû pour une période
Générée automatiquement, statut calculé
Paiement
Somme reçue
Auteur de la saisie tracé, imputé sur les échéances
Reçu
Preuve d'un paiement
Numéro séquentiel sans trou, jamais supprimé
Garantie
Dépôt de garantie d'un contrat
Versement initial puis compléments, un reçu par versement, règlement en fin de contrat (R-30 à R-32)
Renouvellement
Nouvelle version des conditions d'un contrat
Date d'effet, approbation tracée, seule façon de modifier un contrat verrouillé (R-177, R-178)
Fin de contrat
Clôture d'un contrat
Date de sortie, motif, initiateur, prorata, lien vers le règlement de la garantie (R-37)
• R-10 Une propriété simple (une seule maison) crée automatiquement une unité unique.
• R-11 Une unité n'a qu'un contrat actif à la fois. Sans contrat actif, elle est vacante.
• R-12 Un contrat a un seul locataire titulaire en v0.1 (pas de colocataires).
• R-13 Chaque paiement enregistre l'utilisateur qui l'a saisi.
• R-14 Montants stockés en entiers (centimes) avec leur code devise, jamais en nombres à virgule flottante.
• R-15 Référentiels : Pays (plusieurs villes, clé étrangère deviseParDefaut), Ville, et Devise comme entité distincte (code ISO, nom, symbole, nombre de décimales, active). Ils sont dans la même base que CarnetDeLoyer et exposés par une API publique en lecture seule, accessible sans connexion (nécessaire à l'inscription). Modifications depuis le back-office uniquement.
• R-16 Montants et devises : Contrat et Annonce ont leur propre clé étrangère devise et leur propre montant (loyer, prix par nuit ou prix de vente). Le loyer indicatif de l'unité sert seulement à pré-remplir ; le modifier ne change aucun contrat ni aucune annonce existants.
• R-17 Cascade pays et devise : l'Utilisateur a une clé étrangère pays, remplie à l'inscription depuis l'indicatif du téléphone et modifiable. Elle sert de défaut à une nouvelle propriété. La devise proposée pour un contrat ou une annonce est celle du pays de la propriété, sinon celle du pays du compte, et reste toujours modifiable.
• R-18 Une devise désactivée n'est plus proposée pour un nouveau contrat, mais reste valable pour les contrats existants.
• R-19 Le locataire d'un contrat est un Contact (fiche du locataire chez ce bailleur : nom, téléphone), distinct de l'Utilisateur. À la création du contrat, le serveur retrouve ou crée l'Utilisateur de ce numéro au statut non vérifié, et le Contact pointe vers lui (R-72).
• R-175 Périodicité : chaque contrat a une périodicité, mensuelle par défaut et seule active en v0.1. Trimestrielle, semestrielle et annuelle viendront plus tard ; les séjours d'hôtel sont journaliers (v0.5).
• R-176 Jour de paiement : un contrat mensuel (ou plus long) a un jour de paiement, entier de 1 à 28, par défaut le jour de la date de début plafonné à 28 et modifiable. Chaque échéance est due ce jour-là et les rappels s'appuient dessus. Les séjours d'hôtel n'en ont pas.
4. v0.1 — Échéances et paiements
Le bailleur touche « Encaisser » et l'app sait quels mois sont couverts : il n'a rien à calculer.
• R-20 Devise : une seule devise par contrat. Un paiement reçu dans une autre devise est saisi par le bailleur déjà converti.
• R-21 Génération : les échéances sont générées automatiquement (mensuelles par défaut) sur 12 mois glissants, jamais au-delà de la date de fin du contrat. Chaque échéance est due le jour de paiement du contrat (R-176).
• R-22 Statuts calculés : à venir, payée, partielle, en retard (date dépassée et non soldée). Le statut en retard apparaît dès le lendemain du jour de paiement ; les relances partent à J+3 (R-181).
• R-23 Pas de pénalités de retard.
• R-24 Montant pré-rempli : « Encaisser » propose la prochaine échéance due avec son montant. Aucune frappe dans le cas normal.
• R-25 Paiement d'avance : un sélecteur « Nombre de mois » calcule le total.
• R-26 Paiement partiel : un interrupteur déverrouille le champ montant.
• R-27 Imputation : un paiement solde d'abord l'échéance impayée la plus ancienne, puis les suivantes. Le bailleur peut corriger l'imputation à la main.
• R-28 Fin de contrat : date de fin optionnelle (sans date = reconduction tacite).
• R-179 Première échéance au prorata : si la date de début ne tombe pas le jour de paiement, la première échéance couvre de la date de début à la veille du premier jour de paiement. Le serveur la calcule au prorata sur une base de 30 jours (loyer ÷ 30 × jours, arrondi au centime). Exemple : 300 $, entrée le 20 octobre, paiement le 5, soit 16 jours = 160 $.
• R-179 (suite) Alerte à la création : l'app signale l'écart avant la validation du contrat et propose d'accepter ce montant, de le modifier, ou de changer le jour de paiement. Les échéances suivantes sont des loyers complets.
5. v0.1 — Garantie, reçus et clôture
Un reçu émis est une preuve définitive : on l'annule, on ne l'efface jamais.
Garantie locative
• R-30 La garantie est une entité à part, rattachée au contrat et dans sa devise. Elle reçoit un versement initial puis d'éventuels compléments, uniquement par renouvellement (R-177). Chaque versement a sa date de réception et son propre reçu ; la garantie vaut la somme des versements. Elle n'entre jamais dans le calcul des loyers dus.
• R-31 Les mois payés d'avance sont des paiements de loyer normaux (R-25), pas une garantie.
• R-32 À la clôture, la garantie passe à restituée, partiellement retenue (montant et motif) ou imputée sur loyers impayés (choix explicite du bailleur, qui génère une écriture). Le règlement porte sur le total de la garantie.
Reçus et corrections
• R-33 Numérotation séquentielle par espace bailleur, sans trou (exemple : CDL-2026-000123).
• R-34 Annulation d'un paiement avec motif obligatoire : contre-écriture, recalcul de l'imputation, reçu au statut annulé (il garde son numéro), locataire notifié.
• R-35 Correction = annulation puis nouvelle saisie, avec un nouveau reçu.
• R-36 Un paiement saisi hors ligne et pas encore synchronisé peut être supprimé librement.
Clôture de contrat
• R-37 La fin d'un contrat est une entité Fin de contrat (date de sortie, motif, initiateur, prorata, lien vers le règlement de la garantie). Les échéances postérieures à la sortie sont annulées. Le serveur propose une dernière échéance au prorata sur une base de 30 jours, que le bailleur accepte ou modifie. Un trop-perçu est affiché et le bailleur décide (remboursement hors de l'app ou imputation sur la garantie, R-32). Les impayés restent dus.
• R-38 La clôture déclenche le règlement de la garantie (R-32), puis l'unité redevient vacante. Le contrat clôturé passe en lecture seule.
Déclaration par le locataire
• R-39 En mode locataire, « J'ai payé » déclare un paiement : montant pré-rempli, référence de transaction, capture d'écran facultative.
• R-40 Le bailleur valide, en mode bailleur uniquement (paiement normal avec reçu) ou refuse (avec motif). En attente ou refusée, la déclaration ne modifie jamais le solde. Relance au bailleur sans réponse, jamais de validation automatique.
• R-180 Preuve conservée : la référence (numéro de bordereau ou de transaction mobile) et la capture de la preuve restent attachées à la déclaration, validée ou refusée (R-06). La capture est compressée sur le téléphone, stockée en privé et visible seulement par le bailleur, le locataire et un gestionnaire du territoire, via un lien temporaire.
Renouvellement de contrat
• R-177 Contrat verrouillé : un contrat est modifiable librement jusqu'au premier paiement enregistré ou à la confirmation par le locataire, selon ce qui arrive en premier. Ensuite, tout changement (loyer, jour de paiement, date de fin, complément de garantie) passe par un renouvellement : une nouvelle version des conditions, rattachée au même contrat, avec une date d'effet. L'historique des paiements reste intact et les échéances futures sont recalculées.
• R-178 Approbation : si le locataire a confirmé le contrat dans l'app, il approuve le renouvellement dans l'app. Sinon, le bailleur atteste l'accord du locataire, avec une photo du document signé en option, et l'attestation est tracée dans l'activité. En cas de litige, un gestionnaire du territoire approuve ou annule depuis le back-office.
6. Modèle économique
Le bailleur paie 9,9 % du loyer mensuel par an et par unité louée, après 12 mois gratuits sur sa première unité. Exemple : une unité à 300 $ par mois coûte 29,70 $ par an.
Abonnement par unité
• R-50 Gratuité : la première unité est gratuite les 12 premiers mois, une seule fois par compte. Elle devient payante au 13e mois.
• R-51 Tarif : 9,9 % (par défaut) du loyer mensuel du contrat, par an et par unité, dès la 2e unité.
• R-52 Une unité vacante n'est pas facturée. L'abonnement se paie à l'activation du contrat et court 12 mois à partir de cette date.
• R-53 Un contrat qui se termine en cours de période ne donne pas lieu à remboursement. Un nouveau contrat sur la même unité crédite le reste non consommé dans le wallet du bailleur.
• R-54 Un changement de loyer, y compris par renouvellement de contrat (R-177), ne change l'abonnement qu'à sa période suivante. Un renouvellement de contrat ne crée pas de nouvelle période d'abonnement ; seul un nouveau contrat sur l'unité déclenche le crédit du reste au wallet (R-53).
Renouvellement et suspension
• R-55 Rappels à J-15, J-3 et J, puis 15 jours de grâce avec un bandeau d'alerte.
• R-56 Ensuite, l'unité est suspendue : historique consultable, mais plus de saisie de paiement ni d'émission de reçu. Les échéances continuent d'être générées. Le locataire garde ses reçus.
• R-57 Réactivation : nouvelle période de 12 mois à la date du paiement, sans rattrapage.
Paiement de l'abonnement
• R-58 Agrégateur mobile money avec confirmation automatique, et validation manuelle dans le back-office en secours (référence de transaction saisie par le bailleur).
• R-183 Historique des abonnements : chaque période d'abonnement est une ligne jamais modifiée ni supprimée (unité, contrat, dates de début et de fin, taux appliqué, montant, taux de change, paiement, statut). Un renouvellement d'abonnement crée une nouvelle ligne. Cet historique sert aux factures (R-165), aux calculs de R-50, R-53 et R-57, au tableau de bord (R-114) et aux comptes par territoire (R-188).
Wallet
• R-60 Le wallet est en USD. En v0.1, c'est un crédit interne qui sert uniquement à payer des abonnements CDL.
• R-61 Chaque mouvement est une écriture de journal typée (crédit ou débit, motif, référence). Le solde se calcule depuis le journal, jamais modifié directement.
• R-62 Utilisation ou retrait possible seulement à partir de 11 USD (par défaut), pour tout le wallet. Un message clair explique le seuil. Exception : le débit des commissions d'hôtel (R-92).
• R-63 En v0.9, le wallet devient retirable et utilisable pour payer les loyers.
Question ouverte : un seul wallet par compte, sans distinction de mode bailleur ou locataire ? En attendant, R-147 et R-148 restent en vigueur.
Parrainage
• R-65 Location : le parrain gagne 2 USD (par défaut), à vie, à chaque contrat de son filleul dont l'abonnement est effectivement payé, même pour un petit loyer. Rien sur la première unité gratuite.
• R-66 Hôtel : le parrain gagne un pourcentage de la commission encaissée (20 % par défaut), jamais un montant fixe.
Paramètres et devises
• R-67 Les valeurs par défaut (9,9 %, 2 USD, 11 USD, 20 %, 2 %, prix du SMS payant) se règlent dans le back-office, avec historique. Une dérogation par compte est possible.
• R-68 Jamais rétroactif : chaque paiement enregistre la valeur appliquée au moment où il est fait. Le bailleur voit le montant exact avant de payer.
• R-69 La commission est calculée dans la devise du contrat, puis convertie en USD via une API de conversion monétaire. Le taux est figé au paiement.
7. Comptes, identification et notifications
Le numéro de téléphone est la clé de tout : connexion, rattachement du locataire et envoi des reçus.
• R-70 Identifiant principal : le téléphone au format international. E-mail facultatif.
• R-71 Connexion par code OTP envoyé par SMS à l'inscription et sur un nouvel appareil, puis code PIN ou biométrie. Pas de mot de passe.
• R-72 À la création d'un contrat, le serveur retrouve ou crée le compte du locataire au statut non vérifié, à partir de son numéro. Quand le locataire s'inscrit, l'OTP vérifie son compte et il confirme chaque contrat créé avec son numéro avant d'y accéder. Tant que le locataire n'a pas confirmé le contrat, le bailleur peut corriger le numéro : le contrat se détache de l'ancien compte, qui perd l'accès. Une fois le contrat confirmé, le numéro est verrouillé pour le bailleur ; le locataire change lui-même son numéro depuis son profil, avec un OTP, et garde ses contrats.
• R-73 Un compte, deux modes (bailleur et locataire), avec une bascule accessible à tous les profils.
• R-74 Reçus et rappels de loyer : l'app ouvre WhatsApp ou les SMS du téléphone du bailleur avec le message et le lien déjà rédigés. Coût nul pour CDL. L'invitation à installer l'app, proposée à la création du contrat, suit le même principe ; le locataire n'est jamais obligé d'installer l'app.
• R-75 Le lien du reçu ouvre une page web publique sécurisée (lien unique non devinable), consultable sans compte.
• R-76 Notifications push gratuites pour tous les utilisateurs de l'app.
• R-77 SMS envoyés par le serveur limités aux codes OTP, aux rappels d'expiration d'abonnement et à l'option SMS payants (R-184).
• R-181 Rappels de loyer par notification push : au locataire à J-3 et le jour J (avec un bouton « J'ai payé »), puis au locataire et au bailleur à J+3 si l'échéance n'est pas soldée, une seule relance par échéance. Le bailleur reçoit chaque matin un résumé des loyers dus et des retards. Chaque type de rappel peut être désactivé.
• R-182 Refus du contrat : si le locataire indique dans l'app qu'un contrat ne le concerne pas, le contrat est détaché de son compte et le refus est tracé. Le bailleur est notifié et corrige le numéro ; le contrat reste valable de son côté (R-02).
SMS payants
• R-184 Activation et facturation : pour joindre un locataire qui n'a pas l'app, le bailleur active l'option SMS payants dans les paramètres d'un contrat, avec le prix affiché avant l'activation. Chaque SMS envoyé par le serveur débite le wallet du prix réglable dans le back-office (R-67), sans le seuil de 11 USD (R-62). Solde insuffisant : le SMS n'est pas envoyé, le bailleur est prévenu et l'app propose l'envoi depuis son téléphone (R-74).
• R-185 Messages et arrêt : le bailleur coche les messages voulus : reçu après chaque paiement (avec le lien R-75), rappel avant échéance, relance de retard (une fois par échéance). L'option s'arrête automatiquement quand le locataire a installé l'app et confirmé le contrat : il reçoit alors les notifications push gratuites (R-181).
Inscription et guide de démarrage
• R-160 Inscription en moins d'une minute : téléphone, code OTP, nom, puis code parrain facultatif. Le PIN se crée juste après. Le reste du profil se complète plus tard.
• R-161 À la première connexion, une seule étape obligatoire : choisir le mode par défaut (bailleur ou locataire).
• R-162 Étapes proposées avec un bouton « Plus tard » : première propriété avec ses unités, publication sur le Market, infos entreprise, demande de vérification. En mode locataire : retrouver ses contrats et saisir un code parrain.
• R-163 Une carte de progression sur l'Accueil permet de reprendre le guide, et disparaît une fois terminé. L'étape « première propriété » est sautée si les données ont été importées.
Comptes professionnels
• R-164 Profil entreprise facultatif sur l'espace bailleur : raison sociale, logo, numéro RCCM ou fiscal, adresse. Il apparaît sur les reçus.
• R-165 Factures d'abonnement au nom du bailleur, téléchargeables en PDF.
• R-166 Import en masse par fichier Excel ou CSV (modèle fourni) : propriétés, unités, locataires, contrats, avec rapport d'erreurs avant validation. Les arriérés sont saisis en une ligne de solde de départ.
• R-167 Import assisté depuis le back-office pour les partenaires : l'équipe CDL charge leurs données avant leur première connexion.
Vérification des comptes
• R-168 Demande depuis l'app : pièce d'identité pour un particulier, RCCM ou équivalent pour une entreprise, envoyés par photo.
• R-169 Traitement par un rôle vérificateur dans le back-office : approuvée ou refusée avec motif.
• R-170 On conserve le résultat (badge, type identité vérifiée ou entreprise vérifiée, date, auteur, expiration), pas les pièces, supprimées automatiquement quelques jours après la décision.
• R-171 Le badge s'affiche sur les annonces du Market et sur la fiche du bailleur vue par ses locataires. Il peut être retiré en cas de signalements.
Fil d'activité
• R-172 Une entité Activité (acteur, espace, type en code, objet visé, paramètres, date) est créée automatiquement par le serveur à chaque action importante : paiement enregistré ou annulé, déclaration du locataire, contrat créé ou clôturé, abonnement payé ou bientôt expiré, gain de parrainage, annonce publiée, badge obtenu.
• R-173 En mode bailleur, on voit toute l'activité de son espace ; en mode locataire, uniquement celle de ses propres contrats. Le texte est traduit à partir du code et des paramètres.
• R-174 L'Accueil affiche les 10 dernières activités avec « Tout voir » ; chaque ligne ouvre l'élément concerné. Conservation de 12 mois dans le fil. Ce fil est distinct du journal d'audit des administrateurs (R-115).
8. Hors ligne, photos, carte et langues
Le geste le plus fréquent sur le terrain, enregistrer un loyer reçu, fonctionne sans réseau.
Hors ligne
• R-80 Consultation hors ligne : propriétés, unités, contrats, échéances et soldes en cache sur le téléphone.
• R-81 Saisie de paiement hors ligne mise en file d'attente, envoyée au retour du réseau. Hors ligne, l'app affiche un reçu provisoire clairement marqué, non envoyé au locataire.
• R-82 Le reçu définitif et son numéro sont émis par le serveur à la synchronisation. Tout le reste (contrat, abonnement, wallet) exige une connexion.
• R-186 Stockage local mixte : des tables dédiées (propriétés, unités, contrats, échéances, paiements, reçus) permettent de chercher et de filtrer hors ligne ; le reste (wallet, abonnements, activité) est gardé en cache de réponses. Ces données sont une copie des valeurs calculées par le serveur, jamais recalculées sur le téléphone (R-135).
• R-187 Market et Hôtels hors ligne : listes et fiches restent consultables en lecture seule, avec la mention « Mis à jour il y a X » et un avertissement sur la disponibilité. Toute action (contact, publication, séjour, déblocage) passe par le serveur ; hors ligne, le bouton affiche « Connexion nécessaire ». Les détails payants (R-106) ne sont mis en cache qu'une fois débloqués.
Photos
• R-83 Dans les listes, une icône par catégorie d'unité. Les photos ne s'affichent que sur la page détail. L'icône de catégorie est le repère principal : les bailleurs ne sont pas des professionnels de la photo. Les icônes, gérées en base (R-117), sont toujours disponibles hors ligne.
• R-84 Photos facultatives, 6 au maximum par unité ou annonce (paramétrable), compressées sur le téléphone (environ 1 280 px et 200 Ko), avec miniature.
• R-85 Chargées seulement à l'ouverture de la page détail, jamais en cache hors ligne en grand format (seules les miniatures le sont), stockées sur un stockage objet compatible S3.
• R-86 Bouton « Signaler » et retrait depuis le back-office. Coordonnées interdites dans les photos.
Géolocalisation
• R-87 Coordonnées saisies à la création de la propriété, par GPS ou en plaçant une épingle.
• R-88 Position exacte privée (bailleur et locataire rattaché). Sur le Market, zone approximative ; position exacte affichée pour les hôtels. Carte basée sur OpenStreetMap.
Langues
• R-89 v0.1 en français, puis anglais et swahili. Internationalisation prévue dès la v0.1 : aucun texte en dur, codes d'erreur dans l'API. Reçus en français.
9. v0.5 — Hôtels
Une chambre d'hôtel est une unité de catégorie hôtel : elle réutilise toute la chaîne, avec des échéances journalières et une commission à chaque séjour au lieu d'un abonnement annuel.
• R-90 Un séjour = un contrat sur une chambre, avec dates d'arrivée et de départ. Montant pré-rempli : nombre de nuits × prix par nuit.
• R-91 Commission de 9,9 % (par défaut) du montant de chaque séjour. Exemple : 2 nuits à 30 $ rapportent 5,94 $.
• R-92 L'hôtel recharge un wallet prépayé. Chaque séjour débite automatiquement la commission, quel que soit le solde au regard du seuil de 11 USD. Solde insuffisant : création du séjour bloquée avec « Rechargez votre wallet ».
• R-93 Client : nom obligatoire, téléphone fortement conseillé. Sans téléphone, le reçu est imprimé ou montré à l'écran. Un client qui revient est retrouvé par son numéro.
• R-94 Une chambre a un seul séjour actif à la fois et peut être réattribuée le jour même du départ.
• R-95 Pas de garantie pour les séjours.
• R-96 Parrainage hôtel selon R-66 (pourcentage de la commission).
• R-97 Dès la v0.1, une vitrine des hôtels : propriétés de catégorie hôtel avec prix indicatif par nuit, position exacte et contact. La gestion des séjours (R-90 à R-96) arrive en v0.5.
• R-98 Seules les entreprises avec le badge entreprise vérifiée (R-170) peuvent publier dans la catégorie Hôtels. Un hôtelier gère ses chambres depuis ses Biens, en mode bailleur.
Risque connu : un hôtel peut ne pas déclarer certains séjours. Ce risque commercial est à suivre, il n'a pas de parade technique en v0.5.
10. v0.9 — CDL Market
Le Market publie les unités vacantes à louer et les biens à vendre ; le contact se fait par WhatsApp ou appel, et chaque affaire conclue passe par un contrat dans l'app.

Location
Vente
Source de l'annonce
Unité vacante publiée en un geste
Bien à vendre (maison, terrain, bureau…)
Contrat
Contrat de location
Contrat d'achat (vendeur, acheteur, prix, date, paiements, reçus)
Ce que paie le bailleur ou vendeur
Publication incluse dans l'abonnement ; mise en avant payante possible
2 % du prix affiché (par défaut), payés à la publication
Durée de l'annonce
Jusqu'à la location ou le retrait
Jusqu'à la vente ou le retrait, sans expiration
• R-100 Annonce à louer ou à vendre, avec catégorie (icône), prix, zone et description courte. Photos sur la page détail uniquement (R-83).
• R-101 Tous les utilisateurs sont connectés (R-09) : la consultation et le contact par WhatsApp ou appel sont toujours tracés. Aucune transaction ne passe par l'app.
• R-102 Une location trouvée sur le Market se crée en contrat depuis l'annonce, ce qui déclenche l'abonnement (R-52).
• R-103 Vente : aucun remboursement si le bien ne se vend pas, si l'annonce est retirée ou si le prix baisse.
• R-104 Vente : prix final ou prix affiché en hausse, le vendeur paie le complément de 2 % sur la différence pour clôturer le contrat d'achat.
• R-105 L'encaissement des loyers par mobile money et le wallet retirable (R-63) arrivent avec la v0.9.
• R-106 Déblocage des détails : plus tard, voir le contact du bailleur, l'adresse détaillée et la carte précise sera payant, avec un forfait gratuit limité dans le temps ou en nombre de biens. Le quartier, la ville et le pays restent toujours visibles. Activé seulement quand le nombre d'annonces atteint un seuil (par ville). Prix et forfait réglables dans le back-office, paiement par le wallet. Une entité Déblocage (utilisateur, annonce, date, source) est préparée dès la v0.9.
• R-107 Vitrine dès la v0.1 : l'onglet Market affiche déjà les unités vacantes à louer, publiées gratuitement en un geste par leur propriétaire. La vente et ses règles (R-103, R-104) arrivent en v0.9.
• R-108 Seul le propriétaire d'une unité gérée dans l'app peut la publier : pas d'annonces libres d'intermédiaires.
• R-109 Numéros de téléphone et coordonnées interdits et filtrés dans les descriptions, comme dans les photos. Une liste vide affiche une invitation à publier une unité vacante ou à parrainer un bailleur.
11. Back-office et intégrations
Le back-office couvre le strict nécessaire pour exploiter l'app sans jamais intervenir directement en base de données ; il est développé sur mesure (Twig et Bootstrap) dans le projet Symfony, sous /admin, et réutilise les services de l'API pour ne jamais dupliquer la logique métier.
Écrans
• R-110 Comptes : recherche par téléphone ou nom, consultation (propriétés, unités, contrats, wallet), suspension.
• R-111 Paiements d'abonnement : file des paiements manuels à valider ou rejeter.
• R-112 Paramètres : valeurs par défaut avec historique et dérogations par compte (R-67).
• R-113 Wallet : ajustement uniquement par écriture motivée, jamais en modifiant le solde.
• R-114 Tableau de bord : comptes actifs, unités payantes, chiffre d'affaires du mois, renouvellements à venir.
• R-115 Journal d'audit : chaque action d'un administrateur est tracée (qui, quoi, quand, sur quel territoire).
• R-116 Rôles : super-administrateur (tout, y compris les paramètres globaux), gestionnaire pays, gestionnaire ville, support et vérificateur, chacun limité à son territoire (R-188). Le support n'a accès ni aux paramètres ni au wallet.
• R-117 Référentiels : pays, villes, devises (activer ou désactiver) et catégories d'unités avec leurs icônes, sans redéploiement.
• R-118 Intégrations : pour chaque API externe, état, dernière synchronisation réussie et dernières erreurs.
• R-188 Territoires : une propriété appartient à la ville et au pays de son adresse, et ses unités, contrats, paiements et reçus suivent ; un compte appartient à son pays (R-17). Un gestionnaire de ville ne voit que les biens de sa ville. Les actions sur un compte (suspension, ajustement du wallet) sont réservées au gestionnaire du pays ou au-dessus. Le périmètre est contrôlé côté serveur sur chaque requête. Ce découpage prépare un futur modèle de franchise.
Solutions de secours
API
En cas de panne
Conversion monétaire
Dernier taux connu s'il a moins de 48 h, sinon paiement hors USD bloqué avec un message clair
Agrégateur mobile money
Bascule vers la validation manuelle (R-58)
SMS (OTP)
Second fournisseur en secours
• R-119 Les clés d'API restent dans la configuration du serveur, jamais en base de données ni dans le back-office. L'API de l'app est versionnée sous /api/v1, avec authentification par token Bearer.
Site vitrine
• R-189 Site minimal : un site en Twig dans le projet Symfony présente CarnetDeLoyer : Accueil (liens Google Play, App Store et Microsoft Store), Fonctionnalités, Tarifs (lus depuis les paramètres R-67), Contact et pages légales (conditions d'utilisation, politique de confidentialité, mentions légales). Il n'y a pas de version web pour les clients : la version bureau est l'app Windows (R-157). Seule exception : la page publique du reçu (R-75).
12. Données personnelles et sécurité
On respecte les droits de chacun sans jamais détruire une preuve dont l'autre partie a besoin.
• R-120 Données minimales en v0.1 : nom, téléphone, e-mail facultatif. Aucune pièce conservée au-delà de la vérification (R-170).
• R-121 Le premier message envoyé à un locataire contient un lien vers la politique de confidentialité.
• R-122 Suppression de compte : données personnelles anonymisées ; contrats, paiements et reçus conservés pendant la durée légale.
• R-123 Export : chaque utilisateur peut télécharger ses données (contrats, reçus).
• R-124 HTTPS partout, téléphones et coordonnées GPS chiffrés en base, sauvegardes chiffrées.
Question ouverte : la durée légale de conservation varie selon les pays, et reste à fixer avec un juriste.
13. Architecture mobile (Flutter)
L'app est découpée par domaine métier autour d'un noyau partagé, et n'affiche que des valeurs calculées par le serveur.
Les écrans lisent les providers, qui passent par les services ; seuls les services parlent à l'API et au cache local.
Organisation du code
• R-130 Un noyau core/ partagé : modèles métier (Unité, Contrat, Échéance, Paiement, Reçu), client API (Dio), cache Drift, erreurs, thème, traductions, widgets communs.
• R-131 Features par domaine : auth, biens, contrats, paiements, abonnement, wallet, hotel, market, statistiques, home. Pas de dossier de pages secondaires : chaque écran vit dans la feature de son domaine.
• R-132 home est une feature d'assemblage : elle lit les providers des autres features, sans logique propre.
• R-133 Chaque feature contient screens/, widgets/, services/ (API et cache, sans état), providers/ (controllers Riverpod) et models/ (modèles propres à la feature uniquement).
• R-134 Outils : riverpod_generator, freezed, json_serializable. Les services sont exposés via des providers pour être remplacés en test.
• R-190 Feature locations : visible en mode locataire uniquement (onglet « Mes locations »). Elle liste les contrats actifs du locataire, avec des raccourcis sur chacun : déclarer un paiement (« J'ai payé », R-39), voir tous les paiements du contrat, voir les détails de la propriété. Elle s'ajoute aux features de R-131.
Logique métier
• R-135 Le serveur calcule, l'app affiche : statuts d'échéances, soldes, montants pré-remplis, abonnements et commissions viennent de l'API. Seul l'aperçu « loyer × nombre de mois » est calculé sur le téléphone.
Hors ligne
• R-136 Drift (SQLite) pour le cache et une table outbox des paiements en attente (états : en attente, envoyé, rejeté avec motif).
• R-137 Chaque paiement reçoit sur le téléphone un UUID envoyé comme clé d'idempotence. Le backend renvoie le paiement existant si la clé a déjà été reçue.
• R-138 Hors ligne, les soldes affichés sont ceux du cache ; les paiements en attente apparaissent à part, sans recalcul. Envoi automatique au retour du réseau, plus un bouton « Synchroniser ».
• R-139 La file d'attente est liée à l'utilisateur : elle n'est jamais envoyée sous un autre compte.
Sessions
• R-140 Token d'accès d'environ 1 heure, token de rafraîchissement de 60 jours avec rotation (LexikJWTAuthenticationBundle et un bundle de refresh tokens côté Symfony).
• R-141 Un intercepteur Dio rafraîchit le token automatiquement. PIN ou biométrie déverrouillent l'app sans réseau. Token et PIN dans flutter_secure_storage.
• R-142 Rafraîchissement expiré : nouvel OTP, file d'attente conservée et envoyée après reconnexion.
Navigation et modes
• R-143 go_router avec deux espaces de navigation étanches et des gardes de route (non connecté, mauvais mode).
Mode
Onglets
Bailleur
Accueil, Biens, Paiements (encaissements), Market, Hôtels
Locataire
Accueil, Mes locations, Paiements (et reçus), Market, Hôtels
• R-144 modeActif est une énumération (bailleur, locataire), extensible, stockée sur le téléphone. Le serveur garde la dernière préférence pour un nouvel appareil, sans effet sur les droits : chaque appel API est autorisé selon ce que l'utilisateur possède.
• R-145 Bascule depuis le Profil ou le menu latéral (drawer). Elle remet la navigation à zéro dans l'autre mode.
• R-146 Liens profonds : un lien de reçu ouvre l'app si elle est installée, sinon la page web publique.
• R-155 Les cinq onglets sont présents dès la v0.1. Le drawer contient le reste : Wallet, Abonnements, Statistiques, Parrainage, Vérification, Profil, bascule de mode, Paramètres. Un onglet peut être activé ou masqué depuis le back-office (feature flag), sans mise à jour sur les stores.
• R-156 Mise en page adaptative dès la v0.1 : sur grand écran, listes en tableaux, navigation à gauche et panneau latéral fixe au lieu du drawer.
• R-157 Version Windows avec le même code Flutter, publiée juste après la v0.1 mobile. Adaptations : épingle sur la carte au lieu du GPS, WhatsApp Web ou copie du lien pour les reçus, PIN ou Windows Hello, notifications Windows et rappels importants par e-mail ou SMS. Distribution par le Microsoft Store ou un installateur sur le site.
Wallet
• R-147 Un journal d'écritures par utilisateur, chaque écriture étiquetée par espace (bailleur ou locataire). Soldes par espace calculés, solde total = solde de l'utilisateur.
• R-148 Le seuil de 11 USD s'applique au total. Une dépense puise d'abord dans l'espace où elle a lieu, puis dans l'autre. Le locataire accumule ses gains, utilisables s'il devient bailleur, puis pour payer à terme (loyer).
Erreurs
• R-149 L'API renvoie un code métier, un message technique et les erreurs par champ. core/errors/ convertit toute réponse en erreur typée (réseau, session, validation, règle métier, serveur).
• R-150 Chaque code a son message traduit, avec un message de secours. Bandeau hors ligne, rafraîchissement de session et erreur serveur gérés globalement. Plantages remontés dans Firebase Crashlytics.
Appareils, environnements et tests
• R-151 Android en priorité, minimum Android 7 (API 24), puis iOS. Moins de 25 Mo installée (App Bundle), icônes vectorielles, API paginée et compressée. Tests réguliers sur un téléphone de 2 Go de RAM.
• R-152 Trois environnements (dev, staging avec agrégateur en bac à sable, prod), chacun avec son URL, son nom et son icône.
• R-153 Tests prioritaires : file hors ligne et idempotence, rafraîchissement de token, conversion des erreurs, gardes de navigation. Tests de widgets sur « Encaisser », création de contrat et wallet.
• R-154 GitHub Actions : analyse et tests à chaque envoi, puis version staging générée automatiquement.
14. Hors périmètre et évolutions prévues
Ces sujets sont volontairement exclus de la v0.1 ; le modèle de données les prépare quand c'est indiqué.
Sujet
Prévu
Préparation dès la v0.1
Délégation à un gérant (rôles, droits limités)
Après v0.1
Espace bailleur séparé de l'utilisateur, auteur tracé sur chaque paiement
Encaissement des loyers par mobile money
v0.9
Le paiement est une écriture qui peut avoir plusieurs sources
Wallet retirable et paiement des loyers par wallet
v0.9
Journal d'écritures typées
Réservation d'hôtel en ligne (calendrier, paiement)
Non planifié
Aucune
Colocataires sur un même contrat
Non planifié
Aucune
Alignement des abonnements sur une date unique
Non planifié
Aucune
Anglais et swahili
Après v0.1
Internationalisation (R-89)
Périodicités trimestrielle, semestrielle, annuelle
Après v0.1
Champ périodicité du contrat (R-175)
Franchise et partage des revenus par territoire
Non planifié
Territoires et rôles du back-office (R-188)
15. Questions ouvertes et historique
Quatre points restent à trancher ; la version 2.1 intègre les décisions du 4 novembre 2026.
Questions ouvertes
• Un seul wallet par compte, sans distinction de mode (R-147, R-148) ?
• Correspondance des tables pays, villes et devise avec la base existante, à vérifier avant toute migration.
• Partage des revenus avec les futurs franchisés.
• Durée légale de conservation des données (section 12).
Historique
Version
Date
Changements
2.1
4 nov. 2026
Compte locataire non vérifié dès le contrat (R-19, R-72), refus du contrat (R-182), invitation (R-74), SMS payants (R-184, R-185), rappels push et retard (R-181, R-22), périodicité et jour de paiement (R-175, R-176), prorata d'entrée et de sortie (R-179, R-37), garantie, fin de contrat et renouvellement (R-30, R-177, R-178), preuve de paiement conservée (R-180), historique des abonnements (R-183), stockage local mixte et Market hors ligne (R-186, R-187), icônes (R-83, R-85), back-office sur mesure et territoires (section 11, R-116, R-188), site vitrine (R-189), feature locations (R-190)
2.0
27 oct. 2026
Règles numérotées R-xx issues des séances de questions