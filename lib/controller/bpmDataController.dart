import 'dart:convert';

import 'package:blood_pressure_monitoring/model/bpmDataModel.dart';
import 'package:blood_pressure_monitoring/page/history/widget/historyItem_bpm.dart';
import 'package:flutter/foundation.dart';
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
  String prevDecoded = "";
  Map<int, BpmDataModel> processedData = {};

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
    currentData.diastolic = null;
    currentData.systolic = null;
    currentData.heartRate = null;
    previousIncomplete = 0;
    buffer = "";
    completedJson.clear();
    processedJson.clear();
    processedData.clear();
    prevDecoded = "";

    currentData.time = DateTime.now().toUtc().millisecondsSinceEpoch;
  }

  Future<void> add(BpmDataModel f) async {
    await db.add(f.toJson(), SembastDb2.BPM);
  }

  Future<void> find(int offset, Function setState) async {
    if (offset == 0) list.clear();
    final r = await db.find(SembastDb2.BPM,
        finder: Finder(
            offset: offset, limit: 50, sortOrders: [SortOrder("time", false)]));

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
        finder: Finder(sortOrders: [SortOrder("time", true)], limit: 1));
    // print(firstData.first["date"]);
    db.delete(Finder(filter: Filter.equals("time", firstData.first["time"])),
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
                Finder(filter: Filter.equals("time", date)), SembastDb2.BPM)));

    if (r != null && r) {
      final m = list[index];
      key.currentState!.removeItem(index, (c, a) {
        return HistoryitemBpm(
            animation: a, fdm: m, isDelete: isDelete, onDelete: () {});
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

  void completeJson(String data, int index, String NewJson) {
    // buffer += data.substring(0, index + 1);

    // print("complete json: ${data.replaceAll("\n", "").replaceAll(" ", "")}");

    // if (buffer.indexOf("{") == -1) return;

   
    if (buffer.isEmpty) {
      final diff = data.length - NewJson.length;

      final completeString = "${NewJson.substring(0, (index - diff) + 1)}";

      // print("complete json: $completeString");

    
      completedJson.add(completeString);
    } else {
      final completeString = "${buffer.substring(buffer.indexOf(
                "{",
              )) + data.substring(0, index + 1)}"
         ;

      // print(
      //     "complete json: ${completeString.replaceAll("\n", "").replaceAll(" ", "")}");

      
      completedJson.add(completeString);
    }

    // print("incomplete complete1: $data");

    // print("incomplete complete: ${completedJson[0]}");

    buffer = "";
  }

  int incompleteJsonCount(String s, {int? previousBracketNum}) {
    int bracketLeft = previousBracketNum ?? 0;
    bool isBracketStart = previousBracketNum != null && previousBracketNum > 0;
    String newJson = "";
    int lastCompleteIndex = 0;

    for (var i = 0; i < s.length; i++) {
      if (s[i] == "{") {
        bracketLeft++;
        // print(
        //   "incomplete: ${s[i]}",
        // );
      } else if (s[i] == "}" && isBracketStart && bracketLeft > 0) {
        bracketLeft--;
        // print(
        //   "incomplete: ${s[i]}",
        // );
      }

      if (!isBracketStart && bracketLeft >= 1) {
        isBracketStart = true;
      }

      if (isBracketStart && bracketLeft == 0) {
        isBracketStart = false;
        completeJson(s, i, newJson);
        newJson = s.substring(i + 1);
        lastCompleteIndex = i + 1;

        // print("final newJson: $newJson");
      }
    }

    // if (newJson.isNotEmpty) {
    //   s = newJson;
    // }else
     if(lastCompleteIndex > 0){
      s = s.substring(lastCompleteIndex);
    }

    if(lastCompleteIndex > 0 && newJson.isEmpty){
      s = "";
    }

    

    // if (s.contains("\"resp\"")) {
    //   print("s contains resp: $s");
    // }

    return bracketLeft;
  }

  void addProcessedJson(int time, String processedString) {
    if (processedJson.containsKey(time)) {
      processedJson[time]!.add(processedString);
    } else {
      processedJson.putIfAbsent(time, () => []);
      processedJson[time]!.add(processedString);
    }

    if (processedJson[time]!.length > 2 && currentData.time == time) {
      add(currentData);
    }
  }

  bool isProcessedJsonComplete(int time) {
    return processedJson[time]!.length == 2;
  }

  void clearProcessedJson(int time) {
    processedJson.remove(time);
  }

  int getTimeInMillisecondUtc(String timeString) {
    return DateTime.parse("${timeString.substring(0, timeString.indexOf("+"))}")
        .toUtc()
        .millisecondsSinceEpoch;
  }

  Future<void> addProcessedData(BpmDataModel d) async {
    if (processedData.containsKey(d.time)) {
      final p = processedData[d.time];

      p!.heartRate = d.heartRate ?? p!.heartRate;
      p!.diastolic = d.diastolic ?? p!.diastolic;
      p!.systolic = d.systolic ?? p!.systolic;

      if (p!.heartRate != null && p!.diastolic != null && p!.systolic != null) {
        await add(p);

        processedData.remove(d.time);
      }

      return;
    }
    processedData.putIfAbsent(d.time, () => d);
  }

  BpmDataModel? processData(List<int> data) {
    // print(data);
    try {
      if (data.contains(0)) {
        final dataClean = data.getRange(0, data.indexOf(0)).toList();
        data = dataClean;
      }

      final decoded = utf8.decode(data, allowMalformed: true);
      // print(
      //   "incomplete: $decoded",
      // );

      if (buffer.isEmpty &&
          !(decoded.replaceAll(" ", "")).contains("{\n\"res")) {
        return null;
      }

      if (prevDecoded == decoded) {
        return null;
      }

      prevDecoded = decoded;

      // print(
      //   "incomplete: $decoded",
      // );

      if (decoded.isNotEmpty) {
        int incompleteJsonNum = incompleteJsonCount(decoded,
            previousBracketNum: previousIncomplete);
        // print(
        //   "incomplete num: $incompleteJsonNum",
        // );

        previousIncomplete = incompleteJsonNum;

        buffer += decoded;

        // print(
        //   "prev incomplete: $previousIncomplete",
        // );
      }

      // print(buffer);

      if (completedJson.isNotEmpty) {
        final processedString = completedJson.removeAt(0);
        // print(
        //   "processed Json incomplete: ${processedString.substring(processedString.indexOf(",\n    \"div\" :"), processedString.indexOf("</div>\"\n") + 8)}",
        // );

        final replacedStering =
            processedString.replaceAll(" ", "").replaceAll("\n", "").replaceAll("{\"resp\":\"alldatasent\"}", "");
        Map<String, dynamic> json =
            jsonDecode(replacedStering.indexOf(",\"div\":") == -1
                ? processedString
                : (replacedStering.replaceAll(
                    replacedStering.substring(
                        replacedStering.indexOf(",\"div\":"),
                        replacedStering.indexOf("</div>\"") + 7),
                    "",
                  )));

        // print(
        //   "processed Json: $json",
        // );

        if (json.containsKey("component")) {
          currentData.systolic = json["component"][0]["valueQuantity"]["value"];
          currentData.diastolic =
              json["component"][1]["valueQuantity"]["value"];
          String timeString = (json["effectiveDateTime"] as String);
          int time = getTimeInMillisecondUtc(timeString);
          currentData.time = time;

          addProcessedJson(time, processedString);

          return BpmDataModel(
              time: time,
              diastolic: currentData.diastolic,
              systolic: currentData.systolic,
              heartRate: null);
        } else if (json.containsKey("valueQuantity")) {
          currentData.heartRate = json["valueQuantity"]["value"];
          String timeString = (json["effectiveDateTime"] as String);
          int time = getTimeInMillisecondUtc(timeString);
          currentData.time = time;

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
      if (kDebugMode) {
        print(e);
      }
      return null;
    }

    return null;
  }
}
