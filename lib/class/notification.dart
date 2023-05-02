import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class notification {
  static Future inittilize(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var androidInittilize =
        new AndroidInitializationSettings('mipmap/ic_launcher');

    var initializationSettings =
        new InitializationSettings(android: androidInittilize);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static showBigTextNotification({
    var id = 0,
    required DateTime dateTime,
    required String title,
    required String body,
    DateTime? time,
    required FlutterLocalNotificationsPlugin fln,
  }) async {
    const channelId = '2';

    final androidDetails = AndroidNotificationDetails(
      channelId,
      'TaskApp',
      enableLights: true,
      ledColor: Colors.green,
      ledOnMs: 2,
      ledOffMs: 2,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('notification'),
      importance: Importance.max,
      priority: Priority.high,
    );

    final platformDetails = NotificationDetails(
      android: androidDetails,
    );
    tz.initializeTimeZones();
    final scheduledDate = tz.TZDateTime.from(dateTime, tz.local);

    await fln.zonedSchedule(
      0,
      title,
      body,
      scheduledDate,
      platformDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.wallClockTime,
      androidAllowWhileIdle: true,
    );

    final scheduledDatee = tz.TZDateTime.from(time!, tz.local);

    await fln.zonedSchedule(
      0,
      title,
      body,
      scheduledDatee,
      platformDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.wallClockTime,
      androidAllowWhileIdle: true,
    );
  }
}
