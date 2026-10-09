#include "include/smart_hotkeys/smart_hotkeys_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "smart_hotkeys_plugin.h"

void SmartHotkeysPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  smart_hotkeys::SmartHotkeysPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
