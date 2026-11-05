// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'declaration.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Declaration {

 int get id; int get contratId; int get montant; String get devise; String get datePaiement; String? get reference; String get statut; String? get motifRefus; String get locataire; String get unite;
/// Create a copy of Declaration
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeclarationCopyWith<Declaration> get copyWith => _$DeclarationCopyWithImpl<Declaration>(this as Declaration, _$identity);

  /// Serializes this Declaration to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Declaration;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Declaration&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.contratId, _this.contratId) || other.contratId == _this.contratId)&&(identical(other.montant, _this.montant) || other.montant == _this.montant)&&(identical(other.devise, _this.devise) || other.devise == _this.devise)&&(identical(other.datePaiement, _this.datePaiement) || other.datePaiement == _this.datePaiement)&&(identical(other.reference, _this.reference) || other.reference == _this.reference)&&(identical(other.statut, _this.statut) || other.statut == _this.statut)&&(identical(other.motifRefus, _this.motifRefus) || other.motifRefus == _this.motifRefus)&&(identical(other.locataire, _this.locataire) || other.locataire == _this.locataire)&&(identical(other.unite, _this.unite) || other.unite == _this.unite));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Declaration;
  return Object.hash(runtimeType,_this.id,_this.contratId,_this.montant,_this.devise,_this.datePaiement,_this.reference,_this.statut,_this.motifRefus,_this.locataire,_this.unite);
}

@override
String toString() {
  final _this = this as Declaration;
  return 'Declaration(id: ${_this.id}, contratId: ${_this.contratId}, montant: ${_this.montant}, devise: ${_this.devise}, datePaiement: ${_this.datePaiement}, reference: ${_this.reference}, statut: ${_this.statut}, motifRefus: ${_this.motifRefus}, locataire: ${_this.locataire}, unite: ${_this.unite})';
}


}

/// @nodoc
abstract mixin class $DeclarationCopyWith<$Res>  {
  factory $DeclarationCopyWith(Declaration value, $Res Function(Declaration) _then) = _$DeclarationCopyWithImpl;
@useResult
$Res call({
 int id, int contratId, int montant, String devise, String datePaiement, String? reference, String statut, String? motifRefus, String locataire, String unite
});




}
/// @nodoc
class _$DeclarationCopyWithImpl<$Res>
    implements $DeclarationCopyWith<$Res> {
  _$DeclarationCopyWithImpl(this._self, this._then);

  final Declaration _self;
  final $Res Function(Declaration) _then;

/// Create a copy of Declaration
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? contratId = null,Object? montant = null,Object? devise = null,Object? datePaiement = null,Object? reference = freezed,Object? statut = null,Object? motifRefus = freezed,Object? locataire = null,Object? unite = null,}) {
  return _then(Declaration(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,contratId: null == contratId ? _self.contratId : contratId // ignore: cast_nullable_to_non_nullable
as int,montant: null == montant ? _self.montant : montant // ignore: cast_nullable_to_non_nullable
as int,devise: null == devise ? _self.devise : devise // ignore: cast_nullable_to_non_nullable
as String,datePaiement: null == datePaiement ? _self.datePaiement : datePaiement // ignore: cast_nullable_to_non_nullable
as String,reference: freezed == reference ? _self.reference : reference // ignore: cast_nullable_to_non_nullable
as String?,statut: null == statut ? _self.statut : statut // ignore: cast_nullable_to_non_nullable
as String,motifRefus: freezed == motifRefus ? _self.motifRefus : motifRefus // ignore: cast_nullable_to_non_nullable
as String?,locataire: null == locataire ? _self.locataire : locataire // ignore: cast_nullable_to_non_nullable
as String,unite: null == unite ? _self.unite : unite // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Declaration].
extension DeclarationPatterns on Declaration {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Declaration value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Declaration() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Declaration value)  $default,){
final _that = this;
switch (_that) {
case _Declaration():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Declaration value)?  $default,){
final _that = this;
switch (_that) {
case _Declaration() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int contratId,  int montant,  String devise,  String datePaiement,  String? reference,  String statut,  String? motifRefus,  String locataire,  String unite)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Declaration() when $default != null:
return $default(_that.id,_that.contratId,_that.montant,_that.devise,_that.datePaiement,_that.reference,_that.statut,_that.motifRefus,_that.locataire,_that.unite);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int contratId,  int montant,  String devise,  String datePaiement,  String? reference,  String statut,  String? motifRefus,  String locataire,  String unite)  $default,) {final _that = this;
switch (_that) {
case _Declaration():
return $default(_that.id,_that.contratId,_that.montant,_that.devise,_that.datePaiement,_that.reference,_that.statut,_that.motifRefus,_that.locataire,_that.unite);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int contratId,  int montant,  String devise,  String datePaiement,  String? reference,  String statut,  String? motifRefus,  String locataire,  String unite)?  $default,) {final _that = this;
switch (_that) {
case _Declaration() when $default != null:
return $default(_that.id,_that.contratId,_that.montant,_that.devise,_that.datePaiement,_that.reference,_that.statut,_that.motifRefus,_that.locataire,_that.unite);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Declaration implements Declaration {
  const _Declaration({required this.id, required this.contratId, required this.montant, required this.devise, required this.datePaiement, this.reference, required this.statut, this.motifRefus, this.locataire = '', this.unite = ''});
  factory _Declaration.fromJson(Map<String, dynamic> json) => _$DeclarationFromJson(json);

@override final  int id;
@override final  int contratId;
@override final  int montant;
@override final  String devise;
@override final  String datePaiement;
@override final  String? reference;
@override final  String statut;
@override final  String? motifRefus;
@override@JsonKey() final  String locataire;
@override@JsonKey() final  String unite;

/// Create a copy of Declaration
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeclarationCopyWith<_Declaration> get copyWith => __$DeclarationCopyWithImpl<_Declaration>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DeclarationToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Declaration&&(identical(other.id, id) || other.id == id)&&(identical(other.contratId, contratId) || other.contratId == contratId)&&(identical(other.montant, montant) || other.montant == montant)&&(identical(other.devise, devise) || other.devise == devise)&&(identical(other.datePaiement, datePaiement) || other.datePaiement == datePaiement)&&(identical(other.reference, reference) || other.reference == reference)&&(identical(other.statut, statut) || other.statut == statut)&&(identical(other.motifRefus, motifRefus) || other.motifRefus == motifRefus)&&(identical(other.locataire, locataire) || other.locataire == locataire)&&(identical(other.unite, unite) || other.unite == unite));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,contratId,montant,devise,datePaiement,reference,statut,motifRefus,locataire,unite);
}

@override
String toString() {
    return 'Declaration(id: $id, contratId: $contratId, montant: $montant, devise: $devise, datePaiement: $datePaiement, reference: $reference, statut: $statut, motifRefus: $motifRefus, locataire: $locataire, unite: $unite)';
}


}

