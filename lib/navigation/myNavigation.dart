import 'package:blood_pressure_monitoring/controller/controller.dart';
import 'package:blood_pressure_monitoring/global/globalProvider.dart';
import 'package:blood_pressure_monitoring/page/home/home_bpm.dart';
import 'package:blood_pressure_monitoring/page/splash/splash_bpm.dart';
import 'package:blood_pressure_monitoring/tools/bluetoothMobile.dart';
import 'package:blood_pressure_monitoring/widget/dialogRename.dart';
import 'package:flutter/material.dart';

class MyNavigation extends StatelessWidget {
  const MyNavigation({Key? key}) : super(key: key);

  Route generatePage(child) {
    return MaterialPageRoute(builder: (context) => child);
  }

  @override
  Widget build(BuildContext context) {
    final c = Controller();
    return Globalprovider(
      child: Navigator(
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case 'splash':
              // Route for firs screen
              return generatePage(const Splash());
            case 'home':
              // Route for second screen
              return generatePage(Home());
          }
        },
        // our first screen in app
        initialRoute: 'splash',
      ),
    );
  }
}
