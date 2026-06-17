import 'package:json_annotation/json_annotation.dart';

part 'system_settings_model.g.dart';

@JsonSerializable()
class SystemSettingsModel {
  @JsonKey(defaultValue: false)
  final bool theme;
  @JsonKey(defaultValue: false)
  final bool viewMode;

  SystemSettingsModel({
    required this.theme,
    required this.viewMode,
  });

  factory SystemSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$SystemSettingsModelFromJson(json);
  Map<String, dynamic> toJson() => _$SystemSettingsModelToJson(this);

  SystemSettingsModel copyWith({
    bool? theme,
    bool? viewMode,
  }) {
    return SystemSettingsModel(
      theme: theme ?? this.theme,
      viewMode: viewMode ?? this.viewMode,
    );
  }
}
