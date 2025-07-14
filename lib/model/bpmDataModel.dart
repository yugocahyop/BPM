import 'package:json_annotation/json_annotation.dart';

part 'bpmDataModel.g.dart';

@JsonSerializable()
class BpmDataModel {
  int? systolic;
  int? diastolic;
  int? heartRate;
  int time;

  BpmDataModel({
    required this.systolic,
    required this.diastolic,
    required this.heartRate,
    required this.time,
  });

  factory BpmDataModel.fromJson(Map<String, dynamic> json) =>
      _$BpmDataModelFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$BpmDataModelToJson(this);
}
