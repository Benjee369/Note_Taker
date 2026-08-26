import 'package:json_annotation/json_annotation.dart';

part 'note_preview_model.g.dart';

@JsonSerializable()
class NotePreviewModel {
  final String uuid;
  final String contentPreview;
  final DateTime createdDate;
  final String? folderUuid;
  final bool isPinned;

  NotePreviewModel({
    required this.uuid,
    required this.createdDate,
    required this.contentPreview,
    this.folderUuid, required this.isPinned,
  });

  factory NotePreviewModel.fromJson(Map<String, dynamic> json) =>
      _$NotePreviewModelFromJson(json);
  Map<String, dynamic> toJson() => _$NotePreviewModelToJson(this);
}
