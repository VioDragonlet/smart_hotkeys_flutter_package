// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hotkey.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Hotkey _$HotkeyFromJson(Map<String, dynamic> json) => _Hotkey(
  usbHidUsage: (json['usbHidUsage'] as num).toInt(),
  modifiers: (json['modifiers'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$HotkeyToJson(_Hotkey instance) => <String, dynamic>{
  'usbHidUsage': instance.usbHidUsage,
  'modifiers': instance.modifiers,
};
