part of '../../quran.dart';

class SkipToPrevious extends StatelessWidget {
  SkipToPrevious({super.key});
  final audioCtrl = AudioController.instance;

  @override
  Widget build(BuildContext context) {
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
          await audioCtrl.skipPreviousAyah();
        },
      ),
    );
  }
}
