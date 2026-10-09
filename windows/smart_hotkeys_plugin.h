#ifndef FLUTTER_PLUGIN_SMART_HOTKEYS_PLUGIN_H_
#define FLUTTER_PLUGIN_SMART_HOTKEYS_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>
#include <windows.h>
#include <array>
#include <deque>
#include <mutex>
#include <thread>

namespace smart_hotkeys {

class SmartHotkeysPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  SmartHotkeysPlugin();

  virtual ~SmartHotkeysPlugin();

  // Disallow copy and assign.
  SmartHotkeysPlugin(const SmartHotkeysPlugin&) = delete;
  SmartHotkeysPlugin& operator=(const SmartHotkeysPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
 private:
  struct KeyEvent { int key; bool down; int modifiers; };
  std::unique_ptr<flutter::MethodChannel<flutter::EncodableValue>> channel_;
  HWND window_ = nullptr;
  HHOOK hook_ = nullptr;
  HANDLE ready_ = nullptr;
  DWORD thread_id_ = 0;
  DWORD start_error_ = 0;
  std::thread thread_;
  std::mutex mutex_;
  std::deque<KeyEvent> events_;
  std::array<bool, 256> held_{};
  static thread_local SmartHotkeysPlugin* listener_;
  static LRESULT CALLBACK Hook(int code, WPARAM message, LPARAM data);
  static LRESULT CALLBACK WindowProc(HWND window, UINT message, WPARAM wparam, LPARAM lparam);
  void Stop();
  void Seed();
  void Queue(KeyEvent event);
};

}  // namespace smart_hotkeys

#endif  // FLUTTER_PLUGIN_SMART_HOTKEYS_PLUGIN_H_
