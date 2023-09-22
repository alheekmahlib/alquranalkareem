import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../../shared/services/controllers_put.dart';

class SkipToNext extends StatelessWidget {
  const SkipToNext({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SequenceState?>(
      stream: surahAudioController.audioPlayer.sequenceStateStream,
      builder: (context, snapshot) => IconButton(
        icon: Icon(
          Icons.skip_previous,
          color: Theme.of(context).colorScheme.surface,
          size: 30,
        ),
        onPressed: () {
          if (surahAudioController.isDownloading.value) {
            if (surahAudioController.sorahNum.value == 114) {
              surahAudioController.sorahNum.value = 1;
              surahAudioController.selectedSurah.value = 1;
            } else {
              surahAudioController.sorahNum.value += 1;
              surahAudioController.selectedSurah.value += 1;
            }
          } else {
            if (surahAudioController.sorahNum.value == 114) {
              surahAudioController.sorahNum.value = 1;
              surahAudioController.selectedSurah.value = 1;
            } else {
              surahAudioController.sorahNum.value += 1;
              surahAudioController.selectedSurah.value += 1;
            }
          }
          surahAudioController.playNextSurah();
        },
      ),
    );
  }
}
