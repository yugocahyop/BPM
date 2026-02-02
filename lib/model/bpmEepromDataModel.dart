import 'package:json_annotation/json_annotation.dart';

part 'bpmEepromDataModel.g.dart';

@JsonSerializable()
class EepromDataModel {
  int modelId;
  int id;
  int? systolic;
  int? diastolic;
  int? heartRate;
  int time;

  EepromDataModel({
    required this.id,
    required this.modelId,
    required this.systolic,
    required this.diastolic,
    required this.heartRate,
    required this.time,
  });

  factory EepromDataModel.fromJson(Map<String, dynamic> json) =>
      _$EepromDataModelFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$EepromDataModelToJson(this);
}
