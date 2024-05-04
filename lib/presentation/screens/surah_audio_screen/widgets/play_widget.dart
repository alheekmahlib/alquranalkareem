import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/services/services_locator.dart';
import '../../../../core/utils/constants/extensions/extensions.dart';
import '../../../../core/utils/constants/svg_picture.dart';
import '../../../controllers/surah_audio_controller.dart';
import 'change_reader.dart';
import 'download_play_button.dart';
import 'online_play_button.dart';
import 'skip_next.dart';
import 'skip_previous.dart';
import 'surah_seek_bar.dart';

class PlayWidget extends StatelessWidget {
  PlayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final surahCtrl = sl<SurahAudioController>();
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        height: size.height / 2.66, //295,
        width: context.customOrientation(size.width, size.width * .5),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: RotatedBox(
                quarterTurns: 2,
                child: decorations(context),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: decorations(context),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: context.customClose(
                    close: () => surahCtrl.boxController.closeBox()),
              ),
            ),
            Column(
              children: [
                Obx(
                  () => Stack(
                    alignment: Alignment.center,
                    children: [
                      Opacity(
                        opacity: .1,
                        child: surahName(
                          90,
                          150,
                        ),
                      ),
                      surahName(
                        70,
                        150,
                      ),
                    ],
                  ),
                ),
                const ChangeSurahReader(),
                const SurahSeekBar(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Obx(
                        () => surahCtrl.surahDownloadStatus
                                    .value[surahCtrl.surahNum.value] ??
                                false
                            ? const SizedBox.shrink()
                            : const DownloadPlayButton(),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Semantics(
                              button: true,
                              enabled: true,
                              label: 'backward'.tr,
                              child: backward_arrow(height: 20.0),
                            ),
                            onPressed: () {
                              surahCtrl.audioPlayer.seek(Duration(
                                  seconds: surahCtrl.seekNextSeconds.value -=
                                      5));
                            },
                          ),
                          const SkipToPrevious(),
                        ],
                      ),
                      const OnlinePlayButton(
                        isRepeat: true,
                      ),
                      Row(
                        children: [
                          const SkipToNext(),
                          IconButton(
                            icon: Semantics(
                              button: true,
                              enabled: true,
                              label: 'rewind'.tr,
                              child: rewind_arrow(height: 20.0),
                            ),
                            onPressed: () {
                              surahCtrl.audioPlayer.seek(Duration(
                                  seconds: surahCtrl.seekNextSeconds.value +=
                                      5));
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
