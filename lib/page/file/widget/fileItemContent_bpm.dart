import 'package:blood_pressure_monitoring/model/bpmJsonFileDataModel.dart';
import 'package:blood_pressure_monitoring/style/textStyle.dart';
<<<<<<< HEAD
=======
import 'package:blood_pressure_monitoring/tools/fileService.dart';
>>>>>>> 7753693 (2026 feb 2 2)
import 'package:flutter/material.dart';

import '../../../style/mainStyle.dart';

class FileContent extends StatefulWidget {
  FileContent({super.key, required this.jdm});

  JsonFileDataModel jdm;

  @override
  State<FileContent> createState() => _FileContentState();
}

class _FileContentState extends State<FileContent> {
  List<String> listContent = [];
  List<Widget> listTextWidget = [];

  final sc = ScrollController();
  final sc2 = ScrollController();
  final sc3 = ScrollController();
  late ScrollController scMain;

  int maxLengthPixel = 0;

  ScrollbarOrientation so = ScrollbarOrientation.right;

  Axis scrollAxis1 = Axis.vertical;
  Axis scrollAxis2 = Axis.horizontal;

  _sc3Listener() {
    sc2.removeListener(_sc2Listener);
    sc2.jumpTo(sc3.offset);
    sc2.addListener(_sc2Listener);
  }

  _sc2Listener() {
    sc3.removeListener(_sc3Listener);
    sc3.jumpTo(sc2.offset);
    sc3.addListener(_sc3Listener);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    scMain = sc;

    listContent = widget.jdm.content.split("\n");

    for (var i = 0; i < listContent.length; i++) {
      maxLengthPixel = listContent[i].length > maxLengthPixel
          ? listContent[i].length
          : maxLengthPixel;
      listTextWidget.add(Row(
        children: [
          SizedBox(
              width: 25,
              child: Text(
                "${i + 1}",
                textAlign: TextAlign.end,
                style: MyTextStyle.defaultFontCustom(MainStyle.thirdColor, 13),
              )),
          SizedBox(
              height: 20,
              child: VerticalDivider(
                color: MainStyle.thirdColor,
              )),
          MainStyle.sizedBoxW5,
          Text(
            listContent[i],
            style: MyTextStyle.defaultFontCustom(MainStyle.thirdColor, 13),
          )
        ],
      ));
    }

    listTextWidget.add(SizedBox(
      height: 20,
    ));

    sc3.addListener(_sc3Listener);
    sc2.addListener(_sc2Listener);

    // print(listContent[0]);
  }

  @override
  Widget build(BuildContext context) {
    final widthLogical = MediaQuery.of(context).size.width;
    final heightLogical = MediaQuery.of(context).size.height;

    // print(jdm.content);
    return Scaffold(
      body: SizedBox(
        width: widthLogical,
        height: heightLogical,
        child: Column(
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
            const SizedBox(
              height: 40,
            ),
            SizedBox(
              width: widthLogical,
              child: Row(
<<<<<<< HEAD
                children: [
                  IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.arrow_back,
                        color: MainStyle.primaryColor,
                        size: 30,
                      )),
                  MainStyle.sizedBoxW10,
                  Text(
                    widget.jdm.fileName,
                    style: MyTextStyle.defaultFontCustom(
                        MainStyle.thirdColor, 21,
                        weight: FontWeight.bold),
                  )
=======
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(
                            Icons.arrow_back,
                            color: MainStyle.primaryColor,
                            size: 30,
                          )),
                      MainStyle.sizedBoxW10,
                      Text(
                        widget.jdm.fileName,
                        style: MyTextStyle.defaultFontCustom(
                            MainStyle.thirdColor, 21,
                            weight: FontWeight.bold),
                      )
                    ],
                  ),

                  IconButton(
                      onPressed: () {
                        saveFileAndNotify(widget.jdm.fileName, widget.jdm.content);
                      },
                      icon: Icon(
                        Icons.download,
                        color: MainStyle.primaryColor,
                        size: 30,
                      ))
>>>>>>> 7753693 (2026 feb 2 2)
                ],
              ),
            ),
            Expanded(
                child: Stack(
              children: [
                ScrollbarTheme(
                  data: ScrollbarThemeData(
                      thumbColor:
                          WidgetStateProperty.all(MainStyle.primaryColor),
                      trackColor:
                          WidgetStateProperty.all(MainStyle.secondaryColor)),
                  child: Scrollbar(
                      controller: scMain,
                      thumbVisibility: true,
                      trackVisibility: true,
                      interactive: true,
                      radius: const Radius.circular(20),
                      thickness: 10,
                      scrollbarOrientation: so,
                      child: SingleChildScrollView(
                        controller: sc,
                        scrollDirection: scrollAxis1,
                        child: SingleChildScrollView(
                          controller: sc2,
                          scrollDirection: scrollAxis2,
                          child: Column(
                            children: listTextWidget
                                .map((e) => SizedBox(
                                      width: maxLengthPixel * 6.4,
                                      child: e,
                                    ))
                                .toList(),
                          ),
                        ),
                      )),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ScrollbarTheme(
                    data: ScrollbarThemeData(
                        thumbColor:
                            WidgetStateProperty.all(MainStyle.primaryColor),
                        trackColor:
                            WidgetStateProperty.all(MainStyle.secondaryColor)),
                    child: Scrollbar(
                        controller: sc3,
                        thumbVisibility: true,
                        trackVisibility: true,
                        interactive: true,
                        scrollbarOrientation: ScrollbarOrientation.bottom,
                        radius: const Radius.circular(20),
                        thickness: 10,
                        child: SingleChildScrollView(
                            controller: sc3,
                            scrollDirection: scrollAxis2,
                            child: SizedBox(
                              height: 10,
                              width: maxLengthPixel * 6.4,
                            ))),
                  ),
                ),
              ],
            ))
          ],
        ),
      ),
    );
  }
}
