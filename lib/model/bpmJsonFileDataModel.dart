import 'package:json_annotation/json_annotation.dart';

part 'bpmJsonFileDataModel.g.dart';

@JsonSerializable()
class JsonFileDataModel {
  String fileName;
  String content;
  int time;

  JsonFileDataModel({
    required this.fileName,
    required this.content,
    required this.time,
  });

  factory JsonFileDataModel.fromJson(Map<String, dynamic> json) =>
      _$JsonFileDataModelFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$JsonFileDataModelToJson(this);
}
