import 'dart:convert';

import 'package:blood_pressure_monitoring/model/bpmDataModel.dart';
import 'package:blood_pressure_monitoring/model/bpmEepromModel.dart';
import 'package:blood_pressure_monitoring/page/eeprom/widget/eepromItem_bpm.dart';
import 'package:blood_pressure_monitoring/page/history/widget/historyItem_bpm.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sembast/sembast.dart';

import '../tools/sembast2.dart';
import '../widget/dialogBox_xirkabit.dart';
import 'controller.dart';

typedef RemovedItemBuilder<T> = Widget Function(
    T item, BuildContext context, Animation<double> animation);

class EepromModelController {
  late EepromModel currentData;
  late SembastDb2 db;
  List<EepromModel> list = [];
  bool isDelete = false;
  int max = 0, lastId = 0;
  String buffer = "";
  int previousIncomplete = 0;
  List<String> completedJson = [];
  Map<int, List<String>> processedJson = {};
  String prevDecoded = "";
  Map<int, EepromModel> processedData = {};

  EepromModelController() {
    db = SembastDb2();

    currentData = EepromModel(
      id: -1,
      time: DateTime.now().millisecondsSinceEpoch,
    );
    getLastId();
    count();
  }

  getLastId() async {
    await db.wait();
    final r = await db.find(SembastDb2.eepromBPM,
        finder: Finder(sortOrders: [SortOrder("id", false)], limit: 1));

    if (r.isNotEmpty) {
      lastId = r.first["id"] as int;
    }
  }

  void reset() {
    currentData.id = -1;

    previousIncomplete = 0;
    buffer = "";
    completedJson.clear();
    processedJson.clear();
    processedData.clear();
    prevDecoded = "";

    currentData.time = DateTime.now().toUtc().millisecondsSinceEpoch;
  }

  add(EepromModel f) {
    db.add(f.toJson(), SembastDb2.eepromBPM);
  }

  Future<void> find(int offset, Function setState) async {
    if (offset == 0) list.clear();
    final r = await db.find(SembastDb2.eepromBPM,
        finder: Finder(
            offset: offset, limit: 50, sortOrders: [SortOrder("time", false)]));

    for (var i = 0; i < r.length; i++) {
      final fh = EepromModel.fromJson(r[i].value);
      list.add(fh);
    }

    // list.add(currentData);
    // list.add(currentData);

    setState();
  }

  Future<int> count() async {
    await db.wait();
    max = await db.count(SembastDb2.eepromBPM);
    return max;
  }

  Future<void> deleteFirst() async {
    final firstData = await db.find(SembastDb2.eepromBPM,
        finder: Finder(sortOrders: [SortOrder("time", true)], limit: 1));
    // print(firstData.first["date"]);
    db.delete(Finder(filter: Filter.equals("time", firstData.first["time"])),
        SembastDb2.eepromBPM);

    await count();
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
                Finder(filter: Filter.equals("time", date)),
                SembastDb2.eepromBPM)));

    if (r != null && r) {
      final m = list[index];
      key.currentState!.removeItem(index, (c, a) {
        return EepromItemBpm(
            animation: a,
            fdm: m,
            onTap: () {},
            isDelete: true,
            onDelete: () {});
      });
      list.removeAt(index);

      await count();

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
            buttonAction1: () => db.delete(Finder(), SembastDb2.eepromBPM)));

    if (r != null && r) {
      list.clear();
      max = 0;
      setState();
    }
  }

  void setCurrentData(EepromModel fm) {
    currentData.id = fm.id;
    currentData.time = fm.time;
  }

  void completeJson(String data, int index) {
    // buffer += data.substring(0, index + 1);

    completedJson.add(
      "${buffer.substring(buffer.indexOf(
            "{",
          )) + data.substring(0, index + 1)}",
    );

    // print("incomplete complete1: $data");

    // print("incomplete complete: ${completedJson[0]}");

    buffer = "";
  }

  int incompleteJsonCount(String s, {int? previousBracketNum}) {
    int bracketLeft = previousBracketNum ?? 0;
    bool isBracketStart = previousBracketNum != null && previousBracketNum > 0;
    String newJson = "";

    for (var i = 0; i < s.length; i++) {
      if (s[i] == "{") {
        bracketLeft++;
        // print(
        //   "incomplete: ${s[i]}",
        // );
      } else if (s[i] == "}" && isBracketStart) {
        bracketLeft--;
        // print(
        //   "incomplete: ${s[i]}",
        // );
      }

      if (!isBracketStart && bracketLeft >= 1) {
        isBracketStart = true;
      }

      if (isBracketStart && bracketLeft == 0) {
        completeJson(s, i);
        newJson = s.substring(i + 1);

        isBracketStart = false;
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

    // if (processedJson[time]!.length > 2 && currentData.time == time) {
    //   add(currentData);
    // }
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
}
