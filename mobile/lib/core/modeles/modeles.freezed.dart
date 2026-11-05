// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'modeles.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Devise {

 String get code; String get nom; String get symbole; int get decimales; bool get active;
/// Create a copy of Devise
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeviseCopyWith<Devise> get copyWith => _$DeviseCopyWithImpl<Devise>(this as Devise, _$identity);

  /// Serializes this Devise to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Devise;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Devise&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.nom, _this.nom) || other.nom == _this.nom)&&(identical(other.symbole, _this.symbole) || other.symbole == _this.symbole)&&(identical(other.decimales, _this.decimales) || other.decimales == _this.decimales)&&(identical(other.active, _this.active) || other.active == _this.active));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Devise;
  return Object.hash(runtimeType,_this.code,_this.nom,_this.symbole,_this.decimales,_this.active);
}

@override
String toString() {
  final _this = this as Devise;
  return 'Devise(code: ${_this.code}, nom: ${_this.nom}, symbole: ${_this.symbole}, decimales: ${_this.decimales}, active: ${_this.active})';
}


}

/// @nodoc
abstract mixin class $DeviseCopyWith<$Res>  {
  factory $DeviseCopyWith(Devise value, $Res Function(Devise) _then) = _$DeviseCopyWithImpl;
@useResult
$Res call({
 String code, String nom, String symbole, int decimales, bool active
});




}
/// @nodoc
class _$DeviseCopyWithImpl<$Res>
    implements $DeviseCopyWith<$Res> {
  _$DeviseCopyWithImpl(this._self, this._then);

  final Devise _self;
  final $Res Function(Devise) _then;

/// Create a copy of Devise
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? nom = null,Object? symbole = null,Object? decimales = null,Object? active = null,}) {
  return _then(Devise(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,nom: null == nom ? _self.nom : nom // ignore: cast_nullable_to_non_nullable
as String,symbole: null == symbole ? _self.symbole : symbole // ignore: cast_nullable_to_non_nullable
as String,decimales: null == decimales ? _self.decimales : decimales // ignore: cast_nullable_to_non_nullable
as int,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Devise].
extension DevisePatterns on Devise {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Devise value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Devise() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Devise value)  $default,){
final _that = this;
switch (_that) {
case _Devise():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Devise value)?  $default,){
final _that = this;
switch (_that) {
case _Devise() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  String nom,  String symbole,  int decimales,  bool active)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Devise() when $default != null:
return $default(_that.code,_that.nom,_that.symbole,_that.decimales,_that.active);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  String nom,  String symbole,  int decimales,  bool active)  $default,) {final _that = this;
switch (_that) {
case _Devise():
return $default(_that.code,_that.nom,_that.symbole,_that.decimales,_that.active);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  String nom,  String symbole,  int decimales,  bool active)?  $default,) {final _that = this;
switch (_that) {
case _Devise() when $default != null:
return $default(_that.code,_that.nom,_that.symbole,_that.decimales,_that.active);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Devise implements Devise {
  const _Devise({required this.code, required this.nom, required this.symbole, required this.decimales, this.active = true});
  factory _Devise.fromJson(Map<String, dynamic> json) => _$DeviseFromJson(json);

@override final  String code;
@override final  String nom;
@override final  String symbole;
@override final  int decimales;
@override@JsonKey() final  bool active;

/// Create a copy of Devise
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeviseCopyWith<_Devise> get copyWith => __$DeviseCopyWithImpl<_Devise>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DeviseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Devise&&(identical(other.code, code) || other.code == code)&&(identical(other.nom, nom) || other.nom == nom)&&(identical(other.symbole, symbole) || other.symbole == symbole)&&(identical(other.decimales, decimales) || other.decimales == decimales)&&(identical(other.active, active) || other.active == active));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,code,nom,symbole,decimales,active);
}

@override
String toString() {
    return 'Devise(code: $code, nom: $nom, symbole: $symbole, decimales: $decimales, active: $active)';
}


}

