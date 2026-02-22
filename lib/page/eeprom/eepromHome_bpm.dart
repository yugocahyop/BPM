import 'package:blood_pressure_monitoring/controller/bpmDataController.dart';
import 'package:blood_pressure_monitoring/controller/bpmEepromDataController.dart';
import 'package:blood_pressure_monitoring/controller/bpmEepromJsonFileDataController.dart';
import 'package:blood_pressure_monitoring/controller/bpmEepromModelController.dart';
import 'package:blood_pressure_monitoring/controller/controller.dart';
import 'package:blood_pressure_monitoring/model/bpmDataModel.dart';
import 'package:blood_pressure_monitoring/model/bpmEepromDataModel.dart';
import 'package:blood_pressure_monitoring/model/bpmJsonFileDataModel.dart';
import 'package:blood_pressure_monitoring/page/eeprom/widget/eepromItem_bpm.dart';
import 'package:blood_pressure_monitoring/page/eeprom/widget/eepromTitle_bpm.dart';
import 'package:blood_pressure_monitoring/page/file/widget/fileItemContent_bpm.dart';
import 'package:blood_pressure_monitoring/page/history/history_bpm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loadmore_listview/loadmore_listview.dart';

import '../../style/mainStyle.dart';
import '../../style/textStyle.dart';

class EepromBpm extends StatefulWidget {
  EepromBpm({super.key, required this.isDelete, required this.bdc});

  EepromModelController bdc;
  bool isDelete;

  @override
  State<EepromBpm> createState() => _EepromBpmState();
}

class _EepromBpmState extends State<EepromBpm> {
  final keyAnimatedList = GlobalKey<AnimatedListState>();
  final pc = PageController();
  final bDdc = BPMDataController();
  var eDataC = EepromDataController();
  var eJsonC = EepromJsonFileDataController();

