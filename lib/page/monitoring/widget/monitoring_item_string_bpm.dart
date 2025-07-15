import 'package:blood_pressure_monitoring/style/textStyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MonitoringItemString extends StatelessWidget {
  MonitoringItemString(
      {super.key,
      required this.isConnected,
      required this.isBluetooth,
      required this.title,
      required this.value,
      required this.valueSize,
      required this.svgBackground});

  String title;
  String value;
  double valueSize;
  SvgPicture svgBackground;
  bool isBluetooth;
  bool isConnected;

  @override
  Widget build(BuildContext context) {
    final widhtLogical = MediaQuery.of(context).size.width;
    final heightLogical = MediaQuery.of(context).size.height;
    return SizedBox(
      width: widhtLogical,
      height: heightLogical,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomLeft,
            child: Transform.translate(
              offset: const Offset(0, 5),
              child: svgBackground,
            ),
          ),
          SizedBox(
            width: widhtLogical,
            height: heightLogical,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        // width: widhtLogical,
                        child: Text(
                          title,
                          style: MyTextStyle.defaultFontCustom(Colors.black, 14,
                              weight: FontWeight.w500),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Container(
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                          color: const Color(0xff34C759),
                          borderRadius: BorderRadius.circular(8)
                        ),
                        alignment: Alignment.center,
                        // padding: EdgeInsets.all(3),
                        child: Icon(Icons.bluetooth, color: Colors.white, size: 15,),
                      )
                    ],
                  ),
                  SizedBox(
                    width: widhtLogical,
                    child: Text(
                      value,
                      style: MyTextStyle.defaultFontCustom(
                          Colors.black, valueSize,
                          weight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
