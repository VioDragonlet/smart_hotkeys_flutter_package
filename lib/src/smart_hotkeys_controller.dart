import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'hotkey.dart';
import 'hotkey_event.dart';
import 'hotkeys_state.dart';
import 'hotkey_backend_provider.dart';
part 'smart_hotkeys_controller.g.dart';

/// One controller per Flutter engine. Access through [smartHotkeysProvider].
@Riverpod(keepAlive: true)
class SmartHotkeys extends _$SmartHotkeys {
  final _callbacks = <String, ({VoidCallback down, VoidCallback up})>{};
  // Resource cleanup leases, kept without accessing Ref during disposal.
  final _activeReleases = <String, VoidCallback>{};
  final _held = <int>{};
  final _portalHeld = <String>{};
  final _events = StreamController<HotkeyEvent>.broadcast();
  StreamSubscription<Map<String, Object?>>? _subscription;
  Future<void> _pending = Future.value();

  /// Press/release transitions, including synthetic release reasons.
  Stream<HotkeyEvent> get events => _events.stream;

  @override
  HotkeysState build() {
    final backend = ref.read(hotkeyBackendProvider);
    ref.onDispose(() {
      final releases = Map<String, VoidCallback>.of(_activeReleases);
      _activeReleases.clear();
      scheduleMicrotask(() {
        for (final entry in releases.entries) {
          _events.add(
            HotkeyEvent(id: entry.key, pressed: false, reason: 'disposed'),
          );
          _invoke(entry.value);
        }
        unawaited(_events.close());
      });
      unawaited(_subscription?.cancel());
      unawaited(backend.stop().catchError((Object _) {}));
    });
    return const HotkeysState();
  }

  Future<void> _serial(Future<void> Function() action) {
    final task = _pending.then((_) {
      if (!ref.mounted) {
        throw StateError('Hotkeys controller has been disposed');
      }
      return action();
    });
    _pending = task.catchError((Object _) {});
    return task;
  }

  Future<void> initialize() => _serial(_initialize);

  Future<void> _initialize() async {
    if (state.initialized) return;
    final backend = ref.read(hotkeyBackendProvider);
    _subscription = backend.events.listen(
      _handle,
      onError: (Object error, StackTrace stack) {
        pause();
        FlutterError.reportError(
          FlutterErrorDetails(
            exception: error,
            stack: stack,
            library: 'smart_hotkeys',
          ),
        );
      },
    );
    try {
      final name = await backend.start();
      if (!ref.mounted) {
        await backend.stop();
        return;
      }
      state = state.copyWith(initialized: true, backend: name);
    } catch (_) {
      await _subscription?.cancel();
      _subscription = null;
      rethrow;
    }
  }

  /// Adds a binding. Duplicate IDs/combinations throw PlatformException.
  Future<void> register({
    required String id,
    required Hotkey hotkey,
    required VoidCallback onPressed,
    required VoidCallback onReleased,
  }) => _serial(() async {
    hotkey.validate();
    if (id.trim().isEmpty) throw ArgumentError.value(id, 'id');
    if (state.bindings.containsKey(id) ||
        state.bindings.containsValue(hotkey)) {
      throw PlatformException(
        code: 'conflict',
        message: 'ID or combination is already registered',
      );
    }
    await _initialize();
    final backend = ref.read(hotkeyBackendProvider);
    await backend.bind(id, hotkey);
    if (!ref.mounted) {
      await backend.unbind(id);
      return;
    }
    _callbacks[id] = (down: onPressed, up: onReleased);
    state = state.copyWith(bindings: {...state.bindings, id: hotkey});
  });

  Future<void> unregister(String id) => _serial(() async {
    if (!state.bindings.containsKey(id)) return;
    await ref.read(hotkeyBackendProvider).unbind(id);
    if (!ref.mounted) return;
    _release(id, 'unregistered');
    _callbacks.remove(id);
    _portalHeld.remove(id);
    state = state.copyWith(bindings: {...state.bindings}..remove(id));
  });

  /// Immediately releases active bindings; monitoring continues to track held keys.
  void pause() {
    state = state.copyWith(paused: true);
    for (final id in state.activeIds.toList()) {
      _release(id, 'paused');
    }
  }

  /// A key held through pause must be released and pressed again.
  void resume() {
    state = state.copyWith(paused: false);
  }

  /// Releases actions, removes registrations and shuts down the native listener.
  Future<void> shutdown() => _serial(() async {
    pause();
    await ref.read(hotkeyBackendProvider).stop();
    await _subscription?.cancel();
    _subscription = null;
    _held.clear();
    _portalHeld.clear();
    _callbacks.clear();
    if (ref.mounted) state = const HotkeysState();
  });

  void _handle(Map<String, Object?> event) {
    if (!ref.mounted) return;
    if (event['reset'] == true) {
      for (final id in state.activeIds.toList()) {
        _release(id, 'backendReset');
      }
      _held.clear();
      _portalHeld.clear();
      return;
    }
    if (event.containsKey('id')) {
      final id = event['id'] as String;
      if (event['down'] == true) {
        if (!_portalHeld.add(id) || state.paused) return;
        _press(id);
      } else {
        _portalHeld.remove(id);
        _release(id, 'released');
      }
      return;
    }
    final key = event['key'] as int;
    final down = event['down'] as bool;
    final modifiers = event['modifiers'] as int;
    final fresh = down ? _held.add(key) : _held.remove(key);
    for (final id in state.activeIds.toList()) {
      final binding = state.bindings[id]!;
      if ((!down && key == binding.usbHidUsage) ||
          modifiers & binding.modifiers != binding.modifiers) {
        _release(id, 'released');
      }
    }
    if (!down || !fresh || state.paused) return;
    for (final entry in state.bindings.entries.toList()) {
      if (entry.value.usbHidUsage == key && entry.value.modifiers == modifiers) {
        _press(entry.key);
      }
    }
  }

  void _press(String id) {
    if (!state.bindings.containsKey(id) ||
        state.activeIds.contains(id) ||
        state.paused) {
      return;
    }
    state = state.copyWith(activeIds: {...state.activeIds, id});
    _notify(id, true, null);
  }

  void _release(String id, String reason) {
    if (!state.activeIds.contains(id)) return;
    state = state.copyWith(activeIds: {...state.activeIds}..remove(id));
    _notify(id, false, reason);
  }

  void _notify(String id, bool down, String? reason) {
    if (down) {
      final release = _callbacks[id]?.up;
      if (release != null) _activeReleases[id] = release;
    } else {
      _activeReleases.remove(id);
    }
    _events.add(HotkeyEvent(id: id, pressed: down, reason: reason));
    final callback = down ? _callbacks[id]?.down : _callbacks[id]?.up;
    _invoke(callback);
  }

  void _invoke(VoidCallback? callback) {
    try {
      callback?.call();
    } catch (error, stack) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stack,
          library: 'smart_hotkeys',
        ),
      );
    }
  }
}
