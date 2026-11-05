# CarnetDeLoyer — Charte graphique v1.0

Référence visuelle de l'app Flutter (Android, iOS, Windows), du back-office et du site vitrine.
Source : thème `AppTheme` fourni le 4 novembre 2026. En cas d'écart, **ce document fait foi** et le code s'aligne.

- Thème Flutter : `mobile/lib/core/theme/` (R-130). Aucune couleur ni taille en dur dans les écrans : tout passe par le thème.
- Back-office et site vitrine (Twig + Bootstrap) : mêmes couleurs, rayons et échelle de texte, via des variables CSS.
- Material 3 (`useMaterial3: true`), mode clair et mode sombre.

## 1. Couleurs

### Marque

| Rôle | Nom Flutter | Hex | Usage |
|---|---|---|---|
| Primaire | `primaryColor` | `#8B0000` | Boutons principaux, éléments actifs, liens, focus (mode clair) |
| Primaire claire | `primaryLight` | `#B71C1C` | Primaire du mode sombre (boutons pleins) |
| Primaire foncée | `primaryDark` | `#650000` | État pressé, en-têtes accentués |
| Secondaire | `secondaryColor` | `#FFB300` | Accent ambre : mise en avant, badges, éléments actifs du mode sombre |
| Secondaire foncée | `secondaryDark` | `#FF8F00` | État pressé de l'accent |

### Couleurs sémantiques

| Rôle | Nom Flutter | Hex |
|---|---|---|
| Succès | `successColor` | `#2E7D32` |
| Avertissement | `warningColor` | `#F9A825` |
| Erreur | `errorColor` | `#C62828` (mode sombre : `#EF5350`) |
| Information | `infoColor` | `#1565C0` |

### Neutres

| Rôle | Mode clair | Mode sombre |
|---|---|---|
| Fond d'écran | `#F8F8F8` | `#121212` |
| Surface (cartes, barres, dialogues) | `#FFFFFF` | `#1E1E1E` |
| Texte principal | `#1F1F1F` | `#FFFFFF` |
| Texte secondaire | `#6B6B6B` | `#BDBDBD` |
| Bordures et séparateurs | `#E5E5E5` | `#353535` |
| Snackbar, info-bulle | `#252525` | `#303030` |

### Couleurs des statuts métier (proposition, à valider)

Une couleur par statut, toujours accompagnée d'un libellé ou d'une icône : la couleur seule ne porte jamais l'information.

| Statut | Couleur | Exemple |
|---|---|---|
| Échéance payée, déclaration validée, compte vérifié | Succès | Pastille « Payée » |
| Échéance partielle, déclaration en attente, période de grâce (R-55) | Avertissement | Pastille « Partielle » |
| Échéance en retard (R-22), déclaration refusée, unité suspendue (R-56) | Erreur | Pastille « En retard » |
| Échéance à venir, information | Information | Pastille « À venir » |
| Reçu provisoire hors ligne (R-81) | Texte secondaire + bordure pointillée | « Reçu provisoire » |

Pastille : fond = couleur à 12 % d'opacité, texte = couleur pleine (avertissement : texte `#1F1F1F`, voir 2).

## 2. Contrastes (règles d'usage)

Calculés selon WCAG 2.1 ; 4,5:1 minimum pour le texte, 3:1 pour les icônes et bordures.

| Combinaison | Contraste | Règle |
|---|---|---|
| Blanc sur primaire `#8B0000` | 10,0 | Correct |
| Blanc sur primaire claire `#B71C1C` | 6,6 | Correct |
| Primaire `#8B0000` sur surface sombre | 1,7 | **Interdit** : en mode sombre, utiliser `primaryLight` en fond plein, ou la secondaire pour le texte |
| Primaire claire `#B71C1C` sur surface sombre | 2,5 | **Interdit pour du texte ou une bordure de focus** ; uniquement en fond de bouton |
| Secondaire `#FFB300` sur blanc | 1,8 | **Interdit pour du texte** ; en mode clair, l'ambre sert de fond (texte noir : 11,7) |
| Secondaire `#FFB300` sur surface sombre | 9,3 | Correct (texte, icônes, liens du mode sombre) |
| Avertissement `#F9A825` sur blanc | 2,0 | **Interdit pour du texte** ; texte `#1F1F1F` sur fond avertissement (8,4) |
| Succès, erreur, information sur blanc | 5,1 à 5,7 | Correct |
| Texte secondaire `#6B6B6B` sur fond `#F8F8F8` | 5,0 | Correct |

## 3. Typographie

Police système par défaut (Roboto sur Android, San Francisco sur iOS, Segoe UI sur Windows). Graisses 400, 600, 700.

| Style Flutter | Taille | Graisse | Usage |
|---|---|---|---|
| `displayLarge` | 32 | 700 | Montant principal (solde, total encaissé) |
| `displayMedium` | 28 | 700 | Chiffre clé d'une carte |
| `displaySmall` | 24 | 700 | Titre d'écran d'accueil ou d'étape |
| `headlineLarge` | 22 | 700 | Titre de section importante |
| `headlineMedium` | 20 | 700 | Titre de dialogue |
| `headlineSmall` | 18 | 600 | Sous-titre |
| `titleLarge` | 18 | 600 | Titre de barre d'app (en 700) |
| `titleMedium` | 16 | 600 | Titre de carte, nom d'un bien |
| `titleSmall` | 14 | 600 | Intitulé de ligne |
| `bodyLarge` | 16 | 400 | Texte courant important |
| `bodyMedium` | 14 | 400 | Texte courant |
| `bodySmall` | 12 | 400, texte secondaire | Dates, mentions, aides |
| `labelLarge` | 14 | 600 | Libellé de bouton |
| Navigation basse | 11 | 600 | Libellés des onglets |

