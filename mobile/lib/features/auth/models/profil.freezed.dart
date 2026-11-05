// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profil.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PaysProfil {

 int get id; String get nom; String get codeIso; String? get deviseParDefaut;
/// Create a copy of PaysProfil
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaysProfilCopyWith<PaysProfil> get copyWith => _$PaysProfilCopyWithImpl<PaysProfil>(this as PaysProfil, _$identity);

  /// Serializes this PaysProfil to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PaysProfil;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaysProfil&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.nom, _this.nom) || other.nom == _this.nom)&&(identical(other.codeIso, _this.codeIso) || other.codeIso == _this.codeIso)&&(identical(other.deviseParDefaut, _this.deviseParDefaut) || other.deviseParDefaut == _this.deviseParDefaut));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PaysProfil;
  return Object.hash(runtimeType,_this.id,_this.nom,_this.codeIso,_this.deviseParDefaut);
}

@override
String toString() {
  final _this = this as PaysProfil;
  return 'PaysProfil(id: ${_this.id}, nom: ${_this.nom}, codeIso: ${_this.codeIso}, deviseParDefaut: ${_this.deviseParDefaut})';
}


}

/// @nodoc
abstract mixin class $PaysProfilCopyWith<$Res>  {
  factory $PaysProfilCopyWith(PaysProfil value, $Res Function(PaysProfil) _then) = _$PaysProfilCopyWithImpl;
@useResult
$Res call({
 int id, String nom, String codeIso, String? deviseParDefaut
});




}
/// @nodoc
class _$PaysProfilCopyWithImpl<$Res>
    implements $PaysProfilCopyWith<$Res> {
  _$PaysProfilCopyWithImpl(this._self, this._then);

  final PaysProfil _self;
  final $Res Function(PaysProfil) _then;

/// Create a copy of PaysProfil
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? nom = null,Object? codeIso = null,Object? deviseParDefaut = freezed,}) {
  return _then(PaysProfil(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,nom: null == nom ? _self.nom : nom // ignore: cast_nullable_to_non_nullable
as String,codeIso: null == codeIso ? _self.codeIso : codeIso // ignore: cast_nullable_to_non_nullable
as String,deviseParDefaut: freezed == deviseParDefaut ? _self.deviseParDefaut : deviseParDefaut // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PaysProfil].
extension PaysProfilPatterns on PaysProfil {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaysProfil value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaysProfil() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaysProfil value)  $default,){
final _that = this;
switch (_that) {
case _PaysProfil():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaysProfil value)?  $default,){
final _that = this;
switch (_that) {
case _PaysProfil() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String nom,  String codeIso,  String? deviseParDefaut)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaysProfil() when $default != null:
return $default(_that.id,_that.nom,_that.codeIso,_that.deviseParDefaut);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String nom,  String codeIso,  String? deviseParDefaut)  $default,) {final _that = this;
switch (_that) {
case _PaysProfil():
return $default(_that.id,_that.nom,_that.codeIso,_that.deviseParDefaut);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String nom,  String codeIso,  String? deviseParDefaut)?  $default,) {final _that = this;
switch (_that) {
case _PaysProfil() when $default != null:
return $default(_that.id,_that.nom,_that.codeIso,_that.deviseParDefaut);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PaysProfil implements PaysProfil {
  const _PaysProfil({required this.id, required this.nom, required this.codeIso, this.deviseParDefaut});
  factory _PaysProfil.fromJson(Map<String, dynamic> json) => _$PaysProfilFromJson(json);

@override final  int id;
@override final  String nom;
@override final  String codeIso;
@override final  String? deviseParDefaut;

/// Create a copy of PaysProfil
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaysProfilCopyWith<_PaysProfil> get copyWith => __$PaysProfilCopyWithImpl<_PaysProfil>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaysProfilToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaysProfil&&(identical(other.id, id) || other.id == id)&&(identical(other.nom, nom) || other.nom == nom)&&(identical(other.codeIso, codeIso) || other.codeIso == codeIso)&&(identical(other.deviseParDefaut, deviseParDefaut) || other.deviseParDefaut == deviseParDefaut));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,nom,codeIso,deviseParDefaut);
}

@override
String toString() {
    return 'PaysProfil(id: $id, nom: $nom, codeIso: $codeIso, deviseParDefaut: $deviseParDefaut)';
}


}

