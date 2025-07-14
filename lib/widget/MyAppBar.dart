import 'package:flutter/material.dart';

class Myappbar extends StatelessWidget {
  Myappbar({super.key, required this.actions});

  List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final lWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      width: lWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            "assets/logo_horizontal_detect_me.png",
            width: 150,
          ),
          SizedBox(
            // width: 50,
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: actions.map((e) => e).toList(),
            ),
          )
        ],
      ),
    );
  }
}
