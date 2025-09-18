import 'dart:io';

import 'package:blood_pressure_monitoring/global/globalProvider.dart';
import 'package:device_info_plus/device_info_plus.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../style/mainStyle.dart';
import '../style/mainStyle.dart';
import '../tools/heroPageRoute.dart';
import 'package:permission_handler/permission_handler.dart' as perm;

// import '../tools/apiHelper.dart';
import '../widget/myTextField.dart';

class Controller {
  // final BuildContext context;
  Controller();

  Function()? setState;

  static String addZero(String time) {
    return time.length > 1 ? time : "0$time";
  }

  showSnackBar(BuildContext context, String text) {
    FocusScope.of(context).unfocus();

    var snackbar = SnackBar(
      elevation: 10,
      content: Text(text),
      // backgroundColor: ,
      // duration: const Duration(seconds: 1),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  bool validate(List<Mytextfield> inputs, BuildContext context) {
    for (var i = 0; i < inputs.length; i++) {
      if (inputs[i].con.text.isEmpty) {
        inputs[i].startShake();

        inputs[i].focusNode.requestFocus();

        return false;
      } else if (inputs[i].inputType == TextInputType.number &&
          int.tryParse(inputs[i].con.text) == null) {
        inputs[i].startShake();

        inputs[i].focusNode.requestFocus();

        showSnackBar(context, "${inputs[i].hintText} harus angka");

        return false;
      }
    }

    return true;
  }

  Future<dynamic> goToDialog(BuildContext context, Widget w) async {
    return await showDialog(
        context: context,
        builder: ((context) {
          return Globalprovider(child: w);
        }));
  }

  // static const String KEY_CUR_USER_ID = "com.xirka.xfeeder.user_id";
  // static const String KEY_CUR_USER_TOKEN = "com.xirka.xfeeder.token";
  // static const String KEY_CUR_USER_LAST_UPDATE =
  //     "com.xirka.xfeeder.last.update";

  // Future<void> saveSharedPref(String key, dynamic val) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();

  //   if (val is String) {
  //     await prefs.setString(key, val);
  //   } else if (val is int) {
  //     await prefs.setInt(key, val);
  //   } else if (val is bool) {
  //     await prefs.setBool(key, val);
  //   }
  // }

  // Future<dynamic> loadSharedPref(String key, String dateType) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();

  //   // String? email = prefs.getString(key);

  //   switch (dateType) {
  //     case "int":
  //       return prefs.getInt(key);
  //     case "String":
  //       return prefs.getString(key);
  //     case "bool":
  //       return prefs.getBool(key);

  //     default:
  //   }
  // }

  Future<void> checkPermission() async {
    if (!Platform.isAndroid) return;
    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;

    if (androidInfo.version.sdkInt > 30) {
      Map<perm.Permission, perm.PermissionStatus> statuses = await [
        perm.Permission.bluetoothScan,
        perm.Permission.bluetoothConnect,
        // perm.Permission.storage,
        perm.Permission.location,
      ].request();
    } else {
      Map<perm.Permission, perm.PermissionStatus> statuses = await [
        perm.Permission.bluetooth,
        // perm.Permission.storage,
        perm.Permission.location,
      ].request();
    }
  }

  Future<void> setStatusBarColor() async {
    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;

    if (androidInfo.version.sdkInt >= 35) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ));
    } else {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor: MainStyle.whiteColor,
          statusBarIconBrightness: Brightness.dark));
    }
  }

  pageRoute(BuildContext context, Widget w, {String? name}) async {
    return await Navigator.push(
        context,
        MaterialPageRoute(
            settings: RouteSettings(name: name ?? ""),
            maintainState: true,
            fullscreenDialog: false,
            builder: (BuildContext context) {
              return w;
            }));
  }

  pageRouteReplace(BuildContext context, Widget w, {String? name}) async {
    return await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            settings: RouteSettings(name: name ?? ""),
            maintainState: true,
            fullscreenDialog: false,
            builder: (BuildContext context) {
              return w;
            }));
  }

  cupertinoPageRoute(BuildContext context, Widget w, {String? name}) async {
    return await Navigator.push(
        context,
        CupertinoPageRoute(
            settings: RouteSettings(name: name ?? ""),
            maintainState: false,
            fullscreenDialog: false,
            builder: (BuildContext context) {
              return w;
            }));
  }

  cupertinoPageRouteReplace(BuildContext context, Widget w,
      {String? name}) async {
    return await Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
            settings: RouteSettings(name: name ?? ""),
            maintainState: false,
            fullscreenDialog: false,
            builder: (BuildContext context) {
              return w;
            }));
  }

  heroPageRoute(BuildContext context, Widget w, {String? name}) async {
    return await Navigator.push(
        context,
        HeroDialogRoute(
            settings: RouteSettings(name: name ?? ""),
            builder: (BuildContext context) {
              return w;
            }));
  }

  heroPageRouteReplace(BuildContext context, Widget w, {String? name}) async {
    return await Navigator.pushReplacement(
        context,
        HeroDialogRoute(
            settings: RouteSettings(name: name ?? ""),
            builder: (BuildContext context) {
              return w;
            }));
  }
}
