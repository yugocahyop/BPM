import 'package:blood_pressure_monitoring/page/home/widget/bottomNav_bpm.dart';
import 'package:blood_pressure_monitoring/page/monitoring/monitoring_bpm.dart';
import 'package:blood_pressure_monitoring/style/mainStyle.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int page = 0;
  @override
  Widget build(BuildContext context) {
    final heightLogical = MediaQuery.of(context).size.height;
    final widthLogical = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SizedBox(
        width: widthLogical,
        height: heightLogical,
        child: Column(
          children: [
            Container(
              width: widthLogical,
              height: heightLogical * 0.1,
              decoration: const BoxDecoration(
                color: MainStyle.primaryColor,
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(20)),
              ),
            ),
            Expanded(
                child: PageView(
              children: [Monitoring()],
            )),
            BottomNav(
              page: page,
              onClick: (page1) {
                // print(page1);
                setState(() {
                  page = page1;
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
