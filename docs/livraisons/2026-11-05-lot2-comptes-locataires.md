# Lot 2 — Comptes et contrats du locataire

Règles : R-19, R-72, R-182, R-06, R-173.

## Comportement

- Un contrat avec téléphone retrouve ou crée le compte non vérifié du locataire. Sans téléphone, le contact simple reste utilisable par le bailleur seul. Aucun jeton ni accès n'est créé pour un compte provisoire.
- L'OTP puis le nom terminent l'inscription sur la même identité, sans doublon ni perte du lien avec les contacts existants.
- Chaque contrat nécessite sa propre confirmation. La confirmation d'un contact n'ouvre plus tous ses contrats. L'ancienne route reste compatible lorsqu'un seul contrat attend confirmation ; sinon elle exige de choisir un contrat.
- Avant confirmation, le bailleur peut corriger le numéro. Après confirmation, cette correction est refusée, y compris si le locataire refuse ensuite le contrat : l'accord historique reste conservé.
- Le locataire peut changer son propre téléphone dans Profil, avec OTP envoyé au nouveau numéro. Ses identifiants et contrats restent les mêmes. Un numéro déjà associé à une autre identité est refusé ; aucune fusion automatique de comptes.
- « Ne me concerne pas » retire le contrat du locataire et ajoute une activité destinée au bailleur, sans clôture ni suppression du contrat. Les autres locations restent accessibles. La notification push générale sera traitée avec le lot notifications.
- Les listes, détails, déclarations, paiements, exports et activités du locataire exigent un contrat confirmé et non refusé. Le cache locataire est invalidé après refus ; les paiements hors ligne en attente ne sont pas supprimés.

## Migration

`Version20261105050000` ajoute un indicateur de téléphone vérifié et deux dates de décision par contrat. Aucun paiement, reçu, contrat ou contact n'est supprimé.

Les comptes historiques sont considérés vérifiés : l'ancien code applicatif les créait après OTP. Les contrats des contacts déjà rattachés conservent leur accès. Leur date de confirmation est la date de reprise, car l'ancienne base ne stockait pas la date réelle de l'accord. Les contacts non rattachés ne sont pas confirmés automatiquement.

Le retour arrière destructif est refusé : les nouvelles décisions constituent des traces conservées. Toute correction devra être additive. La conformité des référentiels seule ne remplace pas l'examen de l'historique des migrations.

Sur le PC, après récupération du lot et installation des dépendances :

```bash
php bin/console doctrine:migrations:status
php bin/console doctrine:migrations:migrate --no-interaction
php bin/console doctrine:schema:validate
```

Si la base est déjà remplie mais n'a aucun historique de migrations, ne pas marquer toutes les versions comme exécutées : il faut préparer sa reprise.

## Vérifications

- Suite PHP locale sur SQLite : 130 tests et 1080 assertions réussis. La CI vérifie aussi MariaDB et la migration réelle.
- Nouveaux tests d'API : compte provisoire, inscription sur la même identité, confirmation individuelle, refus et isolation, correction avant confirmation, droits d'un autre compte, changement de téléphone par OTP et interdiction de fusion.
- Test MariaDB dédié : reprise d'un compte et de deux confirmations historiques, contrat non confirmé conservé privé, aucun enregistrement supprimé et nouveaux comptes non vérifiés par défaut.
- Tests Flutter : choix d'un seul contrat, refus avec confirmation et purge du cache limitée à l'utilisateur, changement de numéro depuis Profil.
- Les contrôles PHP/MariaDB, Flutter, intégration réelle et concurrence sont exécutés par GitHub Actions ; consulter les résultats du commit livré.

Pas de migration exécutée sur le PC par l'agent. Pas de validation visuelle sur téléphone réel ni de build store dans ce lot.
