cmake_minimum_required(VERSION 3.14)
project(smart_hotkeys LANGUAGES CXX)
cmake_policy(VERSION 3.14...3.25)
set(PLUGIN_NAME smart_hotkeys_plugin)
add_library(${PLUGIN_NAME} SHARED
  include/smart_hotkeys/smart_hotkeys_plugin_c_api.h
  smart_hotkeys_plugin_c_api.cpp smart_hotkeys_plugin.cpp smart_hotkeys_plugin.h key_mapping.h)
apply_standard_settings(${PLUGIN_NAME})
set_target_properties(${PLUGIN_NAME} PROPERTIES CXX_VISIBILITY_PRESET hidden)
target_compile_definitions(${PLUGIN_NAME} PRIVATE FLUTTER_PLUGIN_IMPL)
target_include_directories(${PLUGIN_NAME} INTERFACE "${CMAKE_CURRENT_SOURCE_DIR}/include")
target_link_libraries(${PLUGIN_NAME} PRIVATE flutter flutter_wrapper_plugin wtsapi32)
set(smart_hotkeys_bundled_libraries "" PARENT_SCOPE)
