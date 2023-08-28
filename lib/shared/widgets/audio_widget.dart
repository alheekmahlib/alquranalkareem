import 'package:alquranalkareem/shared/widgets/ayah_list.dart';
import 'package:alquranalkareem/shared/widgets/seek_bar.dart';
import 'package:alquranalkareem/shared/widgets/svg_picture.dart';
import 'package:alquranalkareem/shared/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as getx;
import 'package:just_audio/just_audio.dart';
import 'package:square_percent_indicater/square_percent_indicater.dart';
import 'package:theme_provider/theme_provider.dart';

import '../../l10n/app_localizations.dart';
import 'controllers_put.dart';

class AudioWidget extends StatelessWidget {
  AudioWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 120.0),
        child: Container(
          height: 100,
          width: 320,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface.withOpacity(.94),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  flex: 2,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Center(
                        child: Container(
                          height: 30,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: ThemeProvider.themeOf(context).id == 'dark'
                                  ? const Color(0xffcdba72).withOpacity(.4)
                                  : Theme.of(context)
                                      .dividerColor
                                      .withOpacity(.4),
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(8),
                                topLeft: Radius.circular(8),
                              )),
                        ),
                      ),
                      StreamBuilder<PlayerState>(
                          stream: audioController.audioPlayer.playerStateStream,
                          builder: (context, snapshot) {
                            final playerState = snapshot.data;
                            final processingState =
                                playerState?.processingState;
                            final playing = playerState?.playing;
                            if (processingState == ProcessingState.idle) {
                              return AyahList();
                            } else if (playing == true) {
                              return Container(
                                height: 50,
                                alignment: Alignment.center,
                                width: 290,
                                child: StreamBuilder<PositionData>(
                                  stream: audioController.positionDataStream,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      final positionData = snapshot.data;
                                      return SeekBar(
                                        duration: positionData?.duration ??
                                            Duration.zero,
                                        position: positionData?.position ??
                                            Duration.zero,
                                        bufferedPosition:
                                            positionData?.bufferedPosition ??
                                                Duration.zero,
                                        onChangeEnd:
                                            audioController.audioPlayer.seek,
                                      );
                                    }
                                    return const SizedBox.shrink();
                                  },
                                ),
                              );
                            } else if (playing != true) {
                              return AyahList();
                            } else {
                              return const SizedBox.shrink();
                            }
                          }),
                    ],
                  )),
              Expanded(
                flex: 3,
                child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          spaceLine(
                              50, MediaQuery.of(context).size.width / 1 / 2),
                          getx.Obx(
                            () => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SquarePercentIndicator(
                                  width: 35,
                                  height: 35,
                                  startAngle: StartAngle.topRight,
                                  // reverse: true,
                                  borderRadius: 8,
                                  shadowWidth: 1.5,
                                  progressWidth: 2,
                                  shadowColor: Colors.grey,
                                  progressColor:
                                      audioController.downloading.value
                                          ? Theme.of(context).canvasColor
                                          : Colors.transparent,
                                  progress: audioController.progress.value,
                                  child: Container(
                                    height: 35,
                                    width: 35,
                                    decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surface,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(8))),
                                    child: audioController.downloading.value
                                        ? Container(
                                            alignment: Alignment.center,
                                            child: Text(
                                              audioController
                                                  .progressString.value,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: 'kufi',
                                                  color: Theme.of(context)
                                                      .canvasColor),
                                            ),
                                          )
                                        : getx.Obx(
                                            () => IconButton(
                                              icon: Icon(
                                                audioController.isPlay.value
                                                    ? Icons.pause
                                                    : Icons.play_arrow,
                                                size: 20,
                                              ),
                                              color:
                                                  Theme.of(context).canvasColor,
                                              onPressed: !audioController
                                                      .isPagePlay.value
                                                  ? () {
                                                      print(audioController
                                                          .progressString
                                                          .value);
                                                      if (audioController
                                                              .pageAyahNumber ==
                                                          null) {
                                                        customErrorSnackBar(
                                                            context,
                                                            AppLocalizations.of(
                                                                    context)!
                                                                .choiceAyah);
                                                      } else {
                                                        audioController
                                                            .playAyah(context);
                                                      }
                                                    }
                                                  : null,
                                            ),
                                          ),
                                  ),
                                ),
                                SquarePercentIndicator(
                                  width: 35,
                                  height: 35,
                                  startAngle: StartAngle.topRight,
                                  // reverse: true,
                                  borderRadius: 8,
                                  shadowWidth: 1.5,
                                  progressWidth: 2,
                                  shadowColor: Colors.grey,
                                  progressColor:
                                      audioController.downloadingPage.value
                                          ? Theme.of(context).canvasColor
                                          : Colors.transparent,
                                  progress: audioController.progressPage.value,
                                  child: Container(
                                    height: 35,
                                    width: 35,
                                    decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surface,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(8))),
                                    child: audioController.downloadingPage.value
                                        ? Container(
                                            alignment: Alignment.center,
                                            child: Text(
                                              audioController
                                                  .progressPageString.value,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: 'kufi',
                                                  color: Theme.of(context)
                                                      .canvasColor),
                                            ),
                                          )
                                        : getx.Obx(
                                            () => IconButton(
                                              icon: Icon(
                                                audioController.isPagePlay.value
                                                    ? Icons.pause
                                                    : Icons
                                                        .text_snippet_outlined,
                                                size: 20,
                                              ),
                                              color:
                                                  Theme.of(context).canvasColor,
                                              onPressed:
                                                  !audioController.isPlay.value
                                                      ? () {
                                                          print(audioController
                                                              .progressPageString
                                                              .value);
                                                          audioController.playPage(
                                                              context,
                                                              generalController
                                                                  .cuMPage);
                                                        }
                                                      : null,
                                            ),
                                          ),
                                  ),
                                ),
                                Container(
                                  height: 35,
                                  width: 35,
                                  decoration: BoxDecoration(
                                      color:
                                          Theme.of(context).colorScheme.surface,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(8))),
                                  child: IconButton(
                                    icon: Icon(Icons.person_search_outlined,
                                        size: 20,
                                        color: Theme.of(context).canvasColor),
                                    onPressed: () => readerDropDown(context),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
