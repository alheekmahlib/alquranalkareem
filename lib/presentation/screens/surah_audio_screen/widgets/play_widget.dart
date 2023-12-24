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

class PlayWidget extends StatelessWidget {
  PlayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    return Container(
      height: 220.0,
      width: width,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(12.0), topLeft: Radius.circular(12.0)),
          color: Theme.of(context).colorScheme.background,
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, -2),
              blurRadius: 10,
              color: Theme.of(context).colorScheme.surface,
            ),
          ]),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Stack(
          alignment: Alignment.center,
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
              alignment: Alignment.topRight,
              child: customClose(
                context,
                close: () => sl<GeneralController>().closeSlider(),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Obx(
                () => Stack(
                  alignment: Alignment.center,
                  children: [
                    Opacity(
                      opacity: .1,
                      child: surahName(
                        context,
                        90,
                        150,
                      ),
                    ),
                    surahName(
                      context,
                      70,
                      150,
                    ),
                  ],
                ),
              ),
            ),
            const Align(
              alignment: Alignment.topLeft,
              child: ChangeSurahReader(),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: SizedBox(
                  height: 50,
                  child: Obx(
                    () => sl<SurahAudioController>().isDownloading.value == true
                        ? const DownloadSurahSeekBar()
                        : const SurahSeekBar(),
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 32.0),
              child: Align(
                alignment: Alignment.center,
                child: Row(
                  children: [
                    Expanded(flex: 1, child: SkipToPrevious()),
                    OnlinePlayButton(),
                    Expanded(flex: 1, child: SkipToNext()),
                  ],
                ),
              ),
            ),
            const Align(
              alignment: Alignment.centerRight,
              child: Padding(
                  padding: EdgeInsets.only(top: 32.0),
                  child: DownloadPlayButton()),
            ),
          ],
        ),
      ),
    );
  }
}
