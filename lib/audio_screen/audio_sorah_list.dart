import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../audio_screen/widget/play_widget.dart';
import '../../audio_screen/widget/play_widget_land.dart';
import '../../audio_screen/widget/surah_list.dart';
import '../shared/services/controllers_put.dart';
import '../shared/utils/constants/svg_picture.dart';
import '../shared/widgets/widgets.dart';
import 'widget/last_listen.dart';
import 'widget/play_banner.dart';
import 'widget/surah_search.dart';

class AudioSorahList extends StatelessWidget {
  const AudioSorahList({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: platformView(
            orientation(
                context,
                Stack(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Opacity(
                            opacity: .1,
                            child: quranIcon(context, height / 1 / 2, width),
                          ),
                          quranIcon(context, 100, width / 1 / 2),
                        ],
                      ),
                    ),
                    const Align(
                        alignment: Alignment.topRight, child: LastListen()),
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 160.0),
                        child: Stack(
                          children: [
                            const Align(
                                alignment: Alignment.topRight,
                                child: SurahSearch()),
                            Obx(() => surahAudioController
                                        .isDownloading.value ||
                                    surahAudioController.isPlaying.value == true
                                ? const Align(
                                    alignment: Alignment.topLeft,
                                    child: PlayBanner())
                                : const SizedBox.shrink())
                          ],
                        ),
                      ),
                    ),
                    const Align(
                        alignment: Alignment.bottomCenter, child: SurahList()),
                    Obx(
                      () => AnimatedPositioned(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        bottom: generalController.widgetPosition.value,
                        left: 0,
                        right: 0,
                        child: PlayWidget(),
                      ),
                    ),
                  ],
                ),
                Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        width: width / 1 / 2,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 96.0),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Opacity(
                                opacity: .1,
                                child:
                                    quranIcon(context, height / 1 / 2, width),
                              ),
                              quranIcon(context, 100, width / 1 / 2),
                              Padding(
                                padding: const EdgeInsets.only(top: 160.0),
                                child: Stack(
                                  children: [
                                    const Align(
                                        alignment: Alignment.topRight,
                                        child: SurahSearch()),
                                    Obx(() => surahAudioController
                                                .isDownloading.value ||
                                            surahAudioController
                                                    .isPlaying.value ==
                                                true
                                        ? const Align(
                                            alignment: Alignment.topLeft,
                                            child: PlayBanner())
                                        : const SizedBox.shrink())
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Align(
                      alignment: Alignment.bottomLeft,
                      child: LastListen(),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        width: width / 1 / 2,
                        child: const SurahList(),
                      ),
                    ),
                    Obx(
                      () => AnimatedPositioned(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        bottom: generalController.widgetPosition.value,
                        left: 0,
                        right: 0,
                        child: PlayWidgetLand(),
                      ),
                    ),
                  ],
                )),
            Stack(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: width / 1 / 2,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Opacity(
                          opacity: .1,
                          child: quranIcon(context, height / 1 / 2, width),
                        ),
                        quranIcon(context, 100, width / 1 / 2),
                        const SurahSearch(),
                      ],
                    ),
                  ),
                ),
                const Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
                    child: LastListen(),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: width / 1 / 2,
                    child: const SurahList(),
                  ),
                ),
                Obx(
                  () => AnimatedPositioned(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    bottom: generalController.widgetPosition.value,
                    left: 0,
                    right: 0,
                    child: PlayWidgetLand(),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
