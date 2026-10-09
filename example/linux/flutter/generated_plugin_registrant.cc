//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <smart_hotkeys/smart_hotkeys_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) smart_hotkeys_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "SmartHotkeysPlugin");
  smart_hotkeys_plugin_register_with_registrar(smart_hotkeys_registrar);
}
