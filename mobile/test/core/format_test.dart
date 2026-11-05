import 'package:carnetdeloyer/core/outils/format.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  setUpAll(() => initializeDateFormatting('fr'));

  group('Saisie vers unité mineure (R-14, sans flottant)', () {
    test('entiers et décimales', () {
      expect(Format.versMineur('300', 2), 30000);
      expect(Format.versMineur('300,5', 2), 30050);
      expect(Format.versMineur('300.05', 2), 30005);
      expect(Format.versMineur('1 500 000', 0), 1500000);
      // 0.1 + 0.2 : piège classique des flottants.
      expect(Format.versMineur('0,30', 2), 30);
    });

    test('saisies invalides', () {
      expect(Format.versMineur('', 2), isNull);
      expect(Format.versMineur('abc', 2), isNull);
      expect(Format.versMineur('-5', 2), isNull);
      expect(Format.versMineur('10,5', 0), isNull, reason: 'trop de décimales pour la devise');
      expect(Format.versMineur('1,234', 2), isNull);
    });

    test('aller-retour', () {
      for (final v in [0, 1, 99, 100, 30050, 123456789]) {
        expect(Format.versMineur(Format.versSaisie(v, 2), 2), v);
      }
      expect(Format.versSaisie(30000, 2), '300');
      expect(Format.versSaisie(30005, 2), '300,05');
    });
  });

  test('affichage avec symbole et décimales de la devise', () {
    expect(Format.montant(30000, 'USD'), contains('300,00'));
    expect(Format.montant(30000, 'USD'), contains(r'$'));
    expect(Format.montant(600000, 'XAF'), isNot(contains(',')));
    expect(Format.montant(85500000, 'CDF'), contains('FC'));
  });

  test('dates', () {
    expect(Format.date('2026-10-27'), '27/10/2026');
    expect(Format.dateIso(DateTime(2026, 1, 5)), '2026-01-05');
    expect(Format.moisAnnee('2026-10-01'), 'octobre 2026');
  });
}
