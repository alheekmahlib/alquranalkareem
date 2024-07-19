import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

import '/core/utils/constants/extensions/extensions.dart';
import '../../../../core/utils/constants/lottie.dart';
import '../../../../core/utils/constants/lottie_constants.dart';
import '../controller/surah_audio_controller.dart';

class DownloadPlayButton extends StatelessWidget {
  const DownloadPlayButton({super.key});

  @override
  Widget build(BuildContext context) {
    final surahAudioCtrl = SurahAudioController.instance;
    return SizedBox(
      width: 40,
      child: Obx(
        () => surahAudioCtrl.state.onDownloading.value
            ? context.customClose(
                height: 20,
                width: 20,
                close: () => surahAudioCtrl.cancelDownload(),
              )
            : StreamBuilder<PlayerState>(
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
      ),
    );
  }
}