  @override
  void didUpdateWidget(covariant EepromBpm oldWidget) {
    // TODO: implement didUpdateWidget
    eDataC= EepromDataController();
    eJsonC= EepromJsonFileDataController();

    // print("didUpdateWidget called ${widget.bdc.list.length} ${pc.page}");
    // if (oldWidget.bdc.list.length != widget.bdc.list.length) {
      if(widget.bdc.list.isEmpty){

        if(pc.page ==1.0 ){
          pc.animateToPage(0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn);
        }
      // }
      
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // eDataC.list.addAll([
    //   EepromDataModel(
    //       id: 1,
    //       modelId: 1,
    //       systolic: 232,
    //       diastolic: 22,
    //       heartRate: 22,
    //       time: DateTime.now().microsecondsSinceEpoch - 1000000),
    //   EepromDataModel(
    //       id: 2,
    //       modelId: 1,
    //       systolic: 232,
    //       diastolic: 22,
    //       heartRate: 22,
    //       time: DateTime.now().microsecondsSinceEpoch - 2000000),
    //   EepromDataModel(
    //       id: 3,
    //       modelId: 1,
    //       systolic: 232,
    //       diastolic: 22,
    //       heartRate: 22,
    //       time: DateTime.now().microsecondsSinceEpoch - 3000000),
    //   EepromDataModel(
    //       id: 4,
    //       modelId: 1,
    //       systolic: 232,
    //       diastolic: 22,
    //       heartRate: 22,
    //       time: DateTime.now().microsecondsSinceEpoch - 4000000),
    // ]);
  }

  @override
  Widget build(BuildContext context) {
    final lWidth = MediaQuery.of(context).size.width;
    final lHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8, top: 20),
      child: PageView(
        clipBehavior: Clip.none,
        controller: pc,
        physics: NeverScrollableScrollPhysics(),
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              EepromTitleBpm(),
              Expanded(
                child: widget.bdc.list.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              "assets/noData.svg",
                              width: 70,
                              color: MainStyle.primaryColor
                                  .withAlpha((255 * 0.7).toInt()),
                            ),
                            Text(
                              "No Data Available",
                              style: MyTextStyle.defaultFontCustom(
                                  MainStyle.primaryColor
                                      .withAlpha((255 * 0.7).toInt()),
                                  28,
                                  weight: FontWeight.bold),
                            )
                          ],
                        ),
                      )
                    : LoadMoreListView.builder(
                        // key: keyAnimatedList,
                        padding: EdgeInsets.zero,
                        keyAnimatedList: keyAnimatedList,
                        clipBehavior: Clip.hardEdge,
                        itemCount: widget.bdc.list.length,
                        hasMoreItem: widget.bdc.list.length < widget.bdc.max,
                        onLoadMore: () async {
                          // keyAnimatedList.currentState!
                          //     .insertItem(widget.bdc.list.length);

                          // keyAnimatedList.currentState!
                          //     .insertItem(widget.bdc.list.length);

                          // await widget.bdc.find(widget.bdc.list.length, () {});

                          // // keyAnimatedList.currentState!.removeItem(
                          // //     widget.bdc.list.length + 1, (c, a) => SizedBox());

                          // // await Future.delayed(const Duration(seconds: 2));

                          // // if (mounted) {
                          // // setState(() {});
                          // // }
                          // // keyAnimatedList.currentState!.removeItem(1, (c, a) {
                          // //   return Visibility(visible: false, child: SizedBox());
                          // // });

                          // keyAnimatedList.currentState!.insertAllItems(
                          //     widget.bdc.list.length - 20,
                          //     widget.bdc.list.length -
                          //         (widget.bdc.list.length - 20));
                        },
                        onRefresh: () => widget.bdc.find(0, () {
                          if (mounted) {
                            // setState(() {});
                            // keyAnimatedList.currentState!.reassemble();
                            keyAnimatedList.currentState!
                                .removeAllItems((c, a) => SizedBox());
                            keyAnimatedList.currentState!
                                .insertAllItems(0, widget.bdc.list.length);
                          }
                        }),
                        loadMoreWidget: Container(
                            margin: const EdgeInsets.all(20.0),
                            alignment: Alignment.center,
                            child: const SpinKitThreeBounce(
                              color: MainStyle.whiteColor,
                            )),
                        itemBuilder: (context, i, animation) => EepromItemBpm(
                          onTap: () {
                            // bDdc.list.clear();
                            // bDdc.list.addAll(eDataC.list
                            //     .where(
                            //         (e) => e.modelId == widget.bdc.list[i].id)
                            //     .map((e) => BpmDataModel(
                            //         systolic: e.systolic,
                            //         diastolic: e.diastolic,
                            //         heartRate: e.heartRate,
                            //         time: e.time)) 
                            //     .toList());

                            bDdc.list.clear();
                            // print("eDataC model id ${widget.bdc.list[i].id}");
                            eDataC.find(widget.bdc.list[i].id, 0, () {
                              
                              bDdc.list.addAll(eDataC.list
                                  .map((e) => BpmDataModel(
                                      systolic: e.systolic,
                                      diastolic: e.diastolic,
                                      heartRate: e.heartRate,
                                      time: e.time))
                                  .toList());
                              setState(() {});

                              final c = Controller();
                              pc.animateToPage(1,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeIn);
                            });
                          },
                          isDelete: widget.isDelete,
                          fdm: widget.bdc.list[i],
                          animation: animation,
                          // model: widget.fhc.list[i],
                          onDelete: () => widget.bdc.deletePrompt(
                              i, widget.bdc.list[i].time, context, () {
                            if (mounted) {
                              setState(() {});
                            }
                          }, keyAnimatedList),
                          // isDelete: widget.fhc.isDelete,
                        ),
                      ),
              )
            ],
          ),
          Transform.translate(
            offset: Offset(0, -20),
            child: Column(
              children: [
                TextButton(
                    onPressed: () => pc.animateToPage(0,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn),
                    child: Row(
                      children: [
                        Icon(Icons.arrow_back,
                            color: MainStyle.primaryColor, size: 30),
                        MainStyle.sizedBoxW5,
                        Text(
                          "Back",
                          style: MyTextStyle.defaultFontCustom(
                              MainStyle.primaryColor, 14),
                        )
                      ],
                    )),
                Expanded(
                    child: HistoryBpm(
                  isRefresh: false,
                  isDelete: widget.isDelete,
                  bdc: bDdc,
                  padding: EdgeInsets.zero,
                  onTap: (i) {
                    final r = eJsonC.find(eDataC.list[i].id, 0, () {
                      setState(() {});
          
                      final c = Controller();
                      c.cupertinoPageRoute(
                          context,
                          FileContent(
                              jdm: JsonFileDataModel(
                            fileName: eJsonC.list.first.fileName,
                            content: eJsonC.list.first.content,
                            time: eJsonC.list.first.time,
                          )));
                    });
                  },
                ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
