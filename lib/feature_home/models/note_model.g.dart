// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NoteModel _$NoteModelFromJson(Map<String, dynamic> json) => NoteModel(
  uuid: json['uuid'] as String,
  // title: json['title'] as String,
  content: json['content'] as String,
  createdDate: DateTime.parse(json['createdDate'] as String),
  updatedDate: DateTime.parse(json['updatedDate'] as String),
);

Map<String, dynamic> _$NoteModelToJson(NoteModel instance) => <String, dynamic>{
  'uuid': instance.uuid,
  // 'title': instance.title,
  'content': instance.content,
  'createdDate': instance.createdDate.toIso8601String(),
  'updatedDate': instance.updatedDate.toIso8601String(),
};
