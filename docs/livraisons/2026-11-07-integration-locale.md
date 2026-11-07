# Intégration locale du site et du lot 2 — 7 novembre 2026

Réunit le site et le mode OTP dev (`b0ca23c`) avec le lot 2 des comptes locataires
présent sur GitHub (`8d6f1df`). Règles : R-19, R-71, R-72, R-182, R-189.

- Les deux conflits de placement ont été résolus dans `backend/` ; le test de
  migration ajouté par le lot 2 a également été déplacé dans ce dossier.
- Les changements d'authentification du lot 2 et le code libre de six chiffres
  réservé à `dev` sont conservés ensemble. Les autres environnements vérifient
  toujours le véritable OTP.
- La migration du lot 2 conserve sa branche MySQL/MariaDB et prend également en
  charge SQLite, utilisé sur le PC. Un test en mémoire contrôle la conservation
  des identités, des confirmations et des contrats non confirmés.
- Les tests PHP fixent leur fuseau à UTC, comme MockClock et la CI, pour éviter
  les différences liées au fuseau par défaut de PHP sous XAMPP.
- Les traductions Flutter ont été régénérées depuis le fichier ARB fusionné.
- Le travail quotidien est désormais local, sur `main`, puis poussé vers GitHub.

## Base locale

Avant toute écriture, comparaison complète des mappings et du schéma : seules
`user.telephone_verifie`, `contrat.locataire_confirme_le` et
`contrat.locataire_refuse_le` manquaient. Les 25 tables étaient présentes ; aucun
contrat, paiement ou reçu n'était enregistré.

Une sauvegarde SQLite cohérente a été créée dans `backend/var/sauvegardes/`,
ignoré par Git. La migration additive a été appliquée en transaction, puis tous
les comptages existants et la synchronisation du schéma ont été vérifiés.
L'historique de reprise distingue les deux versions du socle reconnues après
comparaison de structure de la migration du lot 2 réellement exécutée. Cette
comparaison ne certifie pas l'exhaustivité des données de référence.

La configuration du PC a été conservée dans `backend/.env.local`, ignoré par
Git ; `.env` reste le modèle partagé. Bases, sauvegardes et clés privées ne sont
pas publiées. Cette reprise est propre à la base SQLite inspectée ; elle n'est
pas une instruction de migration automatique pour une autre installation.

## Vérifications exécutées

- PHP : **137 tests, 1 107 assertions**, sur une base SQLite neuve et isolée.
- Flutter : **41 tests réussis**, analyse sans erreur. Le test Flutter/API réel,
  exclu par défaut, n'a pas été lancé dans cette séance.
- Twig : toutes les pages rendues à la racine et avec le chemin XAMPP.
- Navigateur : rendu mobile, thème, inscription avec `234567`, reconnexion avec
  un autre code, accès au profil et au tableau de bord réels, déconnexion,
  rejet du code déjà consommé et simulateur de tarif.
- Doctrine : mappings corrects et base locale synchronisée.

Les tests MariaDB, la reprise MariaDB et la concurrence restent couverts par le
workflow GitHub Actions ; leurs résultats doivent être consultés séparément.
