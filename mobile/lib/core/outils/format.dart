import 'package:intl/intl.dart';

import '../modeles/modeles.dart';

/// Affichage des montants : l'app ne calcule pas, elle formate (R-135).
class Format {
  const Format._();

  /// Devises sans décimales (ISO 4217) quand l'objet devise n'est pas fourni.
  static const _sansDecimales = {'XAF', 'XOF', 'RWF', 'BIF', 'UGX', 'KMF', 'GNF', 'JPY'};
  static const _symboles = {'USD': r'$', 'CDF': 'FC', 'EUR': '€', 'XAF': 'FCFA', 'XOF': 'FCFA'};

  static int decimalesDe(String code) => _sansDecimales.contains(code) ? 0 : 2;

  static String montant(int mineur, String code, {int? decimales, String? symbole}) {
    final d = decimales ?? decimalesDe(code);
    final format = NumberFormat.currency(locale: 'fr', symbol: symbole ?? _symboles[code] ?? code, decimalDigits: d);
    return format.format(mineur / _puissance(d));
  }

  static String montantDevise(int mineur, Devise devise) =>
      montant(mineur, devise.code, decimales: devise.decimales, symbole: devise.symbole);

  /// Saisie utilisateur ("300", "300,50") vers l'unité mineure, sans flottant.
  static int? versMineur(String saisie, int decimales) {
    final s = saisie.replaceAll(RegExp(r'[\s  ]'), '').replaceAll(',', '.');
    final m = RegExp(r'^(\d+)(?:\.(\d+))?$').firstMatch(s);
    if (m == null) return null;
    final fraction = m.group(2) ?? '';
    if (fraction.length > decimales) return null;
    return int.parse(m.group(1)!) * _puissance(decimales) + (fraction.isEmpty ? 0 : int.parse(fraction.padRight(decimales, '0')));
  }

  /// Unité mineure vers saisie éditable ("300" ou "300,50").
  static String versSaisie(int mineur, int decimales) {
    if (decimales == 0) return '$mineur';
    final entier = mineur ~/ _puissance(decimales);
    final reste = mineur % _puissance(decimales);
    return reste == 0 ? '$entier' : '$entier,${'$reste'.padLeft(decimales, '0')}';
  }

  static String date(String iso) {
    final d = DateTime.tryParse(iso);
    return d == null ? iso : DateFormat('dd/MM/yyyy', 'fr').format(d);
  }

  static String moisAnnee(String iso) {
    final d = DateTime.tryParse(iso);
    return d == null ? iso : DateFormat('MMMM yyyy', 'fr').format(d);
  }

  static String dateIso(DateTime d) => DateFormat('yyyy-MM-dd').format(d);

  static int _puissance(int d) {
    var p = 1;
    for (var i = 0; i < d; i++) {
      p *= 10;
    }
    return p;
  }
}
