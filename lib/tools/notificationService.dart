import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Function onNotificationTapped= (payload) {};

  static Future<void> init() async {
    // Request permission for Android 13+

    // _onNotificationTapped = _onNotificationTapped;

    // if (await Permission.notification.isDenied) {
    //   await Permission.notification.request();
    // }

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_stat_bpmlogo');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings, onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
  }

  static void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload != null) {
      if (kDebugMode) {
        print('notification payload: $payload');
      }

      onNotificationTapped(payload);
    }
    
}


  static Future<void> showNotification(String title, String body, {String? payload}) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'file_download_channel',
      'File Download Notifications',
      channelDescription: 'Channel for file download alerts',
      importance: Importance.max,
      priority: Priority.high,
       // Show as complete
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails, iOS: DarwinNotificationDetails());

    await _flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      title,
      body,
      notificationDetails,
      payload: payload, // Optional: data to pass when tapped
    );
  }
}
