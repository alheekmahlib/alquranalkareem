import 'dart:developer' show log;
import 'dart:io' show Platform, File;

import 'package:dio/dio.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:workmanager/workmanager.dart';

import '../../core/services/services_locator.dart';
import '/presentation/controllers/adhan_controller.dart';
import 'general_controller.dart';

class NotificationController extends GetxController {
  final sharedCtrl = sl<SharedPreferences>();
  final adhanCtrl = sl<AdhanController>();
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  RxBool onDownloading = false.obs;
  RxString progressString = "0".obs;
  RxDouble progress = 0.0.obs;
  final generalCtrl = sl<GeneralController>();

  // Function to register background task
  void registerBackgroundTask() {
    Workmanager().registerOneOffTask(
      'notificationTask',
      'sendNotification',
      initialDelay: const Duration(seconds: 1),
    );
  }

  Future<bool> downloadAdhan(String url) async {
    Dio dio = Dio();
    CancelToken cancelToken = CancelToken();

    try {
      try {
        // Get application documents directory
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/adhan.mp3';

        // If the file already exists, no need to download again
        if (await File(filePath).exists()) {
          print('Adhan file already exists. Skipping download.');
          return true;
        }

        onDownloading.value = true;
        progressString.value = "0";
        progress.value = 0;

        await dio.download(
          url,
          filePath,
          onReceiveProgress: (rec, total) {
            progressString.value = ((rec / total) * 100).toStringAsFixed(0);
            progress.value = (rec / total).toDouble();
            print(progressString.value);
          },
          cancelToken: cancelToken,
        );
      } catch (e) {
        // ... (error handling as before) ...
      }
      onDownloading.value = false; // Indicate download completion
      progressString.value = "100%"; // Set progress to 100%
      print("Download completed for $url");
      return true;
    } catch (e) {
      // ... (error handling as before) ...
    }

    return false;
  }

  Future<void> _showNotification(String prayerName, String prayerTime) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'alquranalkareem_adhan_channel_id',
      'alquranalkareem_adhan_channel',
      channelDescription: 'alquranalkareem adhan notifications channel',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      sound: RawResourceAndroidNotificationSound('aqsa'),
    );
    const DarwinNotificationDetails iosPlatformChannelSpecifics =
        DarwinNotificationDetails(
      sound: 'adhan_sounds/aqsa.wav',
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iosPlatformChannelSpecifics,
      macOS: iosPlatformChannelSpecifics,
    );

    await FlutterLocalNotificationsPlugin().show(
      0,
      'موعد الصلاة',
      '$prayerName $prayerTime',
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  Future<void> schedulePrayerNotifications() async {
    log('Scheduling Notifications', name: 'NotificationsCtrl');
    await FlutterLocalNotificationsPlugin().cancelAll();
    for (var prayer in adhanCtrl.prayerNameList) {
      final timeString = '${prayer['hourTime']}';
      // '${adhanCtrl.now.add(const Duration(seconds: 20))}';
      final sharedAlarmKey = prayer['sharedAlarm'] as String;
      final prayerTime = DateTime.parse(timeString);

      log('timeString: $prayerTime');
      log('adhanCtrl.now: ${adhanCtrl.now}');
      log('prayerTime.isAfter(adhanCtrl.now): ${prayerTime.isAfter(adhanCtrl.now) && sharedCtrl.getBool(sharedAlarmKey) == true}');
      if (prayerTime.isAfter(adhanCtrl.now) &&
          sharedCtrl.getBool(sharedAlarmKey) == true) {
        if (Platform.isIOS) {
          await _scheduleNotification(prayerTime, prayer['title'] as String, 0);

          for (int i = 1; i <= 6; i++) {
            DateTime nextNotificationTime =
                prayerTime.add(Duration(seconds: 30 * i));
            await _scheduleNotification(
                nextNotificationTime, prayer['title'] as String, i);
          }
        } else {
          await _scheduleNotification(prayerTime, prayer['title'] as String, 0);
        }
      }
    }
    await _scheduleNotification(
        DateTime(DateTime.now().minute + 5), 'Title', 1);
    Future.delayed(const Duration(seconds: 5)).then((_) =>
        _scheduleNotification(
            DateTime(DateTime.now().minute + 5), 'Title now', 0,
            now: true));
  }

  Future<void> _scheduleNotification(
      DateTime prayerTime, String prayerName, int notificationId,
      {bool now = false}) async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    AndroidNotificationDetails androidPlatformChannelSpecifics =
        const AndroidNotificationDetails(
      'alquranalkareem_adhan_channel_id',
      'alquranalkareem_adhan_channel',
      channelDescription: 'alquranalkareem adhan notifications channel',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      sound: RawResourceAndroidNotificationSound('aqsa'),
    );
    DarwinNotificationDetails iosPlatformChannelSpecifics =
        DarwinNotificationDetails(
      sound: '${notificationId + 1}.caf',
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iosPlatformChannelSpecifics,
      macOS: iosPlatformChannelSpecifics,
    );
    if (now) {
      await flutterLocalNotificationsPlugin.show(
          notificationId,
          'موعد الصلاة',
          '$prayerName في تمام ${prayerTime.hour}:${prayerTime.minute}',
          notificationDetails);
    } else {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        notificationId, // Use the unique notificationId here
        'موعد الصلاة', //TODO: needs translations
        '$prayerName في تمام ${prayerTime.hour}:${prayerTime.minute}', //TODO: also here
        tz.TZDateTime.from(prayerTime, tz.local),
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }

  @override
  void onInit() async {
    super.onInit();
    if (generalCtrl.activeLocation.value) {
      final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('ic_launcher');
      const DarwinInitializationSettings initializationSettingsIOS =
          DarwinInitializationSettings();
      const InitializationSettings initializationSettings =
          InitializationSettings(
              android: initializationSettingsAndroid,
              iOS: initializationSettingsIOS,
              macOS: initializationSettingsIOS);
      await flutterLocalNotificationsPlugin.initialize(initializationSettings);
      schedulePrayerNotifications();
    }
  }
}
