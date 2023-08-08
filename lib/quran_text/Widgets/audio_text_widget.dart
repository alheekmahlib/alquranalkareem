import 'package:alquranalkareem/shared/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:square_percent_indicater/square_percent_indicater.dart';

import '../../shared/controller/audio_controller.dart';
import '../../shared/widgets/seek_bar.dart';

class AudioTextWidget extends StatefulWidget {
  AudioTextWidget({Key? key}) : super(key: key);

  @override
  State<AudioTextWidget> createState() => _AudioTextWidgetState();
}

class _AudioTextWidgetState extends State<AudioTextWidget>
    with WidgetsBindingObserver {
  final AudioController aCtrl = Get.put(AudioController());

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 80.0),
        child: Container(
          height: 60,
          width: 280,
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
                          borderRadius: 8,
                          shadowWidth: 1.5,
                          progressWidth: 2,
                          shadowColor: Colors.grey,
                          progressColor: aCtrl.downloading.value
                              ? Theme.of(context).canvasColor
                              : Colors.transparent,
                          progress: aCtrl.progress.value,
                          child: aCtrl.downloading.value
                              ? Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    aCtrl.progressString.value,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'kufi',
                                        color: Theme.of(context).canvasColor),
                                  ),
                                )
                              : IconButton(
                                  icon: Icon(
                                    aCtrl.isPlay.value
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                    size: 20,
                                  ),
                                  color: Theme.of(context).canvasColor,
                                  onPressed: () {
                                    print(aCtrl.progressString.value);

                                    aCtrl.textPlayAyah(context);
                                  },
                                ),
                        ),
                      ),
                      Container(
                        height: 50,
                        alignment: Alignment.center,
                        width: 170,
                        child: StreamBuilder<PositionData>(
                          stream: aCtrl.textPositionDataStream,
                          builder: (context, snapshot) {
                            final positionData = snapshot.data;
                            return SeekBar(
                              duration: positionData?.duration ?? Duration.zero,
                              position: positionData?.position ?? Duration.zero,
                              bufferedPosition:
                                  positionData?.bufferedPosition ??
                                      Duration.zero,
                              onChangeEnd: aCtrl.textAudioPlayer.seek,
                            );
                          },
                        ),
                        // child: SliderTheme(
                        //   data: const SliderThemeData(
                        //       thumbShape:
                        //           RoundSliderThumbShape(enabledThumbRadius: 8)),
                        //   child: Slider(
                        //     activeColor: Theme.of(context).colorScheme.background,
                        //     inactiveColor: Theme.of(context).primaryColorDark,
                        //     min: 0,
                        //     max: _duration.value,
                        //     value: _position.value.clamp(0, _duration.value),
                        //     onChanged: (value) {
                        //       audioPlayer.seek(Duration(seconds: value.toInt()));
                        //     },
                        //   ),
                        // ),
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
