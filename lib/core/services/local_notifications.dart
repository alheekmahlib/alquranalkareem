import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotifyHelper {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initializeNotification() async {
    tz.initializeTimeZones();
    await _configureLocalTimeZone();

    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(
      iOS: initializationSettingsIOS,
      android: initializationSettingsAndroid,
      macOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse? response) async {
        if (response != null && response.payload != null) {
          selectNotification(response.payload!);
        }
      },
    );
  }

  Future<void> scheduledNotification(int reminderId, String title, String body,
      {int? hour, int? minutes}) async {
    if (hour == null || minutes == null) {
      // إرسال الإشعار فوراً إذا لم يتم تحديد الوقت
      await displayNotification(title: title, body: body)
          .then((_) => log('$title notification scheduled'));
    } else {
      await flutterLocalNotificationsPlugin
          .zonedSchedule(
            reminderId,
            title,
            body,
            _nextInstanceOfScheduledTime(hour, minutes),
            const NotificationDetails(
              android: AndroidNotificationDetails(
                  'quran_channel_id', 'alQuran_alKareem'),
            ),
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
            androidAllowWhileIdle: true,
            payload: title,
          )
          .then((_) => log('$title notification scheduled on $hour:$minutes'));
    }
  }

  tz.TZDateTime _nextInstanceOfScheduledTime(int hour, int minutes) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minutes);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  Future<void> displayNotification(
      {required String title, required String body}) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        'quran_channel_id', 'alQuran_alKareem_channel',
        importance: Importance.max, priority: Priority.high);
    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }

  Future<void> cancelScheduledNotification(int reminderId) async {
    await flutterLocalNotificationsPlugin.cancel(reminderId);
  }

  void requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  void requestMACPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            MacOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  Future<void> selectNotification(String payload) async {
    if (payload.isNotEmpty) {
      debugPrint('notification payload: $payload');
      // Add your navigation logic here, e.g., Get.to(() => NotificationScreen(payload));
    }
  }

  Future<void> onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    Get.dialog(Text(body ?? 'No body text'));
    if (payload != null) {
      selectNotification(payload);
    }
  }
}
