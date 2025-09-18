import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../style/mainStyle.dart';
import '../../../style/textStyle.dart';

class DeleteBar extends StatelessWidget {
  DeleteBar(
      {super.key,
      required this.isDeleting,
      required this.showDelete,
      required this.onClearAll,
      required this.onDeleteCancel,
      required this.onThrashTap});

  bool showDelete = false, isDeleting = false;
  Function onClearAll, onDeleteCancel, onThrashTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
        duration: Duration(milliseconds: 300),
        opacity: 1,
        child: isDeleting
            ? Row(
                children: [
                  TextButton(
                      onPressed: () => onClearAll(),
                      child: Text(
                        "Clear All",
                        style: MyTextStyle.defaultFontCustom(
                            const Color(0xffC73434), 15,
                            weight: FontWeight.bold),
                      )),
                  TextButton(
                      onPressed: () => onDeleteCancel(),
                      child: Text(
                        "Cancel",
                        style: MyTextStyle.defaultFontCustom(
                            MainStyle.thirdColor, 15,
                            weight: FontWeight.bold),
                      ))
                ],
              )
            : Container(
                width: 35,
                height: 35,
                padding: EdgeInsets.all(2),
                child: Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                      splashColor: Colors.black26,
                      borderRadius: BorderRadius.circular(10),
                      onTap: () => onThrashTap(),
                      child: SvgPicture.asset(
                        "assets/thrash.svg",
                        color: Color(0xffC73434),
                        height: 18,
                        fit: BoxFit.scaleDown,
                      )),
                ),
              ));
  }
}
