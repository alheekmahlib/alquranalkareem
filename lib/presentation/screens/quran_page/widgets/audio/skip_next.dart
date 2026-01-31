part of '../../quran.dart';

class SkipToNext extends StatelessWidget {
  SkipToNext({super.key});
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
          label: 'next'.tr,
          child: Icon(
            Icons.skip_previous,
            color: Theme.of(context).colorScheme.primary,
            size: 30,
          ),
        ),
        onTap: () async {
          isRTL
              ? await audioCtrl.skipNextAyah(
                  context,
                  audioCtrl.currentAyah.ayahUQNumber,
                )
              : await audioCtrl.skipPreviousAyah(
                  context,
                  audioCtrl.currentAyah.ayahUQNumber,
                );
        },
      ),
    );
  }
}
