# API smart_hotkeys

Пакет регистрирует глобальные клавиатурные сочетания с отдельными `onPressed` и
`onReleased`. Окно может быть неактивным или свёрнутым; процесс должен продолжать
работать. Пакет не управляет микрофоном и не сохраняет назначения автоматически.

## Подключение локальной версии

```yaml
dependencies:
  flutter_riverpod: ^3.0.0
  smart_hotkeys:
    path: ../smart_hotkeys_flutter_package
```

Корневой виджет приложения оберните в `ProviderScope`. Используйте один
контроллер из одного `ProviderScope`/`ProviderContainer` на Flutter engine.
Нативный MethodChannel общий для engine; независимые контейнеры для этого API
в одном engine не поддерживаются. Пакет предназначен для desktop и основного isolate.

```dart
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_hotkeys/smart_hotkeys.dart';

// В ConsumerWidget / ConsumerState / Riverpod notifier:
final hotkeys = ref.read(smartHotkeysProvider.notifier);

await hotkeys.register(
  id: 'push_to_talk',
  hotkey: Hotkey.fromKey(PhysicalKeyboardKey.f13),
  onPressed: () => microphone.setTransmitting(true),
  onReleased: () => microphone.setTransmitting(false),
);
```

`microphone` в примере — ваш сервис. `register` сам инициализирует backend.
Если хотите заранее проверить разрешения, вызовите `await hotkeys.initialize()`.
Не регистрируйте сочетания из `build`: используйте lifecycle приложения или
явное действие пользователя. `onPressed` и `onReleased` имеют тип `VoidCallback`.
Если запускаете асинхронную работу, самостоятельно обработайте её ошибки и порядок;
контроллер не ожидает завершения Future внутри callback. Для задержки выключения
микрофона используйте свой таймер и отменяйте его при следующем нажатии.

## Комбинации

```dart
final combination = Hotkey.fromKey(
  PhysicalKeyboardKey.space,
  modifiers: {
    HotkeyModifier.control,
    HotkeyModifier.alt,
    HotkeyModifier.shift,
  },
);
```

Одна основная клавиша и 0–4 модификатора. Left/Right Ctrl, Alt, Shift и Meta
эквивалентны. Meta — Win на Windows, Command на macOS, Super на Linux.
Caps Lock / Num Lock не влияют на совпадение. Список поддерживаемых основных
клавиш доступен в `supportedHotkeyKeys`: буквы, цифры верхнего ряда, обычные
знаки ANSI, Enter, Escape, Backspace, Tab, Space, навигация и F1–F24.
Numpad, мультимедийные кнопки, мышь, комбинации нескольких обычных клавиш и
модификаторы без основной клавиши в 0.1 не поддерживаются.
На macOS стандартные keycode доступны только для F1–F20; F21–F24 возвращают
`unsupported_key`. Windows поддерживает весь диапазон F13–F24.

### Точное правило нажатия / отпускания

1. Нажатие основной клавиши при точном наборе модификаторов вызывает `onPressed`.
2. Удержание и автоповтор не создают дополнительных `onPressed`.
3. Отпускание основной клавиши **или любого обязательного модификатора** вызывает
   один `onReleased`. Когда удерживаются обе стороны модификатора, отпускание
   одной стороны не завершает сочетание, если вторая всё ещё нажата.
4. Добавление лишнего модификатора после активации не завершает действие.
5. Если действие завершилось из-за модификатора, повторное нажатие модификатора
   при удерживаемой основной клавише не активирует действие. Отпустите и снова
   нажмите основную клавишу.

Это явно заданная семантика пакета, а не обещание побитовой копии Discord.
На Wayland моменты активации / деактивации определяет compositor через портал;
детали правил модификаторов могут отличаться.

## Пауза при настройке

```dart
final wasPaused = ref.read(smartHotkeysProvider).paused;
hotkeys.pause();
try {
  // Запись клавиш вашим UI. Сохранение / перерегистрация назначения.
} finally {
  if (!wasPaused) hotkeys.resume();
}
```

