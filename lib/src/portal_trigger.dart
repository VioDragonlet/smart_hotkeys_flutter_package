import 'hotkey.dart';
import 'supported_keys.dart';

/// Wayland portals use key symbols rather than physical HID positions.
String portalTrigger(Hotkey key) {
  final usage = key.usbHidUsage & 0xffff;
  final names = <int, String>{
    0x28: 'Return',
    0x29: 'Escape',
    0x2a: 'BackSpace',
    0x2b: 'Tab',
    0x2c: 'space',
    0x2d: 'minus',
    0x2e: 'equal',
    0x2f: 'bracketleft',
    0x30: 'bracketright',
    0x31: 'backslash',
    0x33: 'semicolon',
    0x34: 'apostrophe',
    0x35: 'grave',
    0x36: 'comma',
    0x37: 'period',
    0x38: 'slash',
    0x49: 'Insert',
    0x4a: 'Home',
    0x4b: 'Prior',
    0x4c: 'Delete',
    0x4d: 'End',
    0x4e: 'Next',
    0x4f: 'Right',
    0x50: 'Left',
    0x51: 'Down',
    0x52: 'Up',
  };
  final symbol =
      names[usage] ??
      (usage >= 4 && usage <= 29
          ? String.fromCharCode(97 + usage - 4)
          : supportedHotkeyKeys[key.usbHidUsage]!);
  return [
    if (key.modifiers & 1 != 0) 'CTRL',
    if (key.modifiers & 2 != 0) 'ALT',
    if (key.modifiers & 4 != 0) 'SHIFT',
    if (key.modifiers & 8 != 0) 'LOGO',
    symbol,
  ].join('+');
}
