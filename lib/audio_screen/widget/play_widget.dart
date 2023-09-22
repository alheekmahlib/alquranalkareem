import 'package:alquranalkareem/audio_screen/widget/skip_next.dart';
import 'package:alquranalkareem/audio_screen/widget/skip_previous.dart';
import 'package:alquranalkareem/audio_screen/widget/surah_seek_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../shared/services/controllers_put.dart';
import '../../shared/utils/constants/svg_picture.dart';
import '../../shared/widgets/widgets.dart';
import 'download_play_button.dart';
import 'online_play_button.dart';

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
        border:
            Border.all(width: 2, color: Theme.of(context).colorScheme.surface),
        color: Theme.of(context).colorScheme.background,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  customClose(
                    context,
                    close: () => generalController.closeSlider(),
                  ),
                  Obx(
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
                  Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        border: Border.all(
                            color: Theme.of(context).colorScheme.surface,
                            width: 1)),
                    child: IconButton(
                      icon: Icon(Icons.person_search_outlined,
                          size: 20,
                          color: Theme.of(context).colorScheme.surface),
                      onPressed: () => sorahReaderDropDown(context),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Obx(
                      () => Expanded(
                          flex: 8,
                          child:
                              surahAudioController.isDownloading.value == true
                                  ? const DownloadSurahSeekBar()
                                  : const SurahSeekBar()),
                    ),
                  ],
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
