import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// R-141 : token, refresh token et PIN dans flutter_secure_storage.
/// Interface abstraite pour être remplacée en test.
abstract class Coffre {
  Future<String?> lire(String cle);
  Future<void> ecrire(String cle, String? valeur);
}

class CoffreSecurise implements Coffre {
  CoffreSecurise([FlutterSecureStorage? stockage]) : _stockage = stockage ?? const FlutterSecureStorage();
  final FlutterSecureStorage _stockage;

  @override
  Future<String?> lire(String cle) => _stockage.read(key: cle);

  @override
  Future<void> ecrire(String cle, String? valeur) =>
      valeur == null ? _stockage.delete(key: cle) : _stockage.write(key: cle, value: valeur);
}

/// Coffre en mémoire (tests).
class CoffreMemoire implements Coffre {
  final Map<String, String> valeurs = {};

  @override
  Future<String?> lire(String cle) async => valeurs[cle];

  @override
  Future<void> ecrire(String cle, String? valeur) async {
    if (valeur == null) {
      valeurs.remove(cle);
    } else {
      valeurs[cle] = valeur;
    }
  }
}

class Jetons {
  const Jetons(this.acces, this.rafraichissement);
  final String acces;
  final String rafraichissement;

  /// Identifiant utilisateur porté par le JWT (claim "sub").
  int? get utilisateurId {
    final parties = acces.split('.');
    if (parties.length != 3) return null;
    try {
      final charge = jsonDecode(utf8.decode(base64Url.decode(base64Url.normalize(parties[1]))));
      return int.tryParse('${charge['sub']}');
    } catch (_) {
      return null;
    }
  }
}

/// Accès typé au coffre.
class StockageSession {
  StockageSession(this._coffre);
  final Coffre _coffre;

  static const _acces = 'cdl.jeton';
  static const _refresh = 'cdl.refresh';
  static const _pin = 'cdl.pin';
  static const _mode = 'cdl.mode';
  static const _utilisateur = 'cdl.utilisateur';

  Future<Jetons?> jetons() async {
    final a = await _coffre.lire(_acces);
    final r = await _coffre.lire(_refresh);
    return a == null || r == null ? null : Jetons(a, r);
  }

  Future<void> enregistrerJetons(Jetons jetons) async {
    await _coffre.ecrire(_acces, jetons.acces);
    await _coffre.ecrire(_refresh, jetons.rafraichissement);
    final id = jetons.utilisateurId;
    if (id != null) {
      final precedent = await _coffre.lire(_utilisateur);
      // Un autre compte sur ce téléphone : son PIN et son mode ne s'appliquent pas.
      if (precedent != null && precedent != '$id') {
        await _coffre.ecrire(_pin, null);
        await _coffre.ecrire(_mode, null);
      }
      await _coffre.ecrire(_utilisateur, '$id');
    }
  }

  Future<void> effacerJetons() async {
    await _coffre.ecrire(_acces, null);
    await _coffre.ecrire(_refresh, null);
  }

  Future<int?> utilisateurId() async => int.tryParse(await _coffre.lire(_utilisateur) ?? '');

  // PIN : seule une empreinte salée est stockée.
  Future<bool> aUnPin() async => (await _coffre.lire(_pin)) != null;

  Future<void> definirPin(String pin) async {
    final sel = DateTime.now().microsecondsSinceEpoch.toString();
    await _coffre.ecrire(_pin, '$sel:${_empreinte(sel, pin)}');
  }

  Future<bool> verifierPin(String pin) async {
    final stocke = await _coffre.lire(_pin);
    if (stocke == null) return false;
    final i = stocke.indexOf(':');
    return i > 0 && stocke.substring(i + 1) == _empreinte(stocke.substring(0, i), pin);
  }

  Future<void> effacerPin() => _coffre.ecrire(_pin, null);

  Future<String?> mode() => _coffre.lire(_mode);
  Future<void> definirMode(String? mode) => _coffre.ecrire(_mode, mode);

  static String _empreinte(String sel, String pin) {
    List<int> octets = utf8.encode('$sel|$pin');
    for (var i = 0; i < 10000; i++) {
      octets = sha256.convert(octets).bytes;
    }
    return base64Url.encode(octets);
  }
}
