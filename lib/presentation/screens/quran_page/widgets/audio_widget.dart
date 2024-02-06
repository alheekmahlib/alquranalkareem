import 'package:alquranalkareem/core/utils/constants/extensions.dart';
import 'package:alquranalkareem/presentation/controllers/quran_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

import '../../../../core/services/services_locator.dart';
import '../../../../core/widgets/playList/ayahs_playList_widget.dart';
import '../../../../core/widgets/seek_bar.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../controllers/audio_controller.dart';
import '/core/utils/constants/svg_picture.dart';
import 'change_reader.dart';
import 'play_ayah_widget.dart';
import 'play_page_widget.dart';

class AudioWidget extends StatelessWidget {
  AudioWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final quranCtrl = sl<QuranController>();
    return Obx(() => AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        height: quranCtrl.isPlayExpanded.value ? 134 : 50,
        width: quranCtrl.isPlayExpanded.value ? 350 : 250,
        margin: const EdgeInsets.only(bottom: 64.0, right: 32.0, left: 32.0),
        decoration: BoxDecoration(
            color: Get.theme.colorScheme.background,
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            border: Border.all(width: 1, color: Get.theme.hintColor)),
        child: Obx(() => AnimatedCrossFade(
              duration: const Duration(milliseconds: 600),
              firstChild: SizedBox(
                height: 134,
                width: 350,
                child: Stack(
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
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 24.0),
                      child: Column(
                        children: [
                          Expanded(
                            flex: 5,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                context.customClose(
                                  height: 20,
                                  close: () =>
                                      quranCtrl.isPlayExpanded.value = false,
                                ),
                                const ChangeReader(),
                                const PlayPage(),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const PlayAyah(),
                                Expanded(
                                  flex: 8,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Container(
                                        height: 40,
                                        // width: 250,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 4),
                                        decoration: BoxDecoration(
                                            color: Get.theme.colorScheme.primary
                                                .withOpacity(.15),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(8))),
                                      ),
                                      StreamBuilder<PlayerState>(
                                          stream: sl<AudioController>()
                                              .audioPlayer
                                              .playerStateStream,
                                          builder: (context, snapshot) {
                                            return Container(
                                              height: 50,
                                              alignment: Alignment.center,
                                              width: 250,
                                              child:
                                                  StreamBuilder<PositionData>(
                                                stream: sl<AudioController>()
                                                    .positionDataStream,
                                                builder: (context, snapshot) {
                                                  if (snapshot.hasData) {
                                                    final positionData =
                                                        snapshot.data;
                                                    return SeekBar(
                                                      // timeShow: true,
                                                      // padding: 26.0,
                                                      duration: positionData
                                                              ?.duration ??
                                                          Duration.zero,
                                                      position: positionData
                                                              ?.position ??
                                                          Duration.zero,
                                                      bufferedPosition: positionData
                                                              ?.bufferedPosition ??
                                                          Duration.zero,
                                                      activeTrackColor: Get
                                                          .theme
                                                          .colorScheme
                                                          .surface,
                                                      // textColor: Get.theme.dividerColor,
                                                      onChangeEnd:
                                                          sl<AudioController>()
                                                              .audioPlayer
                                                              .seek,
                                                    );
                                                  }
                                                  return const SizedBox
                                                      .shrink();
                                                },
                                              ),
                                            );
                                          }),
                                    ],
                                  ),
                                ),
                                Container(
                                    width: 40,
                                    height: 40,
                                    child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          IconButton(
                                            icon: Semantics(
                                              button: true,
                                              enabled: true,
                                              label: 'Playlist',
                                              child: const Icon(
                                                Icons.playlist_add,
                                                size: 25,
                                              ),
                                            ),
                                            color:
                                                Get.theme.colorScheme.primary,
                                            onPressed: () {
                                              fullModalBottomSheet(
                                                  context,
                                                  MediaQuery.sizeOf(context)
                                                          .height /
                                                      1 /
                                                      2,
                                                  MediaQuery.sizeOf(context)
                                                      .width,
                                                  AyahsPlayListWidget());
                                            },
                                          ),
                                        ]))
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              secondChild: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    PlayAyah(),
                    PlayPage(),
                  ],
                ),
              ),
              crossFadeState: quranCtrl.isPlayExpanded.value
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
            ))));
  }
}
