// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'demo_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DemoState {

 bool get busy; bool get editing; bool get recording; bool get wasPaused; Hotkey get candidate; String? get error; List<String> get log; int get pressedCount; int get releasedCount;
/// Create a copy of DemoState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DemoStateCopyWith<DemoState> get copyWith => _$DemoStateCopyWithImpl<DemoState>(this as DemoState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DemoState&&(identical(other.busy, busy) || other.busy == busy)&&(identical(other.editing, editing) || other.editing == editing)&&(identical(other.recording, recording) || other.recording == recording)&&(identical(other.wasPaused, wasPaused) || other.wasPaused == wasPaused)&&(identical(other.candidate, candidate) || other.candidate == candidate)&&(identical(other.error, error) || other.error == error)&&const DeepCollectionEquality().equals(other.log, log)&&(identical(other.pressedCount, pressedCount) || other.pressedCount == pressedCount)&&(identical(other.releasedCount, releasedCount) || other.releasedCount == releasedCount));
}


@override
int get hashCode => Object.hash(runtimeType,busy,editing,recording,wasPaused,candidate,error,const DeepCollectionEquality().hash(log),pressedCount,releasedCount);

@override
String toString() {
  return 'DemoState(busy: $busy, editing: $editing, recording: $recording, wasPaused: $wasPaused, candidate: $candidate, error: $error, log: $log, pressedCount: $pressedCount, releasedCount: $releasedCount)';
}


}

/// @nodoc
abstract mixin class $DemoStateCopyWith<$Res>  {
  factory $DemoStateCopyWith(DemoState value, $Res Function(DemoState) _then) = _$DemoStateCopyWithImpl;
@useResult
$Res call({
 bool busy, bool editing, bool recording, bool wasPaused, Hotkey candidate, String? error, List<String> log, int pressedCount, int releasedCount
});


$HotkeyCopyWith<$Res> get candidate;

}
/// @nodoc
class _$DemoStateCopyWithImpl<$Res>
    implements $DemoStateCopyWith<$Res> {
  _$DemoStateCopyWithImpl(this._self, this._then);

  final DemoState _self;
  final $Res Function(DemoState) _then;

/// Create a copy of DemoState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? busy = null,Object? editing = null,Object? recording = null,Object? wasPaused = null,Object? candidate = null,Object? error = freezed,Object? log = null,Object? pressedCount = null,Object? releasedCount = null,}) {
  return _then(_self.copyWith(
busy: null == busy ? _self.busy : busy // ignore: cast_nullable_to_non_nullable
as bool,editing: null == editing ? _self.editing : editing // ignore: cast_nullable_to_non_nullable
as bool,recording: null == recording ? _self.recording : recording // ignore: cast_nullable_to_non_nullable
as bool,wasPaused: null == wasPaused ? _self.wasPaused : wasPaused // ignore: cast_nullable_to_non_nullable
as bool,candidate: null == candidate ? _self.candidate : candidate // ignore: cast_nullable_to_non_nullable
as Hotkey,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,log: null == log ? _self.log : log // ignore: cast_nullable_to_non_nullable
as List<String>,pressedCount: null == pressedCount ? _self.pressedCount : pressedCount // ignore: cast_nullable_to_non_nullable
as int,releasedCount: null == releasedCount ? _self.releasedCount : releasedCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of DemoState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HotkeyCopyWith<$Res> get candidate {
  
  return $HotkeyCopyWith<$Res>(_self.candidate, (value) {
    return _then(_self.copyWith(candidate: value));
  });
}
}


/// Adds pattern-matching-related methods to [DemoState].
extension DemoStatePatterns on DemoState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DemoState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DemoState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DemoState value)  $default,){
final _that = this;
switch (_that) {
case _DemoState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DemoState value)?  $default,){
final _that = this;
switch (_that) {
case _DemoState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool busy,  bool editing,  bool recording,  bool wasPaused,  Hotkey candidate,  String? error,  List<String> log,  int pressedCount,  int releasedCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DemoState() when $default != null:
return $default(_that.busy,_that.editing,_that.recording,_that.wasPaused,_that.candidate,_that.error,_that.log,_that.pressedCount,_that.releasedCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool busy,  bool editing,  bool recording,  bool wasPaused,  Hotkey candidate,  String? error,  List<String> log,  int pressedCount,  int releasedCount)  $default,) {final _that = this;
switch (_that) {
case _DemoState():
return $default(_that.busy,_that.editing,_that.recording,_that.wasPaused,_that.candidate,_that.error,_that.log,_that.pressedCount,_that.releasedCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool busy,  bool editing,  bool recording,  bool wasPaused,  Hotkey candidate,  String? error,  List<String> log,  int pressedCount,  int releasedCount)?  $default,) {final _that = this;
switch (_that) {
case _DemoState() when $default != null:
return $default(_that.busy,_that.editing,_that.recording,_that.wasPaused,_that.candidate,_that.error,_that.log,_that.pressedCount,_that.releasedCount);case _:
  return null;

}
}

}

/// @nodoc


class _DemoState implements DemoState {
  const _DemoState({this.busy = false, this.editing = false, this.recording = false, this.wasPaused = false, this.candidate = const Hotkey(usbHidUsage: 0x70068), this.error, final  List<String> log = const [], this.pressedCount = 0, this.releasedCount = 0}): _log = log;
  

@override@JsonKey() final  bool busy;
@override@JsonKey() final  bool editing;
@override@JsonKey() final  bool recording;
@override@JsonKey() final  bool wasPaused;
@override@JsonKey() final  Hotkey candidate;
@override final  String? error;
 final  List<String> _log;
@override@JsonKey() List<String> get log {
  if (_log is EqualUnmodifiableListView) return _log;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_log);
}

@override@JsonKey() final  int pressedCount;
@override@JsonKey() final  int releasedCount;

/// Create a copy of DemoState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DemoStateCopyWith<_DemoState> get copyWith => __$DemoStateCopyWithImpl<_DemoState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DemoState&&(identical(other.busy, busy) || other.busy == busy)&&(identical(other.editing, editing) || other.editing == editing)&&(identical(other.recording, recording) || other.recording == recording)&&(identical(other.wasPaused, wasPaused) || other.wasPaused == wasPaused)&&(identical(other.candidate, candidate) || other.candidate == candidate)&&(identical(other.error, error) || other.error == error)&&const DeepCollectionEquality().equals(other._log, _log)&&(identical(other.pressedCount, pressedCount) || other.pressedCount == pressedCount)&&(identical(other.releasedCount, releasedCount) || other.releasedCount == releasedCount));
}


