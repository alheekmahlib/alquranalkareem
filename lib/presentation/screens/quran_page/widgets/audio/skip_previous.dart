part of '../../quran.dart';

class SkipToPrevious extends StatelessWidget {
  SkipToPrevious({super.key});
  final audioCtrl = AudioCtrl.instance;

  @override
  Widget build(BuildContext context) {
    final isRTL = Get.locale?.languageCode == 'ar';
    return StreamBuilder<SequenceState?>(
      stream: audioCtrl.state.audioPlayer.sequenceStateStream,
      builder: (context, snapshot) => CustomButton(
        svgPath: SvgPath.svgAudioNextIcon,
        height: 40,
        width: 40,
        iconSize: 25,
        isCustomSvgColor: true,
        svgColor: context.theme.colorScheme.primary,
        onPressed: () async {
          isRTL
              ? await audioCtrl.skipPreviousAyah(
                  context,
                  audioCtrl.currentAyah.ayahUQNumber,
                )
              : await audioCtrl.skipNextAyah(
                  context,
                  audioCtrl.currentAyah.ayahUQNumber,
                );
        },
      ),
    );
  }
}
