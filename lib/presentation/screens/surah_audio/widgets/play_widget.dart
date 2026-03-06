part of '../surah_audio.dart';

class PlayWidget extends StatelessWidget {
  PlayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final surahCtrl = AudioCtrl.instance;
    return SizedBox(
      height: 210,
      width: context.customOrientation(Get.width, Get.width * .5),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Obx(
            () => Opacity(
              opacity: .1,
              child: surahNameWidget(
                surahCtrl.state.currentAudioListSurahNum.value.toString(),
                Get.theme.colorScheme.primary,
                height: 90,
                width: 150,
              ),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: context.customArrowDown(
                  close: () =>
                      surahCtrl.surahState.isPlayExpanded.value = false,
                ),
              ),
              const Gap(8),
              SurahChangeSurahReader(
                style: surahCtrl.surahAudioStyle,
                isDark: ThemeController.instance.isDarkMode,
              ),
              const SurahSeekBar(),
              Stack(
                alignment: Alignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: Semantics(
                                button: true,
                                enabled: true,
                                label: 'backward'.tr,
                                child: customSvgWithColor(
                                  SvgPath.svgBackward,
                                  height: 30,
                                ),
                              ),
                              onPressed: () {
                                surahCtrl.state.audioPlayer.seek(
                                  Duration(
                                    seconds:
                                        surahCtrl.state.seekNextSeconds.value -=
                                            5,
                                  ),
                                );
                              },
                            ),
                            SurahSkipToNext(),
                          ],
                        ),
                        const OnlinePlayButton(isRepeat: true),
                        Row(
                          children: [
                            SurahSkipToPrevious(),
                            IconButton(
                              icon: Semantics(
                                button: true,
                                enabled: true,
                                label: 'rewind'.tr,
                                child: customSvgWithColor(
                                  SvgPath.svgRewind,
                                  height: 30,
                                ),
                              ),
                              onPressed: () => surahCtrl.state.audioPlayer.seek(
                                Duration(
                                  seconds:
                                      surahCtrl.state.seekNextSeconds.value +=
                                          5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  RepeatWidget(),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
