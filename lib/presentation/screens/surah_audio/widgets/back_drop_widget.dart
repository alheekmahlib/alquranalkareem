part of '../surah_audio.dart';

class BackDropWidget extends StatelessWidget {
  BackDropWidget({super.key});

  // final surahCtrl = AudioCtrl.instance;

  @override
  Widget build(BuildContext context) {
    return context.customOrientation(
      Column(
        children: [
          const Gap(80),
          SizedBox(
            height: 150,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: customLottieWithColor(
                    LottieConstants.assetsLottieQuranAuIc,
                    height: 120,
                    isRepeat: false,
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Obx(
                    () => AudioCtrl.instance.state.isPlaying.value == true
                        ? const PlayBanner()
                        : const SizedBox.shrink(),
                  ),
                ),
              ],
            ),
          ),
          LastListen(),
          const Gap(4),
          Container(
            height: 8,
            width: Get.width,
            margin: const EdgeInsets.symmetric(horizontal: 62.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Theme.of(context).primaryColorLight,
            ),
          ),
          Flexible(
            child: QuranSurahList(
              marginBottom: 110.0,
              onTap: (index) async {
                print('Surah tapped with index: $index');
                await AudioCtrl.instance.selectSurahFromList(
                  context,
                  index,
                  autoPlay: true,
                );
              },
              leadingChild: (context, index) => SurahDownloadButton(
                surahNumber: index + 1,
                style: SurahAudioStyle.defaults(
                  isDark: themeCtrl.isDarkMode,
                  context: context,
                ),
              ),
              isSelected: (i) =>
                  AudioCtrl.instance.isSelectedSurahIndex(i).value,
              controller: AudioCtrl.instance.state.surahListController,
            ),
          ),
        ],
      ),
      Row(
        children: [
          Expanded(
            flex: 4,
            child: QuranSurahList(
              marginBottom: 110.0,
              onTap: (index) async {
                print('Surah tapped with index: $index');
                await AudioCtrl.instance.selectSurahFromList(
                  context,
                  index,
                  autoPlay: true,
                );
              },
              leadingChild: (context, index) => SurahDownloadButton(
                surahNumber: index + 1,
                style: SurahAudioStyle.defaults(
                  isDark: themeCtrl.isDarkMode,
                  context: context,
                ),
              ),
              isSelected: (i) =>
                  AudioCtrl.instance.isSelectedSurahIndex(i).value,
              controller: AudioCtrl.instance.state.surahListController,
            ),
          ),
          Expanded(
            flex: 4,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      const Gap(80),
                      LastListen(),
                      customLottieWithColor(
                        LottieConstants.assetsLottieQuranAuIc,
                        height: 120,
                        isRepeat: false,
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Obx(
                    () => AudioCtrl.instance.state.isPlaying.value == true
                        ? const PlayBanner()
                        : const SizedBox.shrink(),
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
