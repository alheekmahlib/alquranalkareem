import 'package:flutter/material.dart';

import '../../shared/services/controllers_put.dart';
import '../../shared/utils/constants/shared_preferences_constants.dart';
import '../../shared/widgets/seek_bar.dart';

class SurahSeekBar extends StatelessWidget {
  const SurahSeekBar({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PositionData>(
      stream: surahAudioController.positionDataStream,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          surahAudioController.positionData?.value = snapshot.data!;
          final positionData = snapshot.data;

          surahAudioController.updateControllerValues(positionData!);
          return SeekBar(
            duration: positionData.duration ?? Duration.zero,
            position: surahAudioController.lastTime != null
                ? Duration(seconds: surahAudioController.lastTime!.toInt())
                : positionData.position ?? Duration.zero,
            bufferedPosition: positionData.bufferedPosition ?? Duration.zero,
            onChangeEnd: (newPosition) async {
              surahAudioController.audioPlayer.seek(newPosition);
              await pref.saveInteger(
                  LAST_SURAH, surahAudioController.sorahNum.value);
              await pref.saveInteger(
                  SELECTED_SURAH, surahAudioController.sorahNum.value - 1);
              await pref.saveInteger(LAST_POSITION, newPosition.inSeconds);
            },
            activeTrackColor: Theme.of(context).colorScheme.surface,
            textColor: Theme.of(context).colorScheme.surface,
            timeShow: true,
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class DownloadSurahSeekBar extends StatelessWidget {
  const DownloadSurahSeekBar({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PositionData>(
      stream: surahAudioController.DownloadPositionDataStream,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          surahAudioController.positionData?.value = snapshot.data!;
          final positionData = snapshot.data;

          surahAudioController.updateControllerValues(positionData!);
          return SeekBar(
            duration: positionData.duration ?? Duration.zero,
            position: surahAudioController.lastTime != null
                ? Duration(seconds: surahAudioController.lastTime!.toInt())
                : positionData.position ?? Duration.zero,
            bufferedPosition: positionData.bufferedPosition ?? Duration.zero,
            onChangeEnd: (newPosition) async {
              surahAudioController.downAudioPlayer.seek(newPosition);
              await pref.saveInteger(
                  LAST_SURAH, surahAudioController.sorahNum.value);
              await pref.saveInteger(
                  SELECTED_SURAH, surahAudioController.sorahNum.value - 1);
              await pref.saveInteger(LAST_POSITION, newPosition.inSeconds);
            },
            activeTrackColor: Theme.of(context).colorScheme.surface,
            textColor: Theme.of(context).colorScheme.surface,
            timeShow: true,
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
