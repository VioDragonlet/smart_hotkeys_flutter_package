import 'dart:io';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'hotkey_backend.dart';
import 'native_hotkey_backend.dart';
import 'portal_hotkey_backend.dart';
part 'hotkey_backend_provider.g.dart';

@Riverpod(keepAlive: true)
HotkeyBackend hotkeyBackend(Ref ref) =>
    Platform.isLinux &&
        (Platform.environment['XDG_SESSION_TYPE'] == 'wayland' ||
            (Platform.environment['WAYLAND_DISPLAY'] ?? '').isNotEmpty)
    ? PortalHotkeyBackend()
    : NativeHotkeyBackend();
