import 'dart:convert';
import 'dart:developer' show log;
import 'dart:io' show Directory, File, Platform;

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:workmanager/workmanager.dart';

import '../../core/services/services_locator.dart';
import '../screens/home/data/model/adhan_data.dart';
import '/presentation/controllers/adhan_controller.dart';
import 'general_controller.dart';

class NotificationController extends GetxController {
  final sharedCtrl = sl<SharedPreferences>();
  final adhanCtrl = sl<AdhanController>();
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final generalCtrl = sl<GeneralController>();
  RxBool onDownloading = false.obs;
  RxString progressString = "0".obs;
  RxDouble progress = 0.0.obs;
  final Rx<Map<String, bool>> adhanDownloadStatus = Rx<Map<String, bool>>({});
  RxList<int> adhanDownloadIndex = <int>[0].obs;
  RxBool isDownloading = false.obs;
  RxInt adhanSoundSelect = 0.obs;
  RxInt downloadIndex = 0.obs;
  late var cancelToken = CancelToken();
  late Future<List<AdhanData>> adhanData;
  AudioPlayer audioPlayer = AudioPlayer();
  RxInt adhanNumber = (-1).obs;

  Future<void> playAudio(int index, String url) async {
    adhanNumber.value = index;
    await audioPlayer.setUrl(url);
    await audioPlayer.play();
  }

  // Method to pause audio
  void pauseAudio() {
    audioPlayer.pause();
    adhanNumber.value = -1;
  }

  Future<List<AdhanData>> loadAdhanData() async {
    String jsonString =
        await rootBundle.loadString('assets/json/adhanSounds.json');
    final List<dynamic> jsonData = jsonDecode(jsonString);
    return jsonData.map((data) => AdhanData.fromJson(data)).toList();
  }

  Future<void> adhanDownload(int i) async {
    Directory databasePath = await getApplicationDocumentsDirectory();
    var path = join(databasePath.path, '$i');
    String fileUrl = 'https://muslimguider.com/mobile_files/$i';

    if (!onDownloading.value) {
      await downloadAdhan(fileUrl).then((_) {
        onDownloadSuccess('$i');
      });
      print("Downloading from URL: $fileUrl");
    }
  }

  void updateDownloadStatus(String adhanName, bool downloaded) {
    final newStatus = Map<String, bool>.from(adhanDownloadStatus.value);
    newStatus[adhanName] = downloaded;
    adhanDownloadStatus.value = newStatus;
  }

  void onDownloadSuccess(String adhanName) {
    updateDownloadStatus(adhanName, true);
  }

  Future<Map<String, bool>> checkAllAdhanDownloaded() async {
    Directory? directory = await getApplicationDocumentsDirectory();

    for (int i = 0; i <= 4; i++) {
      String filePath = '${directory.path}/${i}';
      File file = File(filePath);
      adhanDownloadStatus.value['$i'] = await file.exists();
    }
    return adhanDownloadStatus.value;
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

  // Function to register background task
  void registerBackgroundTask() {
    Workmanager().registerOneOffTask(
      'notificationTask',
      'sendNotification',
      initialDelay: const Duration(seconds: 1),
    );
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
      // '${adhanCtrl.now.add(const Duration(minutes: 10))}';
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
    // await _scheduleNotification(
    //     DateTime(DateTime.now().minute + 5), 'Title', 1);
    // Future.delayed(const Duration(seconds: 5)).then((_) =>
    //     _scheduleNotification(
    //         DateTime(DateTime.now().minute + 5), 'Title now', 0,
    //         now: true));
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
      if (prayerTime.isAfter(DateTime.now())) {
        await flutterLocalNotificationsPlugin.zonedSchedule(
          notificationId, // Use the unique notificationId here
          'موعد الصلاة', //TODO: needs translations
          '$prayerName في تمام ${prayerTime.hour}:${prayerTime.minute}', //TODO: also here
          tz.TZDateTime.from(prayerTime, tz.local),
          // RepeatInterval.daily,
          notificationDetails,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
        );
      }
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
      adhanData = loadAdhanData();
      checkAllAdhanDownloaded();
    }
  }
}
