# smart_hotkeys

Global Flutter desktop hotkeys with separate **press** and **release** callbacks.
Register combinations at runtime, suspend them while editing shortcuts, and keep
listening while your application is unfocused or minimized.

```dart
final hotkeys = ref.read(smartHotkeysProvider.notifier);
await hotkeys.register(
  id: 'push_to_talk',
  hotkey: Hotkey.fromKey(PhysicalKeyboardKey.f13),
  onPressed: () => startTalking(),
  onReleased: () => stopTalking(),
);

hotkeys.pause();
hotkeys.resume();
await hotkeys.unregister('push_to_talk');
await hotkeys.shutdown();
```

Use `ProviderScope` and import `flutter/services.dart`, `flutter_riverpod` and
`smart_hotkeys/smart_hotkeys.dart`. State uses Riverpod Generator; models use
Freezed. Generated sources are included. Consumers do not need code generation.

- Windows: passive global keyboard hook on a dedicated thread; F1–F24.
- Linux X11: passive XInput2 observation with physical XKB key mapping.
- Linux Wayland: GlobalShortcuts portal where implemented by the desktop.
- macOS: passive CGEvent tap with Input Monitoring permission; F1–F20.

This is an initial implementation. Linux/macOS native implementations still
require builds and runtime validation on those systems. Portal shortcuts follow
compositor rules and may be changed in the system dialog. Observing backends do
not consume keyboard input or detect exclusive conflicts with other applications.

## Documentation

- [Подробное описание API и подключение](docs/API.ru.md)
- [Platform behavior, permissions and limitations](docs/PLATFORMS.md)
- [Запуск примера и сценарии проверки](docs/TESTING.ru.md)

The example includes shortcut recording, a key picker (including F13–F24),
modifier selection, multiple bindings, suspension, live action indicators and
an event log. It tests callbacks without accessing your microphone.

Local path dependency:

```yaml
smart_hotkeys:
  path: ../smart_hotkeys_flutter_package
```

Publication is disabled with `publish_to: none`; nothing has been published.
