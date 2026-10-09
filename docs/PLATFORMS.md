# Platform behavior and validation

| Backend | Implementation | Validation on this machine |
|---|---|---|
| Windows | WH_KEYBOARD_LL on a dedicated native message thread; queued delivery on the Flutter platform thread | Windows build and Dart transition tests |
| Linux X11 | XInput2 raw keyboard events, XKB physical key names, GLib fd source | Source implemented; Linux build/runtime not yet verified |
| Linux Wayland | D-Bus GlobalShortcuts portal, one session per runtime binding | Source implemented; desktop portal integration not yet verified |
| macOS | Passive CGEvent session tap, keyDown/keyUp/flagsChanged | Source implemented; macOS build/runtime not yet verified |

## Windows

No keyboard input is swallowed. The hook callback only maintains key state and
queues events; user callbacks run in Dart outside the hook. This avoids blocking
the native hook with Flutter work. Keyboard state is seeded at startup so a
previously held key does not activate from autorepeat. Sleep/resume and session
lock/unlock reset active actions. Secure desktop, protected applications,
integrity-level restrictions, and system-reserved combinations are outside the
guarantee. F13–F24 are handled explicitly even for injected virtual-key input.

## Ubuntu and other Linux desktops

X11: install `libx11-dev` and `libxi-dev` in addition to the normal Flutter Linux
build dependencies. The plugin uses physical XKB key names, not ASCII text or
an assumption that all keycodes equal evdev+8. Raw observation preserves input
in the focused app and does not reserve combinations. Autorepeat presses are
filtered using XInput2 flags. Multiple physical keyboards are treated as one
logical keyboard; simultaneous identical keys from different devices are not
independently tracked. Unplugging a held key may require pause/resume or shutdown.

Wayland: XWayland cannot observe global keys from Wayland-native applications.
The package therefore selects the portal whenever WAYLAND_DISPLAY is nonempty
or XDG_SESSION_TYPE is wayland. The desktop must implement
`org.freedesktop.portal.GlobalShortcuts`. Ubuntu is not a single fixed backend:
availability depends on the Ubuntu/GNOME version and installed portal provider.
If unavailable, registration returns `unsupported`; there is no fallback that
pretends XWayland is global. An Xorg login session is the available alternative.

Each portal registration can show an OS permission/configuration dialog. The
requested trigger is a preference; the user/compositor can choose another one.
The package's `Hotkey.label` describes the requested trigger and is not proof of
the portal's final choice. Consult the OS dialog for the effective shortcut.
The portal uses logical XKB symbols; physical position and keyboard-layout
independence are not guaranteed on Wayland. Release timing/modifier semantics
are also controlled by the compositor. pause suppresses callbacks but does not
unbind the portal shortcut or override the compositor's input consumption.

## macOS

Enable Input Monitoring in System Settings → Privacy & Security for the final
application. Permission belongs to the host app identity; restart after granting
it if necessary. An initial denied request returns `permission_denied` and may
open the system permission prompt. No administrator/root execution is required.
The event tap is listen-only and leaves keyboard events intact. A disabled tap
resets active actions before being reenabled; sleep/wake also resets actions.
Standard ANSI keys and F1–F20 are mapped; F21–F24 have no standard Apple keycode
and explicitly fail. Caps Lock, Fn, media keys and non-ANSI extra positions are
not primary keys in this version. Sandbox / App Store acceptance requires
separate validation by the host application developer.

## Privacy and lifecycle

The Windows example successfully starts the native listener (`windows-hook`).
Automated UI input on the development machine was blocked by the Windows
automation helper (`GetCursorPos: access denied`); real key transitions and
minimized-window behavior still need the manual checklist in TESTING.ru.md.

Native observation necessarily sees keyboard transitions globally. The plugin
forwards supported physical key usages, modifier masks and down/up booleans to
the host process; it does not capture text, persist raw input, or send it over
the network. Only shortcut transitions are exposed through the public event
stream. The example stores only shortcut IDs / transitions in its in-memory log.
pause keeps monitoring so held-key state stays correct. shutdown removes the
listener. Closing the process stops all hotkeys; minimize does not.

## Platform references

- [Microsoft LowLevelKeyboardProc](https://learn.microsoft.com/en-us/windows/win32/winmsg/lowlevelkeyboardproc)
- [XInput2 protocol](https://www.x.org/releases/current/doc/inputproto/XI2proto.txt)
- [GlobalShortcuts portal](https://flatpak.github.io/xdg-desktop-portal/docs/doc-org.freedesktop.portal.GlobalShortcuts.html)
- [Shortcut trigger specification](https://specifications.freedesktop.org/shortcuts/latest/)
- [Apple CGEvent](https://developer.apple.com/documentation/coregraphics/cgevent)
- [Discord push-to-talk](https://support.discord.com/hc/en-us/articles/211376518-Voice-Input-Modes-101-Push-to-Talk-Voice-Activated)
