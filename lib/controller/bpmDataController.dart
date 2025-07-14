import 'dart:convert';

import 'package:blood_pressure_monitoring/model/bpmDataModel.dart';
import 'package:flutter/material.dart';
import 'package:sembast/sembast.dart';

import '../tools/sembast2.dart';
import '../widget/dialogBox_xirkabit.dart';
import 'controller.dart';

typedef RemovedItemBuilder<T> = Widget Function(
    T item, BuildContext context, Animation<double> animation);

class BPMDataController {
  late BpmDataModel currentData;
  late SembastDb2 db;
  List<BpmDataModel> list = [];
  bool isDelete = false;
  int max = 0;
  String buffer = "";
  int previousIncomplete = 0;
  List<String> completedJson = [];
  Map<int, List<String>> processedJson = {};

  BPMDataController() {
    db = SembastDb2();

    currentData = BpmDataModel(
        time: DateTime.now().millisecondsSinceEpoch,
        diastolic: 0,
        systolic: 0,
        heartRate: 0);
    count();
  }

  void reset() {
    currentData.diastolic = 0;
    currentData.systolic = 0;
    currentData.heartRate = 0;
  }

  add(BpmDataModel f) {
    db.add(f.toJson(), SembastDb2.BPM);
  }

  Future<void> find(int offset, Function setState) async {
    if (offset == 0) list.clear();
    final r = await db.find(SembastDb2.BPM,
        finder: Finder(
            offset: offset, limit: 50, sortOrders: [SortOrder("date", false)]));

    for (var i = 0; i < r.length; i++) {
      final fh = BpmDataModel.fromJson(r[i].value);
      list.add(fh);
    }

    // list.add(currentData);
    // list.add(currentData);

    setState();
  }

  Future<int> count() async {
    await db.wait();
    max = await db.count(SembastDb2.BPM);
    return max;
  }

  Future<void> deleteFirst() async {
    final firstData = await db.find(SembastDb2.BPM,
        finder: Finder(sortOrders: [SortOrder("date", true)], limit: 1));
    // print(firstData.first["date"]);
    db.delete(Finder(filter: Filter.equals("date", firstData.first["date"])),
        SembastDb2.BPM);
  }

  Future<void> deletePrompt(int index, int date, BuildContext context,
      Function setState, GlobalKey<AnimatedListState> key) async {
    final c = Controller();
    final r = await c.goToDialog(
        context,
        DialogboxXirkabit(
            iconData: Icons.delete_forever_outlined,
            iconBackgroundColor: const Color(0xffC73434),
            title: "Are you sure want to delete your file?",
            subtitle: "you will not be able to recover them afterwards.",
            textButton1: "Yes, delete",
            actionColor: const Color(0xffC73434),
            buttonAction1: () => db.delete(
                Finder(filter: Filter.equals("date", date)), SembastDb2.BPM)));

    if (r != null && r) {
      final m = list[index];
      key.currentState!.removeItem(index, (c, a) {
        return SizedBox();
      });
      list.removeAt(index);

      setState();
    }
  }

  Future<void> deleteAll(BuildContext context, Function setState) async {
    final c = Controller();
    final r = await c.goToDialog(
        context,
        DialogboxXirkabit(
            iconData: Icons.delete_forever,
            iconBackgroundColor: const Color(0xffC73434),
            title: "Are you sure want to delete all of your files?",
            subtitle: "you will not be able to recover them afterwards.",
            textButton1: "Yes, delete",
            actionColor: const Color(0xffC73434),
            buttonAction1: () => db.delete(Finder(), SembastDb2.BPM)));

    if (r != null && r) {
      list.clear();
      setState();
    }
  }

  void setCurrentData(BpmDataModel fm) {
    currentData.diastolic = fm.diastolic;
    currentData.systolic = fm.systolic;
    currentData.heartRate = fm.heartRate;
  }

  void completeJson(String buffer, String data, int index) {
    buffer += data.substring(0, index + 1);

    completedJson.add(buffer);

    buffer = "";
  }

  int incompleteJsonCount(String s, {int? previousBracketNum}) {
    int bracketLeft = previousBracketNum ?? 0;
    bool isBracketStart = previousBracketNum != null && previousBracketNum > 0;
    String newJson = "";

    for (var i = 0; i < s.length; i++) {
      if (s[i] == "{") {
        bracketLeft++;
      } else if (s[i] == "}") {
        bracketLeft--;
      }

      if (!isBracketStart && bracketLeft >= 1) {
        isBracketStart = true;
      }

      if (isBracketStart && bracketLeft == 0) {
        completeJson(buffer, s, i);
        newJson = s.substring(i + 1);
      }
    }

    if (newJson.isNotEmpty) s = newJson;

    return bracketLeft;
  }

  void addProcessedJson(int time, String processedString) {
    if (processedJson.containsKey(time)) {
      processedJson[time]!.add(processedString);
    } else {
      processedJson.putIfAbsent(time, () => []);
      processedJson[time]!.add(processedString);
    }
  }

  bool isProcessedJsonComplete(int time) {
    return processedJson[time]!.length == 2;
  }

  void clearProcessedJson(int time) {
    processedJson.remove(time);
  }

  int getTimeInMillisecondUtc(String timeString) {
    return DateTime.parse(
            timeString.substring(0, timeString.indexOf("+")) + "Z")
        .toUtc()
        .millisecondsSinceEpoch;
  }

  BpmDataModel? processData(List<int> data) {
    // print(data);
    try {
      if (data.contains(0)) {
        final dataClean = data.getRange(0, data.indexOf(125) + 1).toList();
        data = dataClean;
      }

      final decoded = utf8.decode(data, allowMalformed: true);

      // print(decoded);

      int incompleteJsonNum =
          incompleteJsonCount(decoded, previousBracketNum: previousIncomplete);

      previousIncomplete = incompleteJsonNum;

      buffer += decoded;

      if (completedJson.isNotEmpty) {
        final processedString = completedJson.removeAt(0);
        Map<String, dynamic> json = jsonDecode(processedString);

        if (json.containsKey("component")) {
          currentData.systolic = json["component"][0]["valueQuantity"]["value"];
          currentData.diastolic =
              json["component"][1]["valueQuantity"]["value"];
          String timeString = (json["effectiveDateTime"] as String);
          int time = getTimeInMillisecondUtc(timeString);

          addProcessedJson(time, processedString);

          return BpmDataModel(
              time: time,
              diastolic: currentData.diastolic,
              systolic: currentData.systolic,
              heartRate: null);
        } else {
          currentData.heartRate = json["valueQuantity"]["value"];
          String timeString = (json["effectiveDateTime"] as String);
          int time = getTimeInMillisecondUtc(timeString);

          addProcessedJson(time, processedString);

          return BpmDataModel(
              time: time,
              diastolic: null,
              systolic: null,
              heartRate: currentData.heartRate);
        }
      }

      // print(BPMData.suhu);
    } catch (e) {
      return null;
    }
  }
}
