import '../../../core/api/client_api.dart';
import '../../../core/cache/lecture.dart';
import '../../../core/modeles/modeles.dart';

/// Propriétés, unités et référentiels. Sans état : API + cache.
class BiensService {
  const BiensService(this.api, this.lecteur);
  final ClientApi api;
  final LecteurCache lecteur;

  Future<Lecture<PageApi<Propriete>>> proprietes() => lecteur.lire('/proprietes', (j) => PageApi.depuis(j, Propriete.fromJson), parametres: {'parPage': 50});

  Future<Lecture<Propriete>> propriete(int id) => lecteur.lire('/proprietes/$id', (j) => Propriete.fromJson(j as Map<String, dynamic>));

  Future<Lecture<Unite>> unite(int id) => lecteur.lire('/unites/$id', (j) => Unite.fromJson(j as Map<String, dynamic>));

  Future<Lecture<List<Devise>>> devises() =>
      lecteur.lire('/referentiels/devises', (j) => (j as List).map((e) => Devise.fromJson(e as Map<String, dynamic>)).toList());

  Future<Lecture<List<Categorie>>> categories() =>
      lecteur.lire('/referentiels/categories', (j) => (j as List).map((e) => Categorie.fromJson(e as Map<String, dynamic>)).toList());

  /// R-10 : type "simple" crée l'unité unique ; "immeuble" exige [unites].
  Future<Propriete> creerPropriete({
    required String nom,
    required String type,
    String? quartier,
    String? adresse,
    String? categorie,
    int? loyerIndicatif,
    String? devise,
    List<Map<String, dynamic>> unites = const [],
  }) async {
    final r = await api.post('/proprietes', {
      'nom': nom,
      'type': type,
      'quartier': ?quartier,
      'adresse': ?adresse,
      'categorie': ?categorie,
      'loyerIndicatif': ?loyerIndicatif,
      'devise': ?devise,
      if (type == 'immeuble') 'unites': unites,
    });
    return Propriete.fromJson(r as Map<String, dynamic>);
  }

  Future<Unite> ajouterUnite(int proprieteId, {required String nom, required String categorie, int? loyerIndicatif, String? devise}) async {
    final r = await api.post('/proprietes/$proprieteId/unites', {
      'nom': nom,
      'categorie': categorie,
      'loyerIndicatif': ?loyerIndicatif,
      'devise': ?devise,
    });
    return Unite.fromJson(r as Map<String, dynamic>);
  }

  /// R-107 : publication gratuite en un geste.
  Future<Unite> publier(int uniteId, String? description) async =>
      Unite.fromJson(await api.post('/unites/$uniteId/publication', {'description': ?description}) as Map<String, dynamic>);

  Future<Unite> retirer(int uniteId) async => Unite.fromJson(await api.delete('/unites/$uniteId/publication') as Map<String, dynamic>);
}
