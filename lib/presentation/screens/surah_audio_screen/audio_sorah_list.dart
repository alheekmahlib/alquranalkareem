import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/services/services_locator.dart';
import '../../../core/utils/constants/svg_picture.dart';
import '../../controllers/general_controller.dart';
import '../../controllers/surah_audio_controller.dart';
import '/core/utils/constants/extensions.dart';
import 'widgets/last_listen.dart';
import 'widgets/play_banner.dart';
import 'widgets/play_widget.dart';
import 'widgets/play_widget_land.dart';
import 'widgets/surah_list.dart';
import 'widgets/surah_search.dart';

class AudioSorahList extends StatelessWidget {
  const AudioSorahList({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        //
        decoration: BoxDecoration(
            color: Get.theme.colorScheme.background,
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            border: Border.all(
              width: 2,
              color: Get.theme.colorScheme.surface,
            )),
        child: context.definePlatform(
            context.customOrientation(
                Stack(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Opacity(
                            opacity: .1,
                            child: quranIcon(height: height * .4, width: width),
                          ),
                          quranIcon(height: 100, width: width / 1 / 2),
                        ],
                      ),
                    ),
                    const Align(
                        alignment: Alignment.topRight, child: LastListen()),
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 120.0),
                        child: Stack(
                          children: [
                            const Align(
                                alignment: Alignment.topRight,
                                child: SurahSearch()),
                            Obx(() => sl<SurahAudioController>()
                                        .isDownloading
                                        .value ||
                                    sl<SurahAudioController>()
                                            .isPlaying
                                            .value ==
                                        true
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
                        bottom: sl<GeneralController>().widgetPosition.value,
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
                                child: quranIcon(
                                    height: height / 1 / 2, width: width),
                              ),
                              quranIcon(height: 100, width: width / 1 / 2),
                              Padding(
                                padding: const EdgeInsets.only(top: 160.0),
                                child: Stack(
                                  children: [
                                    const Align(
                                        alignment: Alignment.topRight,
                                        child: SurahSearch()),
                                    Obx(() => sl<SurahAudioController>()
                                                .isDownloading
                                                .value ||
                                            sl<SurahAudioController>()
                                                    .isPlaying
                                                    .value ==
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
                        bottom: sl<GeneralController>().widgetPosition.value,
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
                          child:
                              quranIcon(height: height / 1 / 2, width: width),
                        ),
                        quranIcon(height: 100, width: width / 1 / 2),
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
                    bottom: sl<GeneralController>().widgetPosition.value,
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

  // @override
  bool get wantKeepAlive => true;
}
