// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'locations_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(locationsService)
final locationsServiceProvider = LocationsServiceProvider._();

final class LocationsServiceProvider
    extends
        $FunctionalProvider<
          LocationsService,
          LocationsService,
          LocationsService
        >
    with $Provider<LocationsService> {
  LocationsServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'locationsServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$locationsServiceHash();

  @$internal
  @override
  $ProviderElement<LocationsService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LocationsService create(Ref ref) {
    return locationsService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LocationsService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LocationsService>(value),
    );
  }
}

String _$locationsServiceHash() => r'27f0dba802fffd789197576fbd702b11ecdf4945';

@ProviderFor(mesLocations)
final mesLocationsProvider = MesLocationsProvider._();

final class MesLocationsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Lecture<PageApi<Contrat>>>,
          Lecture<PageApi<Contrat>>,
          FutureOr<Lecture<PageApi<Contrat>>>
        >
    with
        $FutureModifier<Lecture<PageApi<Contrat>>>,
        $FutureProvider<Lecture<PageApi<Contrat>>> {
  MesLocationsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mesLocationsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mesLocationsHash();

  @$internal
  @override
  $FutureProviderElement<Lecture<PageApi<Contrat>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Lecture<PageApi<Contrat>>> create(Ref ref) {
    return mesLocations(ref);
  }
}

String _$mesLocationsHash() => r'363ed2250a3df5ca8dbdcfa02d495c7d690c5a62';

@ProviderFor(maLocation)
final maLocationProvider = MaLocationFamily._();

final class MaLocationProvider
    extends
        $FunctionalProvider<
          AsyncValue<Lecture<Contrat>>,
          Lecture<Contrat>,
          FutureOr<Lecture<Contrat>>
        >
    with $FutureModifier<Lecture<Contrat>>, $FutureProvider<Lecture<Contrat>> {
  MaLocationProvider._({
    required MaLocationFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'maLocationProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$maLocationHash();

  @override
  String toString() {
    return r'maLocationProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Lecture<Contrat>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Lecture<Contrat>> create(Ref ref) {
    final argument = this.argument as int;
    return maLocation(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is MaLocationProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$maLocationHash() => r'015775bdcb3752ccbaf12aeebddac16e67840113';

final class MaLocationFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Lecture<Contrat>>, int> {
  MaLocationFamily._()
    : super(
        retry: null,
        name: r'maLocationProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MaLocationProvider call(int id) =>
      MaLocationProvider._(argument: id, from: this);

  @override
  String toString() => r'maLocationProvider';
}

@ProviderFor(rattachements)
final rattachementsProvider = RattachementsProvider._();

final class RattachementsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Rattachement>>,
          List<Rattachement>,
          FutureOr<List<Rattachement>>
        >
    with
        $FutureModifier<List<Rattachement>>,
        $FutureProvider<List<Rattachement>> {
  RattachementsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'rattachementsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$rattachementsHash();

  @$internal
  @override
  $FutureProviderElement<List<Rattachement>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Rattachement>> create(Ref ref) {
    return rattachements(ref);
  }
}

String _$rattachementsHash() => r'63ee8f854b3720e142ef4afbd807182df2d73ec2';
