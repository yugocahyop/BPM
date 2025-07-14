import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../tools/bluetoothMobile.dart';
import 'bottom_sheet_bluetooth.dart';

class DeviceConnectionButton extends StatelessWidget {
  DeviceConnectionButton(
      {super.key, required this.bluetooth_controller, required this.setState});

  BluetoothLeMobile bluetooth_controller;
  Function setState;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 48,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        splashColor: Colors.black38,
        onTap: () async {
          await showModalBottomSheet(
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              // showDragHandle: true,
              context: context,
              builder: (context) => Bottom_sheet_bluetooth(
                    bluetooth_controller: bluetooth_controller,
                  ));
          // setState(() {});
          await Future.delayed(const Duration(milliseconds: 500));
          setState();
        },
        child: SvgPicture.asset(
          bluetooth_controller.currDevice != null
              ? "assets/connected.svg"
              : "assets/disconnected.svg",
          width: 23,
          fit: BoxFit.none,
          // height: 40,
        ),
      ),
    );
  }
}
