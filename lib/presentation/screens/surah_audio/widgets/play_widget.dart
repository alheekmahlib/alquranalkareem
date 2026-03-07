part of '../surah_audio.dart';

class PlayWidget extends StatelessWidget {
  final Color? iconColor;
  final Color? backgroundColor;
  final bool? isFullScreen;
  PlayWidget({
    super.key,
    this.iconColor,
    this.backgroundColor,
    this.isFullScreen = false,
  });

  @override
  Widget build(BuildContext context) {
    final surahCtrl = AudioCtrl.instance;
    return SizedBox(
      height: isFullScreen == true ? 180 : 210,
      width: context.customOrientation(Get.width, Get.width * .5),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Obx(
            () => Opacity(
              opacity: .1,
              child: surahNameWidget(
                surahCtrl.state.currentAudioListSurahNum.value.toString(),
                iconColor ?? Get.theme.colorScheme.primary,
                height: 90,
                width: 150,
              ),
            ),
          ),
          Column(
            children: [
              if (isFullScreen == false) ...[
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
              ],
              SurahSeekBar(
                customColor: backgroundColor,
                activeTrackColor: iconColor,
                thumbColor: iconColor,
              ),
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
                                  color:
                                      iconColor ??
                                      Get.theme.colorScheme.primary,
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
                            SurahSkipToNext(iconColor: iconColor),
                          ],
                        ),
                        OnlinePlayButton(isRepeat: true, iconColor: iconColor),
                        Row(
                          children: [
                            SurahSkipToPrevious(iconColor: iconColor),
                            IconButton(
                              icon: Semantics(
                                button: true,
                                enabled: true,
                                label: 'rewind'.tr,
                                child: customSvgWithColor(
                                  SvgPath.svgRewind,
                                  height: 30,
                                  color:
                                      iconColor ??
                                      Get.theme.colorScheme.primary,
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
                  RepeatWidget(iconColor: backgroundColor),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