/// @nodoc
abstract mixin class _$DeviseCopyWith<$Res> implements $DeviseCopyWith<$Res> {
  factory _$DeviseCopyWith(_Devise value, $Res Function(_Devise) _then) = __$DeviseCopyWithImpl;
@override @useResult
$Res call({
 String code, String nom, String symbole, int decimales, bool active
});




}
/// @nodoc
class __$DeviseCopyWithImpl<$Res>
    implements _$DeviseCopyWith<$Res> {
  __$DeviseCopyWithImpl(this._self, this._then);

  final _Devise _self;
  final $Res Function(_Devise) _then;

/// Create a copy of Devise
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? nom = null,Object? symbole = null,Object? decimales = null,Object? active = null,}) {
  return _then(_Devise(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,nom: null == nom ? _self.nom : nom // ignore: cast_nullable_to_non_nullable
as String,symbole: null == symbole ? _self.symbole : symbole // ignore: cast_nullable_to_non_nullable
as String,decimales: null == decimales ? _self.decimales : decimales // ignore: cast_nullable_to_non_nullable
as int,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$Montant {

 int get montant; String? get devise;
/// Create a copy of Montant
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MontantCopyWith<Montant> get copyWith => _$MontantCopyWithImpl<Montant>(this as Montant, _$identity);

  /// Serializes this Montant to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Montant;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Montant&&(identical(other.montant, _this.montant) || other.montant == _this.montant)&&(identical(other.devise, _this.devise) || other.devise == _this.devise));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Montant;
  return Object.hash(runtimeType,_this.montant,_this.devise);
}

@override
String toString() {
  final _this = this as Montant;
  return 'Montant(montant: ${_this.montant}, devise: ${_this.devise})';
}


}

/// @nodoc
abstract mixin class $MontantCopyWith<$Res>  {
  factory $MontantCopyWith(Montant value, $Res Function(Montant) _then) = _$MontantCopyWithImpl;
@useResult
$Res call({
 int montant, String? devise
});




}
/// @nodoc
class _$MontantCopyWithImpl<$Res>
    implements $MontantCopyWith<$Res> {
  _$MontantCopyWithImpl(this._self, this._then);

  final Montant _self;
  final $Res Function(Montant) _then;

/// Create a copy of Montant
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? montant = null,Object? devise = freezed,}) {
  return _then(Montant(
montant: null == montant ? _self.montant : montant // ignore: cast_nullable_to_non_nullable
as int,devise: freezed == devise ? _self.devise : devise // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Montant].
extension MontantPatterns on Montant {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Montant value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Montant() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Montant value)  $default,){
final _that = this;
switch (_that) {
case _Montant():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Montant value)?  $default,){
final _that = this;
switch (_that) {
case _Montant() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int montant,  String? devise)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Montant() when $default != null:
return $default(_that.montant,_that.devise);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int montant,  String? devise)  $default,) {final _that = this;
switch (_that) {
case _Montant():
return $default(_that.montant,_that.devise);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int montant,  String? devise)?  $default,) {final _that = this;
switch (_that) {
case _Montant() when $default != null:
return $default(_that.montant,_that.devise);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Montant implements Montant {
  const _Montant({required this.montant, this.devise});
  factory _Montant.fromJson(Map<String, dynamic> json) => _$MontantFromJson(json);

@override final  int montant;
@override final  String? devise;

/// Create a copy of Montant
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MontantCopyWith<_Montant> get copyWith => __$MontantCopyWithImpl<_Montant>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MontantToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Montant&&(identical(other.montant, montant) || other.montant == montant)&&(identical(other.devise, devise) || other.devise == devise));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,montant,devise);
}

@override
String toString() {
    return 'Montant(montant: $montant, devise: $devise)';
}


}

/// @nodoc
abstract mixin class _$MontantCopyWith<$Res> implements $MontantCopyWith<$Res> {
  factory _$MontantCopyWith(_Montant value, $Res Function(_Montant) _then) = __$MontantCopyWithImpl;
@override @useResult
$Res call({
 int montant, String? devise
});




}
/// @nodoc
class __$MontantCopyWithImpl<$Res>
    implements _$MontantCopyWith<$Res> {
  __$MontantCopyWithImpl(this._self, this._then);

  final _Montant _self;
  final $Res Function(_Montant) _then;

/// Create a copy of Montant
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? montant = null,Object? devise = freezed,}) {
  return _then(_Montant(
montant: null == montant ? _self.montant : montant // ignore: cast_nullable_to_non_nullable
as int,devise: freezed == devise ? _self.devise : devise // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$Categorie {

 String get code; String get libelle; String get icone; bool get hotel;
/// Create a copy of Categorie
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategorieCopyWith<Categorie> get copyWith => _$CategorieCopyWithImpl<Categorie>(this as Categorie, _$identity);

  /// Serializes this Categorie to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Categorie;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Categorie&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.libelle, _this.libelle) || other.libelle == _this.libelle)&&(identical(other.icone, _this.icone) || other.icone == _this.icone)&&(identical(other.hotel, _this.hotel) || other.hotel == _this.hotel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Categorie;
  return Object.hash(runtimeType,_this.code,_this.libelle,_this.icone,_this.hotel);
}

@override
String toString() {
  final _this = this as Categorie;
  return 'Categorie(code: ${_this.code}, libelle: ${_this.libelle}, icone: ${_this.icone}, hotel: ${_this.hotel})';
}


}

/// @nodoc
abstract mixin class $CategorieCopyWith<$Res>  {
  factory $CategorieCopyWith(Categorie value, $Res Function(Categorie) _then) = _$CategorieCopyWithImpl;
@useResult
$Res call({
 String code, String libelle, String icone, bool hotel
});




}
/// @nodoc
class _$CategorieCopyWithImpl<$Res>
    implements $CategorieCopyWith<$Res> {
  _$CategorieCopyWithImpl(this._self, this._then);

  final Categorie _self;
  final $Res Function(Categorie) _then;

/// Create a copy of Categorie
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? libelle = null,Object? icone = null,Object? hotel = null,}) {
  return _then(Categorie(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,libelle: null == libelle ? _self.libelle : libelle // ignore: cast_nullable_to_non_nullable
as String,icone: null == icone ? _self.icone : icone // ignore: cast_nullable_to_non_nullable
as String,hotel: null == hotel ? _self.hotel : hotel // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Categorie].
extension CategoriePatterns on Categorie {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Categorie value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Categorie() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Categorie value)  $default,){
final _that = this;
switch (_that) {
case _Categorie():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Categorie value)?  $default,){
final _that = this;
switch (_that) {
case _Categorie() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  String libelle,  String icone,  bool hotel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Categorie() when $default != null:
return $default(_that.code,_that.libelle,_that.icone,_that.hotel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  String libelle,  String icone,  bool hotel)  $default,) {final _that = this;
switch (_that) {
case _Categorie():
return $default(_that.code,_that.libelle,_that.icone,_that.hotel);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  String libelle,  String icone,  bool hotel)?  $default,) {final _that = this;
switch (_that) {
case _Categorie() when $default != null:
return $default(_that.code,_that.libelle,_that.icone,_that.hotel);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Categorie implements Categorie {
  const _Categorie({required this.code, required this.libelle, required this.icone, this.hotel = false});
  factory _Categorie.fromJson(Map<String, dynamic> json) => _$CategorieFromJson(json);

@override final  String code;
@override final  String libelle;
@override final  String icone;
@override@JsonKey() final  bool hotel;

/// Create a copy of Categorie
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategorieCopyWith<_Categorie> get copyWith => __$CategorieCopyWithImpl<_Categorie>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CategorieToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Categorie&&(identical(other.code, code) || other.code == code)&&(identical(other.libelle, libelle) || other.libelle == libelle)&&(identical(other.icone, icone) || other.icone == icone)&&(identical(other.hotel, hotel) || other.hotel == hotel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,code,libelle,icone,hotel);
}

@override
String toString() {
    return 'Categorie(code: $code, libelle: $libelle, icone: $icone, hotel: $hotel)';
}


}

/// @nodoc
abstract mixin class _$CategorieCopyWith<$Res> implements $CategorieCopyWith<$Res> {
  factory _$CategorieCopyWith(_Categorie value, $Res Function(_Categorie) _then) = __$CategorieCopyWithImpl;
@override @useResult
$Res call({
 String code, String libelle, String icone, bool hotel
});




}
/// @nodoc
class __$CategorieCopyWithImpl<$Res>
    implements _$CategorieCopyWith<$Res> {
  __$CategorieCopyWithImpl(this._self, this._then);

  final _Categorie _self;
  final $Res Function(_Categorie) _then;

/// Create a copy of Categorie
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? libelle = null,Object? icone = null,Object? hotel = null,}) {
  return _then(_Categorie(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,libelle: null == libelle ? _self.libelle : libelle // ignore: cast_nullable_to_non_nullable
as String,icone: null == icone ? _self.icone : icone // ignore: cast_nullable_to_non_nullable
as String,hotel: null == hotel ? _self.hotel : hotel // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$EtatAbonnementUnite {

 String get etat; String? get fin;
/// Create a copy of EtatAbonnementUnite
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EtatAbonnementUniteCopyWith<EtatAbonnementUnite> get copyWith => _$EtatAbonnementUniteCopyWithImpl<EtatAbonnementUnite>(this as EtatAbonnementUnite, _$identity);

  /// Serializes this EtatAbonnementUnite to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as EtatAbonnementUnite;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EtatAbonnementUnite&&(identical(other.etat, _this.etat) || other.etat == _this.etat)&&(identical(other.fin, _this.fin) || other.fin == _this.fin));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as EtatAbonnementUnite;
  return Object.hash(runtimeType,_this.etat,_this.fin);
}

@override
String toString() {
  final _this = this as EtatAbonnementUnite;
  return 'EtatAbonnementUnite(etat: ${_this.etat}, fin: ${_this.fin})';
}


}

/// @nodoc
abstract mixin class $EtatAbonnementUniteCopyWith<$Res>  {
  factory $EtatAbonnementUniteCopyWith(EtatAbonnementUnite value, $Res Function(EtatAbonnementUnite) _then) = _$EtatAbonnementUniteCopyWithImpl;
@useResult
$Res call({
 String etat, String? fin
});




}
/// @nodoc
class _$EtatAbonnementUniteCopyWithImpl<$Res>
    implements $EtatAbonnementUniteCopyWith<$Res> {
  _$EtatAbonnementUniteCopyWithImpl(this._self, this._then);

  final EtatAbonnementUnite _self;
  final $Res Function(EtatAbonnementUnite) _then;

/// Create a copy of EtatAbonnementUnite
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? etat = null,Object? fin = freezed,}) {
  return _then(EtatAbonnementUnite(
etat: null == etat ? _self.etat : etat // ignore: cast_nullable_to_non_nullable
as String,fin: freezed == fin ? _self.fin : fin // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [EtatAbonnementUnite].
extension EtatAbonnementUnitePatterns on EtatAbonnementUnite {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EtatAbonnementUnite value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EtatAbonnementUnite() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EtatAbonnementUnite value)  $default,){
final _that = this;
switch (_that) {
case _EtatAbonnementUnite():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EtatAbonnementUnite value)?  $default,){
final _that = this;
switch (_that) {
case _EtatAbonnementUnite() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String etat,  String? fin)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EtatAbonnementUnite() when $default != null:
return $default(_that.etat,_that.fin);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String etat,  String? fin)  $default,) {final _that = this;
switch (_that) {
case _EtatAbonnementUnite():
return $default(_that.etat,_that.fin);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String etat,  String? fin)?  $default,) {final _that = this;
switch (_that) {
case _EtatAbonnementUnite() when $default != null:
return $default(_that.etat,_that.fin);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EtatAbonnementUnite implements EtatAbonnementUnite {
  const _EtatAbonnementUnite({required this.etat, this.fin});
  factory _EtatAbonnementUnite.fromJson(Map<String, dynamic> json) => _$EtatAbonnementUniteFromJson(json);

@override final  String etat;
@override final  String? fin;

/// Create a copy of EtatAbonnementUnite
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EtatAbonnementUniteCopyWith<_EtatAbonnementUnite> get copyWith => __$EtatAbonnementUniteCopyWithImpl<_EtatAbonnementUnite>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EtatAbonnementUniteToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _EtatAbonnementUnite&&(identical(other.etat, etat) || other.etat == etat)&&(identical(other.fin, fin) || other.fin == fin));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,etat,fin);
}

@override
String toString() {
    return 'EtatAbonnementUnite(etat: $etat, fin: $fin)';
}


}

/// @nodoc
abstract mixin class _$EtatAbonnementUniteCopyWith<$Res> implements $EtatAbonnementUniteCopyWith<$Res> {
  factory _$EtatAbonnementUniteCopyWith(_EtatAbonnementUnite value, $Res Function(_EtatAbonnementUnite) _then) = __$EtatAbonnementUniteCopyWithImpl;
@override @useResult
$Res call({
 String etat, String? fin
});




}
/// @nodoc
class __$EtatAbonnementUniteCopyWithImpl<$Res>
    implements _$EtatAbonnementUniteCopyWith<$Res> {
  __$EtatAbonnementUniteCopyWithImpl(this._self, this._then);

  final _EtatAbonnementUnite _self;
  final $Res Function(_EtatAbonnementUnite) _then;

/// Create a copy of EtatAbonnementUnite
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? etat = null,Object? fin = freezed,}) {
  return _then(_EtatAbonnementUnite(
etat: null == etat ? _self.etat : etat // ignore: cast_nullable_to_non_nullable
as String,fin: freezed == fin ? _self.fin : fin // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$Unite {

 int get id; String get nom; Categorie get categorie; int get proprieteId; String? get propriete; Montant? get loyerIndicatif; bool get vacante; int? get contratActifId; String? get locataire; bool get publieeMarket; String? get descriptionMarket; EtatAbonnementUnite get abonnement;
/// Create a copy of Unite
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UniteCopyWith<Unite> get copyWith => _$UniteCopyWithImpl<Unite>(this as Unite, _$identity);

  /// Serializes this Unite to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Unite;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Unite&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.nom, _this.nom) || other.nom == _this.nom)&&(identical(other.categorie, _this.categorie) || other.categorie == _this.categorie)&&(identical(other.proprieteId, _this.proprieteId) || other.proprieteId == _this.proprieteId)&&(identical(other.propriete, _this.propriete) || other.propriete == _this.propriete)&&(identical(other.loyerIndicatif, _this.loyerIndicatif) || other.loyerIndicatif == _this.loyerIndicatif)&&(identical(other.vacante, _this.vacante) || other.vacante == _this.vacante)&&(identical(other.contratActifId, _this.contratActifId) || other.contratActifId == _this.contratActifId)&&(identical(other.locataire, _this.locataire) || other.locataire == _this.locataire)&&(identical(other.publieeMarket, _this.publieeMarket) || other.publieeMarket == _this.publieeMarket)&&(identical(other.descriptionMarket, _this.descriptionMarket) || other.descriptionMarket == _this.descriptionMarket)&&(identical(other.abonnement, _this.abonnement) || other.abonnement == _this.abonnement));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Unite;
  return Object.hash(runtimeType,_this.id,_this.nom,_this.categorie,_this.proprieteId,_this.propriete,_this.loyerIndicatif,_this.vacante,_this.contratActifId,_this.locataire,_this.publieeMarket,_this.descriptionMarket,_this.abonnement);
}

@override
String toString() {
  final _this = this as Unite;
  return 'Unite(id: ${_this.id}, nom: ${_this.nom}, categorie: ${_this.categorie}, proprieteId: ${_this.proprieteId}, propriete: ${_this.propriete}, loyerIndicatif: ${_this.loyerIndicatif}, vacante: ${_this.vacante}, contratActifId: ${_this.contratActifId}, locataire: ${_this.locataire}, publieeMarket: ${_this.publieeMarket}, descriptionMarket: ${_this.descriptionMarket}, abonnement: ${_this.abonnement})';
}


}

/// @nodoc
abstract mixin class $UniteCopyWith<$Res>  {
  factory $UniteCopyWith(Unite value, $Res Function(Unite) _then) = _$UniteCopyWithImpl;
@useResult
$Res call({
 int id, String nom, Categorie categorie, int proprieteId, String? propriete, Montant? loyerIndicatif, bool vacante, int? contratActifId, String? locataire, bool publieeMarket, String? descriptionMarket, EtatAbonnementUnite abonnement
});


$CategorieCopyWith<$Res> get categorie;$MontantCopyWith<$Res>? get loyerIndicatif;$EtatAbonnementUniteCopyWith<$Res> get abonnement;

}
/// @nodoc
class _$UniteCopyWithImpl<$Res>
    implements $UniteCopyWith<$Res> {
  _$UniteCopyWithImpl(this._self, this._then);

  final Unite _self;
  final $Res Function(Unite) _then;

/// Create a copy of Unite
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? nom = null,Object? categorie = null,Object? proprieteId = null,Object? propriete = freezed,Object? loyerIndicatif = freezed,Object? vacante = null,Object? contratActifId = freezed,Object? locataire = freezed,Object? publieeMarket = null,Object? descriptionMarket = freezed,Object? abonnement = null,}) {
  return _then(Unite(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,nom: null == nom ? _self.nom : nom // ignore: cast_nullable_to_non_nullable
as String,categorie: null == categorie ? _self.categorie : categorie // ignore: cast_nullable_to_non_nullable
as Categorie,proprieteId: null == proprieteId ? _self.proprieteId : proprieteId // ignore: cast_nullable_to_non_nullable
as int,propriete: freezed == propriete ? _self.propriete : propriete // ignore: cast_nullable_to_non_nullable
as String?,loyerIndicatif: freezed == loyerIndicatif ? _self.loyerIndicatif : loyerIndicatif // ignore: cast_nullable_to_non_nullable
as Montant?,vacante: null == vacante ? _self.vacante : vacante // ignore: cast_nullable_to_non_nullable
as bool,contratActifId: freezed == contratActifId ? _self.contratActifId : contratActifId // ignore: cast_nullable_to_non_nullable
as int?,locataire: freezed == locataire ? _self.locataire : locataire // ignore: cast_nullable_to_non_nullable
as String?,publieeMarket: null == publieeMarket ? _self.publieeMarket : publieeMarket // ignore: cast_nullable_to_non_nullable
as bool,descriptionMarket: freezed == descriptionMarket ? _self.descriptionMarket : descriptionMarket // ignore: cast_nullable_to_non_nullable
as String?,abonnement: null == abonnement ? _self.abonnement : abonnement // ignore: cast_nullable_to_non_nullable
as EtatAbonnementUnite,
  ));
}
/// Create a copy of Unite
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CategorieCopyWith<$Res> get categorie {
  
  return $CategorieCopyWith<$Res>(_self.categorie, (value) {
    return _then(_self.copyWith(categorie: value));
  });
}/// Create a copy of Unite
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MontantCopyWith<$Res>? get loyerIndicatif {
    if (_self.loyerIndicatif == null) {
    return null;
  }

  return $MontantCopyWith<$Res>(_self.loyerIndicatif!, (value) {
    return _then(_self.copyWith(loyerIndicatif: value));
  });
}/// Create a copy of Unite
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EtatAbonnementUniteCopyWith<$Res> get abonnement {
  
  return $EtatAbonnementUniteCopyWith<$Res>(_self.abonnement, (value) {
    return _then(_self.copyWith(abonnement: value));
  });
}
}


/// Adds pattern-matching-related methods to [Unite].
extension UnitePatterns on Unite {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Unite value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Unite() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Unite value)  $default,){
final _that = this;
switch (_that) {
case _Unite():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Unite value)?  $default,){
final _that = this;
switch (_that) {
case _Unite() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String nom,  Categorie categorie,  int proprieteId,  String? propriete,  Montant? loyerIndicatif,  bool vacante,  int? contratActifId,  String? locataire,  bool publieeMarket,  String? descriptionMarket,  EtatAbonnementUnite abonnement)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Unite() when $default != null:
return $default(_that.id,_that.nom,_that.categorie,_that.proprieteId,_that.propriete,_that.loyerIndicatif,_that.vacante,_that.contratActifId,_that.locataire,_that.publieeMarket,_that.descriptionMarket,_that.abonnement);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String nom,  Categorie categorie,  int proprieteId,  String? propriete,  Montant? loyerIndicatif,  bool vacante,  int? contratActifId,  String? locataire,  bool publieeMarket,  String? descriptionMarket,  EtatAbonnementUnite abonnement)  $default,) {final _that = this;
switch (_that) {
case _Unite():
return $default(_that.id,_that.nom,_that.categorie,_that.proprieteId,_that.propriete,_that.loyerIndicatif,_that.vacante,_that.contratActifId,_that.locataire,_that.publieeMarket,_that.descriptionMarket,_that.abonnement);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String nom,  Categorie categorie,  int proprieteId,  String? propriete,  Montant? loyerIndicatif,  bool vacante,  int? contratActifId,  String? locataire,  bool publieeMarket,  String? descriptionMarket,  EtatAbonnementUnite abonnement)?  $default,) {final _that = this;
switch (_that) {
case _Unite() when $default != null:
return $default(_that.id,_that.nom,_that.categorie,_that.proprieteId,_that.propriete,_that.loyerIndicatif,_that.vacante,_that.contratActifId,_that.locataire,_that.publieeMarket,_that.descriptionMarket,_that.abonnement);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Unite implements Unite {
  const _Unite({required this.id, required this.nom, required this.categorie, required this.proprieteId, this.propriete, this.loyerIndicatif, required this.vacante, this.contratActifId, this.locataire, this.publieeMarket = false, this.descriptionMarket, required this.abonnement});
  factory _Unite.fromJson(Map<String, dynamic> json) => _$UniteFromJson(json);

@override final  int id;
@override final  String nom;
@override final  Categorie categorie;
@override final  int proprieteId;
@override final  String? propriete;
@override final  Montant? loyerIndicatif;
@override final  bool vacante;
@override final  int? contratActifId;
@override final  String? locataire;
@override@JsonKey() final  bool publieeMarket;
@override final  String? descriptionMarket;
@override final  EtatAbonnementUnite abonnement;

/// Create a copy of Unite
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UniteCopyWith<_Unite> get copyWith => __$UniteCopyWithImpl<_Unite>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UniteToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Unite&&(identical(other.id, id) || other.id == id)&&(identical(other.nom, nom) || other.nom == nom)&&(identical(other.categorie, categorie) || other.categorie == categorie)&&(identical(other.proprieteId, proprieteId) || other.proprieteId == proprieteId)&&(identical(other.propriete, propriete) || other.propriete == propriete)&&(identical(other.loyerIndicatif, loyerIndicatif) || other.loyerIndicatif == loyerIndicatif)&&(identical(other.vacante, vacante) || other.vacante == vacante)&&(identical(other.contratActifId, contratActifId) || other.contratActifId == contratActifId)&&(identical(other.locataire, locataire) || other.locataire == locataire)&&(identical(other.publieeMarket, publieeMarket) || other.publieeMarket == publieeMarket)&&(identical(other.descriptionMarket, descriptionMarket) || other.descriptionMarket == descriptionMarket)&&(identical(other.abonnement, abonnement) || other.abonnement == abonnement));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,nom,categorie,proprieteId,propriete,loyerIndicatif,vacante,contratActifId,locataire,publieeMarket,descriptionMarket,abonnement);
}

