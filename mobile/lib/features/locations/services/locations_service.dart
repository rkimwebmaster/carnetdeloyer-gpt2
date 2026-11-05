import '../../../core/api/client_api.dart';
import '../../../core/cache/lecture.dart';
import '../../../core/modeles/modeles.dart';

class Rattachement {
  const Rattachement(this.contactId, this.bailleur, this.unites, {required this.contratId});
  final int contactId;
  final String bailleur;
  final List<String> unites;
  final int contratId;
}

/// Mode locataire : « Mes locations », rattachement (R-72), « J'ai payé » (R-39).
class LocationsService {
  const LocationsService(this.api, this.lecteur);
  final ClientApi api;
  final LecteurCache lecteur;

  Future<Lecture<PageApi<Contrat>>> contrats() => lecteur.lire('/locataire/contrats', (j) => PageApi.depuis(j, Contrat.fromJson));

  Future<Lecture<Contrat>> contrat(int id) => lecteur.lire('/locataire/contrats/$id', (j) => Contrat.fromJson(j as Map<String, dynamic>));

  Future<List<Rattachement>> aRattacher() async => [
        for (final r in await api.get('/locataire/rattachements') as List)
          for (final c in r['contrats'] as List)
          Rattachement(
            r['contactId'] as int,
            r['bailleur'] as String,
            ['${c['unite']} · ${c['propriete']}'],
            contratId: c['id'] as int,
          ),
      ];

  Future<void> rattacher(int contactId) => api.post('/locataire/rattachements/$contactId');

  Future<void> confirmer(int contratId) => api.post('/locataire/contrats/$contratId/confirmation');
  Future<void> refuser(int contratId) async {
    await api.post('/locataire/contrats/$contratId/refus');
    await lecteur.effacer('/locataire/');
    await lecteur.effacer('/activites?mode=locataire');
  }

  Future<void> declarer(int contratId, {required int montant, required String datePaiement, String? reference}) =>
      api.post('/locataire/contrats/$contratId/declarations', {'montant': montant, 'datePaiement': datePaiement, 'reference': ?reference});
}
