import 'package:blood_pressure_monitoring/page/monitoring/widget/box_bpm.dart';
import 'package:blood_pressure_monitoring/page/monitoring/widget/monitoring_item_bpm.dart';
import 'package:blood_pressure_monitoring/page/monitoring/widget/monitoring_item_string_bpm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../style/mainStyle.dart';
import '../../style/textStyle.dart';

class Monitoring extends StatefulWidget {
  const Monitoring({super.key});

  @override
  State<Monitoring> createState() => _MonitoringState();
}

class _MonitoringState extends State<Monitoring> {
  @override
  Widget build(BuildContext context) {
    final heightLogical = MediaQuery.of(context).size.height;
    final widthLogical = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
      child: Column(
        children: [
          SvgPicture.asset(
            "assets/logo_bpm.svg",
            width: widthLogical * 0.3,
          ),
          MainStyle.sizedBoxH10,
          Text(
            "Blood Pressure Monitoring",
            style: MyTextStyle.defaultFontCustom(MainStyle.thirdColor, 25,
                weight: FontWeight.w800),
          ),

          //monitoring item
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    BoxBpm(
                        width: widthLogical * 0.4,
                        height: 125,
                        child: MonitoringItem(
                            title: "Systolic",
                            value: 0,
                            unit: "mmHg",
                            valueSize: 40,
                            svgBackground: SvgPicture.asset(
                                "assets/systolic_rotated_bpm.svg"))),
                    MainStyle.sizedBoxH20,
                    BoxBpm(
                        width: widthLogical * 0.4,
                        height: 125,
                        child: MonitoringItem(
                            title: "Diastolic",
                            value: 0,
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
                        title: "Heart Rate",
                        value: 0,
                        unit: "bpm",
                        valueSize: 60,
                        svgBackground:
                            SvgPicture.asset("assets/heart_rotated_bpm.svg"))),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  BoxBpm(
                      width: widthLogical * 0.4,
                      height: 115,
                      color: MainStyle.secondaryColor,
                      child: MonitoringItemString(
                          isBluetooth: true,
                          isConnected: false,
                          title: "Time Record",
                          value: "17-06-2025 06:53:05",
                          valueSize: 20,
                          svgBackground:
                              SvgPicture.asset("assets/time_rotated_bpm.svg"))),
                  BoxBpm(
                      width: widthLogical * 0.4,
                      height: 115,
                      color: MainStyle.secondaryColor,
                      child: MonitoringItemString(
                          title: "Bluetooth",
                          value: "BPM001",
                          isBluetooth: true,
                          isConnected: false,
                          valueSize: 20,
                          svgBackground: SvgPicture.asset(
                              "assets/bluetooth_rotated_bpm.svg")))
                ]),
          )
        ],
      ),
    );
  }
}
