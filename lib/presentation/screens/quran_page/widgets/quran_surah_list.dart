part of '../quran.dart';

class QuranSurahList extends StatelessWidget {
  QuranSurahList({super.key});
  final quranCtrl = QuranController.instance;

  @override
  Widget build(BuildContext context) {
    // تمرير إلى السورة الحالية عند فتح القائمة
    quranCtrl.scrollToCurrentSurah();
    final currentIndex = quranCtrl.currentSurahIndex;

    return CupertinoScrollbar(
      controller: quranCtrl.surahController,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
        ),
        child: ListView.builder(
          padding: EdgeInsets.zero,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: quranCtrl.state.surahs.length,
          controller: quranCtrl.surahController,
          itemBuilder: (_, index) {
            final surah = quranCtrl.state.surahs[index];
            return Container(
              height: 73,
              width: Get.width,
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 8.0,
              ),
              margin: const EdgeInsets.symmetric(vertical: 4.0),
              decoration: BoxDecoration(
                color: context.theme.primaryColorLight.withValues(
                  alpha: currentIndex == index ? 0.3 : 0.1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: InkWell(
                onTap: () {
                  quranCtrl.changeSurahListOnTap(surah.ayahs.first.page);
                  quranCtrl.state.navBarController.close();
                },
                child: GetBuilder<QuranController>(
                  builder: (quranCtrl) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            RepaintBoundary(
                              child: customSvg(
                                height: 64,
                                width: 64,
                                SvgPath.svgQuranSurahNumberZakhrafa,
                              ),
                            ),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0,
                                ),
                                child: Text(
                                  '${surah.surahNumber}'
                                      .convertNumbersToCurrentLang(),
                                  style: AppTextStyles.titleMedium(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Gap(12),
                        Expanded(
                          flex: 5,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                RepaintBoundary(
                                  child: customSvgWithColor(
                                    'assets/svg/surah_name/00${index + 1}.svg',
                                    color: Theme.of(context).hintColor,
                                    width: 90,
                                  ),
                                ),
                                Text(
                                  surah.englishName,
                                  style: AppTextStyles.titleSmall(
                                    color: context.theme.primaryColorDark,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Gap(12),
                        Expanded(
                          flex: 3,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Column(
                              children: [
                                // context.vDivider(height: 30.0),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0,
                                    vertical: 6.0,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primaryContainer,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'pages'.tr + ':',
                                        style: AppTextStyles.titleSmall(
                                          color: context.theme.primaryColorDark,
                                        ),
                                      ),
                                      const Gap(4),
                                      Text(
                                        '${surah.ayahs.first.page}'
                                            .convertNumbersToCurrentLang(),
                                        style: AppTextStyles.titleSmall(),
                                      ),
                                    ],
                                  ),
                                ),
                                const Gap(6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0,
                                    vertical: 6.0,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primaryContainer,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'aya_count'.tr + ':',
                                        style: AppTextStyles.titleSmall(
                                          color: context.theme.primaryColorDark,
                                        ),
                                      ),
                                      const Gap(4),
                                      Text(
                                        '${surah.ayahs.last.ayahNumber}'
                                            .convertNumbersToCurrentLang(),
                                        style: AppTextStyles.titleSmall(),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
