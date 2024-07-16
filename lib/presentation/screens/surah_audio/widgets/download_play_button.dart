import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:square_percent_indicater/square_percent_indicater.dart';

import '../../../../core/utils/constants/lottie.dart';
import '../../../../core/utils/constants/lottie_constants.dart';
import '../controller/surah_audio_controller.dart';

class DownloadPlayButton extends StatelessWidget {
  const DownloadPlayButton({super.key});

  @override
  Widget build(BuildContext context) {
    final surahAudioCtrl = SurahAudioController.instance;
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
              progressColor: surahAudioCtrl.state.onDownloading.value
                  ? Theme.of(context).colorScheme.surface
                  : Colors.transparent,
              progress: surahAudioCtrl.state.progress.value,
            ),
          ),
          StreamBuilder<PlayerState>(
            stream: surahAudioCtrl.state.audioPlayer.playerStateStream,
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
                    if (surahAudioCtrl.state.onDownloading.value) {
                      surahAudioCtrl.cancelDownload();
                    } else if (surahAudioCtrl.state.surahDownloadStatus
                            .value[surahAudioCtrl.state.surahNum.value] ==
                        true) {
                      surahAudioCtrl.state.isPlaying.value = true;
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