@override
String toString() {
    return 'Unite(id: $id, nom: $nom, categorie: $categorie, proprieteId: $proprieteId, propriete: $propriete, loyerIndicatif: $loyerIndicatif, vacante: $vacante, contratActifId: $contratActifId, locataire: $locataire, publieeMarket: $publieeMarket, descriptionMarket: $descriptionMarket, abonnement: $abonnement)';
}


}

/// @nodoc
abstract mixin class _$UniteCopyWith<$Res> implements $UniteCopyWith<$Res> {
  factory _$UniteCopyWith(_Unite value, $Res Function(_Unite) _then) = __$UniteCopyWithImpl;
@override @useResult
$Res call({
 int id, String nom, Categorie categorie, int proprieteId, String? propriete, Montant? loyerIndicatif, bool vacante, int? contratActifId, String? locataire, bool publieeMarket, String? descriptionMarket, EtatAbonnementUnite abonnement
});


@override $CategorieCopyWith<$Res> get categorie;@override $MontantCopyWith<$Res>? get loyerIndicatif;@override $EtatAbonnementUniteCopyWith<$Res> get abonnement;

}
/// @nodoc
class __$UniteCopyWithImpl<$Res>
    implements _$UniteCopyWith<$Res> {
  __$UniteCopyWithImpl(this._self, this._then);

  final _Unite _self;
  final $Res Function(_Unite) _then;

/// Create a copy of Unite
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? nom = null,Object? categorie = null,Object? proprieteId = null,Object? propriete = freezed,Object? loyerIndicatif = freezed,Object? vacante = null,Object? contratActifId = freezed,Object? locataire = freezed,Object? publieeMarket = null,Object? descriptionMarket = freezed,Object? abonnement = null,}) {
  return _then(_Unite(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,nom: null == nom ? _self.nom : nom // ignore: cast_nullable_to_non_nullable
as String,categorie: null == categorie ? _self.categorie : categorie // ignore: cast_nullable_to_non_nullable
as Categorie,proprieteId: null == proprieteId ? _self.proprieteId : proprieteId // ignore: cast_nullable_to_non_nullable
as int,propriete: freezed == propriete ? _self.propriete : propriete // ignore: cast_nullable_to_non_nullable
as String?,loyerIndicatif: freezed == loyerIndicatif ? _self.loyerIndicatif : loyerIndicatif // ignore: cast_nullable_to_non_nullable
as Montant?,vacante: null == vacante ? _self.vacante : vacante // ignore: cast_nullable_to_non_nullable
as bool,contratActifId: freezed == contratActifId ? _self.contratActifId : contratActifId // ignore: cast_nullable_to_non_nullable
as int?,locataire: freezed == locataire ? _self.locataire : locataire // ignore: cast_nullable_to_non_nullable
as String?,publieeMarket: null == publieeMarket ? _self.publieeMarket : publieeMarket // ignore: cast_nullable_to_non_nullable
as bool,descriptionMarket: freezed == descriptionMarket ? _self.descriptionMarket : descriptionMarket // ignore: cast_nullable_to_non_nullable
as String?,abonnement: null == abonnement ? _self.abonnement : abonnement // ignore: cast_nullable_to_non_nullable
as EtatAbonnementUnite,
  ));
}

/// Create a copy of Unite
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CategorieCopyWith<$Res> get categorie {
  
  return $CategorieCopyWith<$Res>(_self.categorie, (value) {
    return _then(_self.copyWith(categorie: value));
  });
}/// Create a copy of Unite
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MontantCopyWith<$Res>? get loyerIndicatif {
    if (_self.loyerIndicatif == null) {
    return null;
  }

  return $MontantCopyWith<$Res>(_self.loyerIndicatif!, (value) {
    return _then(_self.copyWith(loyerIndicatif: value));
  });
}/// Create a copy of Unite
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EtatAbonnementUniteCopyWith<$Res> get abonnement {
  
  return $EtatAbonnementUniteCopyWith<$Res>(_self.abonnement, (value) {
    return _then(_self.copyWith(abonnement: value));
  });
}
}


/// @nodoc
mixin _$Propriete {

 int get id; String get nom; String get type; String? get adresse; String? get quartier; double? get latitude; double? get longitude; int get nombreUnites; List<Unite> get unites;
/// Create a copy of Propriete
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProprieteCopyWith<Propriete> get copyWith => _$ProprieteCopyWithImpl<Propriete>(this as Propriete, _$identity);

  /// Serializes this Propriete to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Propriete;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Propriete&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.nom, _this.nom) || other.nom == _this.nom)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.adresse, _this.adresse) || other.adresse == _this.adresse)&&(identical(other.quartier, _this.quartier) || other.quartier == _this.quartier)&&(identical(other.latitude, _this.latitude) || other.latitude == _this.latitude)&&(identical(other.longitude, _this.longitude) || other.longitude == _this.longitude)&&(identical(other.nombreUnites, _this.nombreUnites) || other.nombreUnites == _this.nombreUnites)&&const DeepCollectionEquality().equals(other.unites, _this.unites));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Propriete;
  return Object.hash(runtimeType,_this.id,_this.nom,_this.type,_this.adresse,_this.quartier,_this.latitude,_this.longitude,_this.nombreUnites,const DeepCollectionEquality().hash(_this.unites));
}

@override
String toString() {
  final _this = this as Propriete;
  return 'Propriete(id: ${_this.id}, nom: ${_this.nom}, type: ${_this.type}, adresse: ${_this.adresse}, quartier: ${_this.quartier}, latitude: ${_this.latitude}, longitude: ${_this.longitude}, nombreUnites: ${_this.nombreUnites}, unites: ${_this.unites})';
}


}

/// @nodoc
abstract mixin class $ProprieteCopyWith<$Res>  {
  factory $ProprieteCopyWith(Propriete value, $Res Function(Propriete) _then) = _$ProprieteCopyWithImpl;
@useResult
$Res call({
 int id, String nom, String type, String? adresse, String? quartier, double? latitude, double? longitude, int nombreUnites, List<Unite> unites
});




}
/// @nodoc
class _$ProprieteCopyWithImpl<$Res>
    implements $ProprieteCopyWith<$Res> {
  _$ProprieteCopyWithImpl(this._self, this._then);

  final Propriete _self;
  final $Res Function(Propriete) _then;

/// Create a copy of Propriete
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? nom = null,Object? type = null,Object? adresse = freezed,Object? quartier = freezed,Object? latitude = freezed,Object? longitude = freezed,Object? nombreUnites = null,Object? unites = null,}) {
  return _then(Propriete(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,nom: null == nom ? _self.nom : nom // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,adresse: freezed == adresse ? _self.adresse : adresse // ignore: cast_nullable_to_non_nullable
as String?,quartier: freezed == quartier ? _self.quartier : quartier // ignore: cast_nullable_to_non_nullable
as String?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,nombreUnites: null == nombreUnites ? _self.nombreUnites : nombreUnites // ignore: cast_nullable_to_non_nullable
as int,unites: null == unites ? _self.unites : unites // ignore: cast_nullable_to_non_nullable
as List<Unite>,
  ));
}

}


/// Adds pattern-matching-related methods to [Propriete].
extension ProprietePatterns on Propriete {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Propriete value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Propriete() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Propriete value)  $default,){
final _that = this;
switch (_that) {
case _Propriete():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Propriete value)?  $default,){
final _that = this;
switch (_that) {
case _Propriete() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String nom,  String type,  String? adresse,  String? quartier,  double? latitude,  double? longitude,  int nombreUnites,  List<Unite> unites)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Propriete() when $default != null:
return $default(_that.id,_that.nom,_that.type,_that.adresse,_that.quartier,_that.latitude,_that.longitude,_that.nombreUnites,_that.unites);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String nom,  String type,  String? adresse,  String? quartier,  double? latitude,  double? longitude,  int nombreUnites,  List<Unite> unites)  $default,) {final _that = this;
switch (_that) {
case _Propriete():
return $default(_that.id,_that.nom,_that.type,_that.adresse,_that.quartier,_that.latitude,_that.longitude,_that.nombreUnites,_that.unites);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String nom,  String type,  String? adresse,  String? quartier,  double? latitude,  double? longitude,  int nombreUnites,  List<Unite> unites)?  $default,) {final _that = this;
switch (_that) {
case _Propriete() when $default != null:
return $default(_that.id,_that.nom,_that.type,_that.adresse,_that.quartier,_that.latitude,_that.longitude,_that.nombreUnites,_that.unites);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Propriete implements Propriete {
  const _Propriete({required this.id, required this.nom, required this.type, this.adresse, this.quartier, this.latitude, this.longitude, this.nombreUnites = 0,  List<Unite> unites = const <Unite>[]}): _unites = unites;
  factory _Propriete.fromJson(Map<String, dynamic> json) => _$ProprieteFromJson(json);

@override final  int id;
@override final  String nom;
@override final  String type;
@override final  String? adresse;
@override final  String? quartier;
@override final  double? latitude;
@override final  double? longitude;
@override@JsonKey() final  int nombreUnites;
 final  List<Unite> _unites;
@override@JsonKey() List<Unite> get unites {
  if (_unites is EqualUnmodifiableListView) return _unites;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_unites);
}


/// Create a copy of Propriete
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProprieteCopyWith<_Propriete> get copyWith => __$ProprieteCopyWithImpl<_Propriete>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProprieteToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Propriete&&(identical(other.id, id) || other.id == id)&&(identical(other.nom, nom) || other.nom == nom)&&(identical(other.type, type) || other.type == type)&&(identical(other.adresse, adresse) || other.adresse == adresse)&&(identical(other.quartier, quartier) || other.quartier == quartier)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.nombreUnites, nombreUnites) || other.nombreUnites == nombreUnites)&&const DeepCollectionEquality().equals(other.unites, _unites));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,nom,type,adresse,quartier,latitude,longitude,nombreUnites,const DeepCollectionEquality().hash(_unites));
}

@override
String toString() {
    return 'Propriete(id: $id, nom: $nom, type: $type, adresse: $adresse, quartier: $quartier, latitude: $latitude, longitude: $longitude, nombreUnites: $nombreUnites, unites: $unites)';
}


}

/// @nodoc
abstract mixin class _$ProprieteCopyWith<$Res> implements $ProprieteCopyWith<$Res> {
  factory _$ProprieteCopyWith(_Propriete value, $Res Function(_Propriete) _then) = __$ProprieteCopyWithImpl;
@override @useResult
$Res call({
 int id, String nom, String type, String? adresse, String? quartier, double? latitude, double? longitude, int nombreUnites, List<Unite> unites
});




}
/// @nodoc
class __$ProprieteCopyWithImpl<$Res>
    implements _$ProprieteCopyWith<$Res> {
  __$ProprieteCopyWithImpl(this._self, this._then);

  final _Propriete _self;
  final $Res Function(_Propriete) _then;

/// Create a copy of Propriete
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? nom = null,Object? type = null,Object? adresse = freezed,Object? quartier = freezed,Object? latitude = freezed,Object? longitude = freezed,Object? nombreUnites = null,Object? unites = null,}) {
  return _then(_Propriete(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,nom: null == nom ? _self.nom : nom // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,adresse: freezed == adresse ? _self.adresse : adresse // ignore: cast_nullable_to_non_nullable
as String?,quartier: freezed == quartier ? _self.quartier : quartier // ignore: cast_nullable_to_non_nullable
as String?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,nombreUnites: null == nombreUnites ? _self.nombreUnites : nombreUnites // ignore: cast_nullable_to_non_nullable
as int,unites: null == unites ? _self._unites : unites // ignore: cast_nullable_to_non_nullable
as List<Unite>,
  ));
}


}


