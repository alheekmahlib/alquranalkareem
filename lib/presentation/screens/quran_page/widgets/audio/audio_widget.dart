part of '../../quran.dart';

class AudioWidget extends StatelessWidget {
  AudioWidget({Key? key}) : super(key: key);
  final quranCtrl = QuranController.instance;
  final audioCtrl = AudioController.instance;
  final generalCtrl = GeneralController.instance;

  @override
  Widget build(BuildContext context) {
    return Directionality(
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
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(.15))
              ]),
          child: Obx(() => AnimatedCrossFade(
                duration: const Duration(milliseconds: 200),
                firstChild: SizedBox(
                  height: 50,
                  width: generalCtrl.screenWidth(
                      MediaQuery.sizeOf(context).width * .64, 290),
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
                            child: customSvg(
                              SvgPath.svgPlaylist,
                              height: 25,
                            ),
                          ),
                          onTap: () {
                            Get.bottomSheet(AyahsPlayListWidget(),
                                isScrollControlled: true);
                          },
                        )),
                      ],
                    ),
                  ),
                ),
                secondChild: GetBuilder<AudioController>(
                    id: 'audio_seekBar_id',
                    builder: (c) {
                      return SizedBox(
                          height: 155,
                          width: generalCtrl.screenWidth(
                              MediaQuery.sizeOf(context).width * .64, 290),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Gap(11),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    context.customArrowDown(
                                      height: 26,
                                      isBorder: false,
                                      close: () => quranCtrl
                                          .state.isPlayExpanded.value = false,
                                    ),
                                    const ChangeReader(),
                                    GestureDetector(
                                      child: Semantics(
                                        button: true,
                                        enabled: true,
                                        label: 'Playlist',
                                        child: customSvg(
                                          SvgPath.svgPlaylist,
                                          height: 25,
                                        ),
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
                                  height: 67,
                                  alignment: Alignment.center,
                                  // width: 250,
                                  child: c.state.downloading.value
                                      ? GetX<AudioController>(builder: (c) {
                                          final data = c.state
                                              .tmpDownloadedAyahsCount.value;
                                          debugPrint(
                                              '$data => REBUILDING  ${audioCtrl.state.tmpDownloadedAyahsCount}');
                                          return SliderWidget.downloading(
                                              currentPosition: data,
                                              filesCount: audioCtrl
                                                  .selectedSurahAyahsFileNames
                                                  .length,
                                              horizontalPadding: 0);
                                        })
                                      : StreamBuilder<PositionData>(
                                          stream: audioCtrl.positionDataStream,
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              final positionData =
                                                  snapshot.data;
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
                                                activeTrackColor:
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                onChangeEnd: AudioController
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
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SkipToPrevious(),
                                    const PlayAyah(),
                                    SkipToNext(),
                                  ],
                                ),
                              ),
                            ],
                          ));
                    }),
                crossFadeState: quranCtrl.state.isPlayExpanded.value
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
              ))),
    );
  }
}
