// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_preview_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotePreviewModel _$NotePreviewModelFromJson(Map<String, dynamic> json) =>
    NotePreviewModel(
      uuid: json['uuid'] as String,
      createdDate: DateTime.parse(json['createdDate'] as String),
      contentPreview: json['contentPreview'] as String,
      folderUuid: json['folderUuid'] as String?,
      isPinned: json['isPinned'] as bool,
    );

Map<String, dynamic> _$NotePreviewModelToJson(NotePreviewModel instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'contentPreview': instance.contentPreview,
      'createdDate': instance.createdDate.toIso8601String(),
      'folderUuid': instance.folderUuid,
      'isPinned': instance.isPinned,
    };