/// @nodoc
mixin _$Echeance {

 int get id; String get periodeDebut; String get periodeFin; String get dateExigible; int get montantDu; int get montantPaye; int get restantDu;/// a_venir | payee | partielle | en_retard | annulee (R-22)
 String get statut;
/// Create a copy of Echeance
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EcheanceCopyWith<Echeance> get copyWith => _$EcheanceCopyWithImpl<Echeance>(this as Echeance, _$identity);

  /// Serializes this Echeance to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Echeance;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Echeance&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.periodeDebut, _this.periodeDebut) || other.periodeDebut == _this.periodeDebut)&&(identical(other.periodeFin, _this.periodeFin) || other.periodeFin == _this.periodeFin)&&(identical(other.dateExigible, _this.dateExigible) || other.dateExigible == _this.dateExigible)&&(identical(other.montantDu, _this.montantDu) || other.montantDu == _this.montantDu)&&(identical(other.montantPaye, _this.montantPaye) || other.montantPaye == _this.montantPaye)&&(identical(other.restantDu, _this.restantDu) || other.restantDu == _this.restantDu)&&(identical(other.statut, _this.statut) || other.statut == _this.statut));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Echeance;
  return Object.hash(runtimeType,_this.id,_this.periodeDebut,_this.periodeFin,_this.dateExigible,_this.montantDu,_this.montantPaye,_this.restantDu,_this.statut);
}

@override
String toString() {
  final _this = this as Echeance;
  return 'Echeance(id: ${_this.id}, periodeDebut: ${_this.periodeDebut}, periodeFin: ${_this.periodeFin}, dateExigible: ${_this.dateExigible}, montantDu: ${_this.montantDu}, montantPaye: ${_this.montantPaye}, restantDu: ${_this.restantDu}, statut: ${_this.statut})';
}


}

/// @nodoc
abstract mixin class $EcheanceCopyWith<$Res>  {
  factory $EcheanceCopyWith(Echeance value, $Res Function(Echeance) _then) = _$EcheanceCopyWithImpl;
@useResult
$Res call({
 int id, String periodeDebut, String periodeFin, String dateExigible, int montantDu, int montantPaye, int restantDu, String statut
});




}
/// @nodoc
class _$EcheanceCopyWithImpl<$Res>
    implements $EcheanceCopyWith<$Res> {
  _$EcheanceCopyWithImpl(this._self, this._then);

  final Echeance _self;
  final $Res Function(Echeance) _then;

/// Create a copy of Echeance
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? periodeDebut = null,Object? periodeFin = null,Object? dateExigible = null,Object? montantDu = null,Object? montantPaye = null,Object? restantDu = null,Object? statut = null,}) {
  return _then(Echeance(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,periodeDebut: null == periodeDebut ? _self.periodeDebut : periodeDebut // ignore: cast_nullable_to_non_nullable
as String,periodeFin: null == periodeFin ? _self.periodeFin : periodeFin // ignore: cast_nullable_to_non_nullable
as String,dateExigible: null == dateExigible ? _self.dateExigible : dateExigible // ignore: cast_nullable_to_non_nullable
as String,montantDu: null == montantDu ? _self.montantDu : montantDu // ignore: cast_nullable_to_non_nullable
as int,montantPaye: null == montantPaye ? _self.montantPaye : montantPaye // ignore: cast_nullable_to_non_nullable
as int,restantDu: null == restantDu ? _self.restantDu : restantDu // ignore: cast_nullable_to_non_nullable
as int,statut: null == statut ? _self.statut : statut // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Echeance].
extension EcheancePatterns on Echeance {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Echeance value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Echeance() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Echeance value)  $default,){
final _that = this;
switch (_that) {
case _Echeance():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Echeance value)?  $default,){
final _that = this;
switch (_that) {
case _Echeance() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String periodeDebut,  String periodeFin,  String dateExigible,  int montantDu,  int montantPaye,  int restantDu,  String statut)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Echeance() when $default != null:
return $default(_that.id,_that.periodeDebut,_that.periodeFin,_that.dateExigible,_that.montantDu,_that.montantPaye,_that.restantDu,_that.statut);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String periodeDebut,  String periodeFin,  String dateExigible,  int montantDu,  int montantPaye,  int restantDu,  String statut)  $default,) {final _that = this;
switch (_that) {
case _Echeance():
return $default(_that.id,_that.periodeDebut,_that.periodeFin,_that.dateExigible,_that.montantDu,_that.montantPaye,_that.restantDu,_that.statut);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String periodeDebut,  String periodeFin,  String dateExigible,  int montantDu,  int montantPaye,  int restantDu,  String statut)?  $default,) {final _that = this;
switch (_that) {
case _Echeance() when $default != null:
return $default(_that.id,_that.periodeDebut,_that.periodeFin,_that.dateExigible,_that.montantDu,_that.montantPaye,_that.restantDu,_that.statut);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Echeance implements Echeance {
  const _Echeance({required this.id, required this.periodeDebut, required this.periodeFin, required this.dateExigible, required this.montantDu, required this.montantPaye, required this.restantDu, required this.statut});
  factory _Echeance.fromJson(Map<String, dynamic> json) => _$EcheanceFromJson(json);

@override final  int id;
@override final  String periodeDebut;
@override final  String periodeFin;
@override final  String dateExigible;
@override final  int montantDu;
@override final  int montantPaye;
@override final  int restantDu;
/// a_venir | payee | partielle | en_retard | annulee (R-22)
@override final  String statut;

/// Create a copy of Echeance
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EcheanceCopyWith<_Echeance> get copyWith => __$EcheanceCopyWithImpl<_Echeance>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EcheanceToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Echeance&&(identical(other.id, id) || other.id == id)&&(identical(other.periodeDebut, periodeDebut) || other.periodeDebut == periodeDebut)&&(identical(other.periodeFin, periodeFin) || other.periodeFin == periodeFin)&&(identical(other.dateExigible, dateExigible) || other.dateExigible == dateExigible)&&(identical(other.montantDu, montantDu) || other.montantDu == montantDu)&&(identical(other.montantPaye, montantPaye) || other.montantPaye == montantPaye)&&(identical(other.restantDu, restantDu) || other.restantDu == restantDu)&&(identical(other.statut, statut) || other.statut == statut));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,periodeDebut,periodeFin,dateExigible,montantDu,montantPaye,restantDu,statut);
}

@override
String toString() {
    return 'Echeance(id: $id, periodeDebut: $periodeDebut, periodeFin: $periodeFin, dateExigible: $dateExigible, montantDu: $montantDu, montantPaye: $montantPaye, restantDu: $restantDu, statut: $statut)';
}


}

