part of '../surah_audio.dart';

class SurahSkipToPrevious extends StatelessWidget {
  SurahSkipToPrevious({super.key});
  final audioCtrl = AudioCtrl.instance;

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final isPlayExpanded = audioCtrl.surahState.isPlayExpanded.value;
    return SizedBox(
      height: 50,
      width: 50,
      child: StreamBuilder<SequenceState?>(
        stream: audioCtrl.state.audioPlayer.sequenceStateStream,
        builder: (context, snapshot) => CustomButton(
          svgPath: isRtl
              ? SvgPath.svgAudioPreviousIcon
              : SvgPath.svgAudioNextIcon,
          height: 40,
          width: 40,
          iconSize: isPlayExpanded ? 40 : 30,
          isCustomSvgColor: true,
          svgColor: context.theme.colorScheme.primary,
          onPressed: () async =>
              // languageCode != 'ar'
              //     ? await AudioCtrl.instance.playNextSurah()
              //     :
              await audioCtrl.playNextSurah(),
        ),
      ),
    );
  }
}
