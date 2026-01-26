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
        child: Container(
          width: 150,
          height: 50,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface.withValues(alpha: .2),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
          margin: context.customOrientation(
            const EdgeInsets.only(top: 75.0, right: 16.0),
            const EdgeInsets.only(bottom: 16.0, left: 32.0),
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
                color: Theme.of(context).colorScheme.surface,
                width: 4,
                height: 15,
                animate: true,
              ),
              Container(
                height: 80,
                width: 10,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
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
