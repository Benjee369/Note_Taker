import 'package:json_annotation/json_annotation.dart';

part 'note_model.g.dart';

@JsonSerializable()
class NoteModel {
  final String uuid;
  final String content;
  final DateTime createdDate;
  final DateTime updatedDate;
  @JsonKey(defaultValue: false)
  final bool isPinned;

  NoteModel({
    required this.uuid,
    required this.content,
    required this.createdDate,
    required this.updatedDate,
    required this.isPinned,
  });

  factory NoteModel.fromJson(Map<String, dynamic> json) =>
      _$NoteModelFromJson(json);
  Map<String, dynamic> toJson() => _$NoteModelToJson(this);

  NoteModel copyWith({
    String? uuid,
    String? content,
    DateTime? createDate,
    DateTime? updatedDate,
    bool? pinned,
  }) {
    return NoteModel(
      uuid: uuid ?? this.uuid,
      content: content ?? this.content,
      createdDate: createDate ?? createdDate,
      updatedDate: updatedDate ?? this.updatedDate,
      isPinned: pinned ?? isPinned,
    );
  }
}
