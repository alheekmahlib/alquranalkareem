import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../shared/widgets/seek_bar.dart';
import '../controller/surah_audio_controller.dart';

class SurahSeekBar extends StatelessWidget {
  late final SurahAudioController surahAudioController =
      Get.put(SurahAudioController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => StreamBuilder<PositionData>(
        stream: surahAudioController.isDownloading.value == true
            ? surahAudioController.DownloadPositionDataStream
            : surahAudioController.positionDataStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final positionData = snapshot.data;
            // surahAudioController.lastPosition =
            //     positionData!.position.inSeconds.toDouble();
            surahAudioController.currentTime.value =
                positionData!.position.inSeconds.toDouble();
            surahAudioController.totalDuration =
                positionData!.duration.inSeconds.toDouble();
            return SeekBar(
              duration: positionData?.duration ?? Duration.zero,
              position: positionData?.position ?? Duration.zero,
              bufferedPosition: positionData?.bufferedPosition ?? Duration.zero,
              onChangeEnd: (newPosition) {
                surahAudioController.isDownloading.value == true
                    ? surahAudioController.downAudioPlayer.seek(newPosition)
                    : surahAudioController.audioPlayer.seek(newPosition);
                surahAudioController.saveLastSurahListen(
                    surahAudioController.sorahNum.value,
                    surahAudioController.sorahNum.value - 1,
                    newPosition.inSeconds.toDouble());
              },
              activeTrackColor: Theme.of(context).colorScheme.surface,
              textColor: Theme.of(context).colorScheme.surface,
              timeShow: true,
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
