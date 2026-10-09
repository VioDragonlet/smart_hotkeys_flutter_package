import 'package:flutter/services.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'hotkey_modifier.dart';
import 'supported_keys.dart';
part 'hotkey.freezed.dart';
part 'hotkey.g.dart';

/// Physical primary key and required modifiers. Lock keys are ignored.
@freezed
abstract class Hotkey with _$Hotkey {
  const Hotkey._();
  const factory Hotkey({required int usbHidUsage, @Default(0) int modifiers}) =
      _Hotkey;
  factory Hotkey.fromJson(Map<String, dynamic> json) => _$HotkeyFromJson(json);
  factory Hotkey.fromKey(
    PhysicalKeyboardKey key, {
    Set<HotkeyModifier> modifiers = const {},
  }) => Hotkey(
    usbHidUsage: key.usbHidUsage,
    modifiers: modifiers.fold(0, (mask, item) => mask | item.mask),
  );
  String get label => [
    for (final modifier in HotkeyModifier.values)
      if (modifiers & modifier.mask != 0) modifier.label,
    supportedHotkeyKeys[usbHidUsage] ?? 'Unknown key',
  ].join(' + ');
  void validate() {
    if (!supportedHotkeyKeys.containsKey(usbHidUsage) ||
        modifiers < 0 ||
        modifiers > 15) {
      throw ArgumentError('Unsupported primary key or modifier mask: $label');
    }
  }
}
