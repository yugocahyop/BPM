// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bpmDataModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BpmDataModel _$BpmDataModelFromJson(Map<String, dynamic> json) => BpmDataModel(
      systolic: (json['systolic'] as num).toInt(),
      diastolic: (json['diastolic'] as num).toInt(),
      heartRate: (json['heartRate'] as num).toInt(),
      time: (json['time'] as num).toInt(),
    );

Map<String, dynamic> _$BpmDataModelToJson(BpmDataModel instance) =>
    <String, dynamic>{
      'systolic': instance.systolic,
      'diastolic': instance.diastolic,
      'heartRate': instance.heartRate,
      'time': instance.time,
    };
