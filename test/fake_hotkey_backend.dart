import 'dart:async';
import 'package:smart_hotkeys/src/hotkey.dart';
import 'package:smart_hotkeys/src/hotkey_backend.dart';

class FakeHotkeyBackend implements HotkeyBackend {
  final controller = StreamController<Map<String, Object?>>.broadcast(
    sync: true,
  );
  final bound = <String>{};
  bool failStart = false;
  bool failBind = false;
  bool stopped = false;
  @override
  Stream<Map<String, Object?>> get events => controller.stream;
  @override
  Future<String> start() async {
    if (failStart) throw StateError('start failed');
    stopped = false;
    return 'fake';
  }

  @override
  Future<void> bind(String id, Hotkey hotkey) async {
    if (failBind) throw StateError('bind failed');
    bound.add(id);
  }

  @override
  Future<void> unbind(String id) async {
    bound.remove(id);
  }

  @override
  Future<void> stop() async {
    stopped = true;
    bound.clear();
  }

  void key(int usage, bool down, [int modifiers = 0]) =>
      controller.add({'key': usage, 'down': down, 'modifiers': modifiers});
  void portal(String id, bool down) => controller.add({'id': id, 'down': down});
}
