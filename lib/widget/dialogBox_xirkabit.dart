import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

import '../style/mainStyle.dart';
import '../style/textStyle.dart';
import 'myButton.dart';

class DialogboxXirkabit extends StatelessWidget {
  DialogboxXirkabit(
      {super.key,
      this.buttonNumber = 2,
      required this.iconData,
      required this.iconBackgroundColor,
      required this.title,
      required this.subtitle,
      required this.textButton1,
      required this.buttonAction1,
      this.buttonWidth,
      this.iconSvg,
      this.actionColor = MainStyle.primaryColor,
      this.cancelColor = const Color(0xffA8AE9C)});

  IconData iconData;
  Color iconBackgroundColor;
  SvgPicture? iconSvg;
  String title;
  String subtitle;
  String textButton1;
  Function buttonAction1;
  Color cancelColor;
  Color actionColor;
  int buttonNumber;
  double? buttonWidth;

  @override
  Widget build(BuildContext context) {
    final lWidth = MediaQuery.of(context).size.width;
    final lHeight = MediaQuery.of(context).size.height;
    return Center(
      child: Container(
        width: lWidth * 0.95,
        height: lHeight * 0.3,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.white),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: iconBackgroundColor),
                  child: iconSvg ?? Icon(
                    iconData,
                    color: Colors.white,
                  )),
              MainStyle.sizedBoxH10,
              Material(
                color: Colors.white,
                child: Text(
                  title,
                  style: MyTextStyle.defaultFontCustom(Colors.black, 15,
                      weight: FontWeight.w600),
                ),
              ),
              SizedBox(
                width: lWidth * 0.8,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  runAlignment: WrapAlignment.center,
                  children: [
                    Center(
                      child: Material(
                        color: Colors.white,
                        child: Text(subtitle,
                            textAlign: TextAlign.center,
                            style: MyTextStyle.defaultFontCustom(
                                Colors.black, 12)),
                      ),
                    )
                  ],
                ),
              ),
              MainStyle.sizedBoxH10,
              Container(
                padding: const EdgeInsets.all(10),
                width: lWidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Visibility(
                      visible: buttonNumber == 2,
                      child: Row(
                        children: [
                          SizedBox(
                            width: buttonWidth,
                            child: MyButton(
                                color: cancelColor,
                                text: "Cancel",
                                onPressed: () => Navigator.pop(context, false),
                                textColor: Colors.white),
                          ),
                          MainStyle.sizedBoxW20,
                        ],
                      ),
                    ),
                    SizedBox(
                      width: buttonWidth,
                      child: MyButton(
                          color: actionColor,
                          text: textButton1,
                          onPressed: () {
                            Navigator.pop(context, true);
                            buttonAction1();
                          },
                          textColor: Colors.white),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
