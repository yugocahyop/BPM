// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bpmEepromModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EepromModel _$BpmEepromModelFromJson(Map<String, dynamic> json) =>
    EepromModel(
      id: (json['id'] as num).toInt(),
      time: (json['time'] as num).toInt(),
    );

Map<String, dynamic> _$BpmEepromModelToJson(EepromModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'time': instance.time,
    };
