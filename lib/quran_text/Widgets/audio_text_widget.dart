import 'package:alquranalkareem/shared/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:square_percent_indicater/square_percent_indicater.dart';

import '../../shared/widgets/controllers_put.dart';
import '../../shared/widgets/seek_bar.dart';

class AudioTextWidget extends StatelessWidget {
  const AudioTextWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 80.0),
        child: Container(
          height: 60,
          width: 310,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface.withOpacity(.94),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
          child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Obx(() {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: SquarePercentIndicator(
                          width: 35,
                          height: 35,
                          startAngle: StartAngle.topRight,
                          // reverse: true,
                          borderRadius: 8,
                          shadowWidth: 1.5,
                          progressWidth: 2,
                          shadowColor: Colors.grey,
                          progressColor: audioController.downloading.value
                              ? Theme.of(context).canvasColor
                              : Colors.transparent,
                          progress: audioController.progress.value,
                          child: Container(
                            height: 35,
                            width: 35,
                            decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8))),
                            child: audioController.downloading.value
                                ? Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      audioController.progressString.value,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'kufi',
                                          color: Theme.of(context).canvasColor),
                                    ),
                                  )
                                : Obx(
                                    () => IconButton(
                                      icon: Icon(
                                        audioController.isPlay.value
                                            ? Icons.pause
                                            : Icons.play_arrow,
                                        size: 20,
                                      ),
                                      color: Theme.of(context).canvasColor,
                                      onPressed:
                                          !audioController.isPagePlay.value
                                              ? () {
                                                  print(audioController
                                                      .progressString.value);

                                                  audioController
                                                      .textPlayAyah(context);
                                                }
                                              : null,
                                    ),
                                  ),
                          ),
                        ),
                        // child: SquarePercentIndicator(
                        //   width: 35,
                        //   height: 35,
                        //   startAngle: StartAngle.topRight,
                        //   borderRadius: 8,
                        //   shadowWidth: 1.5,
                        //   progressWidth: 2,
                        //   shadowColor: Colors.grey,
                        //   progressColor: audioController.downloading.value
                        //       ? Theme.of(context).canvasColor
                        //       : Colors.transparent,
                        //   progress: audioController.progress.value,
                        //   child: audioController.downloading.value
                        //       ? Container(
                        //           alignment: Alignment.center,
                        //           child: Text(
                        //             audioController.progressString.value,
                        //             style: TextStyle(
                        //                 fontSize: 14,
                        //                 fontFamily: 'kufi',
                        //                 color: Theme.of(context).canvasColor),
                        //           ),
                        //         )
                        //       : IconButton(
                        //           icon: Icon(
                        //             audioController.isPlay.value
                        //                 ? Icons.pause
                        //                 : Icons.play_arrow,
                        //             size: 20,
                        //           ),
                        //           color: Theme.of(context).canvasColor,
                        //           onPressed: () {
                        //             print(audioController.progressString.value);
                        //
                        //             audioController.textPlayAyah(context);
                        //           },
                        //         ),
                        // ),
                      ),
                      Container(
                        height: 50,
                        alignment: Alignment.center,
                        width: 200,
                        child: StreamBuilder<PositionData>(
                          stream: audioController.textPositionDataStream,
                          builder: (context, snapshot) {
                            final positionData = snapshot.data;
                            return SeekBar(
                              duration: positionData?.duration ?? Duration.zero,
                              position: positionData?.position ?? Duration.zero,
                              bufferedPosition:
                                  positionData?.bufferedPosition ??
                                      Duration.zero,
                              onChangeEnd: audioController.textAudioPlayer.seek,
                            );
                          },
                        ),
                      ),
                      Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8))),
                        child: IconButton(
                          icon: Icon(Icons.person_search_outlined,
                              size: 20, color: Theme.of(context).canvasColor),
                          onPressed: () => readerDropDown(context),
                        ),
                      ),
                    ],
                  );
                }),
              )),
        ),
      ),
    );
  }
}
