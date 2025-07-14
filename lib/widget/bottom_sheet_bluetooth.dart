import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

import '../controller/controller.dart';
import '../style/mainStyle.dart';
import '../style/textStyle.dart';
import '../tools/bluetoothMobile.dart';
import 'dialogBox_xirkabit.dart';
import 'myButton.dart';

class Bottom_sheet_bluetooth extends StatefulWidget {
  Bottom_sheet_bluetooth({super.key, required this.bluetooth_controller});

  BluetoothLeMobile bluetooth_controller;

  @override
  State<Bottom_sheet_bluetooth> createState() => _Bottom_sheet_bluetoothState();
}

class _Bottom_sheet_bluetoothState extends State<Bottom_sheet_bluetooth>
    with TickerProviderStateMixin {
  late AnimationController lottie_controller;

  checkOn() async {
    final isOn = await widget.bluetooth_controller.checkBluetoothOn();

    if (!isOn) {
      Navigator.pop(context);

      final c = Controller();
      await c.goToDialog(
          context,
          DialogboxXirkabit(
              iconData: Icons.bluetooth,
              iconBackgroundColor: MainStyle.primaryColor,
              title: "Bluetooth Not Enabled!",
              subtitle: "Please enable bluetooth to continue.",
              textButton1: "Enable",
              buttonAction1: () =>
                  widget.bluetooth_controller.enableBluetooth()));

      // widget.bluetooth_controller.StartScan();

      // lottie_controller.reset();
      // lottie_controller
      //   ..duration = const Duration(seconds: 5)
      //   ..forward();
    } else {
      if (widget.bluetooth_controller.devices.isEmpty) {
        widget.bluetooth_controller.StartScan();
      }

      Future.delayed(const Duration(seconds: 5), () {
        if (mounted) {
          setState(() {});
        }
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    checkOn();

    lottie_controller = AnimationController(vsync: this);

    // widget.bluetooth_controller.devices.clear();
    draggableController.addListener(() {
      if (kDebugMode) {
        print(draggableController.size);
      }
      if (draggableController.size <= 0.0001 && !isOut) {
        isOut = true;
        Navigator.pop(context);
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    lottie_controller.stop();

    lottie_controller.dispose();
    draggableController.dispose();

    super.dispose();
  }

  final draggableController = DraggableScrollableController();
  bool isOut = false;

  @override
  Widget build(BuildContext context) {
    final lWidth = MediaQuery.of(context).size.width;
    final lHeight = MediaQuery.of(context).size.height;
    // print(lHeight);
    return DraggableScrollableSheet(
        controller: draggableController,
        snap: true,
        shouldCloseOnMinExtent: true,
        initialChildSize: lHeight < 500 ? 0.9 : 0.5,
        maxChildSize: 0.9,
        minChildSize: 0,
        snapSizes: [0, 0.5, 0.9],
        builder: (context, sc) {
          return Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                color: Colors.white),
            // height: 500,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  controller: sc,
                  child: Container(
                    width: lWidth,
                    height: 30,
                    // color: Colors.red,
                    child: Center(
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        width: 32.0,
                        height: 4.0,
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                ),
                Text(
                  "Connect to Device",
                  style: MyTextStyle.defaultFontCustom(
                      MainStyle.primaryColor, 15,
                      weight: FontWeight.bold),
                ),
                widget.bluetooth_controller.devices.isEmpty
                    ? Expanded(
                        child: Center(
                        child: Lottie.asset(
                          "assets/search.json",
                          repeat: false,
                          // reverse: true,
                          controller: lottie_controller,
                          onLoaded: (p0) {
                            lottie_controller
                              ..duration = Duration(seconds: 5)
                              ..forward();
                          },
                        ),
                      ))
                    : Flexible(
                        child: ListView.builder(
                          // controller: sc,
                          itemCount: widget.bluetooth_controller.devices.length,
                          itemBuilder: (context, index) {
                            if (widget.bluetooth_controller.devices.isEmpty)
                              return SizedBox();
                            final device =
                                widget.bluetooth_controller.devices[index];

                            return Material(
                              type: MaterialType.transparency,
                              child: ListTile(
                                splashColor: Colors.black38,
                                onTap: () async {
                                  await widget.bluetooth_controller
                                      .disconnect();
                                  widget.bluetooth_controller
                                      .connectByMac(device.device.remoteId.str);
                                  Navigator.pop(context);
                                },
                                leading: Container(
                                    padding: const EdgeInsets.all(3.0),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(60),
                                        color: MainStyle.primaryColor),
                                    child: Icon(
                                      Icons.bluetooth,
                                      color: Colors.white,
                                    )),
                                title: Text(device.device.advName,
                                    style: MyTextStyle.defaultFontCustom(
                                        MainStyle.primaryColor, 12)),
                                subtitle: Text(device.device.remoteId.str,
                                    style: MyTextStyle.defaultFontCustom(
                                        MainStyle.secondaryColor, 12)),
                                trailing: SizedBox(
                                  width: 55,
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 30,
                                        // height: 15,
                                        child: SvgPicture.asset(
                                          widget.bluetooth_controller
                                              .getSignal(device.rssi),
                                          color: MainStyle.primaryColor,
                                          // width: 15,
                                        ),
                                      ),
                                      widget.bluetooth_controller.currDevice !=
                                                  null &&
                                              device.device.remoteId.str ==
                                                  widget.bluetooth_controller
                                                      .currDevice!.remoteId.str
                                          ? Icon(
                                              Icons.check_circle,
                                              // color: const Color(0xffFF5DB6),
                                              color: Colors.green,
                                            )
                                          : SizedBox()
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                MyButton(
                    color: MainStyle.primaryColor,
                    text: widget.bluetooth_controller.currDevice != null
                        ? "Disconnect"
                        : "Scan for New Devices",
                    onPressed: () async {
                      if (widget.bluetooth_controller.currDevice != null) {
                        await widget.bluetooth_controller.disconnect();

                        setState(() {});
                        return;
                      }

                      widget.bluetooth_controller.devices.clear();
                      setState(() {});
                      widget.bluetooth_controller.StartScan();

                      lottie_controller.reset();
                      lottie_controller
                        ..duration = const Duration(seconds: 5)
                        ..forward();

                      Future.delayed(const Duration(seconds: 5), () {
                        if (mounted) {
                          setState(() {});
                        }
                      });
                    },
                    textColor: Colors.white)
              ],
            ),
          );
        });
  }
}
