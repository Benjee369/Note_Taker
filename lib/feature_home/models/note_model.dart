import 'package:json_annotation/json_annotation.dart';

part 'note_model.g.dart';

@JsonSerializable()
class NoteModel {
  String uuid;
  // String title;
  String content;
  DateTime createdDate;
  DateTime updatedDate;

  NoteModel({
    required this.uuid,
    // required this.title,
    required this.content,
    required this.createdDate,
    required this.updatedDate,
  });
  factory NoteModel.fromJson(Map<String, dynamic> json) => _$NoteModelFromJson(json);
  Map<String, dynamic> toJson()=> _$NoteModelToJson(this);
}
