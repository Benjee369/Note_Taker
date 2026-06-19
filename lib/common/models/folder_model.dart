import 'package:json_annotation/json_annotation.dart';

part 'folder_model.g.dart';

@JsonSerializable()
class FolderModel {
  final String uuid;
  final String name;
  final DateTime createdDate;

  FolderModel(
    this.uuid,
    this.name,
    this.createdDate,
  );

  factory FolderModel.fromJson(Map<String, dynamic> json) =>
      _$FolderModelFromJson(json);
  Map<String, dynamic> toJson() => _$FolderModelToJson(this);
}
