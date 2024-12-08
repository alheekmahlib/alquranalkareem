part of '../../quran.dart';

class SkipToNext extends StatelessWidget {
  SkipToNext({super.key});
  final audioCtrl = AudioController.instance;

  @override
  Widget build(BuildContext context) {
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
          await audioCtrl.skipNextAyah();
        },
      ),
    );
  }
}
