// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bpmEepromDataModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EepromDataModel _$EepromDataModelFromJson(Map<String, dynamic> json) =>
    EepromDataModel(
      id: (json['id'] as num).toInt(),
      modelId: (json['modelId'] as num).toInt(),
      systolic: (json['systolic'] as num?)?.toInt(),
      diastolic: (json['diastolic'] as num?)?.toInt(),
      heartRate: (json['heartRate'] as num?)?.toInt(),
      time: (json['time'] as num).toInt(),
    );

Map<String, dynamic> _$EepromDataModelToJson(EepromDataModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'modelId': instance.modelId,
      'systolic': instance.systolic,
      'diastolic': instance.diastolic,
      'heartRate': instance.heartRate,
      'time': instance.time,
    };
