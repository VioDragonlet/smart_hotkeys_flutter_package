import 'package:freezed_annotation/freezed_annotation.dart';
import 'hotkey.dart';
part 'hotkeys_state.freezed.dart';

@freezed
abstract class HotkeysState with _$HotkeysState {
  const factory HotkeysState({
    @Default(false) bool initialized,
    @Default(false) bool paused,
    @Default('') String backend,
    @Default({}) Map<String, Hotkey> bindings,
    @Default({}) Set<String> activeIds,
  }) = _HotkeysState;
}
