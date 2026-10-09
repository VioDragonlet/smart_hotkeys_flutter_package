import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_hotkeys/smart_hotkeys.dart';
import 'package:smart_hotkeys/src/hotkey_backend_provider.dart';
import 'package:smart_hotkeys/src/portal_trigger.dart';
import 'fake_hotkey_backend.dart';

void main() {
  late ProviderContainer container;
  late FakeHotkeyBackend backend;
  late SmartHotkeys hotkeys;
  late List<String> calls;
  const f13 = 0x70068;
  const space = 0x7002c;
  setUp(() {
    backend = FakeHotkeyBackend();
    container = ProviderContainer(
      overrides: [hotkeyBackendProvider.overrideWithValue(backend)],
    );
    hotkeys = container.read(smartHotkeysProvider.notifier);
    calls = [];
  });
  tearDown(() async {
    container.dispose();
    await backend.controller.close();
  });
  Future<void> register({
    String id = 'ptt',
    Hotkey key = const Hotkey(usbHidUsage: f13),
  }) => hotkeys.register(
    id: id,
    hotkey: key,
    onPressed: () => calls.add('$id+'),
    onReleased: () => calls.add('$id-'),
  );

  test('one press/release despite keyboard autorepeat', () async {
    await register();
    backend.key(f13, true);
    backend.key(f13, true);
    backend.key(f13, false);
    backend.key(f13, false);
    expect(calls, ['ptt+', 'ptt-']);
  });
  test(
    'exact modifiers at activation; release on required modifier up',
    () async {
      await register(key: const Hotkey(usbHidUsage: space, modifiers: 7));
      backend.key(space, true, 1);
      backend.key(space, false, 1);
      backend.key(space, true, 7);
      backend.key(0x700e0, false, 6);
      backend.key(0x700e0, true, 7);
      backend.key(space, true, 7);
      expect(calls, ['ptt+', 'ptt-']);
      backend.key(space, false, 7);
      backend.key(space, true, 7);
      expect(calls.last, 'ptt+');
    },
  );
  test('extra modifier added during hold does not interrupt action', () async {
    await register();
    backend.key(f13, true);
    backend.key(0x700e1, true, 4);
    expect(calls, ['ptt+']);
    backend.key(f13, false, 4);
    expect(calls.last, 'ptt-');
  });
  test(
    'pause releases active action and resume does not retrigger held key',
    () async {
      await register();
      backend.key(f13, true);
      hotkeys.pause();
      hotkeys.resume();
      backend.key(f13, true);
      expect(calls, ['ptt+', 'ptt-']);
      backend.key(f13, false);
      backend.key(f13, true);
      expect(calls, ['ptt+', 'ptt-', 'ptt+']);
    },
  );
  test(
    'key pressed during pause must be released before resume activation',
    () async {
      await register();
      hotkeys.pause();
      backend.key(f13, true);
      hotkeys.resume();
      backend.key(f13, true);
      expect(calls, isEmpty);
      backend.key(f13, false);
      backend.key(f13, true);
      expect(calls, ['ptt+']);
    },
  );
  test('unregister releases active binding exactly once', () async {
    await register();
    backend.key(f13, true);
    await hotkeys.unregister('ptt');
    backend.key(f13, false);
    expect(calls, ['ptt+', 'ptt-']);
    expect(container.read(smartHotkeysProvider).bindings, isEmpty);
  });
  test('duplicate id or combination errors leave original intact', () async {
    await register();
    await expectLater(register(id: 'other'), throwsA(isA<PlatformException>()));
    await expectLater(
      register(key: const Hotkey(usbHidUsage: space)),
      throwsA(isA<PlatformException>()),
    );
    backend.key(f13, true);
    expect(calls, ['ptt+']);
  });
  test('independent actions can be held simultaneously', () async {
    await register();
    await register(
      id: 'other',
      key: const Hotkey(usbHidUsage: space),
    );
    backend.key(f13, true);
    backend.key(space, true);
    backend.key(f13, false);
    expect(container.read(smartHotkeysProvider).activeIds, {'other'});
    expect(calls, ['ptt+', 'other+', 'ptt-']);
  });
  test('failed registration is atomic and queue recovers', () async {
    backend.failBind = true;
    await expectLater(register(), throwsStateError);
    expect(container.read(smartHotkeysProvider).bindings, isEmpty);
    backend.failBind = false;
    await register();
    backend.key(f13, true);
    expect(calls, ['ptt+']);
  });
  test('failed startup can be retried', () async {
    backend.failStart = true;
    await expectLater(register(), throwsStateError);
    backend.failStart = false;
    await register();
    expect(container.read(smartHotkeysProvider).initialized, true);
  });
  test('shutdown releases and can initialize again', () async {
    await register();
    backend.key(f13, true);
    await hotkeys.shutdown();
    expect(calls, ['ptt+', 'ptt-']);
    expect(backend.stopped, true);
    await register();
    backend.key(f13, true);
    expect(calls.last, 'ptt+');
  });
  test('portal duplicate signals and held pause have same semantics', () async {
    await register();
    backend.portal('ptt', true);
    backend.portal('ptt', true);
    hotkeys.pause();
    hotkeys.resume();
    backend.portal('ptt', true);
    expect(calls, ['ptt+', 'ptt-']);
    backend.portal('ptt', false);
    backend.portal('ptt', true);
    expect(calls.last, 'ptt+');
  });
  test('backend reset releases active actions', () async {
    await register();
    backend.key(f13, true);
    backend.controller.add({'reset': true});
    expect(calls, ['ptt+', 'ptt-']);
  });
  test('dispose releases active actions', () async {
    await register();
    backend.key(f13, true);
    container.dispose();
    await Future<void>.delayed(Duration.zero);
    expect(calls, ['ptt+', 'ptt-']);
  });
  test('JSON roundtrip and Wayland symbols', () {
    final key = Hotkey.fromKey(
      PhysicalKeyboardKey.space,
      modifiers: {
        HotkeyModifier.control,
        HotkeyModifier.alt,
        HotkeyModifier.shift,
      },
    );
    expect(Hotkey.fromJson(key.toJson()), key);
    expect(portalTrigger(key), 'CTRL+ALT+SHIFT+space');
    expect(portalTrigger(const Hotkey(usbHidUsage: 0x70073)), 'F24');
  });
  test('modifier-only or unknown keys fail before startup', () async {
    await expectLater(
      register(key: const Hotkey(usbHidUsage: 0x700e0)),
      throwsArgumentError,
    );
    expect(container.read(smartHotkeysProvider).initialized, false);
  });
}