/// @nodoc
abstract mixin class _$PaysProfilCopyWith<$Res> implements $PaysProfilCopyWith<$Res> {
  factory _$PaysProfilCopyWith(_PaysProfil value, $Res Function(_PaysProfil) _then) = __$PaysProfilCopyWithImpl;
@override @useResult
$Res call({
 int id, String nom, String codeIso, String? deviseParDefaut
});




}
/// @nodoc
class __$PaysProfilCopyWithImpl<$Res>
    implements _$PaysProfilCopyWith<$Res> {
  __$PaysProfilCopyWithImpl(this._self, this._then);

  final _PaysProfil _self;
  final $Res Function(_PaysProfil) _then;

/// Create a copy of PaysProfil
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? nom = null,Object? codeIso = null,Object? deviseParDefaut = freezed,}) {
  return _then(_PaysProfil(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,nom: null == nom ? _self.nom : nom // ignore: cast_nullable_to_non_nullable
as String,codeIso: null == codeIso ? _self.codeIso : codeIso // ignore: cast_nullable_to_non_nullable
as String,deviseParDefaut: freezed == deviseParDefaut ? _self.deviseParDefaut : deviseParDefaut // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$EspaceProfil {

 int get id; String get nomAffiche; String? get raisonSociale; String? get badge;
/// Create a copy of EspaceProfil
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EspaceProfilCopyWith<EspaceProfil> get copyWith => _$EspaceProfilCopyWithImpl<EspaceProfil>(this as EspaceProfil, _$identity);

  /// Serializes this EspaceProfil to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as EspaceProfil;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EspaceProfil&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.nomAffiche, _this.nomAffiche) || other.nomAffiche == _this.nomAffiche)&&(identical(other.raisonSociale, _this.raisonSociale) || other.raisonSociale == _this.raisonSociale)&&(identical(other.badge, _this.badge) || other.badge == _this.badge));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as EspaceProfil;
  return Object.hash(runtimeType,_this.id,_this.nomAffiche,_this.raisonSociale,_this.badge);
}

@override
String toString() {
  final _this = this as EspaceProfil;
  return 'EspaceProfil(id: ${_this.id}, nomAffiche: ${_this.nomAffiche}, raisonSociale: ${_this.raisonSociale}, badge: ${_this.badge})';
}


}

/// @nodoc
abstract mixin class $EspaceProfilCopyWith<$Res>  {
  factory $EspaceProfilCopyWith(EspaceProfil value, $Res Function(EspaceProfil) _then) = _$EspaceProfilCopyWithImpl;
@useResult
$Res call({
 int id, String nomAffiche, String? raisonSociale, String? badge
});




}
/// @nodoc
class _$EspaceProfilCopyWithImpl<$Res>
    implements $EspaceProfilCopyWith<$Res> {
  _$EspaceProfilCopyWithImpl(this._self, this._then);

  final EspaceProfil _self;
  final $Res Function(EspaceProfil) _then;

/// Create a copy of EspaceProfil
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? nomAffiche = null,Object? raisonSociale = freezed,Object? badge = freezed,}) {
  return _then(EspaceProfil(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,nomAffiche: null == nomAffiche ? _self.nomAffiche : nomAffiche // ignore: cast_nullable_to_non_nullable
as String,raisonSociale: freezed == raisonSociale ? _self.raisonSociale : raisonSociale // ignore: cast_nullable_to_non_nullable
as String?,badge: freezed == badge ? _self.badge : badge // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [EspaceProfil].
extension EspaceProfilPatterns on EspaceProfil {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EspaceProfil value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EspaceProfil() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EspaceProfil value)  $default,){
final _that = this;
switch (_that) {
case _EspaceProfil():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EspaceProfil value)?  $default,){
final _that = this;
switch (_that) {
case _EspaceProfil() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String nomAffiche,  String? raisonSociale,  String? badge)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EspaceProfil() when $default != null:
return $default(_that.id,_that.nomAffiche,_that.raisonSociale,_that.badge);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String nomAffiche,  String? raisonSociale,  String? badge)  $default,) {final _that = this;
switch (_that) {
case _EspaceProfil():
return $default(_that.id,_that.nomAffiche,_that.raisonSociale,_that.badge);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String nomAffiche,  String? raisonSociale,  String? badge)?  $default,) {final _that = this;
switch (_that) {
case _EspaceProfil() when $default != null:
return $default(_that.id,_that.nomAffiche,_that.raisonSociale,_that.badge);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EspaceProfil implements EspaceProfil {
  const _EspaceProfil({required this.id, required this.nomAffiche, this.raisonSociale, this.badge});
  factory _EspaceProfil.fromJson(Map<String, dynamic> json) => _$EspaceProfilFromJson(json);

@override final  int id;
@override final  String nomAffiche;
@override final  String? raisonSociale;
@override final  String? badge;

/// Create a copy of EspaceProfil
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EspaceProfilCopyWith<_EspaceProfil> get copyWith => __$EspaceProfilCopyWithImpl<_EspaceProfil>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EspaceProfilToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _EspaceProfil&&(identical(other.id, id) || other.id == id)&&(identical(other.nomAffiche, nomAffiche) || other.nomAffiche == nomAffiche)&&(identical(other.raisonSociale, raisonSociale) || other.raisonSociale == raisonSociale)&&(identical(other.badge, badge) || other.badge == badge));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,nomAffiche,raisonSociale,badge);
}

@override
String toString() {
    return 'EspaceProfil(id: $id, nomAffiche: $nomAffiche, raisonSociale: $raisonSociale, badge: $badge)';
}


}