/// @nodoc
abstract mixin class _$EcheanceCopyWith<$Res> implements $EcheanceCopyWith<$Res> {
  factory _$EcheanceCopyWith(_Echeance value, $Res Function(_Echeance) _then) = __$EcheanceCopyWithImpl;
@override @useResult
$Res call({
 int id, String periodeDebut, String periodeFin, String dateExigible, int montantDu, int montantPaye, int restantDu, String statut
});




}
/// @nodoc
class __$EcheanceCopyWithImpl<$Res>
    implements _$EcheanceCopyWith<$Res> {
  __$EcheanceCopyWithImpl(this._self, this._then);

  final _Echeance _self;
  final $Res Function(_Echeance) _then;

/// Create a copy of Echeance
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? periodeDebut = null,Object? periodeFin = null,Object? dateExigible = null,Object? montantDu = null,Object? montantPaye = null,Object? restantDu = null,Object? statut = null,}) {
  return _then(_Echeance(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,periodeDebut: null == periodeDebut ? _self.periodeDebut : periodeDebut // ignore: cast_nullable_to_non_nullable
as String,periodeFin: null == periodeFin ? _self.periodeFin : periodeFin // ignore: cast_nullable_to_non_nullable
as String,dateExigible: null == dateExigible ? _self.dateExigible : dateExigible // ignore: cast_nullable_to_non_nullable
as String,montantDu: null == montantDu ? _self.montantDu : montantDu // ignore: cast_nullable_to_non_nullable
as int,montantPaye: null == montantPaye ? _self.montantPaye : montantPaye // ignore: cast_nullable_to_non_nullable
as int,restantDu: null == restantDu ? _self.restantDu : restantDu // ignore: cast_nullable_to_non_nullable
as int,statut: null == statut ? _self.statut : statut // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$Recu {

 int get id; String get numero; bool get annule; String get lien; String get messagePartage;
/// Create a copy of Recu
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecuCopyWith<Recu> get copyWith => _$RecuCopyWithImpl<Recu>(this as Recu, _$identity);

  /// Serializes this Recu to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Recu;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Recu&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.numero, _this.numero) || other.numero == _this.numero)&&(identical(other.annule, _this.annule) || other.annule == _this.annule)&&(identical(other.lien, _this.lien) || other.lien == _this.lien)&&(identical(other.messagePartage, _this.messagePartage) || other.messagePartage == _this.messagePartage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Recu;
  return Object.hash(runtimeType,_this.id,_this.numero,_this.annule,_this.lien,_this.messagePartage);
}

@override
String toString() {
  final _this = this as Recu;
  return 'Recu(id: ${_this.id}, numero: ${_this.numero}, annule: ${_this.annule}, lien: ${_this.lien}, messagePartage: ${_this.messagePartage})';
}


}

/// @nodoc
abstract mixin class $RecuCopyWith<$Res>  {
  factory $RecuCopyWith(Recu value, $Res Function(Recu) _then) = _$RecuCopyWithImpl;
@useResult
$Res call({
 int id, String numero, bool annule, String lien, String messagePartage
});




}
/// @nodoc
class _$RecuCopyWithImpl<$Res>
    implements $RecuCopyWith<$Res> {
  _$RecuCopyWithImpl(this._self, this._then);

  final Recu _self;
  final $Res Function(Recu) _then;

/// Create a copy of Recu
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? numero = null,Object? annule = null,Object? lien = null,Object? messagePartage = null,}) {
  return _then(Recu(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,numero: null == numero ? _self.numero : numero // ignore: cast_nullable_to_non_nullable
as String,annule: null == annule ? _self.annule : annule // ignore: cast_nullable_to_non_nullable
as bool,lien: null == lien ? _self.lien : lien // ignore: cast_nullable_to_non_nullable
as String,messagePartage: null == messagePartage ? _self.messagePartage : messagePartage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Recu].
extension RecuPatterns on Recu {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Recu value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Recu() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Recu value)  $default,){
final _that = this;
switch (_that) {
case _Recu():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Recu value)?  $default,){
final _that = this;
switch (_that) {
case _Recu() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String numero,  bool annule,  String lien,  String messagePartage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Recu() when $default != null:
return $default(_that.id,_that.numero,_that.annule,_that.lien,_that.messagePartage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String numero,  bool annule,  String lien,  String messagePartage)  $default,) {final _that = this;
switch (_that) {
case _Recu():
return $default(_that.id,_that.numero,_that.annule,_that.lien,_that.messagePartage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String numero,  bool annule,  String lien,  String messagePartage)?  $default,) {final _that = this;
switch (_that) {
case _Recu() when $default != null:
return $default(_that.id,_that.numero,_that.annule,_that.lien,_that.messagePartage);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Recu implements Recu {
  const _Recu({required this.id, required this.numero, required this.annule, required this.lien, this.messagePartage = ''});
  factory _Recu.fromJson(Map<String, dynamic> json) => _$RecuFromJson(json);

@override final  int id;
@override final  String numero;
@override final  bool annule;
@override final  String lien;
@override@JsonKey() final  String messagePartage;

/// Create a copy of Recu
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecuCopyWith<_Recu> get copyWith => __$RecuCopyWithImpl<_Recu>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RecuToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Recu&&(identical(other.id, id) || other.id == id)&&(identical(other.numero, numero) || other.numero == numero)&&(identical(other.annule, annule) || other.annule == annule)&&(identical(other.lien, lien) || other.lien == lien)&&(identical(other.messagePartage, messagePartage) || other.messagePartage == messagePartage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,numero,annule,lien,messagePartage);
}

@override
String toString() {
    return 'Recu(id: $id, numero: $numero, annule: $annule, lien: $lien, messagePartage: $messagePartage)';
}


}

/// @nodoc
abstract mixin class _$RecuCopyWith<$Res> implements $RecuCopyWith<$Res> {
  factory _$RecuCopyWith(_Recu value, $Res Function(_Recu) _then) = __$RecuCopyWithImpl;
@override @useResult
$Res call({
 int id, String numero, bool annule, String lien, String messagePartage
});




}
/// @nodoc
class __$RecuCopyWithImpl<$Res>
    implements _$RecuCopyWith<$Res> {
  __$RecuCopyWithImpl(this._self, this._then);

  final _Recu _self;
  final $Res Function(_Recu) _then;

/// Create a copy of Recu
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? numero = null,Object? annule = null,Object? lien = null,Object? messagePartage = null,}) {
  return _then(_Recu(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,numero: null == numero ? _self.numero : numero // ignore: cast_nullable_to_non_nullable
as String,annule: null == annule ? _self.annule : annule // ignore: cast_nullable_to_non_nullable
as bool,lien: null == lien ? _self.lien : lien // ignore: cast_nullable_to_non_nullable
as String,messagePartage: null == messagePartage ? _self.messagePartage : messagePartage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$Paiement {

 int get id; int get contratId; String get type; int get montant; String get devise; String get datePaiement; String get moyen; String? get reference; String get statut; String? get motifAnnulation; String get cleIdempotence; String get saisiPar; String get locataire; String get unite; Recu? get recu;
/// Create a copy of Paiement
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaiementCopyWith<Paiement> get copyWith => _$PaiementCopyWithImpl<Paiement>(this as Paiement, _$identity);

  /// Serializes this Paiement to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Paiement;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Paiement&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.contratId, _this.contratId) || other.contratId == _this.contratId)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.montant, _this.montant) || other.montant == _this.montant)&&(identical(other.devise, _this.devise) || other.devise == _this.devise)&&(identical(other.datePaiement, _this.datePaiement) || other.datePaiement == _this.datePaiement)&&(identical(other.moyen, _this.moyen) || other.moyen == _this.moyen)&&(identical(other.reference, _this.reference) || other.reference == _this.reference)&&(identical(other.statut, _this.statut) || other.statut == _this.statut)&&(identical(other.motifAnnulation, _this.motifAnnulation) || other.motifAnnulation == _this.motifAnnulation)&&(identical(other.cleIdempotence, _this.cleIdempotence) || other.cleIdempotence == _this.cleIdempotence)&&(identical(other.saisiPar, _this.saisiPar) || other.saisiPar == _this.saisiPar)&&(identical(other.locataire, _this.locataire) || other.locataire == _this.locataire)&&(identical(other.unite, _this.unite) || other.unite == _this.unite)&&(identical(other.recu, _this.recu) || other.recu == _this.recu));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Paiement;
  return Object.hash(runtimeType,_this.id,_this.contratId,_this.type,_this.montant,_this.devise,_this.datePaiement,_this.moyen,_this.reference,_this.statut,_this.motifAnnulation,_this.cleIdempotence,_this.saisiPar,_this.locataire,_this.unite,_this.recu);
}

@override
String toString() {
  final _this = this as Paiement;
  return 'Paiement(id: ${_this.id}, contratId: ${_this.contratId}, type: ${_this.type}, montant: ${_this.montant}, devise: ${_this.devise}, datePaiement: ${_this.datePaiement}, moyen: ${_this.moyen}, reference: ${_this.reference}, statut: ${_this.statut}, motifAnnulation: ${_this.motifAnnulation}, cleIdempotence: ${_this.cleIdempotence}, saisiPar: ${_this.saisiPar}, locataire: ${_this.locataire}, unite: ${_this.unite}, recu: ${_this.recu})';
}


}

/// @nodoc
abstract mixin class $PaiementCopyWith<$Res>  {
  factory $PaiementCopyWith(Paiement value, $Res Function(Paiement) _then) = _$PaiementCopyWithImpl;
@useResult
$Res call({
 int id, int contratId, String type, int montant, String devise, String datePaiement, String moyen, String? reference, String statut, String? motifAnnulation, String cleIdempotence, String saisiPar, String locataire, String unite, Recu? recu
});


$RecuCopyWith<$Res>? get recu;

}
/// @nodoc
class _$PaiementCopyWithImpl<$Res>
    implements $PaiementCopyWith<$Res> {
  _$PaiementCopyWithImpl(this._self, this._then);

  final Paiement _self;
  final $Res Function(Paiement) _then;

/// Create a copy of Paiement
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? contratId = null,Object? type = null,Object? montant = null,Object? devise = null,Object? datePaiement = null,Object? moyen = null,Object? reference = freezed,Object? statut = null,Object? motifAnnulation = freezed,Object? cleIdempotence = null,Object? saisiPar = null,Object? locataire = null,Object? unite = null,Object? recu = freezed,}) {
  return _then(Paiement(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,contratId: null == contratId ? _self.contratId : contratId // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,montant: null == montant ? _self.montant : montant // ignore: cast_nullable_to_non_nullable
as int,devise: null == devise ? _self.devise : devise // ignore: cast_nullable_to_non_nullable
as String,datePaiement: null == datePaiement ? _self.datePaiement : datePaiement // ignore: cast_nullable_to_non_nullable
as String,moyen: null == moyen ? _self.moyen : moyen // ignore: cast_nullable_to_non_nullable
as String,reference: freezed == reference ? _self.reference : reference // ignore: cast_nullable_to_non_nullable
as String?,statut: null == statut ? _self.statut : statut // ignore: cast_nullable_to_non_nullable
as String,motifAnnulation: freezed == motifAnnulation ? _self.motifAnnulation : motifAnnulation // ignore: cast_nullable_to_non_nullable
as String?,cleIdempotence: null == cleIdempotence ? _self.cleIdempotence : cleIdempotence // ignore: cast_nullable_to_non_nullable
as String,saisiPar: null == saisiPar ? _self.saisiPar : saisiPar // ignore: cast_nullable_to_non_nullable
as String,locataire: null == locataire ? _self.locataire : locataire // ignore: cast_nullable_to_non_nullable
as String,unite: null == unite ? _self.unite : unite // ignore: cast_nullable_to_non_nullable
as String,recu: freezed == recu ? _self.recu : recu // ignore: cast_nullable_to_non_nullable
as Recu?,
  ));
}
/// Create a copy of Paiement
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RecuCopyWith<$Res>? get recu {
    if (_self.recu == null) {
    return null;
  }

  return $RecuCopyWith<$Res>(_self.recu!, (value) {
    return _then(_self.copyWith(recu: value));
  });
}
}


/// Adds pattern-matching-related methods to [Paiement].
extension PaiementPatterns on Paiement {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Paiement value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Paiement() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Paiement value)  $default,){
final _that = this;
switch (_that) {
case _Paiement():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Paiement value)?  $default,){
final _that = this;
switch (_that) {
case _Paiement() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int contratId,  String type,  int montant,  String devise,  String datePaiement,  String moyen,  String? reference,  String statut,  String? motifAnnulation,  String cleIdempotence,  String saisiPar,  String locataire,  String unite,  Recu? recu)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Paiement() when $default != null:
return $default(_that.id,_that.contratId,_that.type,_that.montant,_that.devise,_that.datePaiement,_that.moyen,_that.reference,_that.statut,_that.motifAnnulation,_that.cleIdempotence,_that.saisiPar,_that.locataire,_that.unite,_that.recu);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int contratId,  String type,  int montant,  String devise,  String datePaiement,  String moyen,  String? reference,  String statut,  String? motifAnnulation,  String cleIdempotence,  String saisiPar,  String locataire,  String unite,  Recu? recu)  $default,) {final _that = this;
switch (_that) {
case _Paiement():
return $default(_that.id,_that.contratId,_that.type,_that.montant,_that.devise,_that.datePaiement,_that.moyen,_that.reference,_that.statut,_that.motifAnnulation,_that.cleIdempotence,_that.saisiPar,_that.locataire,_that.unite,_that.recu);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int contratId,  String type,  int montant,  String devise,  String datePaiement,  String moyen,  String? reference,  String statut,  String? motifAnnulation,  String cleIdempotence,  String saisiPar,  String locataire,  String unite,  Recu? recu)?  $default,) {final _that = this;
switch (_that) {
case _Paiement() when $default != null:
return $default(_that.id,_that.contratId,_that.type,_that.montant,_that.devise,_that.datePaiement,_that.moyen,_that.reference,_that.statut,_that.motifAnnulation,_that.cleIdempotence,_that.saisiPar,_that.locataire,_that.unite,_that.recu);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Paiement implements Paiement {
  const _Paiement({required this.id, required this.contratId, required this.type, required this.montant, required this.devise, required this.datePaiement, required this.moyen, this.reference, required this.statut, this.motifAnnulation, required this.cleIdempotence, this.saisiPar = '', this.locataire = '', this.unite = '', this.recu});
  factory _Paiement.fromJson(Map<String, dynamic> json) => _$PaiementFromJson(json);

@override final  int id;
@override final  int contratId;
@override final  String type;
@override final  int montant;
@override final  String devise;
@override final  String datePaiement;
@override final  String moyen;
@override final  String? reference;
@override final  String statut;
@override final  String? motifAnnulation;
@override final  String cleIdempotence;
@override@JsonKey() final  String saisiPar;
@override@JsonKey() final  String locataire;
@override@JsonKey() final  String unite;
@override final  Recu? recu;

/// Create a copy of Paiement
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaiementCopyWith<_Paiement> get copyWith => __$PaiementCopyWithImpl<_Paiement>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaiementToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Paiement&&(identical(other.id, id) || other.id == id)&&(identical(other.contratId, contratId) || other.contratId == contratId)&&(identical(other.type, type) || other.type == type)&&(identical(other.montant, montant) || other.montant == montant)&&(identical(other.devise, devise) || other.devise == devise)&&(identical(other.datePaiement, datePaiement) || other.datePaiement == datePaiement)&&(identical(other.moyen, moyen) || other.moyen == moyen)&&(identical(other.reference, reference) || other.reference == reference)&&(identical(other.statut, statut) || other.statut == statut)&&(identical(other.motifAnnulation, motifAnnulation) || other.motifAnnulation == motifAnnulation)&&(identical(other.cleIdempotence, cleIdempotence) || other.cleIdempotence == cleIdempotence)&&(identical(other.saisiPar, saisiPar) || other.saisiPar == saisiPar)&&(identical(other.locataire, locataire) || other.locataire == locataire)&&(identical(other.unite, unite) || other.unite == unite)&&(identical(other.recu, recu) || other.recu == recu));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,contratId,type,montant,devise,datePaiement,moyen,reference,statut,motifAnnulation,cleIdempotence,saisiPar,locataire,unite,recu);
}

@override
String toString() {
    return 'Paiement(id: $id, contratId: $contratId, type: $type, montant: $montant, devise: $devise, datePaiement: $datePaiement, moyen: $moyen, reference: $reference, statut: $statut, motifAnnulation: $motifAnnulation, cleIdempotence: $cleIdempotence, saisiPar: $saisiPar, locataire: $locataire, unite: $unite, recu: $recu)';
}


}

/// @nodoc
abstract mixin class _$PaiementCopyWith<$Res> implements $PaiementCopyWith<$Res> {
  factory _$PaiementCopyWith(_Paiement value, $Res Function(_Paiement) _then) = __$PaiementCopyWithImpl;
@override @useResult
$Res call({
 int id, int contratId, String type, int montant, String devise, String datePaiement, String moyen, String? reference, String statut, String? motifAnnulation, String cleIdempotence, String saisiPar, String locataire, String unite, Recu? recu
});


@override $RecuCopyWith<$Res>? get recu;

}
/// @nodoc
class __$PaiementCopyWithImpl<$Res>
    implements _$PaiementCopyWith<$Res> {
  __$PaiementCopyWithImpl(this._self, this._then);

  final _Paiement _self;
  final $Res Function(_Paiement) _then;

/// Create a copy of Paiement
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? contratId = null,Object? type = null,Object? montant = null,Object? devise = null,Object? datePaiement = null,Object? moyen = null,Object? reference = freezed,Object? statut = null,Object? motifAnnulation = freezed,Object? cleIdempotence = null,Object? saisiPar = null,Object? locataire = null,Object? unite = null,Object? recu = freezed,}) {
  return _then(_Paiement(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,contratId: null == contratId ? _self.contratId : contratId // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,montant: null == montant ? _self.montant : montant // ignore: cast_nullable_to_non_nullable
as int,devise: null == devise ? _self.devise : devise // ignore: cast_nullable_to_non_nullable
as String,datePaiement: null == datePaiement ? _self.datePaiement : datePaiement // ignore: cast_nullable_to_non_nullable
as String,moyen: null == moyen ? _self.moyen : moyen // ignore: cast_nullable_to_non_nullable
as String,reference: freezed == reference ? _self.reference : reference // ignore: cast_nullable_to_non_nullable
as String?,statut: null == statut ? _self.statut : statut // ignore: cast_nullable_to_non_nullable
as String,motifAnnulation: freezed == motifAnnulation ? _self.motifAnnulation : motifAnnulation // ignore: cast_nullable_to_non_nullable
as String?,cleIdempotence: null == cleIdempotence ? _self.cleIdempotence : cleIdempotence // ignore: cast_nullable_to_non_nullable
as String,saisiPar: null == saisiPar ? _self.saisiPar : saisiPar // ignore: cast_nullable_to_non_nullable
as String,locataire: null == locataire ? _self.locataire : locataire // ignore: cast_nullable_to_non_nullable
as String,unite: null == unite ? _self.unite : unite // ignore: cast_nullable_to_non_nullable
as String,recu: freezed == recu ? _self.recu : recu // ignore: cast_nullable_to_non_nullable
as Recu?,
  ));
}

/// Create a copy of Paiement
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RecuCopyWith<$Res>? get recu {
    if (_self.recu == null) {
    return null;
  }

  return $RecuCopyWith<$Res>(_self.recu!, (value) {
    return _then(_self.copyWith(recu: value));
  });
}
}