`pause()` синхронно отпускает активные действия и блокирует новые callback.
Фоновое наблюдение продолжает отслеживать удерживаемые клавиши.
`resume()` не активирует клавишу, удерживаемую через паузу: её нужно отпустить
и нажать снова. Повторные pause/resume допустимы. Пауза общая и не имеет счётчика
вложенности: координируйте несколько страниц настройки самостоятельно.

Запись сочетания в вашем окне можно делать через `Focus.onKeyEvent` и
`HardwareKeyboard.instance`. Используйте `event.physicalKey` и игнорируйте
`KeyRepeatEvent`. В примере запись завершается при отпускании основной клавиши,
а пауза сохраняется до кнопки «Добавить» или «Отменить». На Wayland при
регистрации портал дополнительно показывает системный диалог назначения.

## Удаление и завершение

```dart
await hotkeys.unregister('push_to_talk');
await hotkeys.shutdown();
```

`unregister` отпускает активное действие и удаляет одну регистрацию; неизвестный
ID допустим. Для изменения сочетания удалите старый ID и зарегистрируйте новый.
При ошибке новой регистрации старое сочетание не восстанавливается автоматически.
`shutdown` отпускает всё, удаляет назначения и выключает backend. После него
можно снова вызывать initialize/register. Перед завершением вашего сервиса
предпочтительно явно дождаться shutdown. При уничтожении контейнера release
для активных действий вызывается в следующей microtask; callback не должен
обращаться к уже уничтоженным сервисам.

## Состояние и журнал

```dart
final state = ref.watch(smartHotkeysProvider);
// state.initialized, paused, backend, bindings, activeIds

final subscription = hotkeys.events.listen((event) {
  print('${event.id}: ${event.pressed}, reason=${event.reason}');
});
// Позже: await subscription.cancel();
```

`HotkeyEvent` содержит `id`, `pressed` и `reason`. При press reason = null.
Причины release: `released`, `paused`, `unregistered`, `backendReset`, `disposed`.
shutdown сначала вызывает pause, поэтому его release имеют reason `paused`.
События доставляются асинхронно, в порядке возникновения; callback выполняется
при обработке перехода. История не сохраняется и не воспроизводится новым подписчикам.
Исключение синхронного callback передаётся в `FlutterError.reportError`; остальные
регистрации продолжают работать. Это также относится к ошибкам потока backend:
контроллер ставит хоткеи на паузу и сообщает ошибку. Для восстановления после
закрытия портальной сессии вызовите shutdown и заново зарегистрируйте назначения.

## Ошибки

Операции initialize/register/unregister/shutdown возвращают Future: ожидайте их
и обрабатывайте исключения. Изменения регистраций выполняются последовательно.

| Код / тип | Значение |
|---|---|
| `ArgumentError` | Пустой ID, неизвестная клавиша или неверная маска модификаторов |
| `conflict` | Этот ID или такое сочетание уже есть в данном контроллере |
| `permission_denied` | macOS не разрешает глобальное наблюдение клавиатуры |
| `unsupported_key` | F21–F24 на macOS |
| `unsupported` | Нет X11/XInput2 или подходящего GlobalShortcuts portal |
| `listener_failed` | Не удалось установить Windows hook |
| `cancelled` | Пользователь отменил диалог портала |
| `registration_failed` | Портал отклонил / не вернул назначение |
| `timeout` | Системный диалог не ответил за две минуты |
| `session_closed` | Портальная сессия закрыта, хоткеи поставлены на паузу |

Платформенные коды передаются через `PlatformException`. Сбой соединения D-Bus
во время операций также может вернуть исходное исключение библиотеки dbus.
Для мониторинга Windows/X11/macOS сочетания не резервируются эксклюзивно.
Нельзя достоверно диагностировать конфликт с чужой программой: обе могут
получить событие. Системные сочетания вроде Ctrl+Alt+Delete, secure desktop и
специальные аппаратные Fn-комбинации не обещаются.

## Сохранение

```dart
final json = combination.toJson();
final restored = Hotkey.fromJson(json);
restored.validate();
```

Формат: `{"usbHidUsage": 458856, "modifiers": 0}` для F13.
Сохраняйте назначения и соответствующие ID в своём хранилище. Callback-функции
в JSON не входят: подключайте их при регистрации после загрузки.
