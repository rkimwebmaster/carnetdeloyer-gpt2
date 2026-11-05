import '../../../core/api/client_api.dart';
import '../../../core/cache/lecture.dart';
import '../../../core/modeles/modeles.dart';
import '../models/declaration.dart';

class PaiementsService {
  const PaiementsService(this.api, this.lecteur);
  final ClientApi api;
  final LecteurCache lecteur;

  Future<Lecture<PageApi<Paiement>>> paiements({int page = 1}) =>
      lecteur.lire('/paiements', (j) => PageApi.depuis(j, Paiement.fromJson), parametres: {'page': page, 'parPage': 30});

  /// R-34 : annulation avec motif obligatoire.
  Future<Paiement> annuler(int id, String motif) async =>
      Paiement.fromJson(await api.post('/paiements/$id/annulation', {'motif': motif}) as Map<String, dynamic>);

  Future<PageApi<Declaration>> declarations() async => PageApi.depuis(await api.get('/declarations', parametres: {'statut': 'en_attente'}), Declaration.fromJson);

  Future<void> validerDeclaration(int id) => api.post('/declarations/$id/validation');

  Future<void> refuserDeclaration(int id, String motif) => api.post('/declarations/$id/refus', {'motif': motif});
}
