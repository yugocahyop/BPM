import 'package:blood_pressure_monitoring/style/textStyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MonitoringItem extends StatelessWidget {
  MonitoringItem(
      {super.key,
      required this.title,
      required this.value,
      required this.unit,
      required this.valueSize,
      required this.svgBackground});

  String title;
  int value;
  String unit;
  double valueSize;
  SvgPicture svgBackground;

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
                  SizedBox(
                    width: widhtLogical,
                    child: Text(
                      title,
                      style: MyTextStyle.defaultFontCustom(Colors.white, 14,
                          weight: FontWeight.w500),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  SizedBox(
                    width: widhtLogical,
                    child: Text(
                      "$value",
                      style: MyTextStyle.defaultFontCustom(
                          Colors.white, valueSize,
                          weight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    width: widhtLogical,
                    child: Text(
                      unit,
                      style: MyTextStyle.defaultFontCustom(Colors.white, 14,
                          weight: FontWeight.w500),
                      textAlign: TextAlign.right,
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
