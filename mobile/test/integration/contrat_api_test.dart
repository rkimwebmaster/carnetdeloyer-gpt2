/// Test de contrat entre l'app et la vraie API Symfony.
///
/// Ignoré par défaut. Lancé par `scripts/test-integration.sh`, qui démarre l'API
/// et fournit CDL_API_URL, CDL_JETON (bailleur) et CDL_JETON_LOCATAIRE.
@Tags(['integration'])
library;

import 'dart:io';

import 'package:carnetdeloyer/core/api/client_api.dart';
import 'package:carnetdeloyer/core/cache/base_locale.dart';
import 'package:carnetdeloyer/core/cache/lecture.dart';
import 'package:carnetdeloyer/core/erreurs/erreur_app.dart';
import 'package:carnetdeloyer/core/modeles/modeles.dart';
import 'package:carnetdeloyer/core/session/coffre.dart';
import 'package:carnetdeloyer/features/auth/models/profil.dart';
import 'package:carnetdeloyer/features/biens/services/biens_service.dart';
import 'package:carnetdeloyer/features/contrats/services/contrats_service.dart';
import 'package:carnetdeloyer/features/locations/services/locations_service.dart';
import 'package:carnetdeloyer/features/paiements/services/file_paiements.dart';
import 'package:carnetdeloyer/features/paiements/services/paiements_service.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final url = Platform.environment['CDL_API_URL'];
  final jeton = Platform.environment['CDL_JETON'];
  final jetonLocataire = Platform.environment['CDL_JETON_LOCATAIRE'];
  final telLocataire = Platform.environment['CDL_TEL_LOCATAIRE'];
  final ignorer = url == null || jeton == null ? 'CDL_API_URL / CDL_JETON absents' : null;

  late BaseLocale base;
  late ClientApi api;
  late LecteurCache lecteur;

  Future<ClientApi> client(String j) async {
    final s = StockageSession(CoffreMemoire());
    await s.enregistrerJetons(Jetons(j, 'inutile'));
    return ClientApi(stockage: s, urlBase: url!);
  }

  setUpAll(() async {
    if (ignorer != null) return;
    base = BaseLocale(NativeDatabase.memory());
    api = await client(jeton!);
    lecteur = LecteurCache(api, base, 1);
  });

  test('parcours bailleur complet sur la vraie API', () async {
    final profil = Profil.fromJson(await api.get('/moi') as Map<String, dynamic>);
    expect(profil.codeParrainage, isNotEmpty);

    final biens = BiensService(api, lecteur);
    final devises = (await biens.devises()).valeur;
    expect(devises.map((d) => d.code), contains('USD'));
    final categories = (await biens.categories()).valeur;
    expect(categories.any((c) => c.code == 'maison'), isTrue);

    final p = await biens.creerPropriete(nom: 'Immeuble intégration', type: 'immeuble', quartier: 'Gombe', unites: [
      {'nom': 'A1', 'categorie': 'appartement'},
      {'nom': 'A2', 'categorie': 'appartement'},
    ]);
    expect(p.unites, hasLength(2));
    expect(p.unites.first.abonnement.etat, 'non_facture');
    final listeProprietes = (await biens.proprietes()).valeur;
    expect(listeProprietes.elements.any((x) => x.id == p.id), isTrue);

    final contrats = ContratsService(api, lecteur);
    final c = await contrats.creer(
      uniteId: p.unites.first.id,
      locataireNom: 'Locataire intégration',
      locataireTelephone: telLocataire,
      devise: 'USD',
      loyer: 30000,
      dateDebut: '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-01',
      garantie: 60000,
    );
    expect(c.echeances, isNotEmpty);
    expect(c.garantie!.statut, 'attendue');
    expect(c.devise.decimales, 2);

    final enc = (await contrats.encaissement(c.id)).valeur;
    expect(enc.montantPropose, 30000);

    // File de paiements : envoi réel, idempotence réelle.
    final file = FilePaiements(api: api, base: base, utilisateurId: 1);
    final r = await file.encaisser(SaisiePaiement(contratId: c.id, montant: 30000, devise: 'USD', datePaiement: _aujourdhui(), moyen: 'especes', libelle: 'A1'));
    expect(r, isA<PaiementConfirme>());
    final paiement = (r as PaiementConfirme).paiement;
    expect(paiement.recu!.numero, startsWith('CDL-'));
    expect(paiement.recu!.messagePartage, contains(paiement.recu!.lien));

    // Rejeu manuel de la même clé : 200 et même paiement.
    final (statut, corps) = await api.postAvecStatut('/contrats/${c.id}/paiements', {
      'montant': 30000, 'datePaiement': _aujourdhui(), 'moyen': 'especes', 'cleIdempotence': paiement.cleIdempotence,
    });
    expect(statut, 200);
    expect(Paiement.fromJson(corps as Map<String, dynamic>).id, paiement.id);

    // Rejet métier réel, traduit en ErreurMetier.
    await expectLater(
      file.encaisser(SaisiePaiement(contratId: c.id, montant: 999999999, devise: 'USD', datePaiement: _aujourdhui(), moyen: 'especes', libelle: 'A1')),
      throwsA(isA<ErreurApp>().having((e) => e.code, 'code', 'PAIEMENT_SUPERIEUR_AU_DU')),
    );

    final detail = (await contrats.contrat(c.id)).valeur;
    expect(detail.paiements, hasLength(1));
    expect(detail.echeances.first.statut, 'payee');

    final paiements = PaiementsService(api, lecteur);
    expect((await paiements.paiements()).valeur.elements.first.id, paiement.id);
    final annule = await paiements.annuler(paiement.id, 'Test intégration');
    expect(annule.recu!.annule, isTrue);

    // Tous les écrans de lecture se décodent.
    final unite = (await biens.unite(p.unites.first.id)).valeur;
    expect(unite.vacante, isFalse);
    await api.get('/tableau-de-bord');
    await api.get('/activites', parametres: {'mode': 'bailleur'});
    await api.get('/wallet');
    final abonnements = await api.get('/abonnements') as List;
    for (final u in abonnements) {
      Unite.fromJson(u as Map<String, dynamic>);
    }
    await api.get('/unites/${p.unites.first.id}/abonnement');
    PageApi.depuis(await api.get('/market/annonces'), (j) => j);
    PageApi.depuis(await api.get('/hotels'), (j) => j);

    // Publication Market de l'unité vacante.
    final publiee = await biens.publier(p.unites.last.id, 'Deux chambres, calme.');
    expect(publiee.publieeMarket, isTrue);

    // Cache hors ligne : la lecture précédente est resservie si le réseau tombe.
    final horsLigne = LecteurCache(ClientApi(stockage: api.stockage, urlBase: 'http://127.0.0.1:9'), base, 1);
    final enCache = await horsLigne.lire('/contrats/${c.id}', (j) => Contrat.fromJson(j as Map<String, dynamic>));
    expect(enCache.depuisCache, isTrue);
    expect(enCache.valeur.id, c.id);

    // Mode locataire : rattachement puis « J'ai payé ».
    if (jetonLocataire != null) {
      final apiL = await client(jetonLocataire);
      final locations = LocationsService(apiL, LecteurCache(apiL, base, 2));
      final aRattacher = await locations.aRattacher();
      expect(aRattacher, isNotEmpty);
      await locations.rattacher(aRattacher.first.contactId);
      final mesContrats = (await locations.contrats()).valeur;
      expect(mesContrats.elements.map((x) => x.id), contains(c.id));
      final vue = (await locations.contrat(c.id)).valeur;
      expect(vue.bailleur.nom, isNotEmpty);
      await locations.declarer(c.id, montant: 30000, datePaiement: _aujourdhui(), reference: 'MP-INT');
      final declarations = await paiements.declarations();
      expect(declarations.elements.single.reference, 'MP-INT');
      await paiements.validerDeclaration(declarations.elements.single.id);
    }
  }, skip: ignorer);
}

String _aujourdhui() {
  final d = DateTime.now();
  return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}