Montants : chiffres alignés à droite dans les listes, devise toujours affichée (R-14, R-20).

## 4. Formes et dimensions

| Élément | Valeur |
|---|---|
| Rayon petit (`radiusSmall`) | 8 — boutons texte, info-bulles |
| Rayon moyen (`radiusMedium`) | 12 — boutons, champs, cartes, snackbar |
| Rayon grand (`radiusLarge`) | 16 — dialogues |
| Rayon très grand (`radiusXLarge`) | 20 — feuilles du bas, grandes cartes |
| Hauteur des boutons (`buttonHeight`) | 50, pleine largeur |
| Hauteur de la navigation basse | 70 |
| Marges internes des champs | 16 horizontal, 15 vertical |
| Marges internes des boutons | 20 horizontal, 14 vertical |
| Case à cocher | rayon 5 |
| Taille des icônes | 24 (actives), 23 (inactives en navigation) |

Espacements (proposition, à valider) : échelle 4 · 8 · 12 · 16 · 24 · 32 ; marge d'écran 16 ; espace entre cartes 12.

## 5. Composants

| Composant | Mode clair | Mode sombre |
|---|---|---|
| Barre d'app | Surface blanche, titre centré 18/700, sans ombre | Surface `#1E1E1E`, titre blanc |
| Bouton principal | Fond primaire, texte blanc, sans ombre ; désactivé : fond gris 300, texte gris 600 | Fond primaire claire, texte blanc |
| Bouton secondaire (contour) | Contour primaire 1,5, texte primaire | Contour et texte ambre |
| Bouton texte | Texte primaire | Texte ambre |
| Champ de saisie | Fond blanc, bordure `#E5E5E5` ; focus : primaire 2 px ; erreur : rouge 1 px, 2 px au focus | Fond surface, bordure `#353535` ; focus : primaire claire 2 px |
| Carte | Surface, élévation 1, rayon 12, sans marge | Surface sombre, élévation 1 |
| Navigation basse | Fond blanc, élévation 3 ; actif : icône primaire, indicateur primaire 12 % | Actif : icône ambre, indicateur primaire claire 20 % |
| Menu latéral (drawer) | Fond blanc, élévation 2 | Fond surface sombre |
| Snackbar | Flottante, fond `#252525`, texte blanc 14 | Fond `#303030` |
| Dialogue | Rayon 16, titre 20/700, contenu 14 en texte secondaire | Idem sur surface sombre |
| Feuille du bas | Poignée visible, élévation 5 | Poignée visible |
| Chargement | Primaire | Ambre |
| Interrupteur | Pouce primaire si activé, gris 400 sinon | (à définir, voir 7) |
| Info-bulle | Fond `#252525`, texte blanc 12, rayon 8 | (à définir, voir 7) |

Règle de mode sombre : la primaire passe en `primaryLight` pour les fonds pleins, et **l'ambre devient la couleur d'accent** (contours, liens, onglet actif, chargement), car le bordeaux n'est pas lisible sur fond sombre.

## 6. Icônes de catégorie (R-83, R-117)

L'icône de catégorie est le repère principal des listes : les photos sont secondaires.

- Une icône vectorielle (SVG) par catégorie d'unité : maison d'habitation, appartement, chambre, boutique, bureau, terrain, entrepôt, chambre d'hôtel.
- Style uniforme : trait, épaisseur constante, grille de 24, coins arrondis, une seule couleur (héritée du thème).
- Taille en liste : 40 dans un cercle de fond primaire à 12 % ; sur la page détail : 56.
- Gérées en base depuis le back-office, gardées en cache sur le téléphone pour le hors ligne (R-85).
- Lisibles en petit : reconnaissables sans libellé à 24 px.

## 7. Écarts à corriger dans le code

1. **Thème actuel du dépôt** : `mobile/lib/core/theme/theme.dart` utilise un vert (`#1F6F5C`) et ses propres couleurs de statut. À remplacer par ce thème.
2. **`withOpacity` est déprécié** depuis Flutter 3.27 : utiliser `withValues(alpha: 0.12)`.
3. **Mode sombre incomplet** : il manque `labelLarge`, l'icône de la barre d'app, `focusedErrorBorder`, l'interrupteur, la case à cocher et l'info-bulle. À compléter sur le modèle du mode clair.
4. **Bordure de focus du mode sombre** : `primaryLight` sur fond sombre (2,5:1) est sous le seuil de 3:1. Proposition : ambre.
5. **Couleurs des statuts** : centraliser les correspondances de la section 1 dans le thème (une extension `ThemeExtension`), pour ne jamais choisir une couleur dans un écran.

## 8. Questions ouvertes

- Police de marque (par exemple Inter ou Poppins), ou police système ? Une police embarquée ajoute environ 300 Ko (R-151 : moins de 25 Mo).
- Logo : fichiers SVG et PNG à déposer dans `docs/design/logos/`.
- Validation des couleurs de statut et de l'échelle d'espacement (propositions).