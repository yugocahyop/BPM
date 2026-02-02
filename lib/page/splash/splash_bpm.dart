import 'dart:ffi';

import 'package:blood_pressure_monitoring/page/home/home_bpm.dart';
import 'package:blood_pressure_monitoring/style/mainStyle.dart';
import 'package:blood_pressure_monitoring/style/textStyle.dart';
import 'package:blood_pressure_monitoring/tools/fileService.dart';
import 'package:blood_pressure_monitoring/tools/notificationService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../controller/controller.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash>  {
  
  checkRequirementAndChangePage() async {
    final c = Controller();
    await c.checkPermission();

    
    Future.delayed(const Duration(milliseconds: 5000), () {
      final c = Controller();
      c.pageRouteReplace(context,  Home());
    });
  }

  @override
  void initState() {
    super.initState();

<<<<<<< HEAD
    WakelockPlus.enable();

=======
    
    WakelockPlus.enable();

    NotificationService.onNotificationTapped = (payload) {
      showDownloadFolder(payload);
    };
    NotificationService.init();

>>>>>>> 7753693 (2026 feb 2 2)
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

        // _topAnimationController.forward();

    checkRequirementAndChangePage();
  }

  @override
  void dispose() {
    // _topAnimationController.dispose();
    super.dispose();
  }

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
           SvgPicture.asset(
                "assets/topSplash_bpm.svg",
                width: widthLogical,
              ),
            
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    "assets/logo_bpm.svg",
                    width: widthLogical * 0.5,
                    fit: BoxFit.fill,
                  ),
                  MainStyle.sizedBoxH20,
                  Text(
                    "Blood Pressure",
                    style: MyTextStyle.defaultFontCustom(MainStyle.thirdColor, 34,
                        weight: FontWeight.w800),
                  ),
                  Text(
                    "Monitoring",
                    style: MyTextStyle.defaultFontCustom(MainStyle.thirdColor, 34,
                        weight: FontWeight.w800),
                  )
                ],
              ),
            ),
            SvgPicture.asset(
              "assets/bottomSplash_bpm.svg",
              width: widthLogical,
              fit: BoxFit.fill,
            ),
          ],
        ),
      ),
    );
  }
}
