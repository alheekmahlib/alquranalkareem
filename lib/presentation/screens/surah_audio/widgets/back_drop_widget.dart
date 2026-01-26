part of '../surah_audio.dart';

class BackDropWidget extends StatelessWidget {
  const BackDropWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return context.customOrientation(
      Column(
        children: [
          SizedBox(
            height: 250,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 104.0),
                    child: customLottieWithColor(
                      LottieConstants.assetsLottieQuranAuIc,
                      height: 120,
                      isRepeat: false,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      TabBarWidget(
                        isFirstChild: true,
                        isCenterChild: true,
                        isQuranSetting: false,
                        isNotification: false,
                        centerChild: LastListen(),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 140.0),
                    child: Stack(
                      children: [
                        const Align(
                          alignment: Alignment.topRight,
                          child: SurahSearch(),
                        ),
                        Obx(
                          () => AudioCtrl.instance.state.isPlaying.value == true
                              ? const Align(
                                  alignment: Alignment.topLeft,
                                  child: PlayBanner(),
                                )
                              : const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Flexible(child: SurahAudioList()),
        ],
      ),
      Row(
        children: [
          Expanded(flex: 4, child: SurahAudioList()),
          Expanded(
            flex: 4,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 104.0),
                    child: customLottie(
                      LottieConstants.assetsLottieQuranAuIc,
                      height: 120,
                      isRepeat: false,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      TabBarWidget(
                        isFirstChild: true,
                        isCenterChild: true,
                        isQuranSetting: false,
                        isNotification: false,
                        centerChild: LastListen(),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 140.0),
                    child: Row(
                      children: [
                        Column(
                          children: [
                            const SurahSearch(),
                            Obx(
                              () =>
                                  AudioCtrl.instance.state.isPlaying.value ==
                                      true
                                  ? const Align(
                                      alignment: Alignment.topLeft,
                                      child: PlayBanner(),
                                    )
                                  : const SizedBox.shrink(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
