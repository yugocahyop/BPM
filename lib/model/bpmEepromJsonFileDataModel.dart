import 'package:json_annotation/json_annotation.dart';

part 'bpmEepromJsonFileDataModel.g.dart';

@JsonSerializable()
class EepromJsonFileDataModel {
  int dataId;
  String fileName;
  String content;
  int time;

  EepromJsonFileDataModel({
    required this.dataId,
    required this.fileName,
    required this.content,
    required this.time,
  });

  factory EepromJsonFileDataModel.fromJson(Map<String, dynamic> json) =>
      _$EepromJsonFileDataModelFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$EepromJsonFileDataModelToJson(this);
}