/// @nodoc
mixin _$ContactLocataire {

 int get id; String get nom; String? get telephone; bool get inscrit;
/// Create a copy of ContactLocataire
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContactLocataireCopyWith<ContactLocataire> get copyWith => _$ContactLocataireCopyWithImpl<ContactLocataire>(this as ContactLocataire, _$identity);

  /// Serializes this ContactLocataire to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ContactLocataire;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContactLocataire&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.nom, _this.nom) || other.nom == _this.nom)&&(identical(other.telephone, _this.telephone) || other.telephone == _this.telephone)&&(identical(other.inscrit, _this.inscrit) || other.inscrit == _this.inscrit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ContactLocataire;
  return Object.hash(runtimeType,_this.id,_this.nom,_this.telephone,_this.inscrit);
}

@override
String toString() {
  final _this = this as ContactLocataire;
  return 'ContactLocataire(id: ${_this.id}, nom: ${_this.nom}, telephone: ${_this.telephone}, inscrit: ${_this.inscrit})';
}


}

/// @nodoc
abstract mixin class $ContactLocataireCopyWith<$Res>  {
  factory $ContactLocataireCopyWith(ContactLocataire value, $Res Function(ContactLocataire) _then) = _$ContactLocataireCopyWithImpl;
@useResult
$Res call({
 int id, String nom, String? telephone, bool inscrit
});




}
/// @nodoc
class _$ContactLocataireCopyWithImpl<$Res>
    implements $ContactLocataireCopyWith<$Res> {
  _$ContactLocataireCopyWithImpl(this._self, this._then);

  final ContactLocataire _self;
  final $Res Function(ContactLocataire) _then;

/// Create a copy of ContactLocataire
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? nom = null,Object? telephone = freezed,Object? inscrit = null,}) {
  return _then(ContactLocataire(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,nom: null == nom ? _self.nom : nom // ignore: cast_nullable_to_non_nullable
as String,telephone: freezed == telephone ? _self.telephone : telephone // ignore: cast_nullable_to_non_nullable
as String?,inscrit: null == inscrit ? _self.inscrit : inscrit // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ContactLocataire].
extension ContactLocatairePatterns on ContactLocataire {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ContactLocataire value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ContactLocataire() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ContactLocataire value)  $default,){
final _that = this;
switch (_that) {
case _ContactLocataire():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ContactLocataire value)?  $default,){
final _that = this;
switch (_that) {
case _ContactLocataire() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String nom,  String? telephone,  bool inscrit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ContactLocataire() when $default != null:
return $default(_that.id,_that.nom,_that.telephone,_that.inscrit);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String nom,  String? telephone,  bool inscrit)  $default,) {final _that = this;
switch (_that) {
case _ContactLocataire():
return $default(_that.id,_that.nom,_that.telephone,_that.inscrit);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String nom,  String? telephone,  bool inscrit)?  $default,) {final _that = this;
switch (_that) {
case _ContactLocataire() when $default != null:
return $default(_that.id,_that.nom,_that.telephone,_that.inscrit);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ContactLocataire implements ContactLocataire {
  const _ContactLocataire({required this.id, required this.nom, this.telephone, this.inscrit = false});
  factory _ContactLocataire.fromJson(Map<String, dynamic> json) => _$ContactLocataireFromJson(json);

@override final  int id;
@override final  String nom;
@override final  String? telephone;
@override@JsonKey() final  bool inscrit;

/// Create a copy of ContactLocataire
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContactLocataireCopyWith<_ContactLocataire> get copyWith => __$ContactLocataireCopyWithImpl<_ContactLocataire>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ContactLocataireToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ContactLocataire&&(identical(other.id, id) || other.id == id)&&(identical(other.nom, nom) || other.nom == nom)&&(identical(other.telephone, telephone) || other.telephone == telephone)&&(identical(other.inscrit, inscrit) || other.inscrit == inscrit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,nom,telephone,inscrit);
}

@override
String toString() {
    return 'ContactLocataire(id: $id, nom: $nom, telephone: $telephone, inscrit: $inscrit)';
}


}

/// @nodoc
abstract mixin class _$ContactLocataireCopyWith<$Res> implements $ContactLocataireCopyWith<$Res> {
  factory _$ContactLocataireCopyWith(_ContactLocataire value, $Res Function(_ContactLocataire) _then) = __$ContactLocataireCopyWithImpl;
@override @useResult
$Res call({
 int id, String nom, String? telephone, bool inscrit
});




}
/// @nodoc
class __$ContactLocataireCopyWithImpl<$Res>
    implements _$ContactLocataireCopyWith<$Res> {
  __$ContactLocataireCopyWithImpl(this._self, this._then);

  final _ContactLocataire _self;
  final $Res Function(_ContactLocataire) _then;

/// Create a copy of ContactLocataire
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? nom = null,Object? telephone = freezed,Object? inscrit = null,}) {
  return _then(_ContactLocataire(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,nom: null == nom ? _self.nom : nom // ignore: cast_nullable_to_non_nullable
as String,telephone: freezed == telephone ? _self.telephone : telephone // ignore: cast_nullable_to_non_nullable
as String?,inscrit: null == inscrit ? _self.inscrit : inscrit // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$UniteContrat {

 int get id; String get nom; String get propriete; Categorie get categorie;
/// Create a copy of UniteContrat
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UniteContratCopyWith<UniteContrat> get copyWith => _$UniteContratCopyWithImpl<UniteContrat>(this as UniteContrat, _$identity);

  /// Serializes this UniteContrat to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as UniteContrat;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UniteContrat&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.nom, _this.nom) || other.nom == _this.nom)&&(identical(other.propriete, _this.propriete) || other.propriete == _this.propriete)&&(identical(other.categorie, _this.categorie) || other.categorie == _this.categorie));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as UniteContrat;
  return Object.hash(runtimeType,_this.id,_this.nom,_this.propriete,_this.categorie);
}

@override
String toString() {
  final _this = this as UniteContrat;
  return 'UniteContrat(id: ${_this.id}, nom: ${_this.nom}, propriete: ${_this.propriete}, categorie: ${_this.categorie})';
}


}

/// @nodoc
abstract mixin class $UniteContratCopyWith<$Res>  {
  factory $UniteContratCopyWith(UniteContrat value, $Res Function(UniteContrat) _then) = _$UniteContratCopyWithImpl;
@useResult
$Res call({
 int id, String nom, String propriete, Categorie categorie
});


$CategorieCopyWith<$Res> get categorie;

}
/// @nodoc
class _$UniteContratCopyWithImpl<$Res>
    implements $UniteContratCopyWith<$Res> {
  _$UniteContratCopyWithImpl(this._self, this._then);

  final UniteContrat _self;
  final $Res Function(UniteContrat) _then;

/// Create a copy of UniteContrat
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? nom = null,Object? propriete = null,Object? categorie = null,}) {
  return _then(UniteContrat(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,nom: null == nom ? _self.nom : nom // ignore: cast_nullable_to_non_nullable
as String,propriete: null == propriete ? _self.propriete : propriete // ignore: cast_nullable_to_non_nullable
as String,categorie: null == categorie ? _self.categorie : categorie // ignore: cast_nullable_to_non_nullable
as Categorie,
  ));
}
/// Create a copy of UniteContrat
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CategorieCopyWith<$Res> get categorie {
  
  return $CategorieCopyWith<$Res>(_self.categorie, (value) {
    return _then(_self.copyWith(categorie: value));
  });
}
}


/// Adds pattern-matching-related methods to [UniteContrat].
extension UniteContratPatterns on UniteContrat {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UniteContrat value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UniteContrat() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UniteContrat value)  $default,){
final _that = this;
switch (_that) {
case _UniteContrat():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UniteContrat value)?  $default,){
final _that = this;
switch (_that) {
case _UniteContrat() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String nom,  String propriete,  Categorie categorie)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UniteContrat() when $default != null:
return $default(_that.id,_that.nom,_that.propriete,_that.categorie);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String nom,  String propriete,  Categorie categorie)  $default,) {final _that = this;
switch (_that) {
case _UniteContrat():
return $default(_that.id,_that.nom,_that.propriete,_that.categorie);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String nom,  String propriete,  Categorie categorie)?  $default,) {final _that = this;
switch (_that) {
case _UniteContrat() when $default != null:
return $default(_that.id,_that.nom,_that.propriete,_that.categorie);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UniteContrat implements UniteContrat {
  const _UniteContrat({required this.id, required this.nom, required this.propriete, required this.categorie});
  factory _UniteContrat.fromJson(Map<String, dynamic> json) => _$UniteContratFromJson(json);

@override final  int id;
@override final  String nom;
@override final  String propriete;
@override final  Categorie categorie;

/// Create a copy of UniteContrat
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UniteContratCopyWith<_UniteContrat> get copyWith => __$UniteContratCopyWithImpl<_UniteContrat>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UniteContratToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UniteContrat&&(identical(other.id, id) || other.id == id)&&(identical(other.nom, nom) || other.nom == nom)&&(identical(other.propriete, propriete) || other.propriete == propriete)&&(identical(other.categorie, categorie) || other.categorie == categorie));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,nom,propriete,categorie);
}

@override
String toString() {
    return 'UniteContrat(id: $id, nom: $nom, propriete: $propriete, categorie: $categorie)';
}


}

/// @nodoc
abstract mixin class _$UniteContratCopyWith<$Res> implements $UniteContratCopyWith<$Res> {
  factory _$UniteContratCopyWith(_UniteContrat value, $Res Function(_UniteContrat) _then) = __$UniteContratCopyWithImpl;
@override @useResult
$Res call({
 int id, String nom, String propriete, Categorie categorie
});


@override $CategorieCopyWith<$Res> get categorie;

}
/// @nodoc
class __$UniteContratCopyWithImpl<$Res>
    implements _$UniteContratCopyWith<$Res> {
  __$UniteContratCopyWithImpl(this._self, this._then);

  final _UniteContrat _self;
  final $Res Function(_UniteContrat) _then;

/// Create a copy of UniteContrat
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? nom = null,Object? propriete = null,Object? categorie = null,}) {
  return _then(_UniteContrat(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,nom: null == nom ? _self.nom : nom // ignore: cast_nullable_to_non_nullable
as String,propriete: null == propriete ? _self.propriete : propriete // ignore: cast_nullable_to_non_nullable
as String,categorie: null == categorie ? _self.categorie : categorie // ignore: cast_nullable_to_non_nullable
as Categorie,
  ));
}

/// Create a copy of UniteContrat
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CategorieCopyWith<$Res> get categorie {
  
  return $CategorieCopyWith<$Res>(_self.categorie, (value) {
    return _then(_self.copyWith(categorie: value));
  });
}
}


/// @nodoc
mixin _$BailleurContrat {

 String get nom; String? get badge; String? get telephone;
/// Create a copy of BailleurContrat
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BailleurContratCopyWith<BailleurContrat> get copyWith => _$BailleurContratCopyWithImpl<BailleurContrat>(this as BailleurContrat, _$identity);

  /// Serializes this BailleurContrat to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as BailleurContrat;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BailleurContrat&&(identical(other.nom, _this.nom) || other.nom == _this.nom)&&(identical(other.badge, _this.badge) || other.badge == _this.badge)&&(identical(other.telephone, _this.telephone) || other.telephone == _this.telephone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as BailleurContrat;
  return Object.hash(runtimeType,_this.nom,_this.badge,_this.telephone);
}

@override
String toString() {
  final _this = this as BailleurContrat;
  return 'BailleurContrat(nom: ${_this.nom}, badge: ${_this.badge}, telephone: ${_this.telephone})';
}


}

