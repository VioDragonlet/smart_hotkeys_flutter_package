import 'dart:async';
import 'package:dbus/dbus.dart';
import 'package:flutter/services.dart';
import 'hotkey.dart';
import 'hotkey_backend.dart';
import 'portal_trigger.dart';

/// One portal session per registration allows dynamic add/remove on portal v1.
class PortalHotkeyBackend implements HotkeyBackend {
  static const _name = 'org.freedesktop.portal.Desktop';
  static const _interface = 'org.freedesktop.portal.GlobalShortcuts';
  DBusClient? _client;
  DBusRemoteObject? _portal;
  final _events = StreamController<Map<String, Object?>>.broadcast();
  final _sessions = <String, DBusObjectPath>{};
  final _subscriptions = <StreamSubscription<DBusSignal>>[];
  int _token = 0;
  @override
  Stream<Map<String, Object?>> get events => _events.stream;

  @override
  Future<String> start() async {
    _client = DBusClient.session();
    _portal = DBusRemoteObject(
      _client!,
      name: _name,
      path: DBusObjectPath('/org/freedesktop/portal/desktop'),
    );
    try {
      await _portal!.getProperty(
        _interface,
        'version',
        signature: DBusSignature('u'),
      );
      for (final signalName in ['Activated', 'Deactivated']) {
        _subscriptions.add(
          DBusRemoteObjectSignalStream(
            object: _portal!,
            interface: _interface,
            name: signalName,
            signature: DBusSignature('osta{sv}'),
          ).listen((signal) {
            final session = signal.values[0].asObjectPath();
            final id = signal.values[1].asString();
            if (_sessions[id] == session) {
              _events.add({'id': id, 'down': signalName == 'Activated'});
            }
          }, onError: _events.addError),
        );
      }
      _subscriptions.add(
        DBusSignalStream(
          _client!,
          sender: _name,
          interface: 'org.freedesktop.portal.Session',
          name: 'Closed',
        ).listen((signal) {
          if (_sessions.containsValue(signal.path)) {
            _events.add({'reset': true});
            _events.addError(
              PlatformException(
                code: 'session_closed',
                message: 'Portal session closed. Shutdown and register again.',
              ),
            );
          }
        }, onError: _events.addError),
      );
      return 'wayland-portal';
    } catch (error) {
      await stop();
      throw PlatformException(
        code: 'unsupported',
        message:
            'GlobalShortcuts portal is unavailable in this desktop session: $error',
      );
    }
  }

  Future<Map<String, DBusValue>> _request(
    String method,
    List<DBusValue> args, {
    Map<String, DBusValue> options = const {},
  }) async {
    final token = 'smart_${++_token}';
    final sender = _client!.uniqueName.substring(1).replaceAll('.', '_');
    final path = DBusObjectPath(
      '/org/freedesktop/portal/desktop/request/$sender/$token',
    );
    final completer = Completer<DBusSignal>();
    final subscription =
        DBusSignalStream(
          _client!,
          sender: _name,
          path: path,
          interface: 'org.freedesktop.portal.Request',
          name: 'Response',
          signature: DBusSignature('ua{sv}'),
        ).listen(
          (signal) {
            if (!completer.isCompleted) completer.complete(signal);
          },
          onError: (Object error, StackTrace stack) {
            if (!completer.isCompleted) completer.completeError(error, stack);
          },
        );
    try {
      await _portal!.callMethod(_interface, method, [
        ...args,
        DBusDict.stringVariant({...options, 'handle_token': DBusString(token)}),
      ], replySignature: DBusSignature('o'));
      final response = await completer.future.timeout(
        const Duration(minutes: 2),
      );
      final code = response.values[0].asUint32();
      if (code != 0) {
        throw PlatformException(
          code: code == 1 ? 'cancelled' : 'registration_failed',
          message: 'Portal request was rejected ($code)',
        );
      }
      return response.values[1].asStringVariantDict();
    } on TimeoutException {
      await DBusRemoteObject(
        _client!,
        name: _name,
        path: path,
      ).callMethod('org.freedesktop.portal.Request', 'Close', []);
      throw PlatformException(
        code: 'timeout',
        message: 'Portal permission dialog timed out',
      );
    } finally {
      await subscription.cancel();
    }
  }

  @override
  Future<void> bind(String id, Hotkey hotkey) async {
    final created = await _request(
      'CreateSession',
      [],
      options: {'session_handle_token': DBusString('session_${_token + 1}')},
    );
    final session = DBusObjectPath(created['session_handle']!.asString());
    try {
      final result = await _request('BindShortcuts', [
        session,
        DBusArray(DBusSignature('(sa{sv})'), [
          DBusStruct([
            DBusString(id),
            DBusDict.stringVariant({
              'description': DBusString(id),
              'preferred_trigger': DBusString(portalTrigger(hotkey)),
            }),
          ]),
        ]),
        const DBusString(''),
      ]);
      final bound = (result['shortcuts']! as DBusArray).children;
      if (!bound.any(
        (value) => (value as DBusStruct).children[0].asString() == id,
      )) {
        throw PlatformException(
          code: 'registration_failed',
          message: 'Portal did not bind this shortcut',
        );
      }
      _sessions[id] = session;
    } catch (_) {
      await _close(session);
      rethrow;
    }
  }

  Future<void> _close(DBusObjectPath session) async {
    await DBusRemoteObject(
      _client!,
      name: _name,
      path: session,
    ).callMethod('org.freedesktop.portal.Session', 'Close', []);
  }

  @override
  Future<void> unbind(String id) async {
    final session = _sessions.remove(id);
    if (session != null) await _close(session);
  }

  @override
  Future<void> stop() async {
    for (final subscription in _subscriptions) {
      await subscription.cancel();
    }
    _subscriptions.clear();
    final sessions = _sessions.values.toList();
    _sessions.clear();
    for (final session in sessions) {
      try {
        await _close(session);
      } catch (_) {}
    }
    await _client?.close();
    _client = null;
    _portal = null;
  }
}
