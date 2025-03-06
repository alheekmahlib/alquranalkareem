import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/core/widgets/tab_bar_widget.dart';
import '../../../../core/services/services_locator.dart';
import '../../../../core/utils/constants/extensions/extensions.dart';
import '../../../../core/utils/constants/lottie.dart';
import '../../../../core/utils/constants/lottie_constants.dart';
import '../controller/surah_audio_controller.dart';
import 'last_listen.dart';
import 'play_banner.dart';
import 'surah_audio_list.dart';
import 'surah_search.dart';

class BackDropWidget extends StatelessWidget {
  const BackDropWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return context.customOrientation(
        Column(
          children: [
            SizedBox(
              height: 250,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                      alignment: Alignment.center,
                      child: Padding(
                          padding: const EdgeInsets.only(top: 104.0),
                          child: customLottieWithColor(
                              LottieConstants.assetsLottieQuranAuIc,
                              height: 120,
                              isRepeat: false))),
                  Align(
                      alignment: Alignment.topCenter,
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          TabBarWidget(
                            isFirstChild: true,
                            isCenterChild: true,
                            isQuranSetting: false,
                            isNotification: false,
                            centerChild: LastListen(),
                          ),
                        ],
                      )),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 140.0),
                      child: Stack(
                        children: [
                          const Align(
                              alignment: Alignment.topRight,
                              child: SurahSearch()),
                          Obx(() => sl<SurahAudioController>()
                                      .state
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
                ],
              ),
            ),
            Flexible(child: SurahAudioList()),
          ],
        ),
        Row(
          children: [
            Expanded(flex: 4, child: SurahAudioList()),
            Expanded(
              flex: 4,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                      alignment: Alignment.center,
                      child: Padding(
                          padding: const EdgeInsets.only(top: 104.0),
                          child: customLottie(
                              LottieConstants.assetsLottieQuranAuIc,
                              height: 120,
                              isRepeat: false))),
                  Align(
                      alignment: Alignment.topCenter,
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          TabBarWidget(
                            isFirstChild: true,
                            isCenterChild: true,
                            isQuranSetting: false,
                            isNotification: false,
                            centerChild: LastListen(),
                          ),
                        ],
                      )),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 140.0),
                      child: Row(
                        children: [
                          Column(
                            children: [
                              const SurahSearch(),
                              Obx(() => sl<SurahAudioController>()
                                          .state
                                          .isPlaying
                                          .value ==
                                      true
                                  ? const Align(
                                      alignment: Alignment.topLeft,
                                      child: PlayBanner())
                                  : const SizedBox.shrink())
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
