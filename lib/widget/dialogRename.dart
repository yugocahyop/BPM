import 'dart:async';
import 'dart:convert';

import 'package:blood_pressure_monitoring/global/globalProvider.dart';
import 'package:blood_pressure_monitoring/style/mainStyle.dart';
import 'package:blood_pressure_monitoring/style/textStyle.dart';
import 'package:blood_pressure_monitoring/tools/bluetoothMobile.dart';
import 'package:blood_pressure_monitoring/widget/infoNotif.dart';
import 'package:blood_pressure_monitoring/widget/myButton.dart';
import 'package:blood_pressure_monitoring/widget/myTextField_label.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class RenameDialog extends StatefulWidget {
  RenameDialog(
      {super.key, required this.name, required this.bluetoothController});

  String name;
  BluetoothLeMobile bluetoothController;

  @override
  State<RenameDialog> createState() => _RenameDialogState();
}

class _RenameDialogState extends State<RenameDialog> {
  Mytextfield_label nameTextField = Mytextfield_label(
    width: double.infinity,
    hintText: "Name",
    obscure: false,
  );

  List<String> instructions = [
    "• Letters and numbers are allowed",
    "• For special character, only  “-” and “_” are allowed",
    "• Maximum of 7 characters",
  ];

  bool isMaxOk = true;
  bool isSpecialCharOk = true, isProcessing = false;

  RegExp regExp = RegExp(
    r"[\da-zA-Z_-]",
  );

  Color textColor = const Color(0xff5d5d5d);

  Timer? timeOut;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    widget.bluetoothController.listenFunction = null;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Globalprovider.setState = setState;
    widget.bluetoothController.listenFunction = (data) {
      try {
        final json = jsonDecode(utf8.decode(data)) as Map<String, dynamic>;
        if ((json["msg"] as String).toLowerCase().contains("invalid")) {
          if (timeOut != null) timeOut!.cancel();
          Globalprovider.of(context)!
              .show("Invalid Bluetooth ID", setState: setState);
          nameTextField.startShake();
          nameTextField.focusNode.requestFocus();
        } else {
          Navigator.pop(context);
        }
      } catch (e) {}
    };
    nameTextField.con.addListener(() {
      if (nameTextField.con.text.isEmpty) {
        setState(() {
          isMaxOk = true;
        });
        return;
      }
      if (nameTextField.con.text.length > 7) {
        setState(() {
          isMaxOk = false;
        });
      } else {
        setState(() {
          isMaxOk = true;
        });
      }
      if (regExp.allMatches(nameTextField.con.text).length !=
          nameTextField.con.text.length) {
        setState(() {
          isSpecialCharOk = false;
        });
      } else {
        setState(() {
          isSpecialCharOk = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final lWidth = MediaQuery.of(context).size.width;
    final lHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SizedBox(
        width: lWidth,
        height: lHeight,
        child: Stack(
          children: [
            Center(
              child: Container(
                width: lWidth * 0.9,
                height: lHeight * 0.4,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            "assets/edit_name_bpm.svg",
                            width: 20,
                          ),
                          MainStyle.sizedBoxW10,
                          Text(
                            "Rename",
                            style: MyTextStyle.defaultFontCustom(
                                MainStyle.thirdColor, 18,
                                weight: FontWeight.w600),
                          ),
                        ],
                      ),
                      MainStyle.sizedBoxH10,
                      Text(
                        "Current ID : ${widget.name}",
                        style: MyTextStyle.defaultFontCustom(textColor, 13),
                      ),
                      nameTextField,
                      MainStyle.sizedBoxH10,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: instructions
                            .map((e) => Text(
                                  e,
                                  style: MyTextStyle.defaultFontCustom(
                                      instructions.indexOf(e) == 1
                                          ? (isSpecialCharOk
                                              ? textColor
                                              : Colors.red)
                                          : instructions.indexOf(e) == 2
                                              ? (isMaxOk
                                                  ? textColor
                                                  : Colors.red)
                                              : textColor,
                                      9),
                                ))
                            .toList(),
                      ),
                      MainStyle.sizedBoxH10,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MyButton(
                              width: lWidth * 0.39,
                              color: const Color(0xff699C95),
                              text: "Cancel",
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              textColor: Colors.white),
                          MainStyle.sizedBoxW10,
                          MyButton(
                              width: lWidth * 0.39,
                              color: MainStyle.thirdColor
                                  .withAlpha(isProcessing ? 125 : 255),
                              text: "Rename",
                              onPressed: () {
                                if (isProcessing) return;
                                if (isMaxOk &&
                                    isSpecialCharOk &&
                                    nameTextField.con.text.isNotEmpty) {
                                  setState(() {
                                    isProcessing = true;
                                  });
                                  widget.bluetoothController.write(
                                      ' {"cmd":"BLE","name":"${nameTextField.con.text}"} ');

                                  timeOut =
                                      Timer(const Duration(seconds: 3), () {
                                    Globalprovider.of(context)!.show(
                                        "Bluetooth ID Changed. Please restart connection",
                                        setState: setState);

                                    Future.delayed(const Duration(seconds: 3),
                                        () => Navigator.pop(context));
                                  });
                                } else {
                                  nameTextField.startShake();
                                  nameTextField.focusNode.requestFocus();
                                }
                              },
                              textColor: Colors.white)
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            InfoNotif(
              isOk: Globalprovider.of(context)!.isOk,
              infoText: Globalprovider.of(context)!.infoText,
              showInfo: Globalprovider.of(context)!.showNotif,
              visibilityInfo: Globalprovider.of(context)!.visibilityNotif,
            )
          ],
        ),
      ),
    );
  }
}
