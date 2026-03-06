part of '../surah_audio.dart';

class RepeatWidget extends StatelessWidget {
  RepeatWidget({super.key});

  final surahAudioCtrl = AudioCtrl.instance;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: StreamBuilder<LoopMode>(
          stream: surahAudioCtrl.state.audioPlayer.loopModeStream,
          builder: (context, snapshot) {
            final loopMode = snapshot.data ?? LoopMode.off;
            List<Color> iconsColor = [
              context.theme.primaryColorLight.withValues(alpha: .5),
              context.theme.primaryColorLight,
            ];
            const cycleModes = [LoopMode.off, LoopMode.all];
            final index = cycleModes.indexOf(loopMode);
            return CustomButton(
              svgPath: SvgPath.svgAudioLoop,
              height: 35,
              width: 35,
              iconSize: 38,
              horizontalPadding: 8.0,
              isCustomSvgColor: true,
              svgColor: context.theme.canvasColor,
              backgroundColor: iconsColor[index],
              onPressed: () {
                surahAudioCtrl.state.audioPlayer.setLoopMode(
                  cycleModes[(cycleModes.indexOf(loopMode) + 1) %
                      cycleModes.length],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
