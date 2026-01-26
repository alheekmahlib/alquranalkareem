part of '../surah_audio.dart';

class PlayWidget extends StatelessWidget {
  PlayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final surahCtrl = AudioCtrl.instance;
    return Container(
      height: 305,
      width: context.customOrientation(Get.width, Get.width * .5),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: RotatedBox(
              quarterTurns: 2,
              child: Opacity(
                opacity: .6,
                child: customSvgWithCustomColor(
                  SvgPath.svgDecorations,
                  height: 60,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Opacity(
              opacity: .6,
              child: customSvgWithCustomColor(
                SvgPath.svgDecorations,
                height: 60,
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: context.customArrowDown(
                isBorder: true,
                close: () => surahCtrl.surahState.isPlayExpanded.value = false,
              ),
            ),
          ),
          Column(
            children: [
              Obx(
                () => Stack(
                  alignment: Alignment.center,
                  children: [
                    Opacity(
                      opacity: .1,
                      child: surahNameWidget(
                        surahCtrl.state.currentAudioListSurahNum.value
                            .toString(),
                        Get.theme.colorScheme.primary,
                        height: 90,
                        width: 150,
                      ),
                    ),
                    surahNameWidget(
                      surahCtrl.state.currentAudioListSurahNum.value.toString(),
                      Get.theme.colorScheme.primary,
                      height: 70,
                      width: 150,
                    ),
                  ],
                ),
              ),
              SurahChangeSurahReader(
                style: surahCtrl.surahAudioStyle,
                isDark: ThemeController.instance.isDarkMode,
              ),
              const SurahSeekBar(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                              height: 20,
                            ),
                          ),
                          onPressed: () {
                            surahCtrl.state.audioPlayer.seek(
                              Duration(
                                seconds:
                                    surahCtrl.state.seekNextSeconds.value -= 5,
                              ),
                            );
                          },
                        ),
                        SurahSkipToNext(
                          style: surahCtrl.surahAudioStyle,
                          languageCode: Get.locale!.languageCode,
                        ),
                      ],
                    ),
                    const OnlinePlayButton(isRepeat: true),
                    Row(
                      children: [
                        SurahSkipToPrevious(
                          style: surahCtrl.surahAudioStyle,
                          languageCode: Get.locale!.languageCode,
                        ),
                        IconButton(
                          icon: Semantics(
                            button: true,
                            enabled: true,
                            label: 'rewind'.tr,
                            child: customSvgWithColor(
                              SvgPath.svgRewind,
                              height: 20,
                            ),
                          ),
                          onPressed: () => surahCtrl.state.audioPlayer.seek(
                            Duration(
                              seconds: surahCtrl.state.seekNextSeconds.value +=
                                  5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