/// @nodoc
abstract mixin class $BailleurContratCopyWith<$Res>  {
  factory $BailleurContratCopyWith(BailleurContrat value, $Res Function(BailleurContrat) _then) = _$BailleurContratCopyWithImpl;
@useResult
$Res call({
 String nom, String? badge, String? telephone
});




}
/// @nodoc
class _$BailleurContratCopyWithImpl<$Res>
    implements $BailleurContratCopyWith<$Res> {
  _$BailleurContratCopyWithImpl(this._self, this._then);

  final BailleurContrat _self;
  final $Res Function(BailleurContrat) _then;

/// Create a copy of BailleurContrat
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? nom = null,Object? badge = freezed,Object? telephone = freezed,}) {
  return _then(BailleurContrat(
nom: null == nom ? _self.nom : nom // ignore: cast_nullable_to_non_nullable
as String,badge: freezed == badge ? _self.badge : badge // ignore: cast_nullable_to_non_nullable
as String?,telephone: freezed == telephone ? _self.telephone : telephone // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [BailleurContrat].
extension BailleurContratPatterns on BailleurContrat {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BailleurContrat value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BailleurContrat() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BailleurContrat value)  $default,){
final _that = this;
switch (_that) {
case _BailleurContrat():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BailleurContrat value)?  $default,){
final _that = this;
switch (_that) {
case _BailleurContrat() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String nom,  String? badge,  String? telephone)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BailleurContrat() when $default != null:
return $default(_that.nom,_that.badge,_that.telephone);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String nom,  String? badge,  String? telephone)  $default,) {final _that = this;
switch (_that) {
case _BailleurContrat():
return $default(_that.nom,_that.badge,_that.telephone);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String nom,  String? badge,  String? telephone)?  $default,) {final _that = this;
switch (_that) {
case _BailleurContrat() when $default != null:
return $default(_that.nom,_that.badge,_that.telephone);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BailleurContrat implements BailleurContrat {
  const _BailleurContrat({required this.nom, this.badge, this.telephone});
  factory _BailleurContrat.fromJson(Map<String, dynamic> json) => _$BailleurContratFromJson(json);

@override final  String nom;
@override final  String? badge;
@override final  String? telephone;

/// Create a copy of BailleurContrat
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BailleurContratCopyWith<_BailleurContrat> get copyWith => __$BailleurContratCopyWithImpl<_BailleurContrat>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BailleurContratToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BailleurContrat&&(identical(other.nom, nom) || other.nom == nom)&&(identical(other.badge, badge) || other.badge == badge)&&(identical(other.telephone, telephone) || other.telephone == telephone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,nom,badge,telephone);
}

@override
String toString() {
    return 'BailleurContrat(nom: $nom, badge: $badge, telephone: $telephone)';
}


}

/// @nodoc
abstract mixin class _$BailleurContratCopyWith<$Res> implements $BailleurContratCopyWith<$Res> {
  factory _$BailleurContratCopyWith(_BailleurContrat value, $Res Function(_BailleurContrat) _then) = __$BailleurContratCopyWithImpl;
@override @useResult
$Res call({
 String nom, String? badge, String? telephone
});




}
/// @nodoc
class __$BailleurContratCopyWithImpl<$Res>
    implements _$BailleurContratCopyWith<$Res> {
  __$BailleurContratCopyWithImpl(this._self, this._then);

  final _BailleurContrat _self;
  final $Res Function(_BailleurContrat) _then;

/// Create a copy of BailleurContrat
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? nom = null,Object? badge = freezed,Object? telephone = freezed,}) {
  return _then(_BailleurContrat(
nom: null == nom ? _self.nom : nom // ignore: cast_nullable_to_non_nullable
as String,badge: freezed == badge ? _self.badge : badge // ignore: cast_nullable_to_non_nullable
as String?,telephone: freezed == telephone ? _self.telephone : telephone // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$Garantie {

 int get montant; String get statut; int get retenue; String? get motif;
/// Create a copy of Garantie
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GarantieCopyWith<Garantie> get copyWith => _$GarantieCopyWithImpl<Garantie>(this as Garantie, _$identity);

  /// Serializes this Garantie to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Garantie;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Garantie&&(identical(other.montant, _this.montant) || other.montant == _this.montant)&&(identical(other.statut, _this.statut) || other.statut == _this.statut)&&(identical(other.retenue, _this.retenue) || other.retenue == _this.retenue)&&(identical(other.motif, _this.motif) || other.motif == _this.motif));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Garantie;
  return Object.hash(runtimeType,_this.montant,_this.statut,_this.retenue,_this.motif);
}

@override
String toString() {
  final _this = this as Garantie;
  return 'Garantie(montant: ${_this.montant}, statut: ${_this.statut}, retenue: ${_this.retenue}, motif: ${_this.motif})';
}


}

/// @nodoc
abstract mixin class $GarantieCopyWith<$Res>  {
  factory $GarantieCopyWith(Garantie value, $Res Function(Garantie) _then) = _$GarantieCopyWithImpl;
@useResult
$Res call({
 int montant, String statut, int retenue, String? motif
});




}
/// @nodoc
class _$GarantieCopyWithImpl<$Res>
    implements $GarantieCopyWith<$Res> {
  _$GarantieCopyWithImpl(this._self, this._then);

  final Garantie _self;
  final $Res Function(Garantie) _then;

/// Create a copy of Garantie
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? montant = null,Object? statut = null,Object? retenue = null,Object? motif = freezed,}) {
  return _then(Garantie(
montant: null == montant ? _self.montant : montant // ignore: cast_nullable_to_non_nullable
as int,statut: null == statut ? _self.statut : statut // ignore: cast_nullable_to_non_nullable
as String,retenue: null == retenue ? _self.retenue : retenue // ignore: cast_nullable_to_non_nullable
as int,motif: freezed == motif ? _self.motif : motif // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Garantie].
extension GarantiePatterns on Garantie {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Garantie value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Garantie() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Garantie value)  $default,){
final _that = this;
switch (_that) {
case _Garantie():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Garantie value)?  $default,){
final _that = this;
switch (_that) {
case _Garantie() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int montant,  String statut,  int retenue,  String? motif)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Garantie() when $default != null:
return $default(_that.montant,_that.statut,_that.retenue,_that.motif);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int montant,  String statut,  int retenue,  String? motif)  $default,) {final _that = this;
switch (_that) {
case _Garantie():
return $default(_that.montant,_that.statut,_that.retenue,_that.motif);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int montant,  String statut,  int retenue,  String? motif)?  $default,) {final _that = this;
switch (_that) {
case _Garantie() when $default != null:
return $default(_that.montant,_that.statut,_that.retenue,_that.motif);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Garantie implements Garantie {
  const _Garantie({required this.montant, required this.statut, this.retenue = 0, this.motif});
  factory _Garantie.fromJson(Map<String, dynamic> json) => _$GarantieFromJson(json);

@override final  int montant;
@override final  String statut;
@override@JsonKey() final  int retenue;
@override final  String? motif;

/// Create a copy of Garantie
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GarantieCopyWith<_Garantie> get copyWith => __$GarantieCopyWithImpl<_Garantie>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GarantieToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Garantie&&(identical(other.montant, montant) || other.montant == montant)&&(identical(other.statut, statut) || other.statut == statut)&&(identical(other.retenue, retenue) || other.retenue == retenue)&&(identical(other.motif, motif) || other.motif == motif));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,montant,statut,retenue,motif);
}

@override
String toString() {
    return 'Garantie(montant: $montant, statut: $statut, retenue: $retenue, motif: $motif)';
}


}

/// @nodoc
abstract mixin class _$GarantieCopyWith<$Res> implements $GarantieCopyWith<$Res> {
  factory _$GarantieCopyWith(_Garantie value, $Res Function(_Garantie) _then) = __$GarantieCopyWithImpl;
@override @useResult
$Res call({
 int montant, String statut, int retenue, String? motif
});




}
/// @nodoc
class __$GarantieCopyWithImpl<$Res>
    implements _$GarantieCopyWith<$Res> {
  __$GarantieCopyWithImpl(this._self, this._then);

  final _Garantie _self;
  final $Res Function(_Garantie) _then;

/// Create a copy of Garantie
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? montant = null,Object? statut = null,Object? retenue = null,Object? motif = freezed,}) {
  return _then(_Garantie(
montant: null == montant ? _self.montant : montant // ignore: cast_nullable_to_non_nullable
as int,statut: null == statut ? _self.statut : statut // ignore: cast_nullable_to_non_nullable
as String,retenue: null == retenue ? _self.retenue : retenue // ignore: cast_nullable_to_non_nullable
as int,motif: freezed == motif ? _self.motif : motif // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$Contrat {

 int get id; String get statut; UniteContrat get unite; ContactLocataire get locataire; BailleurContrat get bailleur; Devise get devise; int get loyer; String get dateDebut; String? get dateFin; String? get dateSortie; int get enRetard; int get restantDu; Echeance? get prochaineEcheance; Garantie? get garantie; List<Echeance> get echeances; List<Paiement> get paiements;
/// Create a copy of Contrat
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContratCopyWith<Contrat> get copyWith => _$ContratCopyWithImpl<Contrat>(this as Contrat, _$identity);

  /// Serializes this Contrat to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Contrat;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Contrat&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.statut, _this.statut) || other.statut == _this.statut)&&(identical(other.unite, _this.unite) || other.unite == _this.unite)&&(identical(other.locataire, _this.locataire) || other.locataire == _this.locataire)&&(identical(other.bailleur, _this.bailleur) || other.bailleur == _this.bailleur)&&(identical(other.devise, _this.devise) || other.devise == _this.devise)&&(identical(other.loyer, _this.loyer) || other.loyer == _this.loyer)&&(identical(other.dateDebut, _this.dateDebut) || other.dateDebut == _this.dateDebut)&&(identical(other.dateFin, _this.dateFin) || other.dateFin == _this.dateFin)&&(identical(other.dateSortie, _this.dateSortie) || other.dateSortie == _this.dateSortie)&&(identical(other.enRetard, _this.enRetard) || other.enRetard == _this.enRetard)&&(identical(other.restantDu, _this.restantDu) || other.restantDu == _this.restantDu)&&(identical(other.prochaineEcheance, _this.prochaineEcheance) || other.prochaineEcheance == _this.prochaineEcheance)&&(identical(other.garantie, _this.garantie) || other.garantie == _this.garantie)&&const DeepCollectionEquality().equals(other.echeances, _this.echeances)&&const DeepCollectionEquality().equals(other.paiements, _this.paiements));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Contrat;
  return Object.hash(runtimeType,_this.id,_this.statut,_this.unite,_this.locataire,_this.bailleur,_this.devise,_this.loyer,_this.dateDebut,_this.dateFin,_this.dateSortie,_this.enRetard,_this.restantDu,_this.prochaineEcheance,_this.garantie,const DeepCollectionEquality().hash(_this.echeances),const DeepCollectionEquality().hash(_this.paiements));
}

@override
String toString() {
  final _this = this as Contrat;
  return 'Contrat(id: ${_this.id}, statut: ${_this.statut}, unite: ${_this.unite}, locataire: ${_this.locataire}, bailleur: ${_this.bailleur}, devise: ${_this.devise}, loyer: ${_this.loyer}, dateDebut: ${_this.dateDebut}, dateFin: ${_this.dateFin}, dateSortie: ${_this.dateSortie}, enRetard: ${_this.enRetard}, restantDu: ${_this.restantDu}, prochaineEcheance: ${_this.prochaineEcheance}, garantie: ${_this.garantie}, echeances: ${_this.echeances}, paiements: ${_this.paiements})';
}


}

/// @nodoc
abstract mixin class $ContratCopyWith<$Res>  {
  factory $ContratCopyWith(Contrat value, $Res Function(Contrat) _then) = _$ContratCopyWithImpl;
@useResult
$Res call({
 int id, String statut, UniteContrat unite, ContactLocataire locataire, BailleurContrat bailleur, Devise devise, int loyer, String dateDebut, String? dateFin, String? dateSortie, int enRetard, int restantDu, Echeance? prochaineEcheance, Garantie? garantie, List<Echeance> echeances, List<Paiement> paiements
});


$UniteContratCopyWith<$Res> get unite;$ContactLocataireCopyWith<$Res> get locataire;$BailleurContratCopyWith<$Res> get bailleur;$DeviseCopyWith<$Res> get devise;$EcheanceCopyWith<$Res>? get prochaineEcheance;$GarantieCopyWith<$Res>? get garantie;

}
/// @nodoc
class _$ContratCopyWithImpl<$Res>
    implements $ContratCopyWith<$Res> {
  _$ContratCopyWithImpl(this._self, this._then);

  final Contrat _self;
  final $Res Function(Contrat) _then;

/// Create a copy of Contrat
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? statut = null,Object? unite = null,Object? locataire = null,Object? bailleur = null,Object? devise = null,Object? loyer = null,Object? dateDebut = null,Object? dateFin = freezed,Object? dateSortie = freezed,Object? enRetard = null,Object? restantDu = null,Object? prochaineEcheance = freezed,Object? garantie = freezed,Object? echeances = null,Object? paiements = null,}) {
  return _then(Contrat(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,statut: null == statut ? _self.statut : statut // ignore: cast_nullable_to_non_nullable
as String,unite: null == unite ? _self.unite : unite // ignore: cast_nullable_to_non_nullable
as UniteContrat,locataire: null == locataire ? _self.locataire : locataire // ignore: cast_nullable_to_non_nullable
as ContactLocataire,bailleur: null == bailleur ? _self.bailleur : bailleur // ignore: cast_nullable_to_non_nullable
as BailleurContrat,devise: null == devise ? _self.devise : devise // ignore: cast_nullable_to_non_nullable
as Devise,loyer: null == loyer ? _self.loyer : loyer // ignore: cast_nullable_to_non_nullable
as int,dateDebut: null == dateDebut ? _self.dateDebut : dateDebut // ignore: cast_nullable_to_non_nullable
as String,dateFin: freezed == dateFin ? _self.dateFin : dateFin // ignore: cast_nullable_to_non_nullable
as String?,dateSortie: freezed == dateSortie ? _self.dateSortie : dateSortie // ignore: cast_nullable_to_non_nullable
as String?,enRetard: null == enRetard ? _self.enRetard : enRetard // ignore: cast_nullable_to_non_nullable
as int,restantDu: null == restantDu ? _self.restantDu : restantDu // ignore: cast_nullable_to_non_nullable
as int,prochaineEcheance: freezed == prochaineEcheance ? _self.prochaineEcheance : prochaineEcheance // ignore: cast_nullable_to_non_nullable
as Echeance?,garantie: freezed == garantie ? _self.garantie : garantie // ignore: cast_nullable_to_non_nullable
as Garantie?,echeances: null == echeances ? _self.echeances : echeances // ignore: cast_nullable_to_non_nullable
as List<Echeance>,paiements: null == paiements ? _self.paiements : paiements // ignore: cast_nullable_to_non_nullable
as List<Paiement>,
  ));
}
/// Create a copy of Contrat
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UniteContratCopyWith<$Res> get unite {
  
  return $UniteContratCopyWith<$Res>(_self.unite, (value) {
    return _then(_self.copyWith(unite: value));
  });
}/// Create a copy of Contrat
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ContactLocataireCopyWith<$Res> get locataire {
  
  return $ContactLocataireCopyWith<$Res>(_self.locataire, (value) {
    return _then(_self.copyWith(locataire: value));
  });
}/// Create a copy of Contrat
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BailleurContratCopyWith<$Res> get bailleur {
  
  return $BailleurContratCopyWith<$Res>(_self.bailleur, (value) {
    return _then(_self.copyWith(bailleur: value));
  });
}/// Create a copy of Contrat
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DeviseCopyWith<$Res> get devise {
  
  return $DeviseCopyWith<$Res>(_self.devise, (value) {
    return _then(_self.copyWith(devise: value));
  });
}/// Create a copy of Contrat
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EcheanceCopyWith<$Res>? get prochaineEcheance {
    if (_self.prochaineEcheance == null) {
    return null;
  }

  return $EcheanceCopyWith<$Res>(_self.prochaineEcheance!, (value) {
    return _then(_self.copyWith(prochaineEcheance: value));
  });
}/// Create a copy of Contrat
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GarantieCopyWith<$Res>? get garantie {
    if (_self.garantie == null) {
    return null;
  }

  return $GarantieCopyWith<$Res>(_self.garantie!, (value) {
    return _then(_self.copyWith(garantie: value));
  });
}
}


