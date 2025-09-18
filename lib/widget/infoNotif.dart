import 'package:flutter/material.dart';

import '../style/mainStyle.dart';

class InfoNotif extends StatelessWidget {
  InfoNotif(
      {super.key,
      required this.infoText,
      required this.showInfo,
      required this.visibilityInfo,
      required this.isOk});

  String infoText;
  bool showInfo;
  bool visibilityInfo;
  bool isOk;

  @override
  Widget build(BuildContext context) {
    final logicalWidth = MediaQuery.of(context).size.width;
    final logicalHeight = MediaQuery.of(context).size.height;
    return AnimatedPositioned(
        child: AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: showInfo ? 1 : 0,
            child: Visibility(
                visible: visibilityInfo,
                child: Center(
                  child: Container(
                    width: logicalWidth - 40,
                    padding: EdgeInsets.fromLTRB(20, 3, 20, 3),
                    decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(0, 0),
                          )
                        ],
                        color: const Color(0xff699C95),
                        borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      children: [
                        Icon(
                          isOk ? Icons.check_circle : Icons.info,
                          color: isOk ? Colors.green : Color(0xffF1FF2A),
                          size: 30,
                        ),
                        SizedBox(width: 15),
                        Flexible(
                          child: Text(infoText,
                              style: TextStyle(
                                fontSize: logicalHeight < 800
                                    ? 14 * (logicalHeight / 570)
                                    : 16 * (logicalHeight / 896),
                                color: Colors.white,
                              )),
                        ),
                      ],
                    ),
                  ),
                ))),
        duration: const Duration(milliseconds: 300),
        top: showInfo ? 100 : 60,
        left: 20);
  }
}
