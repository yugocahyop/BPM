import 'dart:convert';
import 'package:blood_pressure_monitoring/model/bpmEepromJsonFileDataModel.dart';
import 'package:blood_pressure_monitoring/model/bpmJsonFileDataModel.dart';
import 'package:blood_pressure_monitoring/page/file/widget/fileItem_bpm.dart';
import 'package:flutter/material.dart';
import 'package:sembast/sembast.dart';

import '../tools/sembast2.dart';
import '../widget/dialogBox_xirkabit.dart';
import 'controller.dart';

typedef RemovedItemBuilder<T> = Widget Function(
    T item, BuildContext context, Animation<double> animation);

class EepromJsonFileDataController {
  late EepromJsonFileDataModel currentData;
  late SembastDb2 db;
  List<EepromJsonFileDataModel> list = [];
  bool isDelete = false;
  int max = 0;

  EepromJsonFileDataController() {
    db = SembastDb2();

    currentData = EepromJsonFileDataModel(
      modelId: -1,
      dataId: -1,
      time: DateTime.now().millisecondsSinceEpoch,
      fileName: "",
      content: "",
    );
    count();
  }

  void reset() {
    currentData.fileName = "";
    currentData.content = "";
  }

  Future<void> add(EepromJsonFileDataModel f, int count) async {
    final file = await db.find(SembastDb2.eepromFile,
        finder: Finder(sortOrders: [SortOrder("time", false)]));
    // print(file);

    // final lastNum = file.isEmpty
    //     ? 0
    //     : int.tryParse((file.last["fileName"] as String)
    //             .split("_")
    //             .last
    //             .split(".")
    //             .first) ??
    //         0;

    f.fileName = "EEPROM${f.modelId}_File_${count + 1}.json";

    await db.add(f.toJson(), SembastDb2.eepromFile);
  }

  Future<void> find(int dataId, int offset, Function setState) async {
    // await db.wait();
    if (offset == 0) list.clear();
    final r = await db.find(SembastDb2.eepromFile,
        finder: Finder(
            filter: Filter.equals("dataId", dataId),
            offset: offset, limit: 50, sortOrders: [SortOrder("time", false)]));

    for (var i = 0; i < r.length; i++) {
      final fh = EepromJsonFileDataModel.fromJson(r[i].value);
      list.add(fh);
    }

    // list.add(currentData);
    // list.add(currentData);

    setState();
  }

  Future<int> count({Filter? filter}) async {
    await db.wait();
    max = await db.count(SembastDb2.eepromFile , finder: Finder(filter: filter));
    // print("count $max");
    return max;
  }

  Future<void> deleteFirst({Filter? filter}) async {
    final firstData = await db.find(SembastDb2.eepromFile,
        finder: Finder(sortOrders: [SortOrder("time", true)], limit: 1, filter: filter));
    if (firstData.isEmpty) return;
    // print(firstData.first);
    db.delete(Finder(filter: Filter.equals("time", firstData.first["time"])),
        SembastDb2.eepromFile);
    await count(filter: filter);
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
                SembastDb2.eepromFile)));

    if (r != null && r) {
      final m = list[index];
      key.currentState!.removeItem(index, (c, a) {
        return FileitemBpm(
            animation: a,
            fdm: JsonFileDataModel(
                content: m.content, fileName: m.fileName, time: m.time),
            isDelete: isDelete,
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
            buttonAction1: () => db.delete(Finder(), SembastDb2.eepromFile)));

    if (r != null && r) {
      list.clear();
      max =0;
      setState();
    }
  }
  Future<void> deleteAllNoPrompt(BuildContext context, Function setState) async {
      db.delete(Finder(), SembastDb2.eepromFile);
      list.clear();
      max =0;
      setState();
    
  }
}
