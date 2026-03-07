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
                    color: context.theme.colorScheme.surface,
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
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: Container(
                    height: 45,
                    width: 100,
                    alignment: AlignmentDirectional.centerStart,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: context.theme.primaryColorLight.withValues(
                        alpha: .2,
                      ),
                      borderRadius: const BorderRadiusDirectional.only(
                        topStart: Radius.circular(8),
                        bottomStart: Radius.circular(8),
                      ),
                    ),
                    child: CustomButton(
                      onPressed: () => Get.to(
                        () => const AudioSurahWithAyahs(),
                        transition: Transition.fadeIn,
                        binding: BindingsBuilder(() {
                          Get.put(AudioSurahWithAyahsController());
                        }),
                      ),
                      height: 40,
                      width: 35,
                      isCustomSvgColor: true,
                      svgPath: SvgPath.svgAudioFullAudioScreen,
                      svgColor: context.theme.colorScheme.primary,
                      backgroundColor: context.theme.canvasColor,
                    ),
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
