import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

// import 'bluetooth.dart';

class BluetoothLeMobile {
  // final FlutterBluePlus = FlutterBluePlus.instance;
  List<ScanResult> devices = [];
  StreamSubscription? scanSub;
  StreamSubscription? connectSub;
  StreamSubscription? notifySub;
  bool isConnected = false;
  BluetoothCharacteristic? writeChars;
  // BluetoothCharacteristic? notifyChars;
  List<int> data = [];
  BluetoothDevice? currDevice;
  int mtu = 0;
  Function(List<int> data)? listenFunction;

  void setListenFunction(f(dynamic data)) {
    listenFunction = (List<int> data) {
      f(data);
    };
  }

  bool checkConnected() {
    return isConnected;
  }

  bool isScanning = true;

  List<String> getDevices() => devices.map((e) => e.device.advName).toList();

  Future<bool> checkBluetoothOn() async {
    return (await FlutterBluePlus.adapterState.first) ==
        BluetoothAdapterState.on;
  }

  enableBluetooth() {
    if (Platform.isAndroid) {
      FlutterBluePlus.turnOn();
    }
  }

  Future<void> StartScan() async {
    if (isScanning) await StopScan();

    isScanning = true;
    // if(scanSub != null) await scanSub!.cancel();

    try {
      await Future.delayed(const Duration(seconds: 1));
      FlutterBluePlus.startScan(timeout: const Duration(seconds: 1));

      scanSub = FlutterBluePlus.scanResults.listen((scans) {
        if (kDebugMode) {
          print(scans);
        }
        for (final scan in scans) {
          if ((devices
              .where((element) =>
                  element.device.id.toString() == scan.device.id.toString())
              .isEmpty)) {
            devices.add(scan);
          }

          Future.delayed(Duration(seconds: 2), () => isScanning = false);
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<bool> checkAvail() async {
    return (await FlutterBluePlus.adapterState.first) ==
        BluetoothAdapterState.on;
  }

  Future<void> StopScan() async {
    if (scanSub != null) await scanSub!.cancel();
    // devices.clear();
    // devices.clear();
    await FlutterBluePlus.stopScan();

    //  await Future.delayed(const Duration(seconds: 2));
  }

  Future<void> requestMtu(BluetoothDevice device) async {
    try {
      mtu = await device.requestMtu(250);
    } catch (e) {}
  }

  Future<void> connect(BluetoothDevice device,
      {String? data, List<int>? dataList}) async {
    try {
      // BluetoothDevice device = devices
      //     .where(
      //       (element) => element.device.advName == (dev as String),
      //     )
      //     .first
      //     .device;
      if (connectSub != null) await connectSub!.cancel();

      if (kDebugMode) {
        print("bluetooth connecting to ${device.advName}");
      }

      // await disconnect();

      currDevice = device;

      device.connect(
        autoConnect: false,
        mtu: 250,
      );
      connectSub = device.connectionState.listen((state) async {
        isConnected = state == BluetoothConnectionState.connected;

        if (kDebugMode) {
          print("bluetooth connection state ${state}");
        }

        if (isConnected) {
          try {
            // await requestMtu(device);

            await searchServices(device);

            //   if (kDebugMode) {
            //   print(mtu);

            // }
          } catch (e) {
            if (kDebugMode) {
              print(e);
            }
          }

          if (data != null) {
            write(data);
          } else if (dataList != null) {
            write(dataList);
          }
        }
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> connectByMac(String mac,
      {String? data, List<int>? dataList}) async {
    await StopScan();
    if (scanSub != null) await scanSub!.cancel();

    FlutterBluePlus.startScan(timeout: const Duration(seconds: 1));
    scanSub = FlutterBluePlus.scanResults.listen((scans) {
      if (kDebugMode) {
        print(scans);
      }
      for (final scan in scans) {
        if (scan.device.remoteId.str == mac) {
          connect(scan.device, dataList: dataList, data: data);
          return;
        }
      }
    });
  }

  String getSignal(int signal) {
    signal *= -1;
    if (signal >= 25 && signal < 50) {
      return "assets/signal_cellular_3_bar.svg";
    } else if (signal >= 50 && signal < 75) {
      return "assets/signal_cellular_2_bar.svg";
    } else if (signal >= 75) {
      return "assets/signal_cellular_1_bar.svg";
    } else if (signal >= 0 && signal < 25) {
      return "assets/signal_cellular_4_bar.svg";
    }

    return "";
  }

  Future<void> searchServices(dynamic dev) async {
    BluetoothDevice device = dev as BluetoothDevice;

    List<BluetoothService> services = await device.discoverServices();
    // String uuid = "";

    for (var i = 0; i < services.length; i++) {
      final service = services[i];

      if (kDebugMode) {
        print(service.uuid.toString());
      }

      if (!service.uuid.toString().toLowerCase().contains("00001800") &&
          !service.uuid.toString().toLowerCase().contains("00001801") &&
          !service.uuid.toString().toLowerCase().contains("0000180f")) {
        // uuid = service.serviceId.toString();
        await discoverCharacteristics(service);
      }
    }
  }

  Future<void> discoverCharacteristics(dynamic serv) async {
    BluetoothService service = serv as BluetoothService;
    for (var i = 0; i < service.characteristics.length; i++) {
      final chars = service.characteristics[i];

      if (chars.properties.notify && notifySub == null) {
        await subscribeToCharacteristic(chars);
      }
      if (chars.properties.write || chars.properties.writeWithoutResponse) {
        // writeId = QualifiedCharacteristic(serviceId: service.serviceId, characteristicId: chars.serviceId, deviceId: deviceId);
        writeChars = chars;
        return;
      }
    }
  }

  Future<void> subscribeToCharacteristic(dynamic char) async {
    BluetoothCharacteristic chars = char as BluetoothCharacteristic;
    if (notifySub != null) await notifySub!.cancel();
    await chars.setNotifyValue(true);

    notifySub = chars.onValueReceived.listen((readData) {
      // code to handle incoming data
      // if(readData.contains(0xA0)){
      //   if(readData.length <28){
      //     readData.clear();
      //   }
      //   else{
      //     return;
      //   }
      // }

      // if (kDebugMode) {
      //   print(readData);
      // }
      data.clear();

      data.addAll(readData);

      if (listenFunction != null) {
        listenFunction!(data);

        // await Future.delayed(const Duration(milliseconds: 100));
      }
    }, onError: (dynamic error) {
      print(error);
      // code to handle errors
    });
  }

  List<List<int>> splitPacket(List<int> data) {
    List<List<int>> result = [];
    int max = mtu - 5;

    if (max < data.length) {
      final divide = (data.length / max).ceil();

      for (var i = 0; i < divide; i++) {
        result.add(data.sublist(
            i * max, (i == divide - 1 ? data.length : ((i + 1) * max))));
      }
    } else {
      result.add(data);
    }

    return result;
  }

  Future<void> sendPacket(List<int> data) async {
    while (mtu == 0) {
      await Future.delayed(const Duration(seconds: 1));
    }

    final packet = splitPacket(data);

    for (var i = 0; i < packet.length; i++) {
      writeChars!.write(packet[i]);

      await Future.delayed(const Duration(milliseconds: 200));
    }
  }

  Future<void> write(dynamic data) async {
    // print(data);
    if (!isConnected) return;
    if (data is String) {
      final sendData = utf8.encode(data);

      if (writeChars != null) {
        sendPacket(sendData);
      }
      return;
    }
    if (writeChars != null) {
      // writeChars!.write( data);
      sendPacket(data);

      Future.delayed(const Duration(seconds: 5), () => disconnect());
    }
  }

  Future<void> disconnect() async {
    if (currDevice != null) currDevice!.disconnect();
    currDevice = null;

    if (connectSub != null) await connectSub!.cancel();
    if (scanSub != null) await scanSub!.cancel();
    if (notifySub != null) await notifySub!.cancel();
    if (writeChars != null) writeChars = null;
    // if (notifyChars != null) notifyChars = null;

    connectSub = null;
    scanSub = null;
    notifySub = null;

    isConnected = false;

    data.clear();
  }
}
