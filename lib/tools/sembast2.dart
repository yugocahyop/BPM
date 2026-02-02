import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast_sqflite/sembast_sqflite.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

class SembastDb2 {
  final dbPath = "bpm.xirka.dbSqf";

  final storeBPM = intMapStoreFactory.store('BPM');
  final storeBPMfile = intMapStoreFactory.store('fileBpm');
  final storeEepromBPM = intMapStoreFactory.store('eepromBPM');
  final storeEepromBPMfile = intMapStoreFactory.store('eepromFileBpm');

  static const String BPM = "BPM";
  static const String file = "fileBpm";
  static const String eepromBPM = "eepromBPM";
  static const String eepromFile = "eepromFileBpm";

  var _db;

  SembastDb2() {
    setupDB();
  }

  void setupDB() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    _db = await getDatabaseFactorySqflite(sqflite.databaseFactory)
        .openDatabase("${appDocDir.path}/$dbPath");
    if (kDebugMode) {
      print(appDocDir);
    }
  }

  Future<void> wait() async {
    while (_db == null) {
      await Future.delayed(const Duration(milliseconds: 200));
    }
  }

  StoreRef<int, Map<String, Object?>> getStore(final String store_text) {
    switch (store_text) {
      case SembastDb2.BPM:
        return storeBPM;
      case SembastDb2.file:
        return storeBPMfile;
      case SembastDb2.eepromBPM:
        return storeEepromBPM;
      case SembastDb2.eepromFile:
        return storeEepromBPMfile;
    }

    return storeBPM;
  }

  // Future<List<RecordSnapshot<int, Map<String, Object?>>>> findRekam(String nik, final String store_text,
  Future<List<RecordSnapshot<int, Map<String, Object?>>>> find(
      final String store_text,
      {Finder? finder}) async {
    await wait();

    StoreRef<int, Map<String, Object?>> store = getStore(store_text);
    final record = await store.find(_db, finder: finder ?? Finder());

    // final int count =  await store.count(_db);

    return record;
  }

  Future<int> count(final String store_text, {Finder? finder}) async {
    await wait();

    StoreRef<int, Map<String, Object?>> store = getStore(store_text);
    // final record = await store.find(_db, finder: finder ?? Finder());

    final int count = await store.count(_db);

    return count;
  }

  // Future<Map<String, List<RecordSnapshot<int, Map<String, Object?>>>>> findUser(

  Future<bool> add(Map<String, dynamic> val, final String store_text) async {
    await wait();

    // final f = (await find( store_text, date: val["date"]));

    // if (f.isNotEmpty) return false;

    StoreRef<int, Map<String, Object?>> store = getStore(store_text);

    // _db.transaction((txn) async {
    await store.add(_db, val);
    // });

    return true;
  }

  Future<bool> update(
      Finder finder, Map<String, dynamic> val, String store) async {
    await wait();
    int edited = await getStore(store).update(_db, val, finder: finder);

    return edited > 0;
  }

  Future<void> delete(Finder finder, final store_text) async {
    await wait();
    StoreRef<int, Map<String, Object?>> store = getStore(store_text);

    await store.delete(_db, finder: finder);
  }
}
