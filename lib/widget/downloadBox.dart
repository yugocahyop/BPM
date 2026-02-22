import 'dart:async';

import 'package:blood_pressure_monitoring/controller/bpmEepromDataController.dart';
import 'package:blood_pressure_monitoring/controller/bpmEepromJsonFileDataController.dart';
import 'package:blood_pressure_monitoring/controller/bpmEepromModelController.dart';
import 'package:blood_pressure_monitoring/model/bpmEepromJsonFileDataModel.dart';
import 'package:blood_pressure_monitoring/model/bpmEepromModel.dart';
import 'package:blood_pressure_monitoring/tools/bluetoothMobile.dart';
import 'package:flutter/material.dart';
import 'package:sembast/sembast.dart';
import '../style/mainStyle.dart';
import '../style/textStyle.dart';
import 'myButton.dart';

class DownloadBox extends StatefulWidget {
  DownloadBox({
    Key? key,
    required this.emc,
    required this.edc,
    required this.ejc,
    required this.bluetoothController,
  }) : super(key: key);

  final BluetoothLeMobile bluetoothController;
  final EepromModelController emc;
  final EepromDataController edc;
  final EepromJsonFileDataController ejc;

  @override
  _DownloadBoxState createState() => _DownloadBoxState();
}

class _DownloadBoxState extends State<DownloadBox> {
  var msg = "Downloading data...";
  var percent = 0.0, prevPercent = 0.0;
  late Function prevListenFunction;
  final maxData = 240;
  var countFile = 0;
  var modelId = 0,
      downloadCount = 0,
      timeOutSeconds = 60 * 1,
      idlePeriondSeconds = 10;
  Timer? timer;

  idlePerioodChecker() async {
    while (percent < 1.0) {
      await Future.delayed(const Duration(seconds: 1));

      if (percent >= 1.0 && mounted) Navigator.pop(context);

      if (percent == prevPercent) {
        if (idlePeriondSeconds > 0) {
          idlePeriondSeconds--;
        }
      } else {
        idlePeriondSeconds = 10;
        timeOutSeconds = 60;
        prevPercent = percent;

        if (timer != null) {
          timer!.cancel();
          timer = null;
        }
      }

      if (timer == null && idlePeriondSeconds == 0) {
        startTimeOut();
      }
    }

    if (mounted) Navigator.pop(context);
  }

  startTimeOut() {
    if (timer != null) timer!.cancel();

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      timeOutSeconds--;
      if (timeOutSeconds == 0) {
        timer.cancel();

        if (mounted) Navigator.pop(context);
      }
      if (mounted) {
        setState(() {
          msg = "No data received, canceling in $timeOutSeconds s";
        });
      }
    });
  }

  sendCommand() {
    widget.bluetoothController.write("{\"cmd\":\"MEMGet\"}");
  }

  setBleListend() {
    widget.bluetoothController.setListenFunction((data) async {
      idlePeriondSeconds = 10;
      final r = widget.edc.processData(data);

      if (r != null) {
        if (widget.edc.processedJson[r.time] == null) return;

        // final modelId = widget.emc.max + 1;

        // print(r.toString());

        final dataId = widget.edc.max + 1;

        if (widget.edc.processedJson[r.time]!.length == 2) {
          percent = (++downloadCount) / maxData;

          await widget.ejc.add(
              EepromJsonFileDataModel(
                  modelId: modelId,
                  dataId: dataId,
                  fileName: "",
                  content:
                      "${widget.edc.processedJson[r.time]![0]}\n\n${widget.edc.processedJson[r.time]![1]}",
                  time: r.time),
              countFile++);

          widget.edc.processedJson[r.time]!.clear();

          widget.ejc.count(filter: Filter.equals("modelId", modelId)).then((c) {
            if (c >= 240) {
              widget.ejc.deleteFirst(filter: Filter.equals("modelId", modelId));
            }
          });
        }

        await widget.edc.addProcessedData(r, modelId, dataId);

        widget.edc.count(filter: Filter.equals("modelId", modelId)).then((c) {
          if (c > 240) {
            widget.edc.deleteFirst(filter: Filter.equals("modelId", modelId));
          }
        });
      }

      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    modelId = widget.emc.lastId + 1;

    widget.emc.add(EepromModel(
        id: modelId, time: DateTime.now().toUtc().millisecondsSinceEpoch));

    widget.emc.count().then((c) {
      if (c > 25) {
        widget.emc.deleteFirst();
      }
    });

    prevListenFunction = widget.bluetoothController.listenFunction ?? (data) {};
    setBleListend();
    sendCommand();
    idlePerioodChecker();
  }

  @override
  void dispose() {
    percent = 1.0;
    if (timer != null) {
      timer!.cancel();
    }
    widget.bluetoothController
        .setListenFunction((data) => prevListenFunction(data));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lWidth = MediaQuery.of(context).size.width;
    final lHeight = MediaQuery.of(context).size.height;
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        // if (didPop) {
        //   Navigator.pop(context);
        // }
      },
      child: Container(
        width: lWidth,
        height: lHeight,
        color: Colors.black.withOpacity(0.5),
        child: Center(
          child: Container(
            width: lWidth * 0.95,
            height: lHeight * (idlePeriondSeconds == 0 ? 0.15 : 0.10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        msg,
                        style: MyTextStyle.defaultFontCustom(
                            MainStyle.primaryColor, 13),
                      ),
                      Text(
                        "${(percent * 100).toStringAsFixed(2)}%",
                        style: MyTextStyle.defaultFontCustom(
                            MainStyle.primaryColor, 13),
                      )
                    ],
                  ),
                  Stack(
                    // clipBehavior: Clip.antiAlias,
                    children: [
                      Container(
                        width: lWidth * 0.9,
                        height: 15,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.grey,
                        ),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        width: percent > 0.005 ? (lWidth * 0.9) * percent : 0,
                        height: 15,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                              topRight: percent > 0.03
                                  ? Radius.circular(20)
                                  : Radius.zero,
                              bottomRight: percent > 0.03
                                  ? Radius.circular(20)
                                  : Radius.zero),
                          color: MainStyle.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Visibility(
                      visible: idlePeriondSeconds == 0,
                      child:
                          // MyButton(color: MainStyle.primaryColor, text: "Cancel now", onPressed: ()=>Navigator.pop(context) , textColor: Colors.white)
                          Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: SizedBox(
                          height: 40,
                          width: lWidth * 0.3,
                          child: MyButton(
                              color: MainStyle.thirdColor,
                              text: "Cancel now",
                              onPressed: () => Navigator.pop(context),
                              textColor: Colors.white),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
