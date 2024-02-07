import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/services/services_locator.dart';
import '../../../../core/utils/constants/svg_picture.dart';
import '../../../controllers/surah_audio_controller.dart';
import '/core/utils/constants/extensions.dart';
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
    return Container(
      height: 291,
      width: size.width,
      decoration: BoxDecoration(
        color: Get.theme.colorScheme.background,
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
              Align(
                alignment: Alignment.topCenter,
                child: Obx(
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
              ),
              const Align(
                alignment: Alignment.center,
                child: ChangeSurahReader(),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: 61,
                  child: Obx(
                    () => sl<SurahAudioController>().isDownloading.value == true
                        ? const DownloadSurahSeekBar()
                        : const SurahSeekBar(),
                  ),
                ),
              ),
              const Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32.0),
                  child: Row(
                    children: [
                      const DownloadPlayButton(),
                      Expanded(flex: 1, child: SkipToPrevious()),
                      OnlinePlayButton(
                        isRepeat: true,
                      ),
                      Expanded(flex: 1, child: SkipToNext()),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
