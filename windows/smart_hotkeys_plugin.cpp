#include "smart_hotkeys_plugin.h"
#include "key_mapping.h"
#include <flutter/standard_method_codec.h>
#include <wtsapi32.h>

namespace smart_hotkeys {
thread_local SmartHotkeysPlugin* SmartHotkeysPlugin::listener_ = nullptr;
constexpr UINT kDispatch = WM_APP + 117;
constexpr UINT kReset = WM_APP + 118;

void SmartHotkeysPlugin::RegisterWithRegistrar(flutter::PluginRegistrarWindows* registrar) {
  auto plugin = std::make_unique<SmartHotkeysPlugin>();
  plugin->channel_ = std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
    registrar->messenger(), "smart_hotkeys", &flutter::StandardMethodCodec::GetInstance());
  plugin->channel_->SetMethodCallHandler([p = plugin.get()](const auto& call, auto result) {
    p->HandleMethodCall(call, std::move(result));
  });
  registrar->AddPlugin(std::move(plugin));
}
SmartHotkeysPlugin::SmartHotkeysPlugin() {
  WNDCLASSW wc{};
  wc.lpfnWndProc = WindowProc;
  wc.hInstance = GetModuleHandle(nullptr);
  wc.lpszClassName = L"SmartHotkeysMessageWindow";
  RegisterClassW(&wc);
  // A hidden top-level window also receives power/session notifications.
  window_ = CreateWindowExW(0, wc.lpszClassName, L"", 0, 0, 0, 0, 0,
    nullptr, nullptr, wc.hInstance, this);
  if (window_) WTSRegisterSessionNotification(window_, NOTIFY_FOR_THIS_SESSION);
}
SmartHotkeysPlugin::~SmartHotkeysPlugin() {
  Stop();
  if (window_) { WTSUnRegisterSessionNotification(window_); DestroyWindow(window_); }
}
void SmartHotkeysPlugin::Seed() {
  for (int i = 0; i < 256; ++i) held_[i] = (GetAsyncKeyState(i) & 0x8000) != 0;
}
void SmartHotkeysPlugin::Queue(KeyEvent event) {
  { std::lock_guard<std::mutex> lock(mutex_); events_.push_back(event); }
  PostMessage(window_, kDispatch, 0, 0);
}
LRESULT CALLBACK SmartHotkeysPlugin::Hook(int code, WPARAM message, LPARAM data) {
  auto p = listener_;
  if (code == HC_ACTION && p) {
    auto key = reinterpret_cast<KBDLLHOOKSTRUCT*>(data);
    bool down = message == WM_KEYDOWN || message == WM_SYSKEYDOWN;
    bool up = message == WM_KEYUP || message == WM_SYSKEYUP;
    if ((down || up) && key->vkCode < 256) {
      // Keep left/right variants separate so releasing one does not release the other.
      DWORD vk = key->vkCode;
      if (vk == VK_CONTROL) vk = (key->flags & LLKHF_EXTENDED) ? VK_RCONTROL : VK_LCONTROL;
      if (vk == VK_MENU) vk = (key->flags & LLKHF_EXTENDED) ? VK_RMENU : VK_LMENU;
      if (vk == VK_SHIFT) vk = key->scanCode == 0x36 ? VK_RSHIFT : VK_LSHIFT;
      if (p->held_[vk] != down) {
        p->held_[vk] = down;
        int modifiers = 0;
        if (p->held_[VK_LCONTROL] || p->held_[VK_RCONTROL]) modifiers |= 1;
        if (p->held_[VK_LMENU] || p->held_[VK_RMENU]) modifiers |= 2;
        if (p->held_[VK_LSHIFT] || p->held_[VK_RSHIFT]) modifiers |= 4;
        if (p->held_[VK_LWIN] || p->held_[VK_RWIN]) modifiers |= 8;
        int usage = KeyUsage(vk, key->scanCode, (key->flags & LLKHF_EXTENDED) != 0);
        if (usage) p->Queue({usage, down, modifiers});
      }
    }
  }
  return CallNextHookEx(nullptr, code, message, data);
}
LRESULT CALLBACK SmartHotkeysPlugin::WindowProc(HWND window, UINT message, WPARAM wparam, LPARAM lparam) {
  if (message == WM_NCCREATE) {
    auto cs = reinterpret_cast<CREATESTRUCT*>(lparam);
    SetWindowLongPtr(window, GWLP_USERDATA, reinterpret_cast<LONG_PTR>(cs->lpCreateParams));
  }
  auto p = reinterpret_cast<SmartHotkeysPlugin*>(GetWindowLongPtr(window, GWLP_USERDATA));
  if (p && message == kDispatch) {
    std::deque<KeyEvent> events;
    { std::lock_guard<std::mutex> lock(p->mutex_); events.swap(p->events_); }
    for (const auto& event : events) {
      if (!p->channel_) continue;
      if (event.key == 0) { p->channel_->InvokeMethod("reset", nullptr); continue; }
      flutter::EncodableMap map{
        {flutter::EncodableValue("key"), flutter::EncodableValue(event.key)},
        {flutter::EncodableValue("down"), flutter::EncodableValue(event.down)},
        {flutter::EncodableValue("modifiers"), flutter::EncodableValue(event.modifiers)}};
      p->channel_->InvokeMethod("key", std::make_unique<flutter::EncodableValue>(map));
    }
    return 0;
  }
  if (p && ((message == WM_WTSSESSION_CHANGE &&
      (wparam == WTS_SESSION_LOCK || wparam == WTS_SESSION_UNLOCK)) ||
      (message == WM_POWERBROADCAST && (wparam == PBT_APMSUSPEND || wparam == PBT_APMRESUMEAUTOMATIC)))) {
    if (p->thread_id_) PostThreadMessage(p->thread_id_, kReset, 0, 0);
  }
  return DefWindowProc(window, message, wparam, lparam);
}
void SmartHotkeysPlugin::Stop() {
  if (thread_.joinable()) {
    PostThreadMessage(thread_id_, WM_QUIT, 0, 0);
    thread_.join();
  }
  if (ready_) { CloseHandle(ready_); ready_ = nullptr; }
  thread_id_ = 0;
  std::lock_guard<std::mutex> lock(mutex_); events_.clear();
}
void SmartHotkeysPlugin::HandleMethodCall(
  const flutter::MethodCall<flutter::EncodableValue>& call,
  std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (call.method_name() == "start") {
    if (thread_.joinable()) { result->Success(flutter::EncodableValue("windows-hook")); return; }
    if (!window_) { result->Error("listener_failed", "Cannot create message window"); return; }
    ready_ = CreateEvent(nullptr, TRUE, FALSE, nullptr);
    if (!ready_) { result->Error("listener_failed", "Cannot create startup event"); return; }
    start_error_ = 0;
    thread_ = std::thread([this] {
      listener_ = this;
      thread_id_ = GetCurrentThreadId();
      MSG msg; PeekMessage(&msg, nullptr, WM_USER, WM_USER, PM_NOREMOVE);
      Seed();
      hook_ = SetWindowsHookEx(WH_KEYBOARD_LL, Hook, GetModuleHandle(nullptr), 0);
      if (!hook_) start_error_ = GetLastError();
      SetEvent(ready_);
      if (hook_) {
        while (GetMessage(&msg, nullptr, 0, 0) > 0) {
          if (msg.message == kReset) { Seed(); Queue({0, false, 0}); }
          else { TranslateMessage(&msg); DispatchMessage(&msg); }
        }
        UnhookWindowsHookEx(hook_); hook_ = nullptr;
      }
      listener_ = nullptr;
    });
    WaitForSingleObject(ready_, INFINITE);
    if (start_error_) { Stop(); result->Error("listener_failed", "SetWindowsHookEx failed: " + std::to_string(start_error_)); }
    else result->Success(flutter::EncodableValue("windows-hook"));
  } else if (call.method_name() == "stop") { Stop(); result->Success(); }
  else result->NotImplemented();
}
}  // namespace smart_hotkeys
