import 'package:flutter/material.dart';

/// Thème commun. Couleurs sobres, lisibles en plein soleil.
class ThemeCdl {
  const ThemeCdl._();

  static const vert = Color(0xFF1F6F5C);
  static const retard = Color(0xFFB42318);
  static const attente = Color(0xFFB54708);
  static const ok = Color(0xFF067647);

  static ThemeData clair() {
    final schema = ColorScheme.fromSeed(seedColor: vert);
    return ThemeData(
      colorScheme: schema,
      useMaterial3: true,
      inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder()),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
      ),
      cardTheme: const CardThemeData(margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6)),
    );
  }

  static ThemeData sombre() => ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: vert, brightness: Brightness.dark),
        useMaterial3: true,
        inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder()),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
        ),
      );

  /// Couleur d'un statut d'échéance (R-22).
  static Color statut(String statut, ColorScheme schema) => switch (statut) {
        'payee' => ok,
        'en_retard' => retard,
        'partielle' => attente,
        _ => schema.onSurfaceVariant,
      };
}
