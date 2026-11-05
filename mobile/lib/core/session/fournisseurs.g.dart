// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fournisseurs.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Lecteur avec cache pour l'utilisateur connecté.

@ProviderFor(lecteur)
final lecteurProvider = LecteurProvider._();

/// Lecteur avec cache pour l'utilisateur connecté.

final class LecteurProvider
    extends $FunctionalProvider<LecteurCache, LecteurCache, LecteurCache>
    with $Provider<LecteurCache> {
  /// Lecteur avec cache pour l'utilisateur connecté.
  LecteurProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'lecteurProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$lecteurHash();

  @$internal
  @override
  $ProviderElement<LecteurCache> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LecteurCache create(Ref ref) {
    return lecteur(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LecteurCache value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LecteurCache>(value),
    );
  }
}

String _$lecteurHash() => r'642cd5272f72dbe5c6a1649617efee6dc2cc47ee';

/// Vrai si le téléphone a une connexion réseau (indicatif : le serveur peut
/// rester injoignable ; les appels gèrent ce cas).

@ProviderFor(enLigne)
final enLigneProvider = EnLigneProvider._();

/// Vrai si le téléphone a une connexion réseau (indicatif : le serveur peut
/// rester injoignable ; les appels gèrent ce cas).

final class EnLigneProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, Stream<bool>>
    with $FutureModifier<bool>, $StreamProvider<bool> {
  /// Vrai si le téléphone a une connexion réseau (indicatif : le serveur peut
  /// rester injoignable ; les appels gèrent ce cas).
  EnLigneProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'enLigneProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$enLigneHash();

  @$internal
  @override
  $StreamProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<bool> create(Ref ref) {
    return enLigne(ref);
  }
}

String _$enLigneHash() => r'b066156d8f4818bb9dad600f87faae38dbfe9461';
