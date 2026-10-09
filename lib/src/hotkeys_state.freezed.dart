// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hotkeys_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HotkeysState {

 bool get initialized; bool get paused; String get backend; Map<String, Hotkey> get bindings; Set<String> get activeIds;
/// Create a copy of HotkeysState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HotkeysStateCopyWith<HotkeysState> get copyWith => _$HotkeysStateCopyWithImpl<HotkeysState>(this as HotkeysState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HotkeysState&&(identical(other.initialized, initialized) || other.initialized == initialized)&&(identical(other.paused, paused) || other.paused == paused)&&(identical(other.backend, backend) || other.backend == backend)&&const DeepCollectionEquality().equals(other.bindings, bindings)&&const DeepCollectionEquality().equals(other.activeIds, activeIds));
}


@override
int get hashCode => Object.hash(runtimeType,initialized,paused,backend,const DeepCollectionEquality().hash(bindings),const DeepCollectionEquality().hash(activeIds));

@override
String toString() {
  return 'HotkeysState(initialized: $initialized, paused: $paused, backend: $backend, bindings: $bindings, activeIds: $activeIds)';
}


}

/// @nodoc
abstract mixin class $HotkeysStateCopyWith<$Res>  {
  factory $HotkeysStateCopyWith(HotkeysState value, $Res Function(HotkeysState) _then) = _$HotkeysStateCopyWithImpl;
@useResult
$Res call({
 bool initialized, bool paused, String backend, Map<String, Hotkey> bindings, Set<String> activeIds
});




}
/// @nodoc
class _$HotkeysStateCopyWithImpl<$Res>
    implements $HotkeysStateCopyWith<$Res> {
  _$HotkeysStateCopyWithImpl(this._self, this._then);

  final HotkeysState _self;
  final $Res Function(HotkeysState) _then;

/// Create a copy of HotkeysState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? initialized = null,Object? paused = null,Object? backend = null,Object? bindings = null,Object? activeIds = null,}) {
  return _then(_self.copyWith(
initialized: null == initialized ? _self.initialized : initialized // ignore: cast_nullable_to_non_nullable
as bool,paused: null == paused ? _self.paused : paused // ignore: cast_nullable_to_non_nullable
as bool,backend: null == backend ? _self.backend : backend // ignore: cast_nullable_to_non_nullable
as String,bindings: null == bindings ? _self.bindings : bindings // ignore: cast_nullable_to_non_nullable
as Map<String, Hotkey>,activeIds: null == activeIds ? _self.activeIds : activeIds // ignore: cast_nullable_to_non_nullable
as Set<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [HotkeysState].
extension HotkeysStatePatterns on HotkeysState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HotkeysState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HotkeysState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HotkeysState value)  $default,){
final _that = this;
switch (_that) {
case _HotkeysState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HotkeysState value)?  $default,){
final _that = this;
switch (_that) {
case _HotkeysState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool initialized,  bool paused,  String backend,  Map<String, Hotkey> bindings,  Set<String> activeIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HotkeysState() when $default != null:
return $default(_that.initialized,_that.paused,_that.backend,_that.bindings,_that.activeIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool initialized,  bool paused,  String backend,  Map<String, Hotkey> bindings,  Set<String> activeIds)  $default,) {final _that = this;
switch (_that) {
case _HotkeysState():
return $default(_that.initialized,_that.paused,_that.backend,_that.bindings,_that.activeIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool initialized,  bool paused,  String backend,  Map<String, Hotkey> bindings,  Set<String> activeIds)?  $default,) {final _that = this;
switch (_that) {
case _HotkeysState() when $default != null:
return $default(_that.initialized,_that.paused,_that.backend,_that.bindings,_that.activeIds);case _:
  return null;

}
}

}

/// @nodoc


class _HotkeysState implements HotkeysState {
  const _HotkeysState({this.initialized = false, this.paused = false, this.backend = '', final  Map<String, Hotkey> bindings = const {}, final  Set<String> activeIds = const {}}): _bindings = bindings,_activeIds = activeIds;
  

@override@JsonKey() final  bool initialized;
@override@JsonKey() final  bool paused;
@override@JsonKey() final  String backend;
 final  Map<String, Hotkey> _bindings;
@override@JsonKey() Map<String, Hotkey> get bindings {
  if (_bindings is EqualUnmodifiableMapView) return _bindings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_bindings);
}

 final  Set<String> _activeIds;
@override@JsonKey() Set<String> get activeIds {
  if (_activeIds is EqualUnmodifiableSetView) return _activeIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_activeIds);
}


/// Create a copy of HotkeysState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HotkeysStateCopyWith<_HotkeysState> get copyWith => __$HotkeysStateCopyWithImpl<_HotkeysState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HotkeysState&&(identical(other.initialized, initialized) || other.initialized == initialized)&&(identical(other.paused, paused) || other.paused == paused)&&(identical(other.backend, backend) || other.backend == backend)&&const DeepCollectionEquality().equals(other._bindings, _bindings)&&const DeepCollectionEquality().equals(other._activeIds, _activeIds));
}


@override
int get hashCode => Object.hash(runtimeType,initialized,paused,backend,const DeepCollectionEquality().hash(_bindings),const DeepCollectionEquality().hash(_activeIds));

@override
String toString() {
  return 'HotkeysState(initialized: $initialized, paused: $paused, backend: $backend, bindings: $bindings, activeIds: $activeIds)';
}


}

/// @nodoc
abstract mixin class _$HotkeysStateCopyWith<$Res> implements $HotkeysStateCopyWith<$Res> {
  factory _$HotkeysStateCopyWith(_HotkeysState value, $Res Function(_HotkeysState) _then) = __$HotkeysStateCopyWithImpl;
@override @useResult
$Res call({
 bool initialized, bool paused, String backend, Map<String, Hotkey> bindings, Set<String> activeIds
});




}
/// @nodoc
class __$HotkeysStateCopyWithImpl<$Res>
    implements _$HotkeysStateCopyWith<$Res> {
  __$HotkeysStateCopyWithImpl(this._self, this._then);

  final _HotkeysState _self;
  final $Res Function(_HotkeysState) _then;

/// Create a copy of HotkeysState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? initialized = null,Object? paused = null,Object? backend = null,Object? bindings = null,Object? activeIds = null,}) {
  return _then(_HotkeysState(
initialized: null == initialized ? _self.initialized : initialized // ignore: cast_nullable_to_non_nullable
as bool,paused: null == paused ? _self.paused : paused // ignore: cast_nullable_to_non_nullable
as bool,backend: null == backend ? _self.backend : backend // ignore: cast_nullable_to_non_nullable
as String,bindings: null == bindings ? _self._bindings : bindings // ignore: cast_nullable_to_non_nullable
as Map<String, Hotkey>,activeIds: null == activeIds ? _self._activeIds : activeIds // ignore: cast_nullable_to_non_nullable
as Set<String>,
  ));
}


}

// dart format on