/// Adds pattern-matching-related methods to [Contrat].
extension ContratPatterns on Contrat {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Contrat value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Contrat() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Contrat value)  $default,){
final _that = this;
switch (_that) {
case _Contrat():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Contrat value)?  $default,){
final _that = this;
switch (_that) {
case _Contrat() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String statut,  UniteContrat unite,  ContactLocataire locataire,  BailleurContrat bailleur,  Devise devise,  int loyer,  String dateDebut,  String? dateFin,  String? dateSortie,  int enRetard,  int restantDu,  Echeance? prochaineEcheance,  Garantie? garantie,  List<Echeance> echeances,  List<Paiement> paiements)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Contrat() when $default != null:
return $default(_that.id,_that.statut,_that.unite,_that.locataire,_that.bailleur,_that.devise,_that.loyer,_that.dateDebut,_that.dateFin,_that.dateSortie,_that.enRetard,_that.restantDu,_that.prochaineEcheance,_that.garantie,_that.echeances,_that.paiements);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String statut,  UniteContrat unite,  ContactLocataire locataire,  BailleurContrat bailleur,  Devise devise,  int loyer,  String dateDebut,  String? dateFin,  String? dateSortie,  int enRetard,  int restantDu,  Echeance? prochaineEcheance,  Garantie? garantie,  List<Echeance> echeances,  List<Paiement> paiements)  $default,) {final _that = this;
switch (_that) {
case _Contrat():
return $default(_that.id,_that.statut,_that.unite,_that.locataire,_that.bailleur,_that.devise,_that.loyer,_that.dateDebut,_that.dateFin,_that.dateSortie,_that.enRetard,_that.restantDu,_that.prochaineEcheance,_that.garantie,_that.echeances,_that.paiements);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String statut,  UniteContrat unite,  ContactLocataire locataire,  BailleurContrat bailleur,  Devise devise,  int loyer,  String dateDebut,  String? dateFin,  String? dateSortie,  int enRetard,  int restantDu,  Echeance? prochaineEcheance,  Garantie? garantie,  List<Echeance> echeances,  List<Paiement> paiements)?  $default,) {final _that = this;
switch (_that) {
case _Contrat() when $default != null:
return $default(_that.id,_that.statut,_that.unite,_that.locataire,_that.bailleur,_that.devise,_that.loyer,_that.dateDebut,_that.dateFin,_that.dateSortie,_that.enRetard,_that.restantDu,_that.prochaineEcheance,_that.garantie,_that.echeances,_that.paiements);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Contrat implements Contrat {
  const _Contrat({required this.id, required this.statut, required this.unite, required this.locataire, required this.bailleur, required this.devise, required this.loyer, required this.dateDebut, this.dateFin, this.dateSortie, required this.enRetard, required this.restantDu, this.prochaineEcheance, this.garantie,  List<Echeance> echeances = const <Echeance>[],  List<Paiement> paiements = const <Paiement>[]}): _echeances = echeances,_paiements = paiements;
  factory _Contrat.fromJson(Map<String, dynamic> json) => _$ContratFromJson(json);

@override final  int id;
@override final  String statut;
@override final  UniteContrat unite;
@override final  ContactLocataire locataire;
@override final  BailleurContrat bailleur;
@override final  Devise devise;
@override final  int loyer;
@override final  String dateDebut;
@override final  String? dateFin;
@override final  String? dateSortie;
@override final  int enRetard;
@override final  int restantDu;
@override final  Echeance? prochaineEcheance;
@override final  Garantie? garantie;
 final  List<Echeance> _echeances;
@override@JsonKey() List<Echeance> get echeances {
  if (_echeances is EqualUnmodifiableListView) return _echeances;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_echeances);
}

 final  List<Paiement> _paiements;
@override@JsonKey() List<Paiement> get paiements {
  if (_paiements is EqualUnmodifiableListView) return _paiements;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_paiements);
}


/// Create a copy of Contrat
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContratCopyWith<_Contrat> get copyWith => __$ContratCopyWithImpl<_Contrat>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ContratToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Contrat&&(identical(other.id, id) || other.id == id)&&(identical(other.statut, statut) || other.statut == statut)&&(identical(other.unite, unite) || other.unite == unite)&&(identical(other.locataire, locataire) || other.locataire == locataire)&&(identical(other.bailleur, bailleur) || other.bailleur == bailleur)&&(identical(other.devise, devise) || other.devise == devise)&&(identical(other.loyer, loyer) || other.loyer == loyer)&&(identical(other.dateDebut, dateDebut) || other.dateDebut == dateDebut)&&(identical(other.dateFin, dateFin) || other.dateFin == dateFin)&&(identical(other.dateSortie, dateSortie) || other.dateSortie == dateSortie)&&(identical(other.enRetard, enRetard) || other.enRetard == enRetard)&&(identical(other.restantDu, restantDu) || other.restantDu == restantDu)&&(identical(other.prochaineEcheance, prochaineEcheance) || other.prochaineEcheance == prochaineEcheance)&&(identical(other.garantie, garantie) || other.garantie == garantie)&&const DeepCollectionEquality().equals(other.echeances, _echeances)&&const DeepCollectionEquality().equals(other.paiements, _paiements));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,statut,unite,locataire,bailleur,devise,loyer,dateDebut,dateFin,dateSortie,enRetard,restantDu,prochaineEcheance,garantie,const DeepCollectionEquality().hash(_echeances),const DeepCollectionEquality().hash(_paiements));
}

@override
String toString() {
    return 'Contrat(id: $id, statut: $statut, unite: $unite, locataire: $locataire, bailleur: $bailleur, devise: $devise, loyer: $loyer, dateDebut: $dateDebut, dateFin: $dateFin, dateSortie: $dateSortie, enRetard: $enRetard, restantDu: $restantDu, prochaineEcheance: $prochaineEcheance, garantie: $garantie, echeances: $echeances, paiements: $paiements)';
}


}

/// @nodoc
abstract mixin class _$ContratCopyWith<$Res> implements $ContratCopyWith<$Res> {
  factory _$ContratCopyWith(_Contrat value, $Res Function(_Contrat) _then) = __$ContratCopyWithImpl;
@override @useResult
$Res call({
 int id, String statut, UniteContrat unite, ContactLocataire locataire, BailleurContrat bailleur, Devise devise, int loyer, String dateDebut, String? dateFin, String? dateSortie, int enRetard, int restantDu, Echeance? prochaineEcheance, Garantie? garantie, List<Echeance> echeances, List<Paiement> paiements
});


@override $UniteContratCopyWith<$Res> get unite;@override $ContactLocataireCopyWith<$Res> get locataire;@override $BailleurContratCopyWith<$Res> get bailleur;@override $DeviseCopyWith<$Res> get devise;@override $EcheanceCopyWith<$Res>? get prochaineEcheance;@override $GarantieCopyWith<$Res>? get garantie;

}
/// @nodoc
class __$ContratCopyWithImpl<$Res>
    implements _$ContratCopyWith<$Res> {
  __$ContratCopyWithImpl(this._self, this._then);

  final _Contrat _self;
  final $Res Function(_Contrat) _then;

/// Create a copy of Contrat
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? statut = null,Object? unite = null,Object? locataire = null,Object? bailleur = null,Object? devise = null,Object? loyer = null,Object? dateDebut = null,Object? dateFin = freezed,Object? dateSortie = freezed,Object? enRetard = null,Object? restantDu = null,Object? prochaineEcheance = freezed,Object? garantie = freezed,Object? echeances = null,Object? paiements = null,}) {
  return _then(_Contrat(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,statut: null == statut ? _self.statut : statut // ignore: cast_nullable_to_non_nullable
as String,unite: null == unite ? _self.unite : unite // ignore: cast_nullable_to_non_nullable
as UniteContrat,locataire: null == locataire ? _self.locataire : locataire // ignore: cast_nullable_to_non_nullable
as ContactLocataire,bailleur: null == bailleur ? _self.bailleur : bailleur // ignore: cast_nullable_to_non_nullable
as BailleurContrat,devise: null == devise ? _self.devise : devise // ignore: cast_nullable_to_non_nullable
as Devise,loyer: null == loyer ? _self.loyer : loyer // ignore: cast_nullable_to_non_nullable
as int,dateDebut: null == dateDebut ? _self.dateDebut : dateDebut // ignore: cast_nullable_to_non_nullable
as String,dateFin: freezed == dateFin ? _self.dateFin : dateFin // ignore: cast_nullable_to_non_nullable
as String?,dateSortie: freezed == dateSortie ? _self.dateSortie : dateSortie // ignore: cast_nullable_to_non_nullable
as String?,enRetard: null == enRetard ? _self.enRetard : enRetard // ignore: cast_nullable_to_non_nullable
as int,restantDu: null == restantDu ? _self.restantDu : restantDu // ignore: cast_nullable_to_non_nullable
as int,prochaineEcheance: freezed == prochaineEcheance ? _self.prochaineEcheance : prochaineEcheance // ignore: cast_nullable_to_non_nullable
as Echeance?,garantie: freezed == garantie ? _self.garantie : garantie // ignore: cast_nullable_to_non_nullable
as Garantie?,echeances: null == echeances ? _self._echeances : echeances // ignore: cast_nullable_to_non_nullable
as List<Echeance>,paiements: null == paiements ? _self._paiements : paiements // ignore: cast_nullable_to_non_nullable
as List<Paiement>,
  ));
}

/// Create a copy of Contrat
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UniteContratCopyWith<$Res> get unite {
  
  return $UniteContratCopyWith<$Res>(_self.unite, (value) {
    return _then(_self.copyWith(unite: value));
  });
}/// Create a copy of Contrat
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ContactLocataireCopyWith<$Res> get locataire {
  
  return $ContactLocataireCopyWith<$Res>(_self.locataire, (value) {
    return _then(_self.copyWith(locataire: value));
  });
}/// Create a copy of Contrat
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BailleurContratCopyWith<$Res> get bailleur {
  
  return $BailleurContratCopyWith<$Res>(_self.bailleur, (value) {
    return _then(_self.copyWith(bailleur: value));
  });
}/// Create a copy of Contrat
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DeviseCopyWith<$Res> get devise {
  
  return $DeviseCopyWith<$Res>(_self.devise, (value) {
    return _then(_self.copyWith(devise: value));
  });
}/// Create a copy of Contrat
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EcheanceCopyWith<$Res>? get prochaineEcheance {
    if (_self.prochaineEcheance == null) {
    return null;
  }

  return $EcheanceCopyWith<$Res>(_self.prochaineEcheance!, (value) {
    return _then(_self.copyWith(prochaineEcheance: value));
  });
}/// Create a copy of Contrat
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GarantieCopyWith<$Res>? get garantie {
    if (_self.garantie == null) {
    return null;
  }

  return $GarantieCopyWith<$Res>(_self.garantie!, (value) {
    return _then(_self.copyWith(garantie: value));
  });
}
}

// dart format on
