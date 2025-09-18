import 'package:blood_pressure_monitoring/model/bpmDataModel.dart';
import 'package:blood_pressure_monitoring/model/bpmJsonFileDataModel.dart';
import 'package:blood_pressure_monitoring/page/monitoring/widget/box_bpm.dart';
import 'package:blood_pressure_monitoring/style/mainStyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../../../style/textStyle.dart';

class FileitemBpm extends StatelessWidget {
  FileitemBpm(
      {super.key,
      required this.animation,
      required this.fdm,
      required this.isDelete,
      required this.onDelete});

  JsonFileDataModel fdm;
  bool isDelete;
  Function onDelete;
  Animation<double> animation;

  DateFormat df = DateFormat("HH:mm dd/MM/yyyy");

  @override
  Widget build(BuildContext context) {
    final lWidth = MediaQuery.of(context).size.width;
    return FadeTransition(
      opacity: animation,
      child: SizeTransition(
        sizeFactor: animation,
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: BoxBpm(
            borderRadius: BorderRadius.circular(10),
            width: lWidth,
            height: 53,
            color: MainStyle.secondaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: lWidth * 0.45,
                  child: Text(
                    fdm.fileName,
                    style: MyTextStyle.defaultFontCustom(
                        MainStyle.thirdColor, 13,
                        weight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  width: lWidth * 0.50,
                  child: Stack(
                    children: [
                      Center(
                        child: Transform.translate(
                          offset: Offset(-8, 0),
                          child: Text(
                              df.format(DateTime.fromMillisecondsSinceEpoch(
                                fdm.time,
                              ).toLocal()),
                              style: MyTextStyle.defaultFontCustom(
                                  MainStyle.thirdColor, 13,
                                  weight: FontWeight.w500),
                              textAlign: TextAlign.center),
                        ),
                      ),
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 300),
                        right: isDelete ? 0 : -30,
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 300),
                          opacity: isDelete ? 1 : 0,
                          child: Container(
                            height: 53,
                            width: 30,
                            decoration: BoxDecoration(
                                color: const Color(0xffC73434),
                                borderRadius: BorderRadius.horizontal(
                                    right: Radius.circular(10))),
                            child: Material(
                              type: MaterialType.transparency,
                              child: InkWell(
                                splashColor: Colors.black26,
                                onTap: () => onDelete(),
                                child: Center(
                                  child: SvgPicture.asset(
                                    "assets/thrash.svg",
                                    width: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
