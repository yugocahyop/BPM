import '../style/mainStyle.dart';
import 'package:flutter/material.dart';

import '../style/textStyle.dart';

class MyButton extends StatelessWidget {
  final Color color;
  final String text;

  Widget? icon;
  final Function() onPressed;
  Color textColor;
  // double? height;
  double? width;

  MyButton(
      {Key? key,
      required this.color,
      required this.text,
      required this.onPressed,
      this.icon,
      required this.textColor,
      this.width});

  @override
  Widget build(BuildContext context) {
    final ButtonStyle raisedButtonStyle = ButtonStyle(
      shape: MaterialStateProperty.all(RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)),
      )),
      // shape: const RoundedRectangleBorder(
      //   borderRadius: BorderRadius.all(Radius.circular(8)),
      // ),
      backgroundColor: MaterialStateProperty.all(color),
      elevation: MaterialStateProperty.all(5),
      // minimumSize: Size(88, 36),

      // padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 30)),

      shadowColor: MaterialStateProperty.all(Colors.black),
    ).copyWith(
      // shadowColor: MaterialStateProperty.resolveWith((states) =>  color),
      shadowColor: MaterialStateProperty.all(Colors.black),
      overlayColor:
          MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
        if (states.contains(MaterialState.focused)) return color;
        if (states.contains(MaterialState.hovered)) return Colors.black26;
        if (states.contains(MaterialState.pressed))
          return Colors.black.withOpacity(0.5);
        return Colors.black; // D,
      }),
    );

    final logicalScreenSize = MediaQuery.of(context).size;
    final logicalWidth = logicalScreenSize.width;
    final logicalHeight = logicalScreenSize.height;
    final MyTextStyle ts = MyTextStyle(logicalHeight);

    // TODO: implement build
    return Container(
        constraints:
            width == null ? null : BoxConstraints.tightFor(width: width!),
        child: ElevatedButton(
            style: raisedButtonStyle,
            onPressed: onPressed,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Visibility(
                  visible: text.isNotEmpty,
                  child: Text(
                    text,
                    style: MyTextStyle.defaultFontCustom(textColor, 13,
                        weight: FontWeight.w700),
                  ),
                ),
                // MainStyle.sizedBoxW10,
                // Visibility(
                //     visible: icon != null,
                //     child: Center(child: icon ?? const Icon(Icons.dangerous))),
              ],
            )));
  }
}
