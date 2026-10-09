#include "include/smart_hotkeys/smart_hotkeys_plugin.h"
#include "key_mapping.h"
#include <flutter_linux/flutter_linux.h>
#include <glib-unix.h>
#include <X11/extensions/XInput2.h>
#include <cstring>

#define SMART_HOTKEYS_PLUGIN(obj) (G_TYPE_CHECK_INSTANCE_CAST((obj), smart_hotkeys_plugin_get_type(), SmartHotkeysPlugin))
struct _SmartHotkeysPlugin {
  GObject parent_instance;
  FlMethodChannel* channel;
  Display* display;
  guint source;
  int opcode;
  int usages[256];
  bool held[256];
};
G_DEFINE_TYPE(SmartHotkeysPlugin, smart_hotkeys_plugin, g_object_get_type())
static void emit_reset(SmartHotkeysPlugin* self) {
  fl_method_channel_invoke_method(self->channel, "reset", nullptr, nullptr, nullptr, nullptr);
}
static void load_map(SmartHotkeysPlugin* self) {
  std::memset(self->usages, 0, sizeof(self->usages));
  auto keyboard = XkbGetKeyboard(self->display, XkbAllComponentsMask, XkbUseCoreKbd);
  if (keyboard && keyboard->names && keyboard->names->keys) {
    for (int code = keyboard->min_key_code; code <= keyboard->max_key_code; ++code)
      self->usages[code] = X11KeyUsage(keyboard->names->keys[code].name);
  }
  if (keyboard) XkbFreeKeyboard(keyboard, XkbAllComponentsMask, True);
  char keys[32]; XQueryKeymap(self->display, keys);
  for (int i = 0; i < 256; ++i) self->held[i] = (keys[i/8] & (1 << (i%8))) != 0;
}
static gboolean read_events(gint, GIOCondition condition, gpointer data) {
  auto self = SMART_HOTKEYS_PLUGIN(data);
  if (condition & (G_IO_HUP | G_IO_ERR)) { self->source = 0; emit_reset(self); return G_SOURCE_REMOVE; }
  while (XPending(self->display)) {
    XEvent event; XNextEvent(self->display, &event);
    if (event.type == MappingNotify) { load_map(self); emit_reset(self); continue; }
    if (event.type != GenericEvent || event.xcookie.extension != self->opcode || !XGetEventData(self->display, &event.xcookie)) continue;
    if (event.xcookie.evtype == XI_RawKeyPress || event.xcookie.evtype == XI_RawKeyRelease) {
      auto raw = static_cast<XIRawEvent*>(event.xcookie.data);
      int code = raw->detail;
      bool down = event.xcookie.evtype == XI_RawKeyPress;
      if (code >= 0 && code < 256 && !(down && (raw->flags & XIKeyRepeat)) && self->held[code] != down) {
        self->held[code] = down;
        int modifiers = 0;
        for (int i = 0; i < 256; ++i) {
          if (!self->held[i]) continue;
          switch (self->usages[i]) {
            case 0x700e0: case 0x700e4: modifiers |= 1; break;
            case 0x700e2: case 0x700e6: modifiers |= 2; break;
            case 0x700e1: case 0x700e5: modifiers |= 4; break;
            case 0x700e3: case 0x700e7: modifiers |= 8; break;
          }
        }
        if (self->usages[code]) {
          g_autoptr(FlValue) value = fl_value_new_map();
          fl_value_set_string_take(value, "key", fl_value_new_int(self->usages[code]));
          fl_value_set_string_take(value, "down", fl_value_new_bool(down));
          fl_value_set_string_take(value, "modifiers", fl_value_new_int(modifiers));
          fl_method_channel_invoke_method(self->channel, "key", value, nullptr, nullptr, nullptr);
        }
      }
    }
    XFreeEventData(self->display, &event.xcookie);
  }
  return G_SOURCE_CONTINUE;
}
static void stop(SmartHotkeysPlugin* self) {
  if (self->source) { g_source_remove(self->source); self->source = 0; }
  if (self->display) { XCloseDisplay(self->display); self->display = nullptr; }
}
static void method_call_cb(FlMethodChannel*, FlMethodCall* call, gpointer data) {
  auto self = SMART_HOTKEYS_PLUGIN(data);
  const gchar* method = fl_method_call_get_name(call);
  if (std::strcmp(method, "start") == 0) {
    if (g_strcmp0(g_getenv("XDG_SESSION_TYPE"), "wayland") == 0 || g_getenv("WAYLAND_DISPLAY")) {
      fl_method_call_respond_error(call, "unsupported", "Use GlobalShortcuts portal on Wayland", nullptr, nullptr); return;
    }
    if (!self->display) {
      self->display = XOpenDisplay(nullptr);
      int event, error, major = 2, minor = 0;
      if (!self->display || !XQueryExtension(self->display, "XInputExtension", &self->opcode, &event, &error) ||
          XIQueryVersion(self->display, &major, &minor) != Success) {
        stop(self); fl_method_call_respond_error(call, "unsupported", "X11 with XInput2 is required", nullptr, nullptr); return;
      }
      load_map(self);
      unsigned char mask[XIMaskLen(XI_RawKeyRelease)]{};
      XISetMask(mask, XI_RawKeyPress); XISetMask(mask, XI_RawKeyRelease);
      XIEventMask events{XIAllMasterDevices, sizeof(mask), mask};
      XISelectEvents(self->display, DefaultRootWindow(self->display), &events, 1);
      XFlush(self->display);
      self->source = g_unix_fd_add(ConnectionNumber(self->display), static_cast<GIOCondition>(G_IO_IN | G_IO_HUP | G_IO_ERR), read_events, self);
    }
    g_autoptr(FlValue) result = fl_value_new_string("x11-xinput2");
    fl_method_call_respond_success(call, result, nullptr);
  } else if (std::strcmp(method, "stop") == 0) {
    stop(self); fl_method_call_respond_success(call, nullptr, nullptr);
  } else fl_method_call_respond_not_implemented(call, nullptr);
}
static void smart_hotkeys_plugin_dispose(GObject* object) {
  stop(SMART_HOTKEYS_PLUGIN(object));
  G_OBJECT_CLASS(smart_hotkeys_plugin_parent_class)->dispose(object);
}
static void smart_hotkeys_plugin_class_init(SmartHotkeysPluginClass* klass) {
  G_OBJECT_CLASS(klass)->dispose = smart_hotkeys_plugin_dispose;
}
static void smart_hotkeys_plugin_init(SmartHotkeysPlugin*) {}
void smart_hotkeys_plugin_register_with_registrar(FlPluginRegistrar* registrar) {
  auto plugin = SMART_HOTKEYS_PLUGIN(g_object_new(smart_hotkeys_plugin_get_type(), nullptr));
  g_autoptr(FlStandardMethodCodec) codec = fl_standard_method_codec_new();
  g_autoptr(FlMethodChannel) channel = fl_method_channel_new(fl_plugin_registrar_get_messenger(registrar), "smart_hotkeys", FL_METHOD_CODEC(codec));
  plugin->channel = channel;
  fl_method_channel_set_method_call_handler(channel, method_call_cb, plugin, g_object_unref);
}
