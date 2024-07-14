import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:timezone/timezone.dart' as tz;

import '/core/utils/constants/extensions/custom_error_snackBar.dart';
import '/core/utils/constants/shared_preferences_constants.dart';
import '../screens/home/controller/adhan/adhan_controller.dart';
import '../screens/home/data/model/adhan_data.dart';
import 'general_controller.dart';

// sound: adhanPath != null ? adhanPath + '1.wav' : 'default_sound',
// log('adhanPath: $adhanPath');

class NotificationController extends GetxController {
  static NotificationController get instance =>
      Get.isRegistered<NotificationController>()
          ? Get.find<NotificationController>()
          : Get.put<NotificationController>(NotificationController());
  final box = GetStorage();
  // final adhanCtrl = AdhanController.instance;
  final generalCtrl = GeneralController.instance;

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

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

  @override
  Future<void> onInit() async {
    getSharedVariables();
    await initializeNotification();
    super.onInit();
  }

  Future<void> initializeNotification() async {
    if (generalCtrl.activeLocation.value) {
      log('initialize Notification');
      // flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('ic_launcher');
      const DarwinInitializationSettings initializationSettingsIOS =
          DarwinInitializationSettings();
      const InitializationSettings initializationSettings =
          InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
        macOS: initializationSettingsIOS,
      );
      await flutterLocalNotificationsPlugin.initialize(initializationSettings);

      adhanData = loadAdhanData();
      await checkAllAdhanDownloaded();
    }
  }

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
    final jsonString =
        await rootBundle.loadString('assets/json/adhanSounds.json');
    final List<dynamic> jsonData = jsonDecode(jsonString);
    return jsonData.map((data) => AdhanData.fromJson(data)).toList();
  }

  Future<void> adhanDownload(String url, String fileName, int index) async {
    if (!onDownloading.value) {
      await downloadAdhan(url, fileName).then((success) {
        if (success) onDownloadSuccess('$index');
      });
    }
  }

  Future<bool> downloadAdhan(String url, String fileName) async {
    Dio dio = Dio();
    CancelToken cancelToken = CancelToken();
    final directory = await getApplicationDocumentsDirectory();
    final zipFilePath = '${directory.path}/$fileName.zip';
    final extractedFilePath = '${directory.path}/$fileName/';

    if (await Directory(extractedFilePath).exists()) {
      log('Adhan file already exists. Skipping download.');
      return true;
    }

    try {
      onDownloading.value = true;
      progressString.value = "0";
      progress.value = 0;

      await dio.download(
        url,
        zipFilePath,
        onReceiveProgress: (rec, total) {
          progressString.value = ((rec / total) * 100).toStringAsFixed(0);
          progress.value = (rec / total).toDouble();
        },
        cancelToken: cancelToken,
      );

      await _extractZipFile(zipFilePath, extractedFilePath);
      await File(zipFilePath).delete();

      onDownloading.value = false;
      progressString.value = "100%";
      return true;
    } catch (e) {
      onDownloading.value = false;
      log('Download failed: $e');
      return false;
    }
  }

  Future<void> _extractZipFile(
      String zipFilePath, String extractedFilePath) async {
    final inputStream = InputFileStream(zipFilePath);
    final archive = ZipDecoder().decodeBuffer(inputStream);

    for (final file in archive) {
      final filename = '$extractedFilePath${file.name}';
      if (file.isFile) {
        if (filename.endsWith('.tar.gz') ||
            filename.endsWith('.tgz') ||
            filename.endsWith('.tar.bz2') ||
            filename.endsWith('.tbz') ||
            filename.endsWith('.tar.xz') ||
            filename.endsWith('.txz') ||
            filename.endsWith('.tar') ||
            filename.endsWith('.zip')) {
          extractFileToDisk('$file', extractedFilePath);
          box.write('adhan_path', filename);
        }
      } else {
        await Directory(filename).create(recursive: true);
      }
    }
  }

  void updateDownloadStatus(String adhanName, bool downloaded) {
    adhanDownloadStatus.value = {
      ...adhanDownloadStatus.value,
      adhanName: downloaded,
    };
  }

  void onDownloadSuccess(String adhanName) {
    updateDownloadStatus(adhanName, true);
  }

  Future<Map<String, bool>> checkAllAdhanDownloaded() async {
    final directory = await getApplicationDocumentsDirectory();

    for (int i = 0; i <= 4; i++) {
      final filePath = '${directory.path}/$i';
      adhanDownloadStatus.value['$i'] = await File(filePath).exists();
    }
    return adhanDownloadStatus.value;
  }

  Future<void> schedulePrayerNotifications() async {
    log('Scheduling Notifications', name: 'NotificationsCtrl');

    await flutterLocalNotificationsPlugin.cancelAll();

    for (var prayer in AdhanController.instance.prayerNameList) {
      final timeString = '${prayer['hourTime']}';
      // '${AdhanController.instance.now.add(const Duration(seconds: 20))}';
      final sharedAlarmKey = prayer['sharedAlarm'] as String;
      final prayerTime = DateTime.parse(timeString);

      if (prayerTime.isAfter(DateTime.now()) &&
          box.read(sharedAlarmKey) == true) {
        await _scheduleDailyNotification(prayerTime, prayer['title'] as String);
      }
    }
  }

  Future<void> _scheduleDailyNotification(
      DateTime prayerTime, String prayerName) async {
    final soundPath = await _getAdhanSoundPath();
    final androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'com.alheekmah.alquranalkareem.alquranalkareem.dailyPrayerNotification',
      'MY FOREGROUND SERVICE',
      channelDescription: 'alquranalkareem adhan notifications channel',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      sound: RawResourceAndroidNotificationSound('aqsa'),
    );

    final iosPlatformChannelSpecifics = DarwinNotificationDetails(
      sound: soundPath,
      // sharedCtrl.getString('adhan_path') != null
      //     ? '${sharedCtrl.getString('adhan_path')}1.wav'
      //     : 'default_sound',
    );

    final platformChannelSpecifics = NotificationDetails(
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

  Future<String?> _getAdhanSoundPath() async {
    // Get the path from SharedPreferences
    String? adhanPath = box.read('adhan_path');
    // log('adhan_path: $adhanPath');
    if (adhanPath != null) {
      return '${adhanPath}1.wav';
    }
    return 'aqsa_ios/aqsa_ios/1.wav';
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
    final isDownloading =
        adhanDownloadStatus.value[adhans[index].adhanFileName] ?? false;
    if (isDownloading) {
      adhanNumber.value = index;

      box.write(ADHAN_NUMBER, index);
    } else {
      Get.context!.showCustomErrorSnackBar('يرجى تحميل الأذان أولًا.');
    }
  }

  void getSharedVariables() {
    adhanNumber.value = box.read(ADHAN_NUMBER) ?? 0;
  }
}
