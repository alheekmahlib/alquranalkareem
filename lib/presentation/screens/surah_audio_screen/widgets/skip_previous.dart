import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

import '../../../../core/services/services_locator.dart';
import '../../../controllers/surah_audio_controller.dart';

class SkipToPrevious extends StatelessWidget {
  const SkipToPrevious({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SequenceState?>(
      stream: sl<SurahAudioController>().audioPlayer.sequenceStateStream,
      builder: (context, snapshot) => IconButton(
        icon: Semantics(
          button: true,
          enabled: true,
          label: 'skipToPrevious'.tr,
          child: Icon(
            Icons.skip_next,
            color: Get.theme.colorScheme.primary,
            size: 30,
          ),
        ),
        onPressed: () {
          if (sl<SurahAudioController>().isDownloading.value) {
            if (sl<SurahAudioController>().surahNum.value == 114) {
              sl<SurahAudioController>().surahNum.value = 1;
              sl<SurahAudioController>().selectedSurah.value = 1;
            } else {
              sl<SurahAudioController>().surahNum.value -= 1;
              sl<SurahAudioController>().selectedSurah.value -= 1;
            }
          } else {
            if (sl<SurahAudioController>().surahNum.value == 114) {
              sl<SurahAudioController>().surahNum.value = 1;
              sl<SurahAudioController>().selectedSurah.value = 1;
            } else {
              sl<SurahAudioController>().surahNum.value -= 1;
              sl<SurahAudioController>().selectedSurah.value -= 1;
            }
          }
          sl<SurahAudioController>().playNextSurah();
        },
      ),
    );
  }
}
