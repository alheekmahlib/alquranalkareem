part of '../../quran.dart';

class AudioWidget extends StatelessWidget {
  AudioWidget({Key? key}) : super(key: key);
  final quranCtrl = QuranController.instance;
  final audioCtrl = AudioCtrl.instance;
  final generalCtrl = GeneralController.instance;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        if (details.primaryDelta != null) {
          if (details.primaryDelta! < -8) {
            Future.delayed(
              const Duration(milliseconds: 10),
              () => quranCtrl.state.isPlayExpanded.value = true,
            );
          } else if (details.primaryDelta! > 8) {
            quranCtrl.state.isPlayExpanded.value = false;
          }
        }
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          margin: const EdgeInsets.only(bottom: 24.0, right: 32.0, left: 32.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, -2),
                blurRadius: 3,
                spreadRadius: 3,
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: .15),
              ),
            ],
          ),
          child: Obx(
            () => AnimatedCrossFade(
              duration: const Duration(milliseconds: 200),
              firstChild: SizedBox(
                height: 50,
                width: generalCtrl.screenWidth(
                  MediaQuery.sizeOf(context).width * .64,
                  290,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Center(child: PlayAyah()),
                      Center(
                        child: AyahChangeReader(
                          downloadManagerStyle:
                              audioCtrl.ayahDownloadManagerStyle,
                          style: audioCtrl.ayahAudioStyle,
                          isDark: themeCtrl.isDarkMode,
                        ),
                      ),
                      // Center(
                      //     child: GestureDetector(
                      //   child: Semantics(
                      //     button: true,
                      //     enabled: true,
                      //     label: 'Playlist',
                      //     child: customSvgWithCustomColor(
                      //       SvgPath.svgPlaylist,
                      //       height: 25,
                      //     ),
                      //   ),
                      //   onTap: () {
                      //     Get.bottomSheet(AyahsPlayListWidget(),
                      //         isScrollControlled: true);
                      //   },
                      // )),
                    ],
                  ),
                ),
              ),
              secondChild: GetBuilder<AudioCtrl>(
                id: 'audio_seekBar_id',
                builder: (c) {
                  return SizedBox(
                    height: 155,
                    width: generalCtrl.screenWidth(
                      MediaQuery.sizeOf(context).width * .64,
                      290,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Gap(11),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              context.customArrowDown(
                                height: 26,
                                isBorder: false,
                                close: () =>
                                    quranCtrl.state.isPlayExpanded.value =
                                        false,
                              ),
                              AyahChangeReader(
                                downloadManagerStyle:
                                    audioCtrl.ayahDownloadManagerStyle,
                                style: audioCtrl.ayahAudioStyle,
                                isDark: themeCtrl.isDarkMode,
                              ),
                              // GestureDetector(
                              //   child: Semantics(
                              //     button: true,
                              //     enabled: true,
                              //     label: 'Playlist',
                              //     child: customSvgWithCustomColor(
                              //       SvgPath.svgPlaylist,
                              //       height: 25,
                              //     ),
                              //   ),
                              //   onTap: () {
                              //     Get.bottomSheet(AyahsPlayListWidget(),
                              //         isScrollControlled: true);
                              //   },
                              // ),
                            ],
                          ),
                        ),
                        const Gap(8),
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: Container(
                            height: 67,
                            alignment: Alignment.center,
                            // width: 250,
                            child: Obx(
                              () => c.state.isDownloading.value
                                  ? Obx(() {
                                      log(
                                        'file size: ${audioCtrl.state.fileSize.value} => download progress  ${audioCtrl.state.downloadProgress.value}',
                                      );
                                      return SliderWidget.downloading(
                                        currentPosition:
                                            (audioCtrl
                                                    .state
                                                    .downloadProgress
                                                    .value)
                                                .toInt(),
                                        filesCount:
                                            audioCtrl.state.fileSize.value,
                                        horizontalPadding: 0,
                                      );
                                    })
                                  : StreamBuilder<PackagePositionData>(
                                      stream: audioCtrl.positionDataStream,
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          final positionData = snapshot.data;
                                          return SliderWidget.player(
                                            horizontalPadding: 0.0,
                                            duration:
                                                positionData?.duration ??
                                                Duration.zero,
                                            position:
                                                positionData?.position ??
                                                Duration.zero,
                                            // bufferedPosition:
                                            //     positionData?.bufferedPosition ??
                                            //         Duration.zero,
                                            activeTrackColor: Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                            onChangeEnd: AudioCtrl
                                                .instance
                                                .state
                                                .audioPlayer
                                                .seek,
                                          );
                                        }
                                        return const SizedBox.shrink();
                                      },
                                    ),
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
                    ),
                  );
                },
              ),
              crossFadeState: quranCtrl.state.isPlayExpanded.value
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
            ),
          ),
        ),
      ),
    );
  }
}
