// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bpmEepromJsonFileDataModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EepromJsonFileDataModel _$EepromJsonFileDataModelFromJson(
        Map<String, dynamic> json) =>
    EepromJsonFileDataModel(
      dataId: (json['dataId'] as num).toInt(),
      fileName: json['fileName'] as String,
      content: json['content'] as String,
      time: (json['time'] as num).toInt(),
    );

Map<String, dynamic> _$EepromJsonFileDataModelToJson(
        EepromJsonFileDataModel instance) =>
    <String, dynamic>{
      'dataId': instance.dataId,
      'fileName': instance.fileName,
      'content': instance.content,
      'time': instance.time,
    };
