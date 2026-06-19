// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'folder_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FolderModel _$FolderModelFromJson(Map<String, dynamic> json) => FolderModel(
      uuid: json['uuid'] as String,
      name: json['name'] as String,
      createdDate: DateTime.parse(json['createdDate'] as String),
    );

Map<String, dynamic> _$FolderModelToJson(FolderModel instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'name': instance.name,
      'createdDate': instance.createdDate.toIso8601String(),
    };
