# CarnetDeLoyer

Gestion locative pour les bailleurs professionnels : biens, contrats, échéances, paiements et reçus, avec un mode locataire, une vitrine Market et une vitrine Hôtels.
Ce dépôt contient la **v0.1 (Location)** de la spécification fonctionnelle v2.0.

| Dossier | Contenu |
|---|---|
| `api/` | API REST Symfony 7.4 (PHP 8.3, Doctrine, MySQL/MariaDB), sous `/api/v1` |
| `mobile/` | Application Flutter (Android, iOS, Windows) : Riverpod, Dio, go_router, Drift |
| `scripts/` | Test de bout en bout app ↔ API |
| `.github/workflows/` | Intégration continue (bloquante, R-154) |

## Démarrer l'API

```bash
cd api
composer install
# Base locale : DATABASE_URL dans .env.local (MySQL 8 ou MariaDB 10.11)
php bin/console lexik:jwt:generate-keypair
php bin/console doctrine:database:create
php bin/console doctrine:migrations:migrate
php bin/console app:referentiels:charger     # devises, pays, villes, catégories
symfony serve                                # ou : php -S 127.0.0.1:8000 -t public
```

Tâches quotidiennes (cron) :

```
php bin/console app:echeances:generer   # 12 mois glissants (R-21)
php bin/console app:rappels             # rappels d'abonnement J-15/J-3/J, relance des déclarations (R-55, R-40)
```

### Variables d'environnement (production : jamais dans le dépôt, R-119)

| Variable | Rôle |
|---|---|
| `APP_SECRET`, `JWT_PASSPHRASE` | secrets Symfony et JWT |
| `APP_CHIFFREMENT_CLE` | 32 octets base64, chiffre téléphones et GPS en base (R-124). `php -r "echo base64_encode(random_bytes(32));"` |
| `APP_SMS_FOURNISSEUR` | `log` en dev. Le fournisseur SMS réel (et son secours) est à brancher dans `src/Sms/FabriqueSms.php` (R-77) |
| `APP_TAUX_CHANGE_URL` | API de conversion monétaire (R-69) |
| `APP_URL_PUBLIQUE` | domaine des liens de reçus `/r/{jeton}` (R-75) |

## Démarrer l'app

```bash
cd mobile
flutter pub get
dart run build_runner build
flutter run --dart-define=CDL_ENV=dev                      # API sur 10.0.2.2:8000
flutter run --dart-define=CDL_API_URL=http://192.168.1.10:8000   # téléphone réel
```

## Tests

| Commande | Couvre |
|---|---|
| `cd api && php vendor/bin/phpunit` | 115 tests : unitaires (argent en entiers, calendrier, chiffrement, filtre de coordonnées) et fonctionnels sur base réelle (chaque test isolé en transaction) |
| `cd api && ./tests/Concurrence/encaissements-paralleles.sh` | 30 encaissements simultanés : aucun montant perdu, reçus sans trou ni doublon, idempotence |
| `cd mobile && flutter test` | 34 tests : client HTTP et rafraîchissement du token, file de paiements hors ligne, PIN, redirections, écrans (inscription, verrou, bascule de mode, encaissement) |
| `./scripts/test-integration.sh` | les services Flutter contre l'API réelle (parcours bailleur et locataire) |

## Ce qui est livré (v0.1)

- **Compte** : inscription par OTP en moins d'une minute, code parrain, JWT 1 h + refresh 60 jours avec rotation, PIN et biométrie hors ligne, choix du mode, bascule bailleur/locataire (menu latéral), export et suppression du compte.
- **Biens** : propriétés simples ou immeubles, unités typées (icônes gérées en base), publication gratuite des unités vacantes sur le Market.
- **Contrats** : devise proposée selon le pays, un contrat actif par unité, échéances mensuelles sur 12 mois glissants, statuts calculés, garantie séparée, clôture (échéances annulées, dernière échéance ajustable, règlement de la garantie).
- **Paiements** : montant pré-rempli, avance de plusieurs mois, paiement partiel, imputation sur l'échéance la plus ancienne (correction manuelle possible), reçus numérotés sans trou par espace, lien public, partage WhatsApp/SMS, annulation motivée, file hors ligne avec clé d'idempotence.
- **Locataire** : rattachement par téléphone après confirmation, consultation des contrats et reçus, « J'ai payé » validé ou refusé par le bailleur.
- **Abonnement** : 1re unité gratuite 12 mois, 9,9 % du loyer par an et par unité en USD, grâce de 15 jours puis suspension, réactivation sans rattrapage, reste crédité au wallet, paiement par wallet ou mobile money validé au back-office.
- **Wallet et parrainage** : journal par espace, seuil de 11 $, 2 $ au parrain par contrat payé.
- **Back-office (API)** : paiements à valider, paramètres avec historique et dérogations, ajustements de wallet motivés, badges, suspension de comptes, journal d'audit, tableau de bord.

## Reste à faire avant la mise en production

- Brancher le fournisseur SMS réel et l'agrégateur mobile money (contrats commerciaux).
- Interface web du back-office (les opérations existent dans l'API sous `/api/v1/admin`).
- Faire relire la politique de confidentialité et fixer la durée légale de conservation (section 12 de la spec).
- Hôtels (séjours, v0.5) et Market complet (photos, déblocage payant, ventes, v0.9).
