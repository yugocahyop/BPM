import 'package:blood_pressure_monitoring/controller/bpmDataController.dart';
import 'package:blood_pressure_monitoring/page/history/widget/deleteBar_bpm.dart';
import 'package:blood_pressure_monitoring/page/history/widget/historyItem_bpm.dart';
import 'package:blood_pressure_monitoring/page/history/widget/historyTitle_bpm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loadmore_listview/loadmore_listview.dart';

import '../../style/mainStyle.dart';
import '../../style/textStyle.dart';

class HistoryBpm extends StatefulWidget {
  HistoryBpm({super.key, required this.bdc});

  BPMDataController bdc;

  @override
  State<HistoryBpm> createState() => _HistoryBpmState();
}

class _HistoryBpmState extends State<HistoryBpm> {
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
              Text(
                "History",
                style: MyTextStyle.defaultFontCustom(MainStyle.thirdColor, 21,
                    weight: FontWeight.bold),
              ),
              DeleteBar(
                  isDeleting: isDeleting,
                  showDelete: showDelete,
                  onClearAll: () =>
                      widget.bdc.deleteAll(context, () => setState(() {})),
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
          HistorytitleBpm(),
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
                    itemBuilder: (context, i, animation) => HistoryitemBpm(
                      isDelete: isDeleting,
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
    );
  }
}
