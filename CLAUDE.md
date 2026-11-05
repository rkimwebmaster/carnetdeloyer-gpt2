# CarnetDeLoyer — consignes pour Claude

Gestion locative pour bailleurs professionnels (B2B), avec un mode locataire, une vitrine Market et une vitrine Hôtels.
Un seul dépôt : API Symfony, application Flutter (Android, iOS, Windows), back-office et site vitrine.

## Règle d'or

- **La spécification fait foi** : `docs/specification/cahier-des-charges.md` (règles numérotées R-xx).
  Version de référence modifiable : https://claude.ai/artifact/7NWj6LjLGfz1LZjz8mATEb
- Si le code s'écarte de la spec, **signaler l'écart avant de corriger**, jamais de résolution silencieuse.
- Ce que la spec ne précise pas : suivre les conventions déjà présentes dans le code.
- Préserver l'existant : travailler par petites étapes, sans régression, tests verts avant chaque livraison.
- Citer les règles R-xx concernées dans les commits, les tests et les notes de livraison.
- Communication et code métier en **français** (noms d'entités, de services, messages).

## Organisation du dépôt

| Dossier | Contenu |
|---|---|
| `api/` | Symfony 7.4 LTS : API REST `/api/v1`, back-office `/admin`, site vitrine, page publique des reçus `/r/{jeton}` |
| `mobile/` | Flutter : Riverpod, Dio, go_router, Drift |
| `docs/specification/` | Cahier des charges (référence) |
| `docs/design/` | Charte graphique (`charte-graphique.md`), logos, maquettes `feature-numéro-écran.png`, index `maquettes.md` |
| `docs/decisions/` | Une fiche par décision importante |
| `docs/livraisons/` | Une note par livrable |
| `scripts/` | Test de bout en bout app ↔ API |

## Commandes

```bash
# API
cd api && composer install
php bin/console doctrine:migrations:migrate
php bin/console app:referentiels:charger      # devises, pays, villes, catégories
php vendor/bin/phpunit                        # tests (chacun isolé en transaction)

# Mobile
cd mobile && flutter pub get && dart run build_runner build
flutter run --dart-define=CDL_ENV=dev
flutter test

# Bout en bout
./scripts/test-integration.sh
```

Tâches cron : `app:echeances:generer` (R-21), `app:rappels` (R-55, R-40).

## Contraintes techniques

- **PHP 8.2** en production : aucune fonctionnalité de PHP 8.3 ou plus. L'intégration continue teste en 8.2.
- Montants en **entiers** (centimes) avec leur devise, jamais de flottants (R-14).
- **Le serveur calcule, l'app affiche** (R-135) : statuts, soldes, montants pré-remplis, abonnements, commissions.
- Aucune suppression de preuve (R-06) : paiements, reçus, contrats, périodes d'abonnement, déclarations et leurs captures sont annulés ou clôturés, jamais effacés ni réécrits.
- Wallet = journal d'écritures ; le solde se calcule, il n'est jamais modifié directement (R-61).
- Paiements idempotents par UUID généré sur le téléphone (R-137).
- Clés d'API dans la configuration du serveur uniquement (R-119). Téléphones et GPS chiffrés en base (R-124).
- Erreurs API : `code` métier + message + erreurs par champ (R-149). Aucun texte en dur dans l'app (R-89).
- Mobile : `core/` partagé + `features/<domaine>/{screens,widgets,services,providers,models}` (R-130 à R-133).
  Features : `auth`, `biens`, `contrats`, `paiements`, `locations` (mode locataire), `abonnement`, `wallet`,
  `hotel`, `market`, `statistiques` (à créer), `home` (assemblage, sans logique propre).

## Chaîne métier à protéger (R-04)

User → Propriété → Unité → Contrat → Échéance → Paiement → Reçu → Notification.
Toute modification sur ce chemin exige des tests sur les cas existants.

## Points d'attention (spec v2.1, 4 novembre 2026)

Les décisions du 4 novembre sont intégrées à la spec (historique en section 15). Les plus structurantes pour le code :

- Locataire : User *non vérifié* créé dès le contrat, Contact conservé (R-19, R-72, R-182).
- Contrat : `periodicite` et `jourPaiement` (R-175, R-176), prorata d'entrée et de sortie base 30 jours (R-179, R-37),
  verrouillé après le premier paiement ou la confirmation, modifiable seulement par `RenouvellementContrat` (R-177, R-178).
- Entités `Garantie` (versements multiples) et `FinContrat` à sortir de `Contrat` (R-30, R-37), par étapes, tests verts.
- SMS payants par contrat, débités du wallet (R-184, R-185) ; rappels push (R-181).
- Hors ligne mixte : tables Drift dédiées + cache JSON ; Market et Hôtels en lecture seule (R-186, R-187).
- Back-office sur mesure en Twig sous `/admin`, rôles par territoire (R-116, R-188) ; site vitrine Twig (R-189).

## Questions ouvertes

Voir la section 15 de la spec. Priorité de la prochaine séance de code : vérifier les tables `pays`, `villes` et
`devise` contre la base existante, avant toute migration.
