import 'package:blood_pressure_monitoring/style/mainStyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomNav extends StatelessWidget {
  int page;
  BottomNav({super.key, required this.page, required this.onClick});
  Function(int page) onClick;

  var nav_button = [
    {
      "page": 0,
      "title": "Home",
      "icon": "assets/home.svg",
    },
    {
      "page": 1,
      "title": "History",
      "icon": "assets/history.svg",
    },
    {
      "page": 2,
      "title": "File",
      "icon": "assets/file_bpm.svg",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final heightLogical = MediaQuery.of(context).size.height;
    final widthLogical = MediaQuery.of(context).size.width;
    return Container(
      width: widthLogical,
      height: heightLogical * 0.12,
      decoration: BoxDecoration(
        color: MainStyle.primaryColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: nav_button
              .map((e) => SizedBox(
                    width: 110,
                    height: 80,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: Material(
                        type: MaterialType.transparency,
                        child: InkWell(
                          onTap: () => onClick((e["page"] as int)),
                          splashColor: Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          child: Stack(
                            children: [
                              Center(
                                child: AnimatedContainer(
                                  width: (e["page"] as int) == page ? 122 : 0,
                                  height: 80,
                                  duration: const Duration(milliseconds: 100),
                                  curve: Curves.easeIn,
                                  decoration: BoxDecoration(
                                      color: (e["page"] as int) == page
                                          ? const Color(0xff344B47)
                                          : MainStyle.primaryColor,
                                      borderRadius: BorderRadius.circular(20)),
                                ),
                              ),
                              Center(
                                child: SvgPicture.asset(
                                  (e["icon"] as String),
                                  width: 29,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
