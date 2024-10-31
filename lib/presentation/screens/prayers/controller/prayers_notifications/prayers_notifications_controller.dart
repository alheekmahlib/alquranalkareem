import 'dart:convert' show jsonDecode, jsonEncode;
import 'dart:developer' show log;

import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '/core/services/notifications_helper.dart';
import '/presentation/screens/prayers/controller/prayers_notifications/extensions/prayers_noti_ui.dart';
import '../../../../../core/utils/constants/shared_preferences_constants.dart';
import '../../data/model/adhan_data.dart';
import '../../helpers/adhan_audio_downloader.dart';
import 'noti_state.dart';

extension NotificationsHelper on PrayersNotificationsCtrl {
  Future<void> scheduleDailyNotificationForPrayer(
    int prayerId,
    DateTime prayerTime,
    String prayerName,
    String notificationType,
  ) {
    if ('nothing' == notificationType) {
      GetStorage('AdhanSounds').remove('scheduledAdhan_$prayerName');
      log('منبة صلاة $prayerName removed');
      return NotifyHelper().cancelNotification(prayerId);
    }
    GetStorage('AdhanSounds')
        .write('scheduledAdhan_$prayerName', notificationType);
    return NotifyHelper().scheduledNotification(
      prayerId,
      'منبة صلاة $prayerName',
      'حان وقت صلاة $prayerName',
      prayerTime,
      {'sound_type': notificationType},
    );
  }
}

class PrayersNotificationsCtrl extends GetxController {
  static PrayersNotificationsCtrl get instance =>
      Get.isRegistered<PrayersNotificationsCtrl>()
          ? Get.find<PrayersNotificationsCtrl>()
          : Get.put(PrayersNotificationsCtrl());

  NotiState state = NotiState();

  @override
  Future<void> onInit() async {
    getSharedVariables;
    state.adhanData = loadAdhanData();
    log('downloadedAdhanData.value: ${state.downloadedAdhanData.length}');
    super.onInit();
  }

  void get getSharedVariables {
    state.selectedAdhanPath.value = state.box.read(ADHAN_PATH) ?? '';
    final downloadedSoundData = state.box.read('Downloaded_Adhan_Sounds_Data');
    log('Retrieved Data: $downloadedSoundData');

    if (null != downloadedSoundData) {
      state.downloadedAdhanData.value =
          (jsonDecode(downloadedSoundData) as List<dynamic>?)?.map((e) {
                return AdhanData.fromJson(e as Map<String, dynamic>);
              }).toList() ??
              [];
      log('Parsed Data Length: ${state.downloadedAdhanData.length}');
    }
  }

  Future<List<AdhanData>> loadAdhanData() async {
    final jsonString =
        await rootBundle.loadString('assets/json/adhanSounds.json');
    final List<dynamic> jsonData = jsonDecode(jsonString);
    return jsonData.map((data) => AdhanData.fromJson(data)).toList();
  }

  Future<void> adhanDownload(AdhanData adhanData) async {
    if (state.isDownloading.value) return;
    state.downloadIndex.value = adhanData.index;
    state.isDownloading.toggle();
    state.progress.value = 0;
    await AudioDownloader()
        .downloadAndUnzipAdhan(adhanData, onReceiveProgress: onReceiveProgress)
        .then((d) {
      state.downloadedAdhanData.add(d);
      final downloadedAdanSoundsAsMap =
          jsonEncode(state.downloadedAdhanData.map((e) => e.toJson()).toList());
      state.box
          .write('Downloaded_Adhan_Sounds_Data', downloadedAdanSoundsAsMap);
      log('Saved Data: $downloadedAdanSoundsAsMap');
      if (state.downloadedAdhanData.length == 1) {
        selectAdhanOnTap(0);
      }
    });

    state.isDownloading.toggle();
  }
}
