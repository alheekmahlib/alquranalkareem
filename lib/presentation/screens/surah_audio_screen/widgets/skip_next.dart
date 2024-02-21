import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

import '../../../../core/services/services_locator.dart';
import '../../../controllers/surah_audio_controller.dart';

class SkipToNext extends StatelessWidget {
  const SkipToNext({super.key});
  @override
  Widget build(BuildContext context) {
    final surahAudioCtrl = sl<SurahAudioController>();
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
        onPressed: () {
          if (surahAudioCtrl.isDownloading.value) {
            if (surahAudioCtrl.surahNum.value == 114) {
              surahAudioCtrl.surahNum.value = 1;
              surahAudioCtrl.selectedSurah.value = 1;
            } else {
              surahAudioCtrl.surahNum.value += 1;
              surahAudioCtrl.selectedSurah.value += 1;
            }
          } else {
            if (surahAudioCtrl.surahNum.value == 114) {
              surahAudioCtrl.surahNum.value = 1;
              surahAudioCtrl.selectedSurah.value = 1;
            } else {
              surahAudioCtrl.surahNum.value += 1;
              surahAudioCtrl.selectedSurah.value += 1;
            }
          }
          surahAudioCtrl.playNextSurah();
        },
      ),
    );
  }
}
