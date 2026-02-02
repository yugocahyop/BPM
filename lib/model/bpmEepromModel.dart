import 'package:json_annotation/json_annotation.dart';

part 'bpmEepromModel.g.dart';

@JsonSerializable()
class EepromModel {
  int id;
  int time;

  EepromModel({
    required this.id,
    required this.time,
  });

  @override
  String toString() {
    // TODO: implement toString
    return 'EepromModel{id: $id, time: $time}';
  }

  factory EepromModel.fromJson(Map<String, dynamic> json) =>
      _$BpmEepromModelFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$BpmEepromModelToJson(this);
}
