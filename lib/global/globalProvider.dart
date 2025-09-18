import 'package:flutter/material.dart';

class Globalprovider extends InheritedWidget {
  Globalprovider({super.key, required this.child}) : super(child: child);

  bool showNotif = false, visibilityNotif = false, isOk = false;
  String infoText = "";

  final Widget child;

  void show(String info, {int? duration, required Function setState}) {
    if (visibilityNotif) return;
    visibilityNotif = true;

    infoText = info;

    setState(() {});
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        showNotif = true;
      });

      Future.delayed(Duration(seconds: duration ?? 2), () {
        // print(visibilityNotif);
        setState(() {
          visibilityNotif = true;
          showNotif = false;
        });

        Future.delayed(const Duration(milliseconds: 300), () {
          setState(() {
            visibilityNotif = false;
          });
        });
      });
    });
  }

  static Globalprovider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Globalprovider>();
  }

  @override
  bool updateShouldNotify(Globalprovider oldWidget) {
    return oldWidget == this;
  }
}
