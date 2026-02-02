import 'package:blood_pressure_monitoring/controller/bpmDataController.dart';
import 'package:blood_pressure_monitoring/controller/bpmEepromDataController.dart';
import 'package:blood_pressure_monitoring/controller/bpmEepromJsonFileDataController.dart';
import 'package:blood_pressure_monitoring/controller/bpmEepromModelController.dart';
import 'package:blood_pressure_monitoring/controller/controller.dart';
import 'package:blood_pressure_monitoring/page/eeprom/eepromHome_bpm.dart';
import 'package:blood_pressure_monitoring/page/history/history_bpm.dart';
import 'package:blood_pressure_monitoring/page/page2/widget/deleteBar_bpm.dart';
import 'package:blood_pressure_monitoring/tools/bluetoothMobile.dart';
import 'package:blood_pressure_monitoring/widget/dialogBox_xirkabit.dart';
import 'package:blood_pressure_monitoring/widget/downloadBox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../style/mainStyle.dart';
import '../../style/textStyle.dart';

class Page2Bpm extends StatefulWidget {
  Page2Bpm(
      {super.key,
      required this.bdc,
      required this.edc,
      required this.bluetoothController});

  BPMDataController bdc;
  EepromModelController edc;
  BluetoothLeMobile bluetoothController;

  @override
  State<Page2Bpm> createState() => _Page2BpmState();
}

class _Page2BpmState extends State<Page2Bpm> {
  final keyAnimatedList = GlobalKey<AnimatedListState>();
  bool showDelete = true, isDeleting = false;
  PageController pc = PageController(initialPage: 0);
  final double boxWidth = 100, boxHeight = 50;
  var page = 0.0;

  final EepromDataController edc = EepromDataController();
  final EepromJsonFileDataController ejc = EepromJsonFileDataController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final lWidth = MediaQuery.of(context).size.width;
    final lHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8, top: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Stack(
                children: [
                  AnimatedPositioned(
                    left: page == 0 ? 0 : boxWidth + 20,
                    child: Container(
                      width: boxWidth,
                      height: boxHeight,
                      decoration: BoxDecoration(
                        color: MainStyle.secondaryColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    duration: Duration(milliseconds: 300),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: boxWidth,
                        height: boxHeight,
                        child: TextButton(
                            onPressed: () {
                              setState(() {
                                page = 0;
                              });
                              pc.animateToPage(0,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeIn);
                            },
                            child: Text(
                              "History",
                              style: MyTextStyle.defaultFontCustom(
                                  MainStyle.thirdColor, 21,
                                  weight: FontWeight.bold),
                            )),
                      ),
                      MainStyle.sizedBoxW20,
                      SizedBox(
                        width: boxWidth,
                        height: boxHeight,
                        child: Center(
                          child: TextButton(
                              onPressed: () {
                                setState(() {
                                  page = 01;
                                });
                                pc.animateToPage(1,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeIn);
                              },
                              child: Text(
                                "Device",
                                style: MyTextStyle.defaultFontCustom(
                                    MainStyle.thirdColor, 21,
                                    weight: FontWeight.bold),
                              )),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              DeleteBar(
                  isDeleting: isDeleting,
                  showDelete: showDelete,
                  onClearAll: () =>
                      widget.bdc.deleteAll(context, () => setState(() {})),
                  onDeleteCancel: () {
                    setState(() {
                      isDeleting = false;
                    });
                  },
                  onThrashTap: () {
                    setState(() {
                      isDeleting = true;
                    });
                  },
                  onDownloadTap: () async {
                    final c = Controller();

                    if (!widget.bluetoothController.isConnected) {
                      // final c = Controller();
                      final r = await c.goToDialog(
                          context,
                          DialogboxXirkabit(
                            buttonNumber: 1,
                              buttonWidth: lWidth * 0.5,
                              iconData: Icons.bluetooth,
                              iconSvg: SvgPicture.asset(
                                  "assets/bluetooth_not_connected.svg"),
                              iconBackgroundColor: Colors.transparent,
                              title: "Device not connected",
                              subtitle: "Please connect your device first",
                              textButton1: "Ok",
                              buttonAction1: () {}));

                      return;
                    }

                    final r = await c.goToDialog(
                        context,
                        DialogboxXirkabit(
                            buttonWidth: lWidth * 0.35,
                            iconData: Icons.file_download,
                            iconSvg:
                                SvgPicture.asset("assets/file_download.svg"),
                            iconBackgroundColor: Colors.transparent,
                            title:
                                "Are you sure to download all Data from EEPROM?",
                            subtitle:
                                "Warning : Don’t operate your device, keep on Standby Mode!",
                            textButton1: "Yes, download",
                            cancelColor: MainStyle.thirdColor,
                            buttonAction1: () {}));

                    if (r) {
                      c.goToDialog(
                          context,
                          DownloadBox(
                            emc: widget.edc,
                            edc: edc,
                            ejc: ejc,
                            bluetoothController: widget.bluetoothController,
                          ));
                    }
                  })
            ],
          ),
          MainStyle.sizedBoxH20,
          Expanded(
              child: PageView(
            controller: pc,
            physics: NeverScrollableScrollPhysics(),
            children: [
              HistoryBpm(
                bdc: widget.bdc,
                isDelete: isDeleting,
              ),
              EepromBpm(isDelete: isDeleting, bdc: widget.edc)
            ],
          )),
        ],
      ),
    );
  }
}
