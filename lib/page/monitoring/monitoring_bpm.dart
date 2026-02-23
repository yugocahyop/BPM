import 'package:blood_pressure_monitoring/controller/bpmDataController.dart';
import 'package:blood_pressure_monitoring/controller/bpmJsonFileDataController.dart';
import 'package:blood_pressure_monitoring/controller/controller.dart';
import 'package:blood_pressure_monitoring/model/bpmJsonFileDataModel.dart';
import 'package:blood_pressure_monitoring/page/monitoring/widget/box_bpm.dart';
import 'package:blood_pressure_monitoring/page/monitoring/widget/monitoring_item_bpm.dart';
import 'package:blood_pressure_monitoring/page/monitoring/widget/monitoring_item_string_bpm.dart';
import 'package:blood_pressure_monitoring/tools/bluetoothMobile.dart';
import 'package:blood_pressure_monitoring/widget/dialogBox_xirkabit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../../style/mainStyle.dart';
import '../../style/textStyle.dart';
import '../../widget/bottom_sheet_bluetooth.dart';

class Monitoring extends StatefulWidget {
  Monitoring(
      {super.key,
      required this.fdc,
      required this.bdc,
      required this.bluetoothController});

  BluetoothLeMobile bluetoothController;
  BPMDataController bdc;
  JsonFileDataController fdc;

  @override
  State<Monitoring> createState() => _MonitoringState();
}

class _MonitoringState extends State<Monitoring> {
  final DateFormat df = DateFormat("dd-MM-yyyy HH:mm:ss");

  Future<void> listenFunction(data) async {
    final r = widget.bdc.processData(data);

    if (r != null) {
      if (widget.bdc.processedJson[r.time] == null) return;
      if (widget.bdc.processedJson[r.time]!.length == 2) {
        await widget.fdc.add(JsonFileDataModel(
            fileName: "",
            content:
                "${widget.bdc.processedJson[r.time]![0]}\n\n${widget.bdc.processedJson[r.time]![1]}",
            time: r.time));

        widget.bdc.processedJson[r.time]!.clear();

        widget.fdc.count().then((c) {
          if (c >= 50) {
            widget.fdc.deleteFirst();
          }
        });
      }

      await widget.bdc.addProcessedData(r);

      widget.bdc.count().then((c) {
        if (c >= 50) {
          widget.bdc.deleteFirst();
        }
      });
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.bluetoothController.currDevice == null) {
      widget.bluetoothController.currDevice =
          BluetoothDevice(remoteId: DeviceIdentifier(""));
    }

    widget.bluetoothController.listenFunction = (data) {
      listenFunction(data);
    };
  }

  @override
  void didUpdateWidget(covariant Monitoring oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);