@override
int get hashCode => Object.hash(runtimeType,busy,editing,recording,wasPaused,candidate,error,const DeepCollectionEquality().hash(_log),pressedCount,releasedCount);

@override
String toString() {
  return 'DemoState(busy: $busy, editing: $editing, recording: $recording, wasPaused: $wasPaused, candidate: $candidate, error: $error, log: $log, pressedCount: $pressedCount, releasedCount: $releasedCount)';
}


}

/// @nodoc
abstract mixin class _$DemoStateCopyWith<$Res> implements $DemoStateCopyWith<$Res> {
  factory _$DemoStateCopyWith(_DemoState value, $Res Function(_DemoState) _then) = __$DemoStateCopyWithImpl;
@override @useResult
$Res call({
 bool busy, bool editing, bool recording, bool wasPaused, Hotkey candidate, String? error, List<String> log, int pressedCount, int releasedCount
});


@override $HotkeyCopyWith<$Res> get candidate;

}
/// @nodoc
class __$DemoStateCopyWithImpl<$Res>
    implements _$DemoStateCopyWith<$Res> {
  __$DemoStateCopyWithImpl(this._self, this._then);

  final _DemoState _self;
  final $Res Function(_DemoState) _then;

/// Create a copy of DemoState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? busy = null,Object? editing = null,Object? recording = null,Object? wasPaused = null,Object? candidate = null,Object? error = freezed,Object? log = null,Object? pressedCount = null,Object? releasedCount = null,}) {
  return _then(_DemoState(
busy: null == busy ? _self.busy : busy // ignore: cast_nullable_to_non_nullable
as bool,editing: null == editing ? _self.editing : editing // ignore: cast_nullable_to_non_nullable
as bool,recording: null == recording ? _self.recording : recording // ignore: cast_nullable_to_non_nullable
as bool,wasPaused: null == wasPaused ? _self.wasPaused : wasPaused // ignore: cast_nullable_to_non_nullable
as bool,candidate: null == candidate ? _self.candidate : candidate // ignore: cast_nullable_to_non_nullable
as Hotkey,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,log: null == log ? _self._log : log // ignore: cast_nullable_to_non_nullable
as List<String>,pressedCount: null == pressedCount ? _self.pressedCount : pressedCount // ignore: cast_nullable_to_non_nullable
as int,releasedCount: null == releasedCount ? _self.releasedCount : releasedCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of DemoState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HotkeyCopyWith<$Res> get candidate {
  
  return $HotkeyCopyWith<$Res>(_self.candidate, (value) {
    return _then(_self.copyWith(candidate: value));
  });
}
}

// dart format on
