// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(authService)
final authServiceProvider = AuthServiceProvider._();

final class AuthServiceProvider
    extends $FunctionalProvider<AuthService, AuthService, AuthService>
    with $Provider<AuthService> {
  AuthServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authServiceHash();

  @$internal
  @override
  $ProviderElement<AuthService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AuthService create(Ref ref) {
    return authService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthService>(value),
    );
  }
}

String _$authServiceHash() => r'd0499f1a255bf7cab2fb524580d65a6ffc0877ec';

/// Profil de l'utilisateur connecté (consultable hors ligne).

@ProviderFor(profil)
final profilProvider = ProfilProvider._();

/// Profil de l'utilisateur connecté (consultable hors ligne).

final class ProfilProvider
    extends $FunctionalProvider<AsyncValue<Profil>, Profil, FutureOr<Profil>>
    with $FutureModifier<Profil>, $FutureProvider<Profil> {
  /// Profil de l'utilisateur connecté (consultable hors ligne).
  ProfilProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profilProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profilHash();

  @$internal
  @override
  $FutureProviderElement<Profil> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Profil> create(Ref ref) {
    return profil(ref);
  }
}

String _$profilHash() => r'1b3574947cccd85c4d57f1127579600b2d6b9ad2';
