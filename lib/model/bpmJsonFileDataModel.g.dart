// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bpmJsonFileDataModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonFileDataModel _$JsonFileDataModelFromJson(Map<String, dynamic> json) =>
    JsonFileDataModel(
      fileName: json['fileName'] as String,
      content: json['content'] as String,
      time: (json['time'] as num).toInt(),
    );

Map<String, dynamic> _$JsonFileDataModelToJson(JsonFileDataModel instance) =>
    <String, dynamic>{
      'fileName': instance.fileName,
      'content': instance.content,
      'time': instance.time,
    };
