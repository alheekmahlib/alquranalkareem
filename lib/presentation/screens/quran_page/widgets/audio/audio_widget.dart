import 'package:alquranalkareem/core/utils/constants/svg_picture.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../../core/services/services_locator.dart';
import '../../../../../core/widgets/playList/ayahs_playList_widget.dart';
import '../../../../../core/widgets/seek_bar.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../../controllers/audio_controller.dart';
import '/core/utils/constants/extensions.dart';
import '/presentation/controllers/quran_controller.dart';
import 'change_reader.dart';
import 'play_ayah_widget.dart';
import 'play_page_widget.dart';

class AudioWidget extends StatelessWidget {
  AudioWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final quranCtrl = sl<QuranController>();
    final audioCtrl = sl<AudioController>();
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
          margin: const EdgeInsets.only(bottom: 96.0, right: 32.0, left: 32.0),
          decoration: BoxDecoration(
              color: Get.theme.colorScheme.background,
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              boxShadow: [
                BoxShadow(
                    offset: const Offset(0, 0),
                    blurRadius: 5,
                    color: Get.theme.colorScheme.primary)
              ]),
          child: Obx(() => AnimatedCrossFade(
                duration: const Duration(milliseconds: 200),
                firstChild: const SizedBox(
                  height: 50,
                  width: 300,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(child: PlayAyah()),
                        Center(
                          child: const ChangeReader(),
                        ),
                        Center(child: PlayPage()),
                      ],
                    ),
                  ),
                ),
                secondChild: SizedBox(
                    height: 150,
                    width: 300,
                    child: Column(
                      children: [
                        const Gap(11),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              context.customClose(
                                height: 20,
                                close: () =>
                                    quranCtrl.isPlayExpanded.value = false,
                              ),
                              GestureDetector(
                                child: Semantics(
                                  button: true,
                                  enabled: true,
                                  label: 'Playlist',
                                  child: playlist(height: 25.0),
                                ),
                                onTap: () {
                                  fullModalBottomSheet(
                                      context,
                                      MediaQuery.sizeOf(context).height / 1 / 2,
                                      MediaQuery.sizeOf(context).width,
                                      AyahsPlayListWidget());
                                },
                              )
                            ],
                          ),
                        ),
                        const Gap(8),
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: Container(
                            height: 61,
                            alignment: Alignment.center,
                            // width: 250,
                            child: StreamBuilder<PositionData>(
                              stream: audioCtrl.isPlay.value
                                  ? audioCtrl.positionDataStream
                                  : audioCtrl.positionPageDataStream,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final positionData = snapshot.data;
                                  return SliderWidget(
                                    horizontalPadding: 0.0,
                                    duration:
                                        positionData?.duration ?? Duration.zero,
                                    position:
                                        positionData?.position ?? Duration.zero,
                                    bufferedPosition:
                                        positionData?.bufferedPosition ??
                                            Duration.zero,
                                    activeTrackColor:
                                        Get.theme.colorScheme.primary,
                                    onChangeEnd:
                                        sl<AudioController>().audioPlayer.seek,
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              PlayAyah(),
                              const ChangeReader(),
                              PlayPage(),
                            ],
                          ),
                        ),
                      ],
                    )),
                crossFadeState: quranCtrl.isPlayExpanded.value
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
              ))),
    );
  }
}
