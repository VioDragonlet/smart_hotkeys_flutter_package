import 'hotkey.dart';

/// Internal transport contract, also used to test the transition logic.
abstract class HotkeyBackend {
  Stream<Map<String, Object?>> get events;
  Future<String> start();
  Future<void> bind(String id, Hotkey hotkey);
  Future<void> unbind(String id);
  Future<void> stop();
}
