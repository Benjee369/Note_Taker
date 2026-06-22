import 'package:json_annotation/json_annotation.dart';

part 'system_settings_model.g.dart';

@JsonSerializable()
class SystemSettingsModel {
  @JsonKey(defaultValue: false)
  final bool theme;
  @JsonKey(defaultValue: false)
  final bool viewMode;
  @JsonKey(defaultValue: 400)
  final double sideBarWidth;
  @JsonKey(defaultValue: 'orange')
  final String themeColorName;
  final NoteFontSettings noteFontSettings;

  SystemSettingsModel({
    required this.theme,
    required this.viewMode,
    required this.sideBarWidth,
    required this.themeColorName,
    required this.noteFontSettings,
  });

  factory SystemSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$SystemSettingsModelFromJson(json);
  Map<String, dynamic> toJson() => _$SystemSettingsModelToJson(this);

  SystemSettingsModel copyWith({
    bool? theme,
    bool? viewMode,
    double? sideBarWidth,
    String? themeColorName,
    NoteFontSettings? noteFontSettings,
  }) {
    return SystemSettingsModel(
      theme: theme ?? this.theme,
      viewMode: viewMode ?? this.viewMode,
      sideBarWidth: sideBarWidth ?? this.sideBarWidth,
      themeColorName: themeColorName ?? this.themeColorName,
      noteFontSettings: noteFontSettings ?? this.noteFontSettings,
    );
  }
}

@JsonSerializable()
class NoteFontSettings {
  @JsonKey(defaultValue: 16)
  final double fontSize;
  @JsonKey(defaultValue: false)
  final bool isFontWeighted;
  @JsonKey(defaultValue: 1.2)
  final double fontHeight;

  NoteFontSettings({
    required this.fontSize,
    required this.isFontWeighted,
    required this.fontHeight,
  });

  factory NoteFontSettings.fromJson(Map<String, dynamic> json) =>
      _$NoteFontSettingsFromJson(json);
  Map<String, dynamic> toJson() => _$NoteFontSettingsToJson(this);

  NoteFontSettings copyWith({
    double? fontSize,
    bool? isFontWeighted,
    double? fontHeight,
  }) {
    return NoteFontSettings(
      fontSize: fontSize ?? this.fontSize,
      isFontWeighted: isFontWeighted ?? this.isFontWeighted,
      fontHeight: fontHeight ?? this.fontHeight,
    );
  }
}
