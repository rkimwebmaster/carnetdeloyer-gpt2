// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Les services sont exposés via des providers pour être remplacés en test (R-134).

@ProviderFor(coffre)
final coffreProvider = CoffreProvider._();

/// Les services sont exposés via des providers pour être remplacés en test (R-134).

final class CoffreProvider extends $FunctionalProvider<Coffre, Coffre, Coffre>
    with $Provider<Coffre> {
  /// Les services sont exposés via des providers pour être remplacés en test (R-134).
  CoffreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'coffreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$coffreHash();

  @$internal
  @override
  $ProviderElement<Coffre> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Coffre create(Ref ref) {
    return coffre(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Coffre value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Coffre>(value),
    );
  }
}

String _$coffreHash() => r'ea83e33f82d35b50e723a866e61e8d4e54d122f6';

@ProviderFor(stockageSession)
final stockageSessionProvider = StockageSessionProvider._();

final class StockageSessionProvider
    extends
        $FunctionalProvider<StockageSession, StockageSession, StockageSession>
    with $Provider<StockageSession> {
  StockageSessionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'stockageSessionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$stockageSessionHash();

  @$internal
  @override
  $ProviderElement<StockageSession> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  StockageSession create(Ref ref) {
    return stockageSession(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StockageSession value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StockageSession>(value),
    );
  }
}

String _$stockageSessionHash() => r'1a3ab7f42052227a8b6ddcc4a1896581212d734d';

@ProviderFor(baseLocale)
final baseLocaleProvider = BaseLocaleProvider._();

final class BaseLocaleProvider
    extends $FunctionalProvider<BaseLocale, BaseLocale, BaseLocale>
    with $Provider<BaseLocale> {
  BaseLocaleProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'baseLocaleProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$baseLocaleHash();

  @$internal
  @override
  $ProviderElement<BaseLocale> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  BaseLocale create(Ref ref) {
    return baseLocale(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BaseLocale value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BaseLocale>(value),
    );
  }
}

String _$baseLocaleHash() => r'1d12e9b6bfcc3958dfa0d70e23a56f9984813ca5';

@ProviderFor(clientApi)
final clientApiProvider = ClientApiProvider._();

final class ClientApiProvider
    extends $FunctionalProvider<ClientApi, ClientApi, ClientApi>
    with $Provider<ClientApi> {
  ClientApiProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'clientApiProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$clientApiHash();

  @$internal
  @override
  $ProviderElement<ClientApi> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ClientApi create(Ref ref) {
    return clientApi(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ClientApi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ClientApi>(value),
    );
  }
}

String _$clientApiHash() => r'6a44484bd394eae47775569b1f2783498be3e6b8';

@ProviderFor(Session)
final sessionProvider = SessionProvider._();

final class SessionProvider extends $NotifierProvider<Session, EtatSession> {
  SessionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sessionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sessionHash();

  @$internal
  @override
  Session create() => Session();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EtatSession value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EtatSession>(value),
    );
  }
}

String _$sessionHash() => r'574a7daf4118ce9fd9e8003a223cd7d8017ff166';

abstract class _$Session extends $Notifier<EtatSession> {
  EtatSession build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<EtatSession, EtatSession>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<EtatSession, EtatSession>,
              EtatSession,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
