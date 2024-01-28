import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/services/services_locator.dart';
import '../../../../core/utils/constants/svg_picture.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../controllers/general_controller.dart';
import '../../../controllers/surah_audio_controller.dart';
import 'change_reader.dart';
import 'download_play_button.dart';
import 'online_play_button.dart';
import 'skip_next.dart';
import 'skip_previous.dart';
import 'surah_seek_bar.dart';

class PlayWidgetLand extends StatelessWidget {
  PlayWidgetLand({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 64.0),
      child: Container(
        height: 160,
        width: width,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(12.0),
                topLeft: Radius.circular(12.0)),
            color: Get.theme.colorScheme.background,
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, -2),
                blurRadius: 10,
                color: Colors.grey.shade400,
              ),
            ]),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomRight,
              child: decorations(context),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: RotatedBox(
                quarterTurns: 2,
                child: decorations(context),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Obx(
                () => Stack(
                  alignment: Alignment.center,
                  children: [
                    Opacity(
                      opacity: .1,
                      child: surahName(
                        130,
                        width,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 23.0),
                      child: surahName(
                        70,
                        width,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: customClose(
                context,
                close: () => sl<GeneralController>().closeSlider(),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                height: 120,
                width: width / 1 / 2,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SkipToPrevious(),
                    OnlinePlayButton(
                      isRepeat: true,
                    ),
                    SkipToNext(),
                    DownloadPlayButton(),
                    ChangeSurahReader(),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: SizedBox(
                  height: 50,
                  width: width / 1 / 2,
                  child: Obx(
                    () => sl<SurahAudioController>().isDownloading.value == true
                        ? const DownloadSurahSeekBar()
                        : const SurahSeekBar(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
