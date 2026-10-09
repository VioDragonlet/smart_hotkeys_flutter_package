// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hotkey_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HotkeyEvent {

 String get id; bool get pressed; String? get reason;
/// Create a copy of HotkeyEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HotkeyEventCopyWith<HotkeyEvent> get copyWith => _$HotkeyEventCopyWithImpl<HotkeyEvent>(this as HotkeyEvent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HotkeyEvent&&(identical(other.id, id) || other.id == id)&&(identical(other.pressed, pressed) || other.pressed == pressed)&&(identical(other.reason, reason) || other.reason == reason));
}


@override
int get hashCode => Object.hash(runtimeType,id,pressed,reason);

@override
String toString() {
  return 'HotkeyEvent(id: $id, pressed: $pressed, reason: $reason)';
}


}

/// @nodoc
abstract mixin class $HotkeyEventCopyWith<$Res>  {
  factory $HotkeyEventCopyWith(HotkeyEvent value, $Res Function(HotkeyEvent) _then) = _$HotkeyEventCopyWithImpl;
@useResult
$Res call({
 String id, bool pressed, String? reason
});




}
/// @nodoc
class _$HotkeyEventCopyWithImpl<$Res>
    implements $HotkeyEventCopyWith<$Res> {
  _$HotkeyEventCopyWithImpl(this._self, this._then);

  final HotkeyEvent _self;
  final $Res Function(HotkeyEvent) _then;

/// Create a copy of HotkeyEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? pressed = null,Object? reason = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,pressed: null == pressed ? _self.pressed : pressed // ignore: cast_nullable_to_non_nullable
as bool,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [HotkeyEvent].
extension HotkeyEventPatterns on HotkeyEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HotkeyEvent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HotkeyEvent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HotkeyEvent value)  $default,){
final _that = this;
switch (_that) {
case _HotkeyEvent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HotkeyEvent value)?  $default,){
final _that = this;
switch (_that) {
case _HotkeyEvent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  bool pressed,  String? reason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HotkeyEvent() when $default != null:
return $default(_that.id,_that.pressed,_that.reason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  bool pressed,  String? reason)  $default,) {final _that = this;
switch (_that) {
case _HotkeyEvent():
return $default(_that.id,_that.pressed,_that.reason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  bool pressed,  String? reason)?  $default,) {final _that = this;
switch (_that) {
case _HotkeyEvent() when $default != null:
return $default(_that.id,_that.pressed,_that.reason);case _:
  return null;

}
}

}

/// @nodoc


class _HotkeyEvent implements HotkeyEvent {
  const _HotkeyEvent({required this.id, required this.pressed, this.reason});
  

@override final  String id;
@override final  bool pressed;
@override final  String? reason;

/// Create a copy of HotkeyEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HotkeyEventCopyWith<_HotkeyEvent> get copyWith => __$HotkeyEventCopyWithImpl<_HotkeyEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HotkeyEvent&&(identical(other.id, id) || other.id == id)&&(identical(other.pressed, pressed) || other.pressed == pressed)&&(identical(other.reason, reason) || other.reason == reason));
}


@override
int get hashCode => Object.hash(runtimeType,id,pressed,reason);

@override
String toString() {
  return 'HotkeyEvent(id: $id, pressed: $pressed, reason: $reason)';
}


}

/// @nodoc
abstract mixin class _$HotkeyEventCopyWith<$Res> implements $HotkeyEventCopyWith<$Res> {
  factory _$HotkeyEventCopyWith(_HotkeyEvent value, $Res Function(_HotkeyEvent) _then) = __$HotkeyEventCopyWithImpl;
@override @useResult
$Res call({
 String id, bool pressed, String? reason
});




}
/// @nodoc
class __$HotkeyEventCopyWithImpl<$Res>
    implements _$HotkeyEventCopyWith<$Res> {
  __$HotkeyEventCopyWithImpl(this._self, this._then);

  final _HotkeyEvent _self;
  final $Res Function(_HotkeyEvent) _then;

/// Create a copy of HotkeyEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? pressed = null,Object? reason = freezed,}) {
  return _then(_HotkeyEvent(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,pressed: null == pressed ? _self.pressed : pressed // ignore: cast_nullable_to_non_nullable
as bool,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
