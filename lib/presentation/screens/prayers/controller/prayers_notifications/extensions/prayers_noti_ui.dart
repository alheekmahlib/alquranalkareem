part of '../../../prayers.dart';

extension PrayersNotiUi on PrayersNotificationsCtrl {
  Future<void> playButtonOnTap(List<AdhanData>? adhanData, int i) async {
    final isDownloaded = state.downloadedAdhanData
        .firstWhereOrNull((d) => d.index == adhanData![i].index);
    if (isDownloaded == true) {
      AdhanData? adhan = state.downloadedAdhanData
          .firstWhere((a) => a.index == adhanData![i].index);
      await state.audioPlayer
          .setAudioSource(
            AudioSource.file(
              adhan.path!,
              tag: MediaItem(
                id: '${adhan.index}',
                title: adhan.adhanName,
                artist: adhan.adhanName,
                artUri: await AudioController.instance.state.cachedArtUri,
              ),
            ),
          )
          .then((_) async => await state.audioPlayer.play());
      log('AdhanPath: ${adhan.path} index: ${adhanData![i].index}');
    } else {
      log('urlPlayAdhan: ${adhanData![i].urlPlayAdhan} index: ${adhanData[i].index}');
      await state.audioPlayer
          .setAudioSource(
            AudioSource.uri(
              Uri.parse(adhanData[i].urlPlayAdhan),
              tag: MediaItem(
                id: '${adhanData[i].index}',
                title: adhanData[i].adhanName,
                artist: adhanData[i].adhanName,
                artUri: await AudioController.instance.state.cachedArtUri,
              ),
            ),
          )
          .then((_) async => await state.audioPlayer.play());
    }
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
