import 'package:blood_pressure_monitoring/controller/bpmDataController.dart';
<<<<<<< HEAD
import 'package:blood_pressure_monitoring/controller/bpmJsonFileDataController%20copy.dart';
=======
import 'package:blood_pressure_monitoring/controller/bpmJsonFileDataController.dart';
>>>>>>> 7753693 (2026 feb 2 2)
import 'package:blood_pressure_monitoring/controller/controller.dart';
import 'package:blood_pressure_monitoring/page/file/widget/fileItemContent_bpm.dart';
import 'package:blood_pressure_monitoring/page/file/widget/fileItem_bpm.dart';
import 'package:blood_pressure_monitoring/page/file/widget/fileTitle_bpm.dart';
<<<<<<< HEAD
import 'package:blood_pressure_monitoring/page/history/widget/deleteBar_bpm.dart';
import 'package:blood_pressure_monitoring/page/history/widget/historyItem_bpm.dart';
import 'package:blood_pressure_monitoring/page/history/widget/historyTitle_bpm.dart';
=======
import 'package:blood_pressure_monitoring/page/page2/widget/deleteBar_bpm.dart';
import 'package:blood_pressure_monitoring/page/history/widget/historyItem_bpm.dart';
import 'package:blood_pressure_monitoring/page/history/widget/historyTitle_bpm.dart';
import 'package:blood_pressure_monitoring/widget/downloadBox.dart';
>>>>>>> 7753693 (2026 feb 2 2)
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loadmore_listview/loadmore_listview.dart';

import '../../style/mainStyle.dart';
import '../../style/textStyle.dart';

class FileBpm extends StatefulWidget {
  FileBpm({super.key, required this.fdc});

  JsonFileDataController fdc;

  @override
  State<FileBpm> createState() => _FileBpmState();
}

class _FileBpmState extends State<FileBpm> {
  final keyAnimatedList = GlobalKey<AnimatedListState>();
  bool showDelete = true, isDeleting = false;

  @override
  Widget build(BuildContext context) {
    final lWidth = MediaQuery.of(context).size.width;
    final lHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8, top: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
<<<<<<< HEAD
              Text(
                "File",
                style: MyTextStyle.defaultFontCustom(MainStyle.thirdColor, 21,
                    weight: FontWeight.bold),
              ),
              DeleteBar(
=======
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  "File",
                  style: MyTextStyle.defaultFontCustom(MainStyle.thirdColor, 21,
                      weight: FontWeight.bold),
                ),
              ),
              DeleteBar(
                  onDownloadTap: (){
                    // final c = Controller();
                    // c.cupertinoPageRoute(context, DownloadBox(edc: widget.fdc.edc), bdc);
                  },
>>>>>>> 7753693 (2026 feb 2 2)
                  isDeleting: isDeleting,
                  showDelete: showDelete,
                  onClearAll: () =>
                      widget.fdc.deleteAll(context, () => setState(() {})),
                  onDeleteCancel: () {
                    setState(() {
                      isDeleting = false;
                    });
                  },
                  onThrashTap: () {
                    setState(() {
                      isDeleting = true;
                    });
                  })
            ],
          ),
          MainStyle.sizedBoxH20,
          FiletitleBpm(),
          Expanded(
            child: widget.fdc.list.isEmpty
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
                          "No File Available",
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
                    // reverse: true,
                    padding: EdgeInsets.zero,
                    keyAnimatedList: keyAnimatedList,
                    clipBehavior: Clip.hardEdge,
                    itemCount: widget.fdc.list.length,
                    hasMoreItem: widget.fdc.list.length < widget.fdc.max,
                    onLoadMore: () async {
                      // keyAnimatedList.currentState!
                      //     .insertItem(widget.fdc.list.length);

                      // keyAnimatedList.currentState!
                      //     .insertItem(widget.fdc.list.length);

                      // await widget.fdc.find(widget.fdc.list.length, () {});

                      // // keyAnimatedList.currentState!.removeItem(
                      // //     widget.fdc.list.length + 1, (c, a) => SizedBox());

                      // // await Future.delayed(const Duration(seconds: 2));

                      // // if (mounted) {
                      // // setState(() {});
                      // // }
                      // // keyAnimatedList.currentState!.removeItem(1, (c, a) {
                      // //   return Visibility(visible: false, child: SizedBox());
                      // // });

                      // keyAnimatedList.currentState!.insertAllItems(
                      //     widget.fdc.list.length - 20,
                      //     widget.fdc.list.length -
                      //         (widget.fdc.list.length - 20));
                    },
                    onRefresh: () => widget.fdc.find(0, () {
                      if (mounted) {
                        // setState(() {});
                        // keyAnimatedList.currentState!.reassemble();
                        keyAnimatedList.currentState!
                            .removeAllItems((c, a) => SizedBox());
                        keyAnimatedList.currentState!
                            .insertAllItems(0, widget.fdc.list.length);
                      }
                    }),
                    loadMoreWidget: Container(
                        margin: const EdgeInsets.all(20.0),
                        alignment: Alignment.center,
                        child: const SpinKitThreeBounce(
                          color: MainStyle.whiteColor,
                        )),
                    itemBuilder: (context, i, animation) => GestureDetector(
                      onTap: () {
                        final c = Controller();
                        c.cupertinoPageRoute(
                            context,
                            FileContent(
                              jdm: widget.fdc.list[i],
                            ));
                      },
                      child: FileitemBpm(
                        isDelete: isDeleting,
                        fdm: widget.fdc.list[i],
                        animation: animation,
                        // model: widget.fhc.list[i],
                        onDelete: () => widget.fdc.deletePrompt(
                            i, widget.fdc.list[i].time, context, () {
                          if (mounted) {
                            setState(() {});
                          }
                        }, keyAnimatedList),
                        // isDelete: widget.fhc.isDelete,
                      ),
                    ),
                  ),
          )
        ],
      ),
    );
  }
}
