import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

import '/core/services/services_locator.dart';
import '../controller/surah_audio_controller.dart';

class SkipToPrevious extends StatelessWidget {
  const SkipToPrevious({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SequenceState?>(
      stream: sl<SurahAudioController>().state.audioPlayer.sequenceStateStream,
      builder: (context, snapshot) => IconButton(
        icon: Semantics(
          button: true,
          enabled: true,
          label: 'skipToPrevious'.tr,
          child: Icon(
            Icons.skip_next,
            color: Theme.of(context).colorScheme.primary,
            size: 30,
          ),
        ),
        onPressed: sl<SurahAudioController>().state.surahNum.value == 1
            ? null
            : () {
                sl<SurahAudioController>().playPreviousSurah();
              },
      ),
    );
  }
}
