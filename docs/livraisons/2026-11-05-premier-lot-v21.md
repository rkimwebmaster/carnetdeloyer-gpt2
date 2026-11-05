# Premier lot d'alignement v2.1 — 5 novembre 2026

## Fonctionnalités

- R-15 : `php bin/console app:referentiels:charger --verifier-schema` contrôle les tables pays, villes et devise en lecture seule. Un schéma incompatible bloque aussi le chargement normal, sans correction automatique ni migration.
- R-15, R-117 : tests des pays et villes désactivés, préservation des données, chargement idempotent, colonnes historiques, index uniques et clés étrangères en cascade.
- R-22 : le filtre des contrats en retard utilise l'horloge de l'application, comme le calcul des échéances, plutôt que la date propre au serveur SQL.
- R-154 : workflow GitHub Actions avec API PHP 8.2/MariaDB 10.11, migrations, validation Doctrine, analyse et tests Flutter.
- Charte graphique : thème bordeaux et ambre, modes clair et sombre, boutons 50 px, focus contrasté, typographie et composants communs. Pastilles de statut adaptées au fond. Tests de contraste et de formulaire avec texte agrandi.

## Vérifications

- Exécuté localement : Composer install et validate ; 123 tests PHP, 930 assertions sur SQLite. SQLite vérifie les parcours mais ne remplace pas la validation des migrations MySQL ni les tests de concurrence.
- Première exécution GitHub Actions (commit dfbe04a) : API PHP 8.2/MariaDB et Flutter réussis. Cette exécution précède les tests supplémentaires et le changement de thème ; vérifier la dernière exécution pour ces ajouts.
- Le SDK Flutter n'est pas disponible localement : les contrôles Flutter s'exécutent dans GitHub Actions.
- Pas de validation visuelle sur téléphone réel ni de test de concurrence exécuté dans ce lot.

## Base locale existante

Les entités historiques fournies ont été comparées au code. Elles ne prouvent pas le schéma réel de la base du PC : obtenir le résultat de `--verifier-schema` et la structure SQL avant de préparer une migration de reprise. `Devise` utilise notamment `is_active` dans l'ancien modèle et `active`/`decimales` dans le nouveau. L'ancienne relation ville-pays permet une suppression en cascade ; le nouveau modèle la protège.

Aucune base du PC n'a été modifiée. Le contrôle compare la structure ; il ne valide pas la qualité ou l'exhaustivité des données.

## Suite de l'implémentation, feature par feature

| Ordre | Lot | Vérifications attendues |
|---|---|---|
| 1 | Référentiels et socle des tests — présent dans ce lot | Contrôle de structure, lecture publique, idempotence, conservation |
| 2 | Comptes et rattachement locataire R-19/R-72/R-182 | Compte non vérifié, OTP, confirmation par contrat, refus, retrait d'accès, absence de fuite entre comptes |
| 3 | Contrats R-175 à R-179 | Jour 1–28, périodicité, prorata, verrouillage et approbation du renouvellement |
| 4 | Garanties et fins de contrat R-30/R-37 | Versements multiples, reçus, impayés, trop-perçu, clôture |
| 5 | Paiements et justificatifs R-180 | Preuve privée, validation/refus, idempotence, annulation et concurrence |
| 6 | Abonnements, wallet et parrainage R-183 | Historique immuable, taux figé, grâce, suspension et écritures |
| 7 | Hors ligne et notifications R-181/R-184 à R-187 | Cache dédié, reprise réseau, file par utilisateur, SMS et push |
| 8 | Back-office, territoires et site R-188/R-189 | Autorisations serveur, audit, paramètres et pages publiques |
| 9 | Vitrines Market/Hôtels et finalisation multiplateforme | Droits de publication, disponibilité, liens, écrans et builds |

Ce lot ne constitue pas l'application v2.1 complète. Les livraisons suivantes doivent conserver les tests verts et documenter toute migration.
