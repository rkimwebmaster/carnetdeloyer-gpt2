// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mode_actif.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Mode)
final modeProvider = ModeProvider._();

final class ModeProvider extends $AsyncNotifierProvider<Mode, ModeActif?> {
  ModeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'modeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$modeHash();

  @$internal
  @override
  Mode create() => Mode();
}

String _$modeHash() => r'64be52a76073e209f47d454851ce6c23abbc81cb';

abstract class _$Mode extends $AsyncNotifier<ModeActif?> {
  FutureOr<ModeActif?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<ModeActif?>, ModeActif?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ModeActif?>, ModeActif?>,
              AsyncValue<ModeActif?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
