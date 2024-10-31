import 'dart:developer';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

import '../../../../../../core/utils/constants/shared_preferences_constants.dart';
import '../../../../quran_page/controllers/audio/audio_controller.dart';
import '../../../data/model/adhan_data.dart';
import '../prayers_notifications_controller.dart';

extension PrayersNotiUi on PrayersNotificationsCtrl {
  Future<void> playButtonOnTap(AdhanData? adhanData) async {
    selectAdhanOnTap(adhanData!.index);
    adhanData = state.downloadedAdhanData.elementAtOrNull(adhanData.index);
    if (adhanData == null) return;
    await state.audioPlayer
        .setAudioSource(
          AudioSource.file(
            adhanData.path!,
            tag: MediaItem(
              id: '${adhanData.index}',
              title: adhanData.adhanName,
              artist: adhanData.adhanName,
              artUri: await AudioController.instance.state.cachedArtUri,
            ),
          ),
        )
        .then((_) async => await state.audioPlayer.play());
    log('urlPlayAdhan: ${adhanData.urlPlayAdhan} index: ${adhanData.index}');
  }

  void selectAdhanOnTap(int index) {
    if (isAdhanDownloadedByIndex(index).value) {
      state.selectedAdhanPath.value = state.downloadedAdhanData
              .firstWhereOrNull((e) => e.index == index)
              ?.path ??
          '';
      state.box.write(ADHAN_PATH, state.selectedAdhanPath.value);
      log('slected: $index ${state.box.read(ADHAN_PATH)}');
    } else {
      log('adhan is not downloaded');
      Get.defaultDialog(
          backgroundColor: Get.context!.theme.cardColor,
          titleStyle: TextStyle(color: Get.context!.theme.canvasColor),
          middleTextStyle: TextStyle(color: Get.context!.theme.canvasColor),
          title: 'Adhan isn\'t Downloaded',
          middleText: 'Please Download Adhan First');
      // adhanDownload(state.adhanData[index])
    }
  }

  RxBool isAdhanDownloadedByIndex(int adhanIndex) => (null !=
          state.downloadedAdhanData
              .firstWhereOrNull((e) => e.index == adhanIndex))
      .obs;

  void onReceiveProgress(int received, int total) {
    if (total != -1) {
      state.progress.value = (received / total);
      state.progressString.value =
          '${(state.progress.value * 100).toStringAsFixed(0)}%';
      log(state.progressString.value);
    }
  }
}
