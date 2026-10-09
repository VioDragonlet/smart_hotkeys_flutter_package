import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'hotkey.dart';
import 'hotkey_backend.dart';

class NativeHotkeyBackend implements HotkeyBackend {
  static const _channel = MethodChannel('smart_hotkeys');
  final _events = StreamController<Map<String, Object?>>.broadcast();
  @override
  Stream<Map<String, Object?>> get events => _events.stream;
  @override
  Future<String> start() async {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'key' || call.method == 'reset') {
        _events.add(
          call.method == 'reset'
              ? {'reset': true}
              : Map<String, Object?>.from(call.arguments as Map),
        );
      }
    });
    try {
      return (await _channel.invokeMethod<String>('start'))!;
    } catch (_) {
      _channel.setMethodCallHandler(null);
      rethrow;
    }
  }

  @override
  Future<void> bind(String id, Hotkey hotkey) async {
    if (Platform.isMacOS) {
      await _channel.invokeMethod<void>('validate', {
        'key': hotkey.usbHidUsage,
      });
    }
  }

  @override
  Future<void> unbind(String id) async {}
  @override
  Future<void> stop() async {
    await _channel.invokeMethod<void>('stop');
    _channel.setMethodCallHandler(null);
  }
}
