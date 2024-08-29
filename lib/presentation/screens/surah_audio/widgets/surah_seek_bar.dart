import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '/presentation/screens/surah_audio/controller/extensions/surah_audio_getters.dart';
import '../../../../core/services/services_locator.dart';
import '../../../../core/utils/constants/shared_preferences_constants.dart';
import '../../../../core/widgets/seek_bar.dart';
import '../controller/surah_audio_controller.dart';

class SurahSeekBar extends StatelessWidget {
  const SurahSeekBar({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SurahAudioController>(
        id: 'seekBar_id',
        builder: (c) => c.state.onDownloading.value
            ? GetX<SurahAudioController>(builder: (c) {
                return SliderWidget.downloading(
                    currentPosition: c.state.downloadProgress.value.toInt(),
                    filesCount: c.state.fileSize.value,
                    horizontalPadding: 32.0);
              })
            : StreamBuilder<PositionData>(
                stream: sl<SurahAudioController>().positionDataStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    sl<SurahAudioController>().state.positionData?.value =
                        snapshot.data!;
                    final positionData = snapshot.data;

                    sl<SurahAudioController>()
                        .updateControllerValues(positionData!);
                    return SliderWidget.player(
                      horizontalPadding: 32.0,
                      duration: positionData.duration,
                      position:
                          sl<SurahAudioController>().state.lastTime != null
                              ? Duration(
                                  seconds: sl<SurahAudioController>()
                                      .state
                                      .lastPosition
                                      .value
                                      .toInt())
                              : positionData.position,
                      // bufferedPosition: positionData.bufferedPosition,
                      onChangeEnd: (newPosition) async {
                        sl<SurahAudioController>()
                            .state
                            .audioPlayer
                            .seek(newPosition);
                        GetStorage().write(LAST_SURAH,
                            sl<SurahAudioController>().state.surahNum.value);
                        GetStorage().write(
                            SELECTED_SURAH,
                            sl<SurahAudioController>().state.surahNum.value -
                                1);
                        GetStorage()
                            .write(LAST_POSITION, newPosition.inSeconds);
                        sl<SurahAudioController>().state.seekNextSeconds.value =
                            newPosition.inSeconds;
                      },
                      activeTrackColor: Theme.of(context).colorScheme.primary,
                      textColor: Theme.of(context).canvasColor,
                      timeShow: true,
                    );
                  }
                  return const SizedBox.shrink();
                },
              ));
  }
}
