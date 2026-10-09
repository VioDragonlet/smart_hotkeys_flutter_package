import Cocoa
import CoreGraphics
import FlutterMacOS

public class SmartHotkeysPlugin: NSObject, FlutterPlugin {
  private var channel: FlutterMethodChannel!
  private var tap: CFMachPort?
  private var source: CFRunLoopSource?
  private var held = Set<Int64>()
  private var observers: [NSObjectProtocol] = []

  public static func register(with registrar: FlutterPluginRegistrar) {
    let instance = SmartHotkeysPlugin()
    instance.channel = FlutterMethodChannel(name: "smart_hotkeys", binaryMessenger: registrar.messenger)
    registrar.addMethodCallDelegate(instance, channel: instance.channel)
  }
  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "start":
      if tap != nil { result("macos-event-tap"); return }
      if #available(macOS 10.15, *) {
        if !CGPreflightListenEventAccess() {
          _ = CGRequestListenEventAccess()
          result(FlutterError(code: "permission_denied", message: "Enable Input Monitoring for this app in System Settings, then restart the app.", details: nil))
          return
        }
      }
      let mask = (1 << CGEventType.keyDown.rawValue) | (1 << CGEventType.keyUp.rawValue) | (1 << CGEventType.flagsChanged.rawValue)
      let context = Unmanaged.passUnretained(self).toOpaque()
      tap = CGEvent.tapCreate(tap: .cgSessionEventTap, place: .headInsertEventTap,
        options: .listenOnly, eventsOfInterest: CGEventMask(mask), callback: { _, type, event, context in
          guard let context = context else { return Unmanaged.passUnretained(event) }
          let plugin = Unmanaged<SmartHotkeysPlugin>.fromOpaque(context).takeUnretainedValue()
          plugin.handleEvent(type, event)
          return Unmanaged.passUnretained(event)
        }, userInfo: context)
      guard let tap = tap else {
        result(FlutterError(code: "permission_denied", message: "Cannot create keyboard event tap. Check Input Monitoring permissions.", details: nil)); return
      }
      source = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, tap, 0)
      CFRunLoopAddSource(CFRunLoopGetMain(), source, .commonModes)
      seed()
      CGEvent.tapEnable(tap: tap, enable: true)
      for name in [NSWorkspace.willSleepNotification, NSWorkspace.didWakeNotification] {
        observers.append(NSWorkspace.shared.notificationCenter.addObserver(forName: name, object: nil, queue: .main) { [weak self] _ in self?.reset() })
      }
      result("macos-event-tap")
    case "validate":
      let args = call.arguments as? [String: Any]
      let usage = args?["key"] as? Int ?? 0
      if usage >= 0x70070 && usage <= 0x70073 {
        result(FlutterError(code: "unsupported_key", message: "macOS does not provide standard key codes for F21-F24.", details: nil))
      } else { result(nil) }
    case "stop": stop(); result(nil)
    default: result(FlutterMethodNotImplemented)
    }
  }
  private func seed() {
    held = Set((0..<128).filter { CGEventSource.keyState(.combinedSessionState, key: CGKeyCode($0)) }.map { Int64($0) })
  }
  private func reset() { seed(); channel.invokeMethod("reset", arguments: nil) }
  private func handleEvent(_ type: CGEventType, _ event: CGEvent) {
    if type == .tapDisabledByTimeout || type == .tapDisabledByUserInput {
      reset()
      if let tap = tap { CGEvent.tapEnable(tap: tap, enable: true) }
      return
    }
    let code = event.getIntegerValueField(.keyboardEventKeycode)
    let down = type == .flagsChanged ? CGEventSource.keyState(.combinedSessionState, key: CGKeyCode(code)) : type == .keyDown
    if down {
      if !held.insert(code).inserted { return }
    } else { held.remove(code) }
    guard let usage = macKeyUsage[Int(code)] else { return }
    var modifiers = 0
    if event.flags.contains(.maskControl) { modifiers |= 1 }
    if event.flags.contains(.maskAlternate) { modifiers |= 2 }
    if event.flags.contains(.maskShift) { modifiers |= 4 }
    if event.flags.contains(.maskCommand) { modifiers |= 8 }
    channel.invokeMethod("key", arguments: ["key": usage | 0x70000, "down": down, "modifiers": modifiers])
  }
  private func stop() {
    for observer in observers { NSWorkspace.shared.notificationCenter.removeObserver(observer) }
    observers.removeAll()
    if let source = source { CFRunLoopRemoveSource(CFRunLoopGetMain(), source, .commonModes) }
    if let tap = tap { CGEvent.tapEnable(tap: tap, enable: false); CFMachPortInvalidate(tap) }
    source = nil; tap = nil; held.removeAll()
  }
  public func detachFromEngine(for registrar: FlutterPluginRegistrar) { stop() }
  deinit { stop() }
}
