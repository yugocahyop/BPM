import 'package:blood_pressure_monitoring/style/mainStyle.dart';
import 'package:flutter/material.dart';

import '../../../style/textStyle.dart';

class EepromTitleBpm extends StatelessWidget {
  EepromTitleBpm({super.key});

  final titles = ["Name", "Date"];

  @override
  Widget build(BuildContext context) {
    final lWidth = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: titles
          .map((e) => Transform.translate(
                offset: Offset(e == "Heart Rate" ? -8 : 0, 0),
                child: SizedBox(
                  width: lWidth * (e == "Name"? 0.4 : 0.20),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      e,
                      style: MyTextStyle.defaultFontCustom(
                          MainStyle.thirdColor, 14,
                          weight: FontWeight.w500),
                    ),
                  ),
                ),
              ))
          .toList(),
    );
  }
}
