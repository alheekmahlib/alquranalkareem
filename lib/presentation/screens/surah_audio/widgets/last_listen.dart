part of '../surah_audio.dart';

class LastListen extends StatelessWidget {
  LastListen({super.key});

  final surahAudioCtrl = AudioCtrl.instance;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 95,
            decoration: BoxDecoration(
              color: context.theme.primaryColorLight,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const Gap(8),
          Expanded(
            child: Semantics(
              button: true,
              enabled: true,
              label: 'lastListen'.tr,
              child: GestureDetector(
                onTap: () {
                  surahAudioCtrl.state.isPlayingSurahsMode = true;
                  surahAudioCtrl.enableSurahAutoNextListener();
                  surahAudioCtrl.enableSurahPositionSaving();
                  surahAudioCtrl.loadLastSurahAndPosition();
                  surahAudioCtrl.state.audioPlayer.play();
                  surahAudioCtrl.state.isSheetOpen.value = true;
                  // surahAudioCtrl.state.boxController.openBox();
                  surahAudioCtrl.jumpToSurah(
                    (surahAudioCtrl.state.selectedSurahIndex.value),
                  );
                },
                child: Container(
                  height: 95,
                  width: Get.width,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 8.0,
                  ),
                  decoration: BoxDecoration(
                    color: context.theme.primaryColorLight.withValues(
                      alpha: .2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 45,
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6.0,
                                      vertical: 4.0,
                                    ),
                                    decoration: BoxDecoration(
                                      color: context
                                          .theme
                                          .colorScheme
                                          .primaryContainer,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        'lastListen'.tr,
                                        style: AppTextStyles.titleMedium(),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                                const Gap(8),
                                Expanded(
                                  child: Container(
                                    height: 45,
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6.0,
                                      vertical: 4.0,
                                    ),
                                    decoration: BoxDecoration(
                                      color: context
                                          .theme
                                          .colorScheme
                                          .primaryContainer,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Obx(
                                      () => customSvgWithColor(
                                        'assets/svg/surah_name/00${surahAudioCtrl.state.selectedSurahIndex.value + 1}.svg',
                                        width: 110,
                                        color: context
                                            .theme
                                            .colorScheme
                                            .inversePrimary,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Gap(8),
                            if (context.mounted)
                              GetX<AudioCtrl>(
                                builder: (surahAudioController) => Text(
                                  '${surahAudioCtrl.formatDuration(Duration(seconds: surahAudioCtrl.state.lastPosition.value))}',
                                  style: AppTextStyles.titleMedium(height: 1.2),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const Gap(16),
                      RotatedBox(
                        quarterTurns: alignmentLayout(1, 3),
                        child: customSvgWithColor(
                          SvgPath.svgHomeArrowDown,
                          color: context.theme.colorScheme.surface,
                          height: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
