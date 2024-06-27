import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

import '../../../controllers/surah_audio_controller.dart';

class SkipToNext extends StatelessWidget {
  const SkipToNext({super.key});
  @override
  Widget build(BuildContext context) {
    final surahAudioCtrl = SurahAudioController.instance;
    return StreamBuilder<SequenceState?>(
      stream: surahAudioCtrl.audioPlayer.sequenceStateStream,
      builder: (context, snapshot) => IconButton(
        icon: Semantics(
          button: true,
          enabled: true,
          label: 'next'.tr,
          child: Icon(
            Icons.skip_previous,
            color: Theme.of(context).colorScheme.primary,
            size: 30,
          ),
        ),
        onPressed: (surahAudioCtrl.surahNum.value) == 114
            ? null
            : () {
                surahAudioCtrl.playNextSurah();
              },
      ),
    );
  }
}
