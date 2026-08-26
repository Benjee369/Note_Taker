import 'package:json_annotation/json_annotation.dart';

part 'folder_model.g.dart';

@JsonSerializable()
class FolderModel {
  final String uuid;
  final String name;
  final DateTime createdDate;

  FolderModel({
    required this.uuid,
    required this.name,
    required this.createdDate,
  });

  factory FolderModel.fromJson(Map<String, dynamic> json) =>
      _$FolderModelFromJson(json);
  Map<String, dynamic> toJson() => _$FolderModelToJson(this);

  FolderModel copyWith({
    String? uuid,
    String? name,
    DateTime? createdDate,
  }) {
    return FolderModel(
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
      createdDate: createdDate ?? this.createdDate,
    );
  }
}
