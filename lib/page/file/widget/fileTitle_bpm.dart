import 'package:blood_pressure_monitoring/style/mainStyle.dart';
import 'package:flutter/material.dart';

import '../../../style/textStyle.dart';

class FiletitleBpm extends StatelessWidget {
  FiletitleBpm({super.key});

  final titles = ["Name", "Date"];

  @override
  Widget build(BuildContext context) {
    final lWidth = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: titles
          .map((e) => Transform.translate(
                offset: Offset(0, 0),
                child: SizedBox(
                  width: lWidth * 0.45,
                  child: Center(
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
