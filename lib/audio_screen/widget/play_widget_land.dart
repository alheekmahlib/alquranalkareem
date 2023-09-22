import 'package:alquranalkareem/shared/services/controllers_put.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../audio_screen/widget/skip_next.dart';
import '../../audio_screen/widget/skip_previous.dart';
import '../../audio_screen/widget/surah_seek_bar.dart';
import '../../shared/utils/constants/svg_picture.dart';
import '../../shared/widgets/widgets.dart';
import 'download_play_button.dart';
import 'online_play_button.dart';

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
              topRight: Radius.circular(12.0), topLeft: Radius.circular(12.0)),
          border: Border.all(
            color: Theme.of(context).colorScheme.surface,
            width: 1,
          ),
          color: Theme.of(context).colorScheme.background,
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Obx(
                () => Stack(
                  alignment: Alignment.center,
                  children: [
                    Opacity(
                      opacity: .1,
                      child: surahName(
                        context,
                        130,
                        width,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 23.0),
                      child: surahName(
                        context,
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
                close: () => generalController.closeSlider(),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                height: 120,
                width: width / 1 / 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SkipToPrevious(),
                    const OnlinePlayButton(),
                    const SkipToNext(),
                    Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8))),
                      child: IconButton(
                        icon: Icon(Icons.person_search_outlined,
                            size: 20, color: Theme.of(context).canvasColor),
                        onPressed: () => sorahReaderDropDown(context),
                      ),
                    ),
                    const Align(
                      alignment: Alignment.centerRight,
                      child: DownloadPlayButton(),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: SizedBox(
                  height: 20,
                  width: width / 1 / 2,
                  child: Obx(
                    () => surahAudioController.isDownloading.value == true
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
