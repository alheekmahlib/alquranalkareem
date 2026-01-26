part of '../surah_audio.dart';

class CollapsedPlayWidget extends StatelessWidget {
  const CollapsedPlayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: context.customOrientation(width, width * .5),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
        ),
        child: Stack(
          children: [
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SurahSkipToNext(
                        style: AudioCtrl.instance.surahAudioStyle,
                        languageCode: Get.locale!.languageCode,
                      ),
                      const OnlinePlayButton(isRepeat: false),
                      SurahSkipToPrevious(
                        style: AudioCtrl.instance.surahAudioStyle,
                        languageCode: Get.locale!.languageCode,
                      ),
                    ],
                  ),
                  Obx(
                    () => surahNameWidget(
                      AudioCtrl.instance.state.currentAudioListSurahNum
                          .toString(),
                      Get.theme.colorScheme.primary,
                      height: 50,
                      width: 100,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
