part of '../surah_audio.dart';

class CollapsedPlayWidget extends StatelessWidget {
  CollapsedPlayWidget({super.key});

  final surahCtrl = AudioCtrl.instance;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: SizedBox(
        height: 73,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Obx(
                () => surahNameWidget(
                  AudioCtrl.instance.state.currentAudioListSurahNum.toString(),
                  Get.theme.colorScheme.inversePrimary.withValues(alpha: .3),
                  height: 50,
                  width: 100,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SurahSkipToNext(),
                      const Gap(4),
                      const OnlinePlayButton(isRepeat: false),
                      const Gap(4),
                      SurahSkipToPrevious(),
                    ],
                  ),
                  SurahChangeSurahReader(
                    style: surahCtrl.surahAudioStyle,
                    isDark: ThemeController.instance.isDarkMode,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
