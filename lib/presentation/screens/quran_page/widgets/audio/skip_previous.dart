part of '../../quran.dart';

class SkipToPrevious extends StatelessWidget {
  SkipToPrevious({super.key});
  final audioCtrl = AudioCtrl.instance;

  @override
  Widget build(BuildContext context) {
    final isRTL = Get.locale?.languageCode == 'ar';
    return StreamBuilder<SequenceState?>(
      stream: audioCtrl.state.audioPlayer.sequenceStateStream,
      builder: (context, snapshot) => GestureDetector(
        child: Semantics(
          button: true,
          enabled: true,
          label: 'skipToPrevious'.tr,
          child: Icon(
            Icons.skip_next,
            color: Theme.of(context).colorScheme.primary,
            size: 30,
          ),
        ),
        onTap: () async {
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