/// @nodoc
abstract mixin class _$EspaceProfilCopyWith<$Res> implements $EspaceProfilCopyWith<$Res> {
  factory _$EspaceProfilCopyWith(_EspaceProfil value, $Res Function(_EspaceProfil) _then) = __$EspaceProfilCopyWithImpl;
@override @useResult
$Res call({
 int id, String nomAffiche, String? raisonSociale, String? badge
});




}
/// @nodoc
class __$EspaceProfilCopyWithImpl<$Res>
    implements _$EspaceProfilCopyWith<$Res> {
  __$EspaceProfilCopyWithImpl(this._self, this._then);

  final _EspaceProfil _self;
  final $Res Function(_EspaceProfil) _then;

/// Create a copy of EspaceProfil
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? nomAffiche = null,Object? raisonSociale = freezed,Object? badge = freezed,}) {
  return _then(_EspaceProfil(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,nomAffiche: null == nomAffiche ? _self.nomAffiche : nomAffiche // ignore: cast_nullable_to_non_nullable
as String,raisonSociale: freezed == raisonSociale ? _self.raisonSociale : raisonSociale // ignore: cast_nullable_to_non_nullable
as String?,badge: freezed == badge ? _self.badge : badge // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$Profil {

 int get id; String get nom; String? get telephone; String? get email; PaysProfil? get pays; String? get modePrefere; String get codeParrainage; EspaceProfil? get espaceBailleur; List<String> get roles;
/// Create a copy of Profil
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfilCopyWith<Profil> get copyWith => _$ProfilCopyWithImpl<Profil>(this as Profil, _$identity);

  /// Serializes this Profil to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Profil;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Profil&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.nom, _this.nom) || other.nom == _this.nom)&&(identical(other.telephone, _this.telephone) || other.telephone == _this.telephone)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.pays, _this.pays) || other.pays == _this.pays)&&(identical(other.modePrefere, _this.modePrefere) || other.modePrefere == _this.modePrefere)&&(identical(other.codeParrainage, _this.codeParrainage) || other.codeParrainage == _this.codeParrainage)&&(identical(other.espaceBailleur, _this.espaceBailleur) || other.espaceBailleur == _this.espaceBailleur)&&const DeepCollectionEquality().equals(other.roles, _this.roles));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Profil;
  return Object.hash(runtimeType,_this.id,_this.nom,_this.telephone,_this.email,_this.pays,_this.modePrefere,_this.codeParrainage,_this.espaceBailleur,const DeepCollectionEquality().hash(_this.roles));
}

@override
String toString() {
  final _this = this as Profil;
  return 'Profil(id: ${_this.id}, nom: ${_this.nom}, telephone: ${_this.telephone}, email: ${_this.email}, pays: ${_this.pays}, modePrefere: ${_this.modePrefere}, codeParrainage: ${_this.codeParrainage}, espaceBailleur: ${_this.espaceBailleur}, roles: ${_this.roles})';
}


}

/// @nodoc
abstract mixin class $ProfilCopyWith<$Res>  {
  factory $ProfilCopyWith(Profil value, $Res Function(Profil) _then) = _$ProfilCopyWithImpl;
@useResult
$Res call({
 int id, String nom, String? telephone, String? email, PaysProfil? pays, String? modePrefere, String codeParrainage, EspaceProfil? espaceBailleur, List<String> roles
});


$PaysProfilCopyWith<$Res>? get pays;$EspaceProfilCopyWith<$Res>? get espaceBailleur;

}
/// @nodoc
class _$ProfilCopyWithImpl<$Res>
    implements $ProfilCopyWith<$Res> {
  _$ProfilCopyWithImpl(this._self, this._then);

  final Profil _self;
  final $Res Function(Profil) _then;

/// Create a copy of Profil
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? nom = null,Object? telephone = freezed,Object? email = freezed,Object? pays = freezed,Object? modePrefere = freezed,Object? codeParrainage = null,Object? espaceBailleur = freezed,Object? roles = null,}) {
  return _then(Profil(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,nom: null == nom ? _self.nom : nom // ignore: cast_nullable_to_non_nullable
as String,telephone: freezed == telephone ? _self.telephone : telephone // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,pays: freezed == pays ? _self.pays : pays // ignore: cast_nullable_to_non_nullable
as PaysProfil?,modePrefere: freezed == modePrefere ? _self.modePrefere : modePrefere // ignore: cast_nullable_to_non_nullable
as String?,codeParrainage: null == codeParrainage ? _self.codeParrainage : codeParrainage // ignore: cast_nullable_to_non_nullable
as String,espaceBailleur: freezed == espaceBailleur ? _self.espaceBailleur : espaceBailleur // ignore: cast_nullable_to_non_nullable
as EspaceProfil?,roles: null == roles ? _self.roles : roles // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}
/// Create a copy of Profil
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PaysProfilCopyWith<$Res>? get pays {
    if (_self.pays == null) {
    return null;
  }

  return $PaysProfilCopyWith<$Res>(_self.pays!, (value) {
    return _then(_self.copyWith(pays: value));
  });
}/// Create a copy of Profil
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EspaceProfilCopyWith<$Res>? get espaceBailleur {
    if (_self.espaceBailleur == null) {
    return null;
  }

  return $EspaceProfilCopyWith<$Res>(_self.espaceBailleur!, (value) {
    return _then(_self.copyWith(espaceBailleur: value));
  });
}
}


/// Adds pattern-matching-related methods to [Profil].
extension ProfilPatterns on Profil {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Profil value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Profil() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Profil value)  $default,){
final _that = this;
switch (_that) {
case _Profil():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Profil value)?  $default,){
final _that = this;
switch (_that) {
case _Profil() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String nom,  String? telephone,  String? email,  PaysProfil? pays,  String? modePrefere,  String codeParrainage,  EspaceProfil? espaceBailleur,  List<String> roles)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Profil() when $default != null:
return $default(_that.id,_that.nom,_that.telephone,_that.email,_that.pays,_that.modePrefere,_that.codeParrainage,_that.espaceBailleur,_that.roles);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String nom,  String? telephone,  String? email,  PaysProfil? pays,  String? modePrefere,  String codeParrainage,  EspaceProfil? espaceBailleur,  List<String> roles)  $default,) {final _that = this;
switch (_that) {
case _Profil():
return $default(_that.id,_that.nom,_that.telephone,_that.email,_that.pays,_that.modePrefere,_that.codeParrainage,_that.espaceBailleur,_that.roles);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String nom,  String? telephone,  String? email,  PaysProfil? pays,  String? modePrefere,  String codeParrainage,  EspaceProfil? espaceBailleur,  List<String> roles)?  $default,) {final _that = this;
switch (_that) {
case _Profil() when $default != null:
return $default(_that.id,_that.nom,_that.telephone,_that.email,_that.pays,_that.modePrefere,_that.codeParrainage,_that.espaceBailleur,_that.roles);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Profil implements Profil {
  const _Profil({required this.id, required this.nom, this.telephone, this.email, this.pays, this.modePrefere, required this.codeParrainage, this.espaceBailleur,  List<String> roles = const <String>[]}): _roles = roles;
  factory _Profil.fromJson(Map<String, dynamic> json) => _$ProfilFromJson(json);

@override final  int id;
@override final  String nom;
@override final  String? telephone;
@override final  String? email;
@override final  PaysProfil? pays;
@override final  String? modePrefere;
@override final  String codeParrainage;
@override final  EspaceProfil? espaceBailleur;
 final  List<String> _roles;
@override@JsonKey() List<String> get roles {
  if (_roles is EqualUnmodifiableListView) return _roles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_roles);
}


/// Create a copy of Profil
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfilCopyWith<_Profil> get copyWith => __$ProfilCopyWithImpl<_Profil>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProfilToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Profil&&(identical(other.id, id) || other.id == id)&&(identical(other.nom, nom) || other.nom == nom)&&(identical(other.telephone, telephone) || other.telephone == telephone)&&(identical(other.email, email) || other.email == email)&&(identical(other.pays, pays) || other.pays == pays)&&(identical(other.modePrefere, modePrefere) || other.modePrefere == modePrefere)&&(identical(other.codeParrainage, codeParrainage) || other.codeParrainage == codeParrainage)&&(identical(other.espaceBailleur, espaceBailleur) || other.espaceBailleur == espaceBailleur)&&const DeepCollectionEquality().equals(other.roles, _roles));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,nom,telephone,email,pays,modePrefere,codeParrainage,espaceBailleur,const DeepCollectionEquality().hash(_roles));
}

