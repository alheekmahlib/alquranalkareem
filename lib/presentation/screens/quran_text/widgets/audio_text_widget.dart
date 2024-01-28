import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:square_percent_indicater/square_percent_indicater.dart';

import '../../../../core/services/services_locator.dart';
import '../../../../core/utils/constants/svg_picture.dart';
import '../../../../core/widgets/seek_bar.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../controllers/audio_controller.dart';
import '../../../controllers/general_controller.dart';
import '../../quran_page/widgets/change_reader.dart';

class AudioTextWidget extends StatelessWidget {
  const AudioTextWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return audioContainer(
      context,
      Stack(
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: decorations(context),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: RotatedBox(
              quarterTurns: 2,
              child: decorations(context),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0, left: 90.0),
              child: customClose(context,
                  close: () => sl<GeneralController>()
                      .textWidgetPosition
                      .value = -240.0),
            ),
          ),
          const Align(
            alignment: Alignment.topCenter,
            child: ChangeReader(),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Obx(
                            () => SquarePercentIndicator(
                              width: 35,
                              height: 35,
                              startAngle: StartAngle.topRight,
                              // reverse: true,
                              borderRadius: 8,
                              shadowWidth: 1.5,
                              progressWidth: 2,
                              shadowColor: Colors.grey.shade300,
                              progressColor:
                                  sl<AudioController>().downloading.value
                                      ? Get.theme.dividerColor
                                      : Colors.transparent,
                              progress: sl<AudioController>().progress.value,
                            ),
                          ),
                          Obx(
                            () => sl<AudioController>().downloading.value
                                ? Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      sl<AudioController>()
                                          .progressString
                                          .value,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'kufi',
                                          color: Get.theme.colorScheme.surface),
                                    ),
                                  )
                                : IconButton(
                                    icon: Icon(
                                      sl<AudioController>().isPlay.value
                                          ? Icons.pause
                                          : Icons.play_arrow,
                                      size: 22,
                                    ),
                                    color: Get.theme.colorScheme.surface,
                                    onPressed: () {
                                      sl<AudioController>().selected.value =
                                          true;
                                      print(sl<AudioController>()
                                          .progressString
                                          .value);
                                      if (sl<AudioController>()
                                          .onDownloading
                                          .value) {
                                        sl<AudioController>().cancelDownload();
                                      } else {
                                        sl<AudioController>()
                                            .textPlayAyah(context);
                                      }
                                    },
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 8,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: 30,
                          width: 250,
                          decoration: BoxDecoration(
                              color: Get.theme.dividerColor.withOpacity(.4),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8))),
                        ),
                        Container(
                          height: 50,
                          alignment: Alignment.center,
                          child: StreamBuilder<PositionData>(
                            stream:
                                sl<AudioController>().textPositionDataStream,
                            builder: (context, snapshot) {
                              final positionData = snapshot.data;
                              return SeekBar(
                                // timeShow: true,
                                // textColor: Get.theme.dividerColor,
                                duration:
                                    positionData?.duration ?? Duration.zero,
                                position:
                                    positionData?.position ?? Duration.zero,
                                bufferedPosition:
                                    positionData?.bufferedPosition ??
                                        Duration.zero,
                                activeTrackColor: Get.theme.colorScheme.surface,
                                onChangeEnd:
                                    sl<AudioController>().textAudioPlayer.seek,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