/// @nodoc
abstract mixin class _$DeclarationCopyWith<$Res> implements $DeclarationCopyWith<$Res> {
  factory _$DeclarationCopyWith(_Declaration value, $Res Function(_Declaration) _then) = __$DeclarationCopyWithImpl;
@override @useResult
$Res call({
 int id, int contratId, int montant, String devise, String datePaiement, String? reference, String statut, String? motifRefus, String locataire, String unite
});




}
/// @nodoc
class __$DeclarationCopyWithImpl<$Res>
    implements _$DeclarationCopyWith<$Res> {
  __$DeclarationCopyWithImpl(this._self, this._then);

  final _Declaration _self;
  final $Res Function(_Declaration) _then;

/// Create a copy of Declaration
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? contratId = null,Object? montant = null,Object? devise = null,Object? datePaiement = null,Object? reference = freezed,Object? statut = null,Object? motifRefus = freezed,Object? locataire = null,Object? unite = null,}) {
  return _then(_Declaration(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,contratId: null == contratId ? _self.contratId : contratId // ignore: cast_nullable_to_non_nullable
as int,montant: null == montant ? _self.montant : montant // ignore: cast_nullable_to_non_nullable
as int,devise: null == devise ? _self.devise : devise // ignore: cast_nullable_to_non_nullable
as String,datePaiement: null == datePaiement ? _self.datePaiement : datePaiement // ignore: cast_nullable_to_non_nullable
as String,reference: freezed == reference ? _self.reference : reference // ignore: cast_nullable_to_non_nullable
as String?,statut: null == statut ? _self.statut : statut // ignore: cast_nullable_to_non_nullable
as String,motifRefus: freezed == motifRefus ? _self.motifRefus : motifRefus // ignore: cast_nullable_to_non_nullable
as String?,locataire: null == locataire ? _self.locataire : locataire // ignore: cast_nullable_to_non_nullable
as String,unite: null == unite ? _self.unite : unite // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
