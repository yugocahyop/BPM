import 'package:blood_pressure_monitoring/controller/bpmEepromModelController.dart';
import 'package:blood_pressure_monitoring/controller/bpmJsonFileDataController.dart';
import 'package:blood_pressure_monitoring/global/globalProvider.dart';
import 'package:blood_pressure_monitoring/model/bpmEepromModel.dart';
import 'package:blood_pressure_monitoring/page/file/file_bpm.dart';
import 'package:blood_pressure_monitoring/page/history/history_bpm.dart';
import 'package:blood_pressure_monitoring/page/home/widget/bottomNav_bpm.dart';
import 'package:blood_pressure_monitoring/page/monitoring/monitoring_bpm.dart';
import 'package:blood_pressure_monitoring/page/page2/page2_bpm.dart';
import 'package:blood_pressure_monitoring/style/mainStyle.dart';
import 'package:blood_pressure_monitoring/tools/bluetoothMobile.dart';
import 'package:blood_pressure_monitoring/widget/infoNotif.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../controller/bpmDataController.dart';

class Home extends StatefulWidget {
  Home({super.key});

  final edc = EepromModelController();
  final bluetoothController = BluetoothLeMobile();
  final bdc = BPMDataController();
  final fdc = JsonFileDataController();

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int page = 0;
  final pc = PageController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // Globalprovider.setState = setState;
    widget.edc.list.addAll([
      EepromModel(id: 1, time: DateTime.now().microsecondsSinceEpoch - 40000),
      EepromModel(id: 2, time: DateTime.now().microsecondsSinceEpoch - 30000),
      EepromModel(id: 3, time: DateTime.now().microsecondsSinceEpoch - 20000),
      EepromModel(id: 4, time: DateTime.now().microsecondsSinceEpoch - 10000),
    ]);
  }

  bool isSetup = false;

  @override
  Widget build(BuildContext context) {
    final heightLogical = MediaQuery.of(context).size.height;
    final widthLogical = MediaQuery.of(context).size.width;

    // Globalprovider.of(context)!.show("test");

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if(didPop) return;
      },
      child: Scaffold(
        body: SizedBox(
          width: widthLogical,
          height: heightLogical,
          child: Stack(
            children: [

              Align(
                alignment: Alignment.topCenter,
                child: Hero(
                tag: "topSplash",
                child: Transform.translate(
                  offset: const Offset(0, -100),
                  child: Opacity(
                    opacity: 0,
                    child: SvgPicture.asset(
                      "assets/topSplash_bpm.svg",
                      width: widthLogical,
                    ),
                  ),
                ),
                            ),
              ),

              Align(
                alignment: Alignment.bottomCenter,
                child: Hero(
                tag: "bottomSplash",
                child: Transform.translate(
                  offset: const Offset(0, 130),
                  child: Opacity(
                    opacity: 0,
                    child: SvgPicture.asset(
                      "assets/bottomSplash_bpm.svg",
                      width: widthLogical,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                            ),
              ),
              Column(
                children: [
                  Container(
                    width: widthLogical,
                    height: heightLogical * 0.1,
                    decoration: const BoxDecoration(
                      color: MainStyle.primaryColor,
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(20)),
                    ),
                  ),
                  Expanded(
                      child: PageView(
                    controller: pc,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      Monitoring(
                        fdc: widget.fdc,
                        bdc: widget.bdc,
                        bluetoothController: widget.bluetoothController,
                      ),
                      Page2Bpm(
                          bdc: widget.bdc,
                          edc: widget.edc,
                          bluetoothController: widget.bluetoothController),
                      FileBpm(fdc: widget.fdc)
                    ],
                  )),
                  BottomNav(
                    page: page,
                    onClick: (page1) {
                      // print(page1);
                      if (page1 == 1) {
                        widget.bdc.find(0, () => setState(() {}));
                      } else if (page1 == 2) {
                        widget.fdc.find(0, () => setState(() {}));
                      }
                      pc.animateToPage(page1,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.ease);
                      setState(() {
                        page = page1;
                      });
                    },
                  )
                ],
              ),
              InfoNotif(
                isOk: Globalprovider.of(context)!.isOk,
                infoText: Globalprovider.of(context)!.infoText,
                showInfo: Globalprovider.of(context)!.showNotif,
                visibilityInfo: Globalprovider.of(context)!.visibilityNotif,
              )
            ],
          ),
        ),
      ),
    );
  }
}