    if (oldWidget.bluetoothController.isConnected !=
        widget.bluetoothController.isConnected) {
      widget.bdc.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    final heightLogical = MediaQuery.of(context).size.height;
    final widthLogical = MediaQuery.of(context).size.width;
    return FittedBox(
      child: Padding(
        padding: const EdgeInsets.only(left: 8, top: 0, right: 8),
        child: Column(
          children: [
            Hero(
              tag: "logo_bpm",
              child: SvgPicture.asset(
                "assets/logo_blop_bpm.svg",
                width: widthLogical * 0.3,
              ),
            ),
            // MainStyle.sizedBoxH10,
            Text(
              "Blood Pressure Monitoring",
              style: MyTextStyle.defaultFontCustom(MainStyle.thirdColor, 25,
                  weight: FontWeight.w800),
            ),

            //monitoring item
            SizedBox(
              width: widthLogical,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        BoxBpm(
                            width: widthLogical * 0.4,
                            height: 125,
                            child: MonitoringItem(
                                isConnected:
                                    widget.bluetoothController.isConnected,
                                title: "Systolic",
                                value: widget.bdc.currentData.systolic,
                                unit: "mmHg",
                                valueSize: 40,
                                svgBackground: SvgPicture.asset(
                                    "assets/systolic_rotated_bpm.svg"))),
                        MainStyle.sizedBoxH20,
                        BoxBpm(
                            width: widthLogical * 0.4,
                            height: 125,
                            child: MonitoringItem(
                                isConnected:
                                    widget.bluetoothController.isConnected,
                                title: "Diastolic",
                                value: widget.bdc.currentData.diastolic,
                                unit: "mmHg",
                                valueSize: 40,
                                svgBackground: SvgPicture.asset(
                                    "assets/systolic_rotated_bpm.svg"))),
                      ],
                    ),
                    BoxBpm(
                        width: widthLogical * 0.4,
                        height: 125 * 2.2,
                        child: MonitoringItem(
                            isConnected: widget.bluetoothController.isConnected,
                            title: "Heart Rate",
                            value: widget.bdc.currentData.heartRate,
                            unit: "bpm",
                            valueSize: 60,
                            svgBackground: SvgPicture.asset(
                                "assets/heart_rotated_bpm.svg"))),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: widthLogical,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      BoxBpm(
                          width: widthLogical * 0.4,
                          height: 110,
                          color: MainStyle.secondaryColor,
                          child: MonitoringItemString(
                              isBluetooth: false,
                              isConnected:
                                  widget.bluetoothController.isConnected,
                              title: "Time Record",
                              value: df.format(
                                  DateTime.fromMillisecondsSinceEpoch(
                                          widget.bdc.currentData.time)
                                      .toLocal()),
                              valueSize: 20,
                              svgBackground: SvgPicture.asset(
                                  "assets/time_rotated_bpm.svg"))),
                      BoxBpm(
                          width: widthLogical * 0.4,
                          height: 110,
                          color: MainStyle.secondaryColor,
                          child: Material(
                            type: MaterialType.transparency,
                            child: InkWell(
                              splashColor: Colors.black26,
                              onTap: () async {
                                // if (widget.bluetoothController.currDevice ==
                                //     null) {
                                // widget.bluetoothController.currDevice =
                                //     BluetoothDevice(
                                //         remoteId: DeviceIdentifier(""));
                                // }3 nbtvr

                                bool oldIsConnected =
                                    widget.bluetoothController.isConnected;
                                String? deviceMac =
                                    widget.bluetoothController.currDevice ==
                                            null
                                        ? null
                                        : widget.bluetoothController.currDevice!
                                            .remoteId.str;
                                var isOn = await widget.bluetoothController
                                    .checkBluetoothOn();
                                final lWidth =
                                    MediaQuery.of(context).size.width;
                                // final lHeight = MediaQuery.of(context).size.height;

                                if (!isOn) {
                                  final c = Controller();
                                  final r = await c.goToDialog(
                                      context,
                                      DialogboxXirkabit(
                                          buttonWidth: lWidth * 0.3,
                                          iconData: Icons.bluetooth,
                                          iconBackgroundColor:
                                              MainStyle.primaryColor,
                                          title: "Bluetooth Not Enabled!",
                                          subtitle:
                                              "Please enable bluetooth to continue.",
                                          textButton1: "Enable",
                                          buttonAction1: () => widget
                                              .bluetoothController
                                              .enableBluetooth()));

                                  if (r) {
                                    var timeOutSecond = 20;
                                    while (isOn == false) {
                                      await Future.delayed(
                                          const Duration(seconds: 1));
                                      timeOutSecond--;

                                      if (timeOutSecond <= 0) {
                                        return  ;
                                      }
                                      isOn = await widget.bluetoothController
                                          .checkBluetoothOn();
                                      
                                    }
                                  }else{
                                    return ;
                                  }
                                }

                                await showModalBottomSheet(
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    // showDragHandle: true,
                                    context: context,
                                    builder: (context) =>
                                        Bottom_sheet_bluetooth(
                                          bluetooth_controller:
                                              widget.bluetoothController,
                                        ));
                                // setState(() {});
                                await Future.delayed(
                                    const Duration(milliseconds: 1000));
                                // setState();

                                final isSameDevice = (deviceMac ?? "") ==
                                    ((widget.bluetoothController.currDevice ==
                                            null)
                                        ? ""
                                        : widget.bluetoothController.currDevice!
                                            .remoteId.str);

                                if ((oldIsConnected !=
                                    widget.bluetoothController.isConnected)) {
                                  widget.bdc.reset();
                                }

                                // if (!oldIsConnected &&
                                //     widget.bluetoothController.isConnected) {
                                //   widget.bdc.currentData.time = DateTime.now()
                                //       .toUtc()
                                //       .millisecondsSinceEpoch;
                                // }
                                if (mounted) setState(() {});
                              },
                              child: MonitoringItemString(
                                  title: "Bluetooth",
                                  value: widget
                                              .bluetoothController.currDevice ==
                                          null
                                      ? ""
                                      : widget.bluetoothController.currDevice!
                                          .platformName,
                                  isBluetooth: true,
                                  isConnected:
                                      widget.bluetoothController.isConnected,
                                  valueSize: 20,
                                  svgBackground: SvgPicture.asset(
                                      "assets/bluetooth_rotated_bpm.svg")),
                            ),
                          ))
                    ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}
