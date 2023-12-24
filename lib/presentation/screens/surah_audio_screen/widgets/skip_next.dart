import 'package:alquranalkareem/core/services/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../../../../core/services/services_locator.dart';
import '../../../controllers/surah_audio_controller.dart';

class SkipToNext extends StatelessWidget {
  const SkipToNext({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SequenceState?>(
      stream: sl<SurahAudioController>().audioPlayer.sequenceStateStream,
      builder: (context, snapshot) => IconButton(
        icon: Semantics(
          button: true,
          enabled: true,
          label: AppLocalizations.of(context)!.next,
          child: Icon(
            Icons.skip_previous,
            color: Theme.of(context).colorScheme.surface,
            size: 30,
          ),
        ),
        onPressed: () {
          if (sl<SurahAudioController>().isDownloading.value) {
            if (sl<SurahAudioController>().surahNum.value == 114) {
              sl<SurahAudioController>().surahNum.value = 1;
              sl<SurahAudioController>().selectedSurah.value = 1;
            } else {
              sl<SurahAudioController>().surahNum.value += 1;
              sl<SurahAudioController>().selectedSurah.value += 1;
            }
          } else {
            if (sl<SurahAudioController>().surahNum.value == 114) {
              sl<SurahAudioController>().surahNum.value = 1;
              sl<SurahAudioController>().selectedSurah.value = 1;
            } else {
              sl<SurahAudioController>().surahNum.value += 1;
              sl<SurahAudioController>().selectedSurah.value += 1;
            }
          }
          sl<SurahAudioController>().playNextSurah();
        },
      ),
    );
  }
}
