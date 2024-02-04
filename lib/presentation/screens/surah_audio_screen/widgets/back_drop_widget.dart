import 'package:alquranalkareem/core/widgets/tab_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/services/services_locator.dart';
import '../../../../core/utils/constants/lottie.dart';
import '../../../controllers/surah_audio_controller.dart';
import 'last_listen.dart';
import 'play_banner.dart';
import 'surah_audio_list.dart';
import 'surah_search.dart';

class BackDropWidget extends StatelessWidget {
  const BackDropWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
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
                      child: quran_au_ic(height: 120))),
              const Align(
                  alignment: Alignment.topCenter,
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      TabBarWidget(
                        isChild: true,
                        isIndicator: false,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 14.0),
                        child: LastListen(),
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
                          alignment: Alignment.topRight, child: SurahSearch()),
                      Obx(() => sl<SurahAudioController>()
                                  .isDownloading
                                  .value ||
                              sl<SurahAudioController>().isPlaying.value == true
                          ? const Align(
                              alignment: Alignment.topLeft, child: PlayBanner())
                          : const SizedBox.shrink())
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        const Flexible(child: SurahAudioList()),
        // Obx(
        //   () => AnimatedPositioned(
        //     duration: const Duration(milliseconds: 300),
        //     curve: Curves.easeInOut,
        //     bottom: sl<GeneralController>().widgetPosition.value,
        //     left: 0,
        //     right: 0,
        //     child: PlayWidget(),
        //   ),
        // ),
      ],
    );
  }
}
