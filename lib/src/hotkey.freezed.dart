// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hotkey.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Hotkey {

 int get usbHidUsage; int get modifiers;
/// Create a copy of Hotkey
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HotkeyCopyWith<Hotkey> get copyWith => _$HotkeyCopyWithImpl<Hotkey>(this as Hotkey, _$identity);

  /// Serializes this Hotkey to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Hotkey&&(identical(other.usbHidUsage, usbHidUsage) || other.usbHidUsage == usbHidUsage)&&(identical(other.modifiers, modifiers) || other.modifiers == modifiers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,usbHidUsage,modifiers);

@override
String toString() {
  return 'Hotkey(usbHidUsage: $usbHidUsage, modifiers: $modifiers)';
}


}

/// @nodoc
abstract mixin class $HotkeyCopyWith<$Res>  {
  factory $HotkeyCopyWith(Hotkey value, $Res Function(Hotkey) _then) = _$HotkeyCopyWithImpl;
@useResult
$Res call({
 int usbHidUsage, int modifiers
});




}
/// @nodoc
class _$HotkeyCopyWithImpl<$Res>
    implements $HotkeyCopyWith<$Res> {
  _$HotkeyCopyWithImpl(this._self, this._then);

  final Hotkey _self;
  final $Res Function(Hotkey) _then;

/// Create a copy of Hotkey
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? usbHidUsage = null,Object? modifiers = null,}) {
  return _then(_self.copyWith(
usbHidUsage: null == usbHidUsage ? _self.usbHidUsage : usbHidUsage // ignore: cast_nullable_to_non_nullable
as int,modifiers: null == modifiers ? _self.modifiers : modifiers // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Hotkey].
extension HotkeyPatterns on Hotkey {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Hotkey value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Hotkey() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Hotkey value)  $default,){
final _that = this;
switch (_that) {
case _Hotkey():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Hotkey value)?  $default,){
final _that = this;
switch (_that) {
case _Hotkey() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int usbHidUsage,  int modifiers)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Hotkey() when $default != null:
return $default(_that.usbHidUsage,_that.modifiers);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int usbHidUsage,  int modifiers)  $default,) {final _that = this;
switch (_that) {
case _Hotkey():
return $default(_that.usbHidUsage,_that.modifiers);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int usbHidUsage,  int modifiers)?  $default,) {final _that = this;
switch (_that) {
case _Hotkey() when $default != null:
return $default(_that.usbHidUsage,_that.modifiers);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Hotkey extends Hotkey {
  const _Hotkey({required this.usbHidUsage, this.modifiers = 0}): super._();
  factory _Hotkey.fromJson(Map<String, dynamic> json) => _$HotkeyFromJson(json);

@override final  int usbHidUsage;
@override@JsonKey() final  int modifiers;

/// Create a copy of Hotkey
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HotkeyCopyWith<_Hotkey> get copyWith => __$HotkeyCopyWithImpl<_Hotkey>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HotkeyToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Hotkey&&(identical(other.usbHidUsage, usbHidUsage) || other.usbHidUsage == usbHidUsage)&&(identical(other.modifiers, modifiers) || other.modifiers == modifiers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,usbHidUsage,modifiers);

@override
String toString() {
  return 'Hotkey(usbHidUsage: $usbHidUsage, modifiers: $modifiers)';
}


}

/// @nodoc
abstract mixin class _$HotkeyCopyWith<$Res> implements $HotkeyCopyWith<$Res> {
  factory _$HotkeyCopyWith(_Hotkey value, $Res Function(_Hotkey) _then) = __$HotkeyCopyWithImpl;
@override @useResult
$Res call({
 int usbHidUsage, int modifiers
});




}
/// @nodoc
class __$HotkeyCopyWithImpl<$Res>
    implements _$HotkeyCopyWith<$Res> {
  __$HotkeyCopyWithImpl(this._self, this._then);

  final _Hotkey _self;
  final $Res Function(_Hotkey) _then;

/// Create a copy of Hotkey
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? usbHidUsage = null,Object? modifiers = null,}) {
  return _then(_Hotkey(
usbHidUsage: null == usbHidUsage ? _self.usbHidUsage : usbHidUsage // ignore: cast_nullable_to_non_nullable
as int,modifiers: null == modifiers ? _self.modifiers : modifiers // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
