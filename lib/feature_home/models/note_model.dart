import 'package:json_annotation/json_annotation.dart';

part 'note_model.g.dart';

@JsonSerializable()
class NoteModel {
  String uuid;
  String content;
  DateTime createdDate;
  DateTime updatedDate;
  bool pinned;

  NoteModel({
    required this.uuid,
    required this.content,
    required this.createdDate,
    required this.updatedDate,
    required this.pinned,
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
      pinned: pinned ?? this.pinned,
    );
  }
}
