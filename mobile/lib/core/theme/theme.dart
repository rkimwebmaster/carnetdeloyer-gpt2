import 'package:flutter/material.dart';

/// Charte graphique CDL : bordeaux et ambre, sans logique métier.
class ThemeCdl {
  const ThemeCdl._();

  static const primaire = Color(0xFF8B0000);
  static const primaireClaire = Color(0xFFB71C1C);
  static const ambre = Color(0xFFFFB300);
  static const retard = Color(0xFFC62828);
  static const attente = Color(0xFFF9A825);
  static const ok = Color(0xFF2E7D32);
  static const information = Color(0xFF1565C0);
  static const texte = Color(0xFF1F1F1F);
  static const hauteurBouton = 50.0;
  static const rayon = 12.0;

  static ThemeData clair() => _construire(Brightness.light);
  static ThemeData sombre() => _construire(Brightness.dark);

  static ThemeData _construire(Brightness luminosite) {
    final sombre = luminosite == Brightness.dark;
    final accent = sombre ? ambre : primaire;
    final surface = sombre ? const Color(0xFF1E1E1E) : Colors.white;
    final bordure = sombre ? const Color(0xFF353535) : const Color(0xFFE5E5E5);
    final secondaireTexte = sombre ? const Color(0xFFBDBDBD) : const Color(0xFF6B6B6B);
    final schema = ColorScheme.fromSeed(seedColor: primaire, brightness: luminosite).copyWith(
      primary: accent,
      onPrimary: sombre ? texte : Colors.white,
      secondary: ambre,
      onSecondary: texte,
      surface: surface,
      onSurface: sombre ? Colors.white : texte,
      onSurfaceVariant: secondaireTexte,
      outline: bordure,
      error: sombre ? const Color(0xFFEF5350) : retard,
      onError: sombre ? texte : Colors.white,
    );
    final base = ThemeData(colorScheme: schema, useMaterial3: true);
    final forme = RoundedRectangleBorder(borderRadius: BorderRadius.circular(rayon));
    OutlineInputBorder contour(Color couleur, double largeur) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(rayon),
          borderSide: BorderSide(color: couleur, width: largeur),
        );
    final bouton = FilledButton.styleFrom(
      backgroundColor: sombre ? primaireClaire : primaire,
      foregroundColor: Colors.white,
      minimumSize: const Size.fromHeight(hauteurBouton),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      shape: forme,
      elevation: 0,
    );
    return ThemeData(
      colorScheme: schema,
      useMaterial3: true,
      scaffoldBackgroundColor: sombre ? const Color(0xFF121212) : const Color(0xFFF8F8F8),
      textTheme: base.textTheme.copyWith(
        displayLarge: base.textTheme.displayLarge?.copyWith(fontSize: 32, fontWeight: FontWeight.w700),
        displayMedium: base.textTheme.displayMedium?.copyWith(fontSize: 28, fontWeight: FontWeight.w700),
        displaySmall: base.textTheme.displaySmall?.copyWith(fontSize: 24, fontWeight: FontWeight.w700),
        headlineLarge: base.textTheme.headlineLarge?.copyWith(fontSize: 22, fontWeight: FontWeight.w700),
        headlineMedium: base.textTheme.headlineMedium?.copyWith(fontSize: 20, fontWeight: FontWeight.w700),
        headlineSmall: base.textTheme.headlineSmall?.copyWith(fontSize: 18, fontWeight: FontWeight.w600),
        titleLarge: base.textTheme.titleLarge?.copyWith(fontSize: 18, fontWeight: FontWeight.w700),
        titleMedium: base.textTheme.titleMedium?.copyWith(fontSize: 16, fontWeight: FontWeight.w600),
        titleSmall: base.textTheme.titleSmall?.copyWith(fontSize: 14, fontWeight: FontWeight.w600),
        bodyLarge: base.textTheme.bodyLarge?.copyWith(fontSize: 16),
        bodyMedium: base.textTheme.bodyMedium?.copyWith(fontSize: 14),
        bodySmall: base.textTheme.bodySmall?.copyWith(fontSize: 12, color: secondaireTexte),
        labelLarge: base.textTheme.labelLarge?.copyWith(fontSize: 14, fontWeight: FontWeight.w600),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        foregroundColor: schema.onSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(color: schema.onSurface, fontSize: 18, fontWeight: FontWeight.w700),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        border: contour(bordure, 1),
        enabledBorder: contour(bordure, 1),
        focusedBorder: contour(accent, 2),
        errorBorder: contour(schema.error, 1),
        focusedErrorBorder: contour(schema.error, 2),
      ),
      filledButtonTheme: FilledButtonThemeData(style: bouton),
      elevatedButtonTheme: ElevatedButtonThemeData(style: bouton),
      outlinedButtonTheme: OutlinedButtonThemeData(style: OutlinedButton.styleFrom(
        foregroundColor: accent,
        side: BorderSide(color: accent, width: 1.5),
        minimumSize: const Size.fromHeight(hauteurBouton),
        shape: forme,
      )),
      textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: accent)),
      cardTheme: CardThemeData(color: surface, surfaceTintColor: Colors.transparent, elevation: 1, margin: EdgeInsets.zero, shape: forme),
      navigationBarTheme: NavigationBarThemeData(
        height: 70,
        backgroundColor: surface,
        indicatorColor: (sombre ? primaireClaire : primaire).withValues(alpha: sombre ? .20 : .12),
        iconTheme: WidgetStateProperty.resolveWith((etats) => IconThemeData(
          color: etats.contains(WidgetState.selected) ? accent : secondaireTexte,
          size: etats.contains(WidgetState.selected) ? 24 : 23,
        )),
        labelTextStyle: WidgetStateProperty.resolveWith((etats) => TextStyle(
          color: etats.contains(WidgetState.selected) ? accent : secondaireTexte,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        )),
      ),
      drawerTheme: DrawerThemeData(backgroundColor: surface, elevation: 2),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: sombre ? const Color(0xFF303030) : const Color(0xFF252525),
        contentTextStyle: const TextStyle(color: Colors.white, fontSize: 14),
        shape: forme,
      ),
      dialogTheme: DialogThemeData(backgroundColor: surface, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: surface,
        showDragHandle: true,
        elevation: 5,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: accent),
      checkboxTheme: CheckboxThemeData(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(color: sombre ? const Color(0xFF303030) : const Color(0xFF252525), borderRadius: BorderRadius.circular(8)),
        textStyle: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }

  /// Texte de statut lisible sur sa pastille et sur la surface (R-22).
  static Color statut(String statut, ColorScheme schema) {
    final sombre = schema.brightness == Brightness.dark;
    return switch (statut) {
        'payee' => sombre ? const Color(0xFF81C784) : const Color(0xFF256628),
        'en_retard' => schema.error,
        'partielle' => sombre ? ambre : texte,
        'a_venir' => sombre ? const Color(0xFF90CAF9) : information,
        _ => schema.onSurfaceVariant,
      };
  }

  static Color fondStatut(String valeur, ColorScheme schema) =>
      (valeur == 'partielle' ? attente : statut(valeur, schema)).withValues(alpha: .12);
}
