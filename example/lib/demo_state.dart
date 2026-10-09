import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:smart_hotkeys/smart_hotkeys.dart';
part 'demo_state.freezed.dart';

@freezed
abstract class DemoState with _$DemoState {
  const factory DemoState({
    @Default(false) bool busy,
    @Default(false) bool editing,
    @Default(false) bool recording,
    @Default(false) bool wasPaused,
    @Default(Hotkey(usbHidUsage: 0x70068)) Hotkey candidate,
    String? error,
    @Default([]) List<String> log,
    @Default(0) int pressedCount,
    @Default(0) int releasedCount,
  }) = _DemoState;
}
