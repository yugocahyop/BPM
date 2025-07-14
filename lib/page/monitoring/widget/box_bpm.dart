import 'package:flutter/material.dart';

import '../../../style/mainStyle.dart';

class BoxBpm extends StatelessWidget {
  BoxBpm(
      {super.key,
      this.borderRadius,
      this.color,
      required this.width,
      required this.height,
      required this.child});

  double width;
  double height;
  Widget child;
  Color? color;
  BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
          borderRadius: borderRadius ?? BorderRadius.circular(20),
          color: color ?? MainStyle.primaryColor),
      child: child,
    );
  }
}
