part of '../surah_audio.dart';

class PlayBanner extends StatelessWidget {
  const PlayBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: true,
      label: 'Play Banner',
      child: GestureDetector(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 50,
                width: 8,
                decoration: BoxDecoration(
                  color: context.theme.primaryColorLight,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const Gap(8),
              Container(
                width: 150,
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                decoration: BoxDecoration(
                  color: context.theme.primaryColorLight.withValues(alpha: .1),
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Obx(
                      () => RepaintBoundary(
                        child: customSvgWithColor(
                          'assets/svg/surah_name/00${AudioCtrl.instance.state.currentAudioListSurahNum}.svg',
                          width: 100,
                          color: context.theme.colorScheme.inversePrimary,
                        ),
                      ),
                    ),
                    MiniMusicVisualizer(
                      color: context.theme.colorScheme.surface,
                      width: 4,
                      height: 15,
                      animate: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          AudioCtrl.instance.jumpToSurah(
            AudioCtrl.instance.state.selectedSurahIndex.value,
          );
        },
      ),
    );
  }
}
