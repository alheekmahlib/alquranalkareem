part of '../../quran.dart';

class AyahsBuild extends StatelessWidget {
  final int pageIndex;
  AyahsBuild({super.key, required this.pageIndex});

  final quranCtrl = QuranController.instance;

  @override
  Widget build(BuildContext context) {
    sl<TranslateDataController>().loadTranslateValue();
    QuranLibrary().getFontsPrepareMethod(pageIndex: pageIndex);
    return ListView.builder(
        // primary: false,
        shrinkWrap: true,
        controller: quranCtrl.state.ayahsScrollController,
        itemCount: QuranLibrary()
            .quranCtrl
            .getCurrentPageAyahsSeparatedForBasmalah(pageIndex)
            .length,
        itemBuilder: (context, i) {
          return QuranLibrary().currentFontsSelected == 0
              ? _regularAyahsBuild(context, pageIndex, i)
              : _fontsAyahsBuild(context, pageIndex, i);
        });
  }

  Widget _regularAyahsBuild(BuildContext context, int pageIndex, int i) {
    final ayahs = QuranLibrary()
        .quranCtrl
        .getCurrentPageAyahsSeparatedForBasmalah(pageIndex)[i];
    return Column(children: [
      surahAyahBannerFirstPlace(pageIndex, i),
      Obx(() {
        return Column(
            children: List.generate(ayahs.length, (ayahIndex) {
          quranCtrl.state.isSelected = quranCtrl.state.selectedAyahIndexes
              .contains(ayahs[ayahIndex].ayahUQNumber);
          return MeasureSizeWidget(
            onChange: (size) {
              quranCtrl.state.ayahsWidgetHeight.value = size.height;
              // print("Item $ayahIndex size: ${size.height}");
            },
            child: Container(
              key: ValueKey(i),
              child: GestureDetector(
                onLongPress: () => quranCtrl
                    .toggleAyahSelection(ayahs[ayahIndex].ayahUQNumber),
                child: Column(
                  children: [
                    const Gap(16),
                    AyahsMenu(
                      surahNum: quranCtrl
                          .getSurahDataByAyahUQ(ayahs[ayahIndex].ayahUQNumber)
                          .surahNumber,
                      ayahNum: ayahs[ayahIndex].ayahNumber,
                      ayahText: ayahs[ayahIndex].text,
                      pageIndex: pageIndex,
                      ayahTextNormal: ayahs[ayahIndex].text,
                      ayahUQNum: ayahs[ayahIndex].ayahUQNumber,
                      surahName: quranCtrl.state.surahs
                          .firstWhere((s) => s.ayahs.contains(ayahs[ayahIndex]))
                          .arabicName,
                      isSelected: quranCtrl.state.isSelected,
                      index: ayahIndex,
                    ),
                    const Gap(16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Obx(
                        () => RichText(
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.center,
                          text: TextSpan(
                              style: TextStyle(
                                fontFamily: 'uthmanic2',
                                fontSize: sl<GeneralController>()
                                    .state
                                    .fontSizeArabic
                                    .value,
                                height: 2,
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                              ),
                              children: [
                                ayahIndex == 0
                                    ? span(
                                        isFirstAyah: true,
                                        text:
                                            "${ayahs[ayahIndex].text[0].replaceAll('\n', '')}${ayahs[ayahIndex].text.substring(1).replaceAll('\n', '')}",
                                        pageIndex: pageIndex,
                                        isSelected: quranCtrl.state.isSelected,
                                        fontSize: sl<GeneralController>()
                                            .state
                                            .fontSizeArabic
                                            .value,
                                        surahNum: quranCtrl
                                            .getSurahDataByAyahUQ(
                                                ayahs[ayahIndex].ayahUQNumber)
                                            .surahNumber,
                                        ayahNum: ayahs[ayahIndex].ayahUQNumber,
                                      )
                                    : span(
                                        isFirstAyah: false,
                                        text: ayahs[ayahIndex]
                                            .text
                                            .replaceAll('\n', ''),
                                        pageIndex: pageIndex,
                                        isSelected: quranCtrl.state.isSelected,
                                        fontSize: sl<GeneralController>()
                                            .state
                                            .fontSizeArabic
                                            .value,
                                        surahNum: quranCtrl
                                            .getSurahDataByAyahUQ(
                                                ayahs[ayahIndex].ayahUQNumber)
                                            .surahNumber,
                                        ayahNum: ayahs[ayahIndex].ayahUQNumber,
                                      ),
                              ]),
                        ),
                      ),
                    ),
                    const Gap(16),
                    TranslateBuild(
                      ayahs: ayahs,
                      ayahIndex: ayahIndex,
                    ),
                  ],
                ),
              ),
            ),
          );
        }));
      }),
      const Gap(32),
      Align(
        alignment: Alignment.centerLeft,
        child: Container(
          height: 25,
          width: 50,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(4),
                bottomLeft: Radius.circular(8),
              )),
          child: Text(
            '${ayahs[i].page.toString().convertNumbers()}',
            style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).colorScheme.primaryContainer,
                fontFamily: 'naskh'),
          ),
        ),
      ),
    ]);
  }

  Widget _fontsAyahsBuild(BuildContext context, int pageIndex, int i) {
    final ayahs =
        QuranLibrary().getPageAyahsByPageNumber(pageNumber: pageIndex);
    return Column(children: [
      surahAyahBannerFirstPlace(pageIndex, i),
      Obx(() {
        return Column(
            children: List.generate(ayahs.length, (ayahIndex) {
          quranCtrl.state.isSelected = quranCtrl.state.selectedAyahIndexes
              .contains(ayahs[ayahIndex].ayahUQNumber);
          return MeasureSizeWidget(
            onChange: (size) {
              quranCtrl.state.ayahsWidgetHeight.value = size.height;
              // print("Item $ayahIndex size: ${size.height}");
            },
            child: Container(
              key: ValueKey(i),
              child: GestureDetector(
                onLongPress: () => quranCtrl
                    .toggleAyahSelection(ayahs[ayahIndex].ayahUQNumber),
                child: Column(
                  children: [
                    const Gap(16),
                    AyahsMenu(
                      surahNum: quranCtrl
                          .getSurahDataByAyahUQ(ayahs[ayahIndex].ayahUQNumber)
                          .surahNumber,
                      ayahNum: ayahs[ayahIndex].ayahNumber,
                      ayahText: ayahs[ayahIndex].codeV2,
                      pageIndex: pageIndex,
                      ayahTextNormal: ayahs[ayahIndex].text,
                      ayahUQNum: ayahs[ayahIndex].ayahUQNumber,
                      surahName: quranCtrl.state.surahs
                          .firstWhere((s) => s.ayahs.contains(ayahs[ayahIndex]))
                          .arabicName,
                      isSelected: quranCtrl.state.isSelected,
                      index: ayahIndex,
                    ),
                    const Gap(16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Obx(
                        () => RichText(
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.center,
                          text: TextSpan(
                              style: TextStyle(
                                fontFamily:
                                    QuranLibrary().currentFontsSelected == 0
                                        ? 'uthmanic'
                                        : 'p${pageIndex + 2001}',
                                fontSize: sl<GeneralController>()
                                    .state
                                    .fontSizeArabic
                                    .value,
                                height: 2,
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                              ),
                              children: [
                                ayahIndex == 0
                                    ? span(
                                        isFirstAyah: true,
                                        text:
                                            "${ayahs[ayahIndex].codeV2[0].replaceAll('\n', '')}${ayahs[ayahIndex].codeV2.substring(1).replaceAll('\n', '')}",
                                        pageIndex: pageIndex,
                                        isSelected: quranCtrl.state.isSelected,
                                        fontSize: sl<GeneralController>()
                                            .state
                                            .fontSizeArabic
                                            .value,
                                        surahNum: quranCtrl
                                            .getSurahDataByAyahUQ(
                                                ayahs[ayahIndex].ayahUQNumber)
                                            .surahNumber,
                                        ayahNum: ayahs[ayahIndex].ayahUQNumber,
                                      )
                                    : span(
                                        isFirstAyah: false,
                                        text: ayahs[ayahIndex]
                                            .codeV2
                                            .replaceAll('\n', ''),
                                        pageIndex: pageIndex,
                                        isSelected: quranCtrl.state.isSelected,
                                        fontSize: sl<GeneralController>()
                                            .state
                                            .fontSizeArabic
                                            .value,
                                        surahNum: quranCtrl
                                            .getSurahDataByAyahUQ(
                                                ayahs[ayahIndex].ayahUQNumber)
                                            .surahNumber,
                                        ayahNum: ayahs[ayahIndex].ayahUQNumber,
                                      ),
                              ]),
                        ),
                      ),
                    ),
                    const Gap(16),
                    TranslateBuild(
                      ayahs: ayahs,
                      ayahIndex: ayahIndex,
                    ),
                  ],
                ),
              ),
            ),
          );
        }));
      }),
      const Gap(32),
      Align(
        alignment: Alignment.centerLeft,
        child: Container(
          height: 25,
          width: 50,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(4),
                bottomLeft: Radius.circular(8),
              )),
          child: Text(
            '${ayahs[i].page.toString().convertNumbers()}',
            style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).colorScheme.primaryContainer,
                fontFamily: 'naskh'),
          ),
        ),
      ),
    ]);
  }
}
