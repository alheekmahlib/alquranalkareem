import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:square_percent_indicater/square_percent_indicater.dart';

import '../../../../core/services/services_locator.dart';
import '../../../../core/utils/constants/lottie.dart';
import '../../../controllers/surah_audio_controller.dart';

class DownloadPlayButton extends StatelessWidget {
  const DownloadPlayButton({super.key});

  @override
  Widget build(BuildContext context) {
    final surahAudioCtrl = sl<SurahAudioController>();
    return SizedBox(
      height: 120,
      width: 40,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Obx(
            () => SquarePercentIndicator(
              width: 40,
              height: 40,
              borderRadius: 4,
              shadowWidth: 1.5,
              progressWidth: 2,
              shadowColor: Colors.transparent,
              progressColor: surahAudioCtrl.onDownloading.value
                  ? Get.theme.colorScheme.surface
                  : Colors.transparent,
              progress: surahAudioCtrl.progress.value,
            ),
          ),
          StreamBuilder<PlayerState>(
            stream: surahAudioCtrl.audioPlayer.playerStateStream,
            builder: (context, snapshot) {
              final playerState = snapshot.data;
              final processingState = playerState?.processingState;
              final playing = playerState?.playing;
              if (processingState == ProcessingState.loading ||
                  processingState == ProcessingState.buffering) {
                return playButtonLottie(20.0, 20.0);
              } else {
                return IconButton(
                  icon: Semantics(
                      button: true,
                      enabled: true,
                      label: 'download'.tr,
                      child: const Icon(Icons.cloud_download_outlined)),
                  iconSize: 24.0,
                  color: Get.theme.colorScheme.primary,
                  onPressed: () async {
                    surahAudioCtrl.isDownloading.value = true;
                    surahAudioCtrl.isPlaying.value = true;

                    if (surahAudioCtrl.onDownloading.value) {
                      surahAudioCtrl.cancelDownload();
                    } else {
                      await surahAudioCtrl.startDownload();
                    }
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