@override
String toString() {
    return 'Profil(id: $id, nom: $nom, telephone: $telephone, email: $email, pays: $pays, modePrefere: $modePrefere, codeParrainage: $codeParrainage, espaceBailleur: $espaceBailleur, roles: $roles)';
}


}

/// @nodoc
abstract mixin class _$ProfilCopyWith<$Res> implements $ProfilCopyWith<$Res> {
  factory _$ProfilCopyWith(_Profil value, $Res Function(_Profil) _then) = __$ProfilCopyWithImpl;
@override @useResult
$Res call({
 int id, String nom, String? telephone, String? email, PaysProfil? pays, String? modePrefere, String codeParrainage, EspaceProfil? espaceBailleur, List<String> roles
});


@override $PaysProfilCopyWith<$Res>? get pays;@override $EspaceProfilCopyWith<$Res>? get espaceBailleur;

}
/// @nodoc
class __$ProfilCopyWithImpl<$Res>
    implements _$ProfilCopyWith<$Res> {
  __$ProfilCopyWithImpl(this._self, this._then);

  final _Profil _self;
  final $Res Function(_Profil) _then;

/// Create a copy of Profil
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? nom = null,Object? telephone = freezed,Object? email = freezed,Object? pays = freezed,Object? modePrefere = freezed,Object? codeParrainage = null,Object? espaceBailleur = freezed,Object? roles = null,}) {
  return _then(_Profil(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,nom: null == nom ? _self.nom : nom // ignore: cast_nullable_to_non_nullable
as String,telephone: freezed == telephone ? _self.telephone : telephone // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,pays: freezed == pays ? _self.pays : pays // ignore: cast_nullable_to_non_nullable
as PaysProfil?,modePrefere: freezed == modePrefere ? _self.modePrefere : modePrefere // ignore: cast_nullable_to_non_nullable
as String?,codeParrainage: null == codeParrainage ? _self.codeParrainage : codeParrainage // ignore: cast_nullable_to_non_nullable
as String,espaceBailleur: freezed == espaceBailleur ? _self.espaceBailleur : espaceBailleur // ignore: cast_nullable_to_non_nullable
as EspaceProfil?,roles: null == roles ? _self._roles : roles // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

/// Create a copy of Profil
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PaysProfilCopyWith<$Res>? get pays {
    if (_self.pays == null) {
    return null;
  }

  return $PaysProfilCopyWith<$Res>(_self.pays!, (value) {
    return _then(_self.copyWith(pays: value));
  });
}/// Create a copy of Profil
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EspaceProfilCopyWith<$Res>? get espaceBailleur {
    if (_self.espaceBailleur == null) {
    return null;
  }

  return $EspaceProfilCopyWith<$Res>(_self.espaceBailleur!, (value) {
    return _then(_self.copyWith(espaceBailleur: value));
  });
}
}

// dart format on
