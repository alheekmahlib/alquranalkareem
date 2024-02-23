import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/services/services_locator.dart';
import '../../../../core/utils/constants/shared_preferences_constants.dart';
import '../../../../core/widgets/seek_bar.dart';
import '../../../controllers/surah_audio_controller.dart';

class SurahSeekBar extends StatelessWidget {
  const SurahSeekBar({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PositionData>(
      stream: sl<SurahAudioController>().positionDataStream,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          sl<SurahAudioController>().positionData?.value = snapshot.data!;
          final positionData = snapshot.data;

          sl<SurahAudioController>().updateControllerValues(positionData!);
          return SliderWidget(
            horizontalPadding: 32.0,
            duration: positionData.duration ?? Duration.zero,
            position: sl<SurahAudioController>().lastTime != null
                ? Duration(
                    seconds: sl<SurahAudioController>().lastTime!.toInt())
                : positionData.position ?? Duration.zero,
            bufferedPosition: positionData.bufferedPosition ?? Duration.zero,
            onChangeEnd: (newPosition) async {
              sl<SurahAudioController>().audioPlayer.seek(newPosition);
              await sl<SharedPreferences>().setInt(
                  LAST_SURAH, sl<SurahAudioController>().surahNum.value);
              await sl<SharedPreferences>().setInt(SELECTED_SURAH,
                  sl<SurahAudioController>().surahNum.value - 1);
              await sl<SharedPreferences>()
                  .setInt(LAST_POSITION, newPosition.inSeconds);
            },
            activeTrackColor: Theme.of(context).colorScheme.surface,
            textColor: Theme.of(context).canvasColor,
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
      stream: sl<SurahAudioController>().DownloadPositionDataStream,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          sl<SurahAudioController>().positionData?.value = snapshot.data!;
          final positionData = snapshot.data;

          sl<SurahAudioController>().updateControllerValues(positionData!);
          return SliderWidget(
            horizontalPadding: 32.0,
            duration: positionData.duration ?? Duration.zero,
            position: sl<SurahAudioController>().lastTime != null
                ? Duration(
                    seconds: sl<SurahAudioController>().lastTime!.toInt())
                : positionData.position ?? Duration.zero,
            bufferedPosition: positionData.bufferedPosition ?? Duration.zero,
            onChangeEnd: (newPosition) async {
              sl<SurahAudioController>().downAudioPlayer.seek(newPosition);
              await sl<SharedPreferences>().setInt(
                  LAST_SURAH, sl<SurahAudioController>().surahNum.value);
              await sl<SharedPreferences>().setInt(SELECTED_SURAH,
                  sl<SurahAudioController>().surahNum.value - 1);
              await sl<SharedPreferences>()
                  .setInt(LAST_POSITION, newPosition.inSeconds);
            },
            activeTrackColor: Theme.of(context).colorScheme.surface,
            textColor: Theme.of(context).canvasColor,
            timeShow: true,
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
