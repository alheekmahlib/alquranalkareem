import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

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
          return SliderWidget.player(
            horizontalPadding: 32.0,
            duration: positionData.duration,
            position: sl<SurahAudioController>().lastTime != null
                ? Duration(
                    seconds: sl<SurahAudioController>().lastTime!.toInt())
                : positionData.position,
            // bufferedPosition: positionData.bufferedPosition,
            onChangeEnd: (newPosition) async {
              sl<SurahAudioController>().audioPlayer.seek(newPosition);
              GetStorage()
                  .write(LAST_SURAH, sl<SurahAudioController>().surahNum.value);
              GetStorage().write(SELECTED_SURAH,
                  sl<SurahAudioController>().surahNum.value - 1);
              GetStorage().write(LAST_POSITION, newPosition.inSeconds);
              sl<SurahAudioController>().seekNextSeconds.value =
                  newPosition.inSeconds;
            },
            activeTrackColor: Theme.of(context).colorScheme.primary,
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
            duration: positionData.duration,
            position: sl<SurahAudioController>().lastTime != null
                ? Duration(
                    seconds: sl<SurahAudioController>().lastTime!.toInt())
                : positionData.position,
            // bufferedPosition: positionData.bufferedPosition,
            onChangeEnd: (newPosition) async {
              sl<SurahAudioController>().downAudioPlayer.seek(newPosition);
              GetStorage()
                  .write(LAST_SURAH, sl<SurahAudioController>().surahNum.value);
              GetStorage().write(SELECTED_SURAH,
                  sl<SurahAudioController>().surahNum.value - 1);
              GetStorage().write(LAST_POSITION, newPosition.inSeconds);
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
