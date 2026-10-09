import 'dart:async';
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_hotkeys/smart_hotkeys.dart';
import 'demo_state.dart';
part 'demo_controller.g.dart';

@Riverpod(keepAlive: true)
class Demo extends _$Demo {
  int _nextId = 0;
  @override
  DemoState build() {
    final subscription = ref.read(smartHotkeysProvider.notifier).events.listen((
      event,
    ) {
      if (!ref.mounted) return;
      final now = DateTime.now().toIso8601String().substring(11, 23);
      state = state.copyWith(
        log: [
          '$now  ${event.id}  ${event.pressed ? 'PRESS' : 'RELEASE'}${event.reason == null ? '' : ' · ${event.reason}'}',
          ...state.log,
        ].take(100).toList(),
      );
    });
    ref.onDispose(() => unawaited(subscription.cancel()));
    Future.microtask(() {
      if (ref.mounted) initialize();
    });
    return const DemoState();
  }

  Future<void> initialize() async {
    state = state.copyWith(busy: true, error: null);
    try {
      await ref.read(smartHotkeysProvider.notifier).initialize();
    } catch (error) {
      if (ref.mounted) state = state.copyWith(error: '$error');
    } finally {
      if (ref.mounted) state = state.copyWith(busy: false);
    }
  }

  void edit({bool record = false}) {
    if (!state.editing) {
      final wasPaused = ref.read(smartHotkeysProvider).paused;
      ref.read(smartHotkeysProvider.notifier).pause();
      state = state.copyWith(editing: true, wasPaused: wasPaused, error: null);
    }
    state = state.copyWith(recording: record);
  }

  void setKey(int usage) {
    edit();
    state = state.copyWith(
      candidate: state.candidate.copyWith(usbHidUsage: usage),
    );
  }

  void toggleModifier(HotkeyModifier modifier) {
    edit();
    state = state.copyWith(
      candidate: state.candidate.copyWith(
        modifiers: state.candidate.modifiers ^ modifier.mask,
      ),
    );
  }

  void record(KeyEvent event) {
    if (!state.recording) return;
    final key = event.physicalKey;
    if (event is KeyDownEvent &&
        supportedHotkeyKeys.containsKey(key.usbHidUsage)) {
      final keyboard = HardwareKeyboard.instance;
      state = state.copyWith(
        candidate: Hotkey.fromKey(
          key,
          modifiers: {
            if (keyboard.isControlPressed) HotkeyModifier.control,
            if (keyboard.isAltPressed) HotkeyModifier.alt,
            if (keyboard.isShiftPressed) HotkeyModifier.shift,
            if (keyboard.isMetaPressed) HotkeyModifier.meta,
          },
        ),
      );
    } else if (event is KeyUpEvent &&
        key.usbHidUsage == state.candidate.usbHidUsage) {
      state = state.copyWith(recording: false);
    }
  }

  void cancelEdit() {
    if (state.editing && !state.wasPaused) {
      ref.read(smartHotkeysProvider.notifier).resume();
    }
    state = state.copyWith(editing: false, recording: false, error: null);
  }

  Future<void> add() async {
    state = state.copyWith(busy: true, error: null, recording: false);
    try {
      await ref
          .read(smartHotkeysProvider.notifier)
          .register(
            id: 'hotkey_${++_nextId}',
            hotkey: state.candidate,
            onPressed: () {
              if (ref.mounted) {
                state = state.copyWith(pressedCount: state.pressedCount + 1);
              }
            },
            onReleased: () {
              if (ref.mounted) {
                state = state.copyWith(releasedCount: state.releasedCount + 1);
              }
            },
          );
      cancelEdit();
    } catch (error) {
      if (ref.mounted) state = state.copyWith(error: '$error');
    } finally {
      if (ref.mounted) state = state.copyWith(busy: false);
    }
  }

  Future<void> remove(String id) async {
    try {
      await ref.read(smartHotkeysProvider.notifier).unregister(id);
    } catch (error) {
      if (ref.mounted) state = state.copyWith(error: '$error');
    }
  }

  void togglePause() {
    final hotkeys = ref.read(smartHotkeysProvider.notifier);
    ref.read(smartHotkeysProvider).paused ? hotkeys.resume() : hotkeys.pause();
  }

  void clearLog() {
    state = state.copyWith(log: []);
  }
}
