// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system_settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SystemSettingsModel _$SystemSettingsModelFromJson(Map<String, dynamic> json) =>
    SystemSettingsModel(
      theme: json['theme'] as bool? ?? false,
      viewMode: json['viewMode'] as bool? ?? false,
      sideBarWidth: (json['sideBarWidth'] as num?)?.toDouble() ?? 400,
      themeColorName: json['themeColorName'] as String? ?? 'orange',
    );

Map<String, dynamic> _$SystemSettingsModelToJson(
        SystemSettingsModel instance) =>
    <String, dynamic>{
      'theme': instance.theme,
      'viewMode': instance.viewMode,
      'sideBarWidth': instance.sideBarWidth,
      'themeColorName': instance.themeColorName,
    };
