// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paiements_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(filePaiements)
final filePaiementsProvider = FilePaiementsProvider._();

final class FilePaiementsProvider
    extends $FunctionalProvider<FilePaiements, FilePaiements, FilePaiements>
    with $Provider<FilePaiements> {
  FilePaiementsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filePaiementsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filePaiementsHash();

  @$internal
  @override
  $ProviderElement<FilePaiements> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  FilePaiements create(Ref ref) {
    return filePaiements(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FilePaiements value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FilePaiements>(value),
    );
  }
}

String _$filePaiementsHash() => r'0373539f5e7505a60abbf5a536d7720610de96d1';

@ProviderFor(paiementsService)
final paiementsServiceProvider = PaiementsServiceProvider._();

final class PaiementsServiceProvider
    extends
        $FunctionalProvider<
          PaiementsService,
          PaiementsService,
          PaiementsService
        >
    with $Provider<PaiementsService> {
  PaiementsServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'paiementsServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$paiementsServiceHash();

  @$internal
  @override
  $ProviderElement<PaiementsService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PaiementsService create(Ref ref) {
    return paiementsService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PaiementsService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PaiementsService>(value),
    );
  }
}

String _$paiementsServiceHash() => r'f8c21ed466f55246b68c144615d25feba3a47225';

@ProviderFor(paiements)
final paiementsProvider = PaiementsProvider._();

final class PaiementsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Lecture<PageApi<Paiement>>>,
          Lecture<PageApi<Paiement>>,
          FutureOr<Lecture<PageApi<Paiement>>>
        >
    with
        $FutureModifier<Lecture<PageApi<Paiement>>>,
        $FutureProvider<Lecture<PageApi<Paiement>>> {
  PaiementsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'paiementsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$paiementsHash();

  @$internal
  @override
  $FutureProviderElement<Lecture<PageApi<Paiement>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Lecture<PageApi<Paiement>>> create(Ref ref) {
    return paiements(ref);
  }
}

String _$paiementsHash() => r'8dea1a136d8324f42501ee2e1dbf8587acf9f59b';

@ProviderFor(declarations)
final declarationsProvider = DeclarationsProvider._();

final class DeclarationsProvider
    extends
        $FunctionalProvider<
          AsyncValue<PageApi<Declaration>>,
          PageApi<Declaration>,
          FutureOr<PageApi<Declaration>>
        >
    with
        $FutureModifier<PageApi<Declaration>>,
        $FutureProvider<PageApi<Declaration>> {
  DeclarationsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'declarationsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$declarationsHash();

  @$internal
  @override
  $FutureProviderElement<PageApi<Declaration>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<PageApi<Declaration>> create(Ref ref) {
    return declarations(ref);
  }
}

String _$declarationsHash() => r'8a406b2b67a39f10a1d49d794569047c2e89d267';
