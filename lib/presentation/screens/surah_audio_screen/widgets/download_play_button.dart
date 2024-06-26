import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:square_percent_indicater/square_percent_indicater.dart';

import '../../../../core/services/services_locator.dart';
import '../../../../core/utils/constants/lottie.dart';
import '../../../../core/utils/constants/lottie_constants.dart';
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
                  ? Theme.of(context).colorScheme.surface
                  : Colors.transparent,
              progress: surahAudioCtrl.progress.value,
            ),
          ),
          StreamBuilder<PlayerState>(
            stream: surahAudioCtrl.audioPlayer.playerStateStream,
            builder: (context, snapshot) {
              final playerState = snapshot.data;
              final processingState = playerState?.processingState;
              if (processingState == ProcessingState.loading ||
                  processingState == ProcessingState.buffering) {
                return customLottie(LottieConstants.assetsLottiePlayButton,
                    width: 20.0, height: 20.0);
              } else {
                return IconButton(
                  icon: Semantics(
                      button: true,
                      enabled: true,
                      label: 'download'.tr,
                      child: const Icon(Icons.cloud_download_outlined)),
                  iconSize: 24.0,
                  color: Theme.of(context).colorScheme.primary,
                  onPressed: () async {
                    if (surahAudioCtrl.onDownloading.value) {
                      surahAudioCtrl.cancelDownload();
                    } else if (surahAudioCtrl.surahDownloadStatus
                            .value[surahAudioCtrl.surahNum.value] ==
                        true) {
                      surahAudioCtrl.isPlaying.value = true;
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
