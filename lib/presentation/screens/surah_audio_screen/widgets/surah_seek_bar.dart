import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/services/services_locator.dart';
import '../../../../core/utils/constants/shared_pref_services.dart';
import '../../../../core/utils/constants/shared_preferences_constants.dart';
import '../../../../core/widgets/seek_bar.dart';
import '../../../controllers/surah_audio_controller.dart';

class SurahSeekBar extends StatelessWidget {
  const SurahSeekBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        StreamBuilder<PositionData>(
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
                bufferedPosition:
                    positionData.bufferedPosition ?? Duration.zero,
                onChangeEnd: (newPosition) async {
                  sl<SurahAudioController>().audioPlayer.seek(newPosition);
                  await sl<SharedPrefServices>().saveInteger(
                      LAST_SURAH, sl<SurahAudioController>().surahNum.value);
                  await sl<SharedPrefServices>().saveInteger(SELECTED_SURAH,
                      sl<SurahAudioController>().surahNum.value - 1);
                  await sl<SharedPrefServices>()
                      .saveInteger(LAST_POSITION, newPosition.inSeconds);
                },
                activeTrackColor: Get.theme.colorScheme.surface,
                textColor: Get.theme.colorScheme.surface,
                timeShow: true,
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}

class DownloadSurahSeekBar extends StatelessWidget {
  const DownloadSurahSeekBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 30,
          width: 250,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
              color: Get.theme.colorScheme.primary.withOpacity(.15),
              borderRadius: const BorderRadius.all(Radius.circular(8))),
        ),
        StreamBuilder<PositionData>(
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
                bufferedPosition:
                    positionData.bufferedPosition ?? Duration.zero,
                onChangeEnd: (newPosition) async {
                  sl<SurahAudioController>().downAudioPlayer.seek(newPosition);
                  await sl<SharedPrefServices>().saveInteger(
                      LAST_SURAH, sl<SurahAudioController>().surahNum.value);
                  await sl<SharedPrefServices>().saveInteger(SELECTED_SURAH,
                      sl<SurahAudioController>().surahNum.value - 1);
                  await sl<SharedPrefServices>()
                      .saveInteger(LAST_POSITION, newPosition.inSeconds);
                },
                activeTrackColor: Get.theme.colorScheme.surface,
                textColor: Get.theme.colorScheme.surface,
                timeShow: true,
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
