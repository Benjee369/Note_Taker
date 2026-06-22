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
      noteFontSettings: NoteFontSettings.fromJson(
          json['noteFontSettings'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SystemSettingsModelToJson(
        SystemSettingsModel instance) =>
    <String, dynamic>{
      'theme': instance.theme,
      'viewMode': instance.viewMode,
      'sideBarWidth': instance.sideBarWidth,
      'themeColorName': instance.themeColorName,
      'noteFontSettings': instance.noteFontSettings,
    };

NoteFontSettings _$NoteFontSettingsFromJson(Map<String, dynamic> json) =>
    NoteFontSettings(
      fontSize: (json['fontSize'] as num?)?.toDouble() ?? 16,
      isFontWeighted: json['isFontWeighted'] as bool? ?? false,
      fontHeight: (json['fontHeight'] as num?)?.toDouble() ?? 1.2,
    );

Map<String, dynamic> _$NoteFontSettingsToJson(NoteFontSettings instance) =>
    <String, dynamic>{
      'fontSize': instance.fontSize,
      'isFontWeighted': instance.isFontWeighted,
      'fontHeight': instance.fontHeight,
    };
