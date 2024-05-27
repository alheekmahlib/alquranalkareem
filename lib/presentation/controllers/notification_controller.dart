import 'dart:convert';
import 'dart:developer' show log;
import 'dart:io' show Directory, File;

import 'package:alquranalkareem/core/utils/constants/extensions/custom_error_snackBar.dart';
import 'package:archive/archive_io.dart';
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

import '/presentation/controllers/adhan_controller.dart';
import '../../core/services/services_locator.dart';
import '../../core/utils/constants/shared_preferences_constants.dart';
import '../screens/home/data/model/adhan_data.dart';
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

  Future<void> adhanDownload(String url, String fileName, int index) async {
    String fileUrl = url;

    if (!onDownloading.value) {
      await downloadAdhan(fileUrl, fileName).then((_) {
        onDownloadSuccess('$index');
      });
      print("Downloading from URL: $fileUrl");
    }
  }

  Future<bool> downloadAdhan(String url, String fileName) async {
    Dio dio = Dio();
    CancelToken cancelToken = CancelToken();

    try {
      final directory = await getApplicationDocumentsDirectory();
      final zipFilePath = '${directory.path}/$fileName.zip';
      final extractedFilePath = '${directory.path}/$fileName/';

      if (await File(extractedFilePath).exists()) {
        print('Adhan file already exists. Skipping download.');
        return true;
      }

      onDownloading.value = true;
      progressString.value = "0";
      progress.value = 0;

      await dio.download(
        url,
        zipFilePath,
        onReceiveProgress: (rec, total) {
          progressString.value = ((rec / total) * 100).toStringAsFixed(0);
          progress.value = (rec / total).toDouble();
          print(progressString.value);
        },
        cancelToken: cancelToken,
      );

      final bytes = await File(zipFilePath).readAsBytes();
      final archive = ZipDecoder().decodeBytes(bytes);

      for (final file in archive) {
        final filename = basename(file.name);
        log('filename: $directory/$filename');
        if (file.isFile) {
          final data = file.content as List<int>;
          sharedCtrl.setStringList(
              filename, data.map((e) => e.toString()).toList());
          File('$directory/$filename')
            ..createSync(recursive: true)
            ..writeAsBytesSync(data);
        } else {
          Directory('${directory.path}/$filename/Al-Assaf_ios/1.wav')
              .createSync(recursive: true);
        }
      }

      await File(zipFilePath).delete();
      onDownloading.value = false;
      progressString.value = "100%";
      print("Download completed for $url");
      return true;
    } catch (e) {
      onDownloading.value = false;
      log('Download failed: $e');
      return false;
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

  Future<void> schedulePrayerNotifications() async {
    log('Scheduling Notifications', name: 'NotificationsCtrl');
    await FlutterLocalNotificationsPlugin().cancelAll();

    for (var prayer in adhanCtrl.prayerNameList) {
      final timeString = '${prayer['hourTime']}';
      final sharedAlarmKey = prayer['sharedAlarm'] as String;
      final prayerTime = DateTime.parse(timeString);

      if (prayerTime.isAfter(DateTime.now()) &&
          sharedCtrl.getBool(sharedAlarmKey) == true) {
        await _scheduleDailyNotification(prayerTime, prayer['title'] as String);
      }
    }
  }

  Future<void> _scheduleDailyNotification(
      DateTime prayerTime, String prayerName) async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

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

    DarwinNotificationDetails iosPlatformChannelSpecifics =
        DarwinNotificationDetails(
      sound: 'aqsa_ios/aqsa_ios/1.wav',
    );

    NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iosPlatformChannelSpecifics,
      macOS: iosPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      prayerTime.hashCode,
      'موعد الصلاة',
      '$prayerName في تمام ${prayerTime.hour}:${prayerTime.minute}',
      tz.TZDateTime.from(prayerTime, tz.local).add(const Duration(days: 1)),
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
    log('Prayer Scheduled: $prayerName');
  }

  Future<void> initializeNotification() async {
    if (generalCtrl.activeLocation.value) {
      log('initialize Notification');
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

      registerDailyPrayers();
    }
  }

  Future<void> registerDailyPrayers() async {
    try {
      log('register Daily Prayers');
      final delay = adhanCtrl.getDelayUntilNextIsha();

      await Workmanager().cancelAll();

      Workmanager().registerOneOffTask(
        'com.alheekmah.alquranalkareem.alquranalkareem.dailyPrayerNotification_${DateTime.now().millisecondsSinceEpoch}',
        'com.alheekmah.alquranalkareem.alquranalkareem.dailyPrayerNotification',
        initialDelay: delay,
      );
    } catch (e) {
      log('Error scheduling daily task: $e', name: 'NotificationsCtrl');
    }
  }

  @override
  void onInit() {
    super.onInit();
    initializeNotification();
    getSharedVariables();
    Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: true,
    );
  }

  Future<void> playButtonOnTap(int index, List<AdhanData> adhanData) async {
    final directory = await getApplicationDocumentsDirectory();
    adhanNumber.value = index;
    await audioPlayer
        .setAudioSource(AudioSource.file(
            '${directory.path}/Al-Saqqaf_part/Al-Assaf_ios/1.wav'))
        .then((_) async => await audioPlayer.play());
    log('urlPlayAdhan: ${adhanData[index - 1].urlPlayAdhan} index: ${index - 1}');
  }

  void selectAdhanOnTap(int index, List<AdhanData> adhans) {
    bool isDownloading =
        adhanDownloadStatus.value[adhans[index].adhanFileName] ?? false;
    if (isDownloading) {
      adhanNumber.value = index;
      sharedCtrl.setInt(ADHAN_NUMBER, index);
    } else {
      Get.context!.showCustomErrorSnackBar('يرجى تحميل الأذان أولًا.');
    }
  }

  void getSharedVariables() {
    adhanNumber.value = sharedCtrl.getInt(ADHAN_NUMBER) ?? 0;
  }
}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    final AdhanController adhanCtrl = Get.find();
    final NotificationController notificationController = Get.find();
    await adhanCtrl.initializeAdhan().then((_) async {
      await notificationController.schedulePrayerNotifications();
      notificationController.registerDailyPrayers();
    });
    return Future.value(true);
  });
}
