// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'biens_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(biensService)
final biensServiceProvider = BiensServiceProvider._();

final class BiensServiceProvider
    extends $FunctionalProvider<BiensService, BiensService, BiensService>
    with $Provider<BiensService> {
  BiensServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'biensServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$biensServiceHash();

  @$internal
  @override
  $ProviderElement<BiensService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  BiensService create(Ref ref) {
    return biensService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BiensService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BiensService>(value),
    );
  }
}

String _$biensServiceHash() => r'cb967bc8236d161de8864b2ce6d663c551d5d627';

@ProviderFor(proprietes)
final proprietesProvider = ProprietesProvider._();

final class ProprietesProvider
    extends
        $FunctionalProvider<
          AsyncValue<Lecture<PageApi<Propriete>>>,
          Lecture<PageApi<Propriete>>,
          FutureOr<Lecture<PageApi<Propriete>>>
        >
    with
        $FutureModifier<Lecture<PageApi<Propriete>>>,
        $FutureProvider<Lecture<PageApi<Propriete>>> {
  ProprietesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'proprietesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$proprietesHash();

  @$internal
  @override
  $FutureProviderElement<Lecture<PageApi<Propriete>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Lecture<PageApi<Propriete>>> create(Ref ref) {
    return proprietes(ref);
  }
}

String _$proprietesHash() => r'ce1f4d2831ff0286d1cd0b75ff746b3da82f72cf';

@ProviderFor(propriete)
final proprieteProvider = ProprieteFamily._();

final class ProprieteProvider
    extends
        $FunctionalProvider<
          AsyncValue<Lecture<Propriete>>,
          Lecture<Propriete>,
          FutureOr<Lecture<Propriete>>
        >
    with
        $FutureModifier<Lecture<Propriete>>,
        $FutureProvider<Lecture<Propriete>> {
  ProprieteProvider._({
    required ProprieteFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'proprieteProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$proprieteHash();

  @override
  String toString() {
    return r'proprieteProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Lecture<Propriete>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Lecture<Propriete>> create(Ref ref) {
    final argument = this.argument as int;
    return propriete(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ProprieteProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$proprieteHash() => r'b402f2f6fb6669585cd360b4e7cfb587269f4fd3';

final class ProprieteFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Lecture<Propriete>>, int> {
  ProprieteFamily._()
    : super(
        retry: null,
        name: r'proprieteProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ProprieteProvider call(int id) =>
      ProprieteProvider._(argument: id, from: this);

  @override
  String toString() => r'proprieteProvider';
}

@ProviderFor(unite)
final uniteProvider = UniteFamily._();

final class UniteProvider
    extends
        $FunctionalProvider<
          AsyncValue<Lecture<Unite>>,
          Lecture<Unite>,
          FutureOr<Lecture<Unite>>
        >
    with $FutureModifier<Lecture<Unite>>, $FutureProvider<Lecture<Unite>> {
  UniteProvider._({
    required UniteFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'uniteProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$uniteHash();

  @override
  String toString() {
    return r'uniteProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Lecture<Unite>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Lecture<Unite>> create(Ref ref) {
    final argument = this.argument as int;
    return unite(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is UniteProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$uniteHash() => r'b1056ba9055ff732ef64101b022908498a8d4c4b';

final class UniteFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Lecture<Unite>>, int> {
  UniteFamily._()
    : super(
        retry: null,
        name: r'uniteProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  UniteProvider call(int id) => UniteProvider._(argument: id, from: this);

  @override
  String toString() => r'uniteProvider';
}

@ProviderFor(devises)
final devisesProvider = DevisesProvider._();

final class DevisesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Devise>>,
          List<Devise>,
          FutureOr<List<Devise>>
        >
    with $FutureModifier<List<Devise>>, $FutureProvider<List<Devise>> {
  DevisesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'devisesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$devisesHash();

  @$internal
  @override
  $FutureProviderElement<List<Devise>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Devise>> create(Ref ref) {
    return devises(ref);
  }
}

String _$devisesHash() => r'184f3022c30c81c6e0124a98d41b6ef52d0fa6f4';

@ProviderFor(categories)
final categoriesProvider = CategoriesProvider._();

final class CategoriesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Categorie>>,
          List<Categorie>,
          FutureOr<List<Categorie>>
        >
    with $FutureModifier<List<Categorie>>, $FutureProvider<List<Categorie>> {
  CategoriesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'categoriesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$categoriesHash();

  @$internal
  @override
  $FutureProviderElement<List<Categorie>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Categorie>> create(Ref ref) {
    return categories(ref);
  }
}

String _$categoriesHash() => r'f3ef17773aff06d78dea5a8d55e364dc2580f4a7';
