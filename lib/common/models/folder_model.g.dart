// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'folder_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FolderModel _$FolderModelFromJson(Map<String, dynamic> json) => FolderModel(
      json['uuid'] as String,
      json['name'] as String,
      DateTime.parse(json['createdDate'] as String),
    );

Map<String, dynamic> _$FolderModelToJson(FolderModel instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'name': instance.name,
      'createdDate': instance.createdDate.toIso8601String(),
    };
