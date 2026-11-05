/// R-152 : trois environnements (dev, staging, prod), chacun avec son URL.
/// Choisis à la compilation : --dart-define=CDL_ENV=staging
/// et éventuellement --dart-define=CDL_API_URL=https://...
enum Environnement { dev, staging, prod }

class Config {
  const Config._();

  static const _env = String.fromEnvironment('CDL_ENV', defaultValue: 'dev');
  static const _urlForcee = String.fromEnvironment('CDL_API_URL');

  static Environnement get environnement =>
      Environnement.values.firstWhere((e) => e.name == _env, orElse: () => Environnement.dev);

  static String get urlApi {
    if (_urlForcee.isNotEmpty) return _urlForcee;
    return switch (environnement) {
      // 10.0.2.2 = machine hôte depuis l'émulateur Android.
      Environnement.dev => 'http://10.0.2.2:8000',
      Environnement.staging => 'https://staging.carnetdeloyer.com',
      Environnement.prod => 'https://api.carnetdeloyer.com',
    };
  }

  static String get nomApp => switch (environnement) {
        Environnement.dev => 'CDL dev',
        Environnement.staging => 'CDL staging',
        Environnement.prod => 'CarnetDeLoyer',
      };
}
