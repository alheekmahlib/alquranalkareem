part of '../surah_audio.dart';

class SurahAudioList extends StatelessWidget {
  SurahAudioList({super.key});

  final QuranController quranCtrl = QuranController.instance;
  final surahAudioCtrl = AudioCtrl.instance;

  @override
  Widget build(BuildContext context) {
    // إزالة إعادة التهيئة هنا
    // surahAudioCtrl.state.surahListController = ItemScrollController();

    return Container(
      margin: const EdgeInsets.only(
        bottom: 110.0,
        right: 16.0,
        left: 16.0,
        top: 16.0,
      ),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        border: Border.all(
          width: 1,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        addAutomaticKeepAlives: true,
        itemCount: quranCtrl.state.surahs.length,
        controller: surahAudioCtrl.state.surahListController,
        // initialScrollIndex:
        //     surahAudioCtrl.state.surahNum.value - 1, // تعيين الفهرس الأولي
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.zero,
        itemBuilder: (_, index) {
          final surah = quranCtrl.state.surahs[index];

          return Obx(
            () => Column(
              children: [
                GestureDetector(
                  child: Container(
                    height: 70,
                    decoration: BoxDecoration(
                      color: surahAudioCtrl.isSelectedSurahIndex(index).value
                          ? Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: .15)
                          : Colors.transparent,
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Align(
                              alignment: AlignmentDirectional.centerStart,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: RepaintBoundary(
                                      child: customSvgWithCustomColor(
                                        'assets/svg/sora_num.svg',
                                      ),
                                    ),
                                  ),
                                  Transform.translate(
                                    offset: const Offset(0, 1),
                                    child: Text(
                                      surah.surahNumber
                                          .toString()
                                          .convertNumbers(),
                                      style: TextStyle(
                                        color: Theme.of(context).hintColor,
                                        fontFamily: "kufi",
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        height: 2,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 8,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                RepaintBoundary(
                                  child: customSvgWithColor(
                                    'assets/svg/surah_name/00${index + 1}.svg',
                                    width: 100,
                                    color: context
                                        .theme
                                        .colorScheme
                                        .inversePrimary,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Text(
                                    surah.englishName,
                                    style: TextStyle(
                                      fontFamily: "naskh",
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.surface,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (surahAudioCtrl
                                  .isSelectedSurahIndex(index)
                                  .value &&
                              surahAudioCtrl.state.isPlaying.value)
                            MiniMusicVisualizer(
                              color: Theme.of(context).colorScheme.surface,
                              width: 4,
                              height: 15,
                              animate: true,
                            ),
                          const Gap(8.0),
                          SurahDownloadPlayButton(
                            surahNumber: index + 1,
                            style: SurahAudioStyle.defaults(
                              isDark: themeCtrl.isDarkMode,
                              context: context,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  onTap: () async {
                    print('Surah tapped with index: $index');
                    await surahAudioCtrl.selectSurahFromList(
                      context,
                      index,
                      autoPlay: true,
                    );
                  },
                ),
                context.hDivider(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: .2),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
