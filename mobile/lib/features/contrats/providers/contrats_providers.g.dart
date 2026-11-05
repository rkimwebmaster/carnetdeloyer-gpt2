// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contrats_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(contratsService)
final contratsServiceProvider = ContratsServiceProvider._();

final class ContratsServiceProvider
    extends
        $FunctionalProvider<ContratsService, ContratsService, ContratsService>
    with $Provider<ContratsService> {
  ContratsServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'contratsServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$contratsServiceHash();

  @$internal
  @override
  $ProviderElement<ContratsService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ContratsService create(Ref ref) {
    return contratsService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ContratsService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ContratsService>(value),
    );
  }
}

String _$contratsServiceHash() => r'0549590719ca7d2846d3e6cff92f55871db47a09';

@ProviderFor(contrats)
final contratsProvider = ContratsFamily._();

final class ContratsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Lecture<PageApi<Contrat>>>,
          Lecture<PageApi<Contrat>>,
          FutureOr<Lecture<PageApi<Contrat>>>
        >
    with
        $FutureModifier<Lecture<PageApi<Contrat>>>,
        $FutureProvider<Lecture<PageApi<Contrat>>> {
  ContratsProvider._({
    required ContratsFamily super.from,
    required ({String? statut, bool enRetard}) super.argument,
  }) : super(
         retry: null,
         name: r'contratsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$contratsHash();

  @override
  String toString() {
    return r'contratsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<Lecture<PageApi<Contrat>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Lecture<PageApi<Contrat>>> create(Ref ref) {
    final argument = this.argument as ({String? statut, bool enRetard});
    return contrats(ref, statut: argument.statut, enRetard: argument.enRetard);
  }

  @override
  bool operator ==(Object other) {
    return other is ContratsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$contratsHash() => r'3d8f5355ee5e9c96b5815fc07e9bedfbde54ddd9';

final class ContratsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<Lecture<PageApi<Contrat>>>,
          ({String? statut, bool enRetard})
        > {
  ContratsFamily._()
    : super(
        retry: null,
        name: r'contratsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ContratsProvider call({String? statut, bool enRetard = false}) =>
      ContratsProvider._(
        argument: (statut: statut, enRetard: enRetard),
        from: this,
      );

  @override
  String toString() => r'contratsProvider';
}

@ProviderFor(contrat)
final contratProvider = ContratFamily._();

final class ContratProvider
    extends
        $FunctionalProvider<
          AsyncValue<Lecture<Contrat>>,
          Lecture<Contrat>,
          FutureOr<Lecture<Contrat>>
        >
    with $FutureModifier<Lecture<Contrat>>, $FutureProvider<Lecture<Contrat>> {
  ContratProvider._({
    required ContratFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'contratProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$contratHash();

  @override
  String toString() {
    return r'contratProvider'
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
    return contrat(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ContratProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$contratHash() => r'57fa9e6a41f96b0f15cea3d1b003b7f5bb8b2626';

final class ContratFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Lecture<Contrat>>, int> {
  ContratFamily._()
    : super(
        retry: null,
        name: r'contratProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ContratProvider call(int id) => ContratProvider._(argument: id, from: this);

  @override
  String toString() => r'contratProvider';
}

@ProviderFor(encaissement)
final encaissementProvider = EncaissementFamily._();

final class EncaissementProvider
    extends
        $FunctionalProvider<
          AsyncValue<Lecture<Encaissement>>,
          Lecture<Encaissement>,
          FutureOr<Lecture<Encaissement>>
        >
    with
        $FutureModifier<Lecture<Encaissement>>,
        $FutureProvider<Lecture<Encaissement>> {
  EncaissementProvider._({
    required EncaissementFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'encaissementProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$encaissementHash();

  @override
  String toString() {
    return r'encaissementProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Lecture<Encaissement>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Lecture<Encaissement>> create(Ref ref) {
    final argument = this.argument as int;
    return encaissement(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is EncaissementProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$encaissementHash() => r'd1dec6f25ba363f8ab1d722a56ba195cacb63e24';

final class EncaissementFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Lecture<Encaissement>>, int> {
  EncaissementFamily._()
    : super(
        retry: null,
        name: r'encaissementProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  EncaissementProvider call(int contratId) =>
      EncaissementProvider._(argument: contratId, from: this);

  @override
  String toString() => r'encaissementProvider';
}
