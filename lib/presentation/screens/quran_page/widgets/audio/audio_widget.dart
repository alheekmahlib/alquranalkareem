import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../../core/services/services_locator.dart';
import '../../../../../core/widgets/seek_bar.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../../controllers/audio_controller.dart';
import '../playlist/ayahs_playList_widget.dart';
import '/core/utils/constants/extensions.dart';
import '/core/utils/constants/svg_picture.dart';
import '/presentation/controllers/general_controller.dart';
import '/presentation/controllers/quran_controller.dart';
import '/presentation/screens/quran_page/widgets/audio/skip_next.dart';
import '/presentation/screens/quran_page/widgets/audio/skip_previous.dart';
import 'change_reader.dart';
import 'play_ayah_widget.dart';

class AudioWidget extends StatelessWidget {
  AudioWidget({Key? key}) : super(key: key);
  final quranCtrl = sl<QuranController>();
  final audioCtrl = sl<AudioController>();
  final generalCtrl = sl<GeneralController>();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
          margin: const EdgeInsets.only(bottom: 24.0, right: 32.0, left: 32.0),
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
                firstChild: SizedBox(
                  height: 50,
                  width: generalCtrl.screenWidth(
                      290, MediaQuery.sizeOf(context).width * .67),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Center(child: PlayAyah()),
                        const Center(
                          child: ChangeReader(),
                        ),
                        Center(
                            child: GestureDetector(
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
                        )),
                      ],
                    ),
                  ),
                ),
                secondChild: SizedBox(
                    height: 150,
                    width: generalCtrl.screenWidth(
                        290, MediaQuery.sizeOf(context).width * .67),
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
                              const ChangeReader(),
                              GestureDetector(
                                child: Semantics(
                                  button: true,
                                  enabled: true,
                                  label: 'Playlist',
                                  child: playlist(height: 25.0),
                                ),
                                onTap: () {
                                  Get.bottomSheet(AyahsPlayListWidget(),
                                      isScrollControlled: true);
                                },
                              ),
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
                              stream: audioCtrl.positionDataStream,
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
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SkipToPrevious(),
                              const PlayAyah(),
                              SkipToNext(),
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
