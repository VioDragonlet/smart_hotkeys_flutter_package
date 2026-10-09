import 'package:freezed_annotation/freezed_annotation.dart';
part 'hotkey_event.freezed.dart';

@freezed
abstract class HotkeyEvent with _$HotkeyEvent {
  const factory HotkeyEvent({
    required String id,
    required bool pressed,
    String? reason,
  }) = _HotkeyEvent;
}
