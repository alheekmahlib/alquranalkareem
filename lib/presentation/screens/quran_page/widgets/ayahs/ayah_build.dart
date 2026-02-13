part of '../../quran.dart';

class AyahsBuild extends StatelessWidget {
  final int pageIndex;
  AyahsBuild({super.key, required this.pageIndex});

  final quranCtrl = QuranController.instance;
  final transCtrl = TafsirAndTranslateController.instance;

  @override
  Widget build(BuildContext context) {
    sl<TafsirAndTranslateController>().loadTranslateValue();
    // final ayahs =
    //     QuranLibrary().getPageAyahsByPageNumber(pageNumber: pageIndex);
    return ListView.builder(
      // primary: false,
      shrinkWrap: true,
      controller: quranCtrl.state.ayahsScrollController,
      itemCount: QuranLibrary.quranCtrl
          .getCurrentPageAyahsSeparatedForBasmalah(pageIndex)
          .length,
      itemBuilder: (context, i) {
        return _fontsAyahsBuild(context, pageIndex, i);
      },
    );
  }

  Widget _fontsAyahsBuild(BuildContext context, int pageIndex, int i) {
    final ayahs = QuranLibrary().getPageAyahsByPageNumber(
      pageNumber: pageIndex + 1,
    );
    return Column(
      children: [
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
                    onLongPress: () => quranCtrl.toggleAyahSelection(
                      ayahs[ayahIndex].ayahUQNumber,
                    ),
                    child: Column(
                      children: [
                        const Gap(16),
                        AyahsMenu(
                          surahNum: QuranLibrary()
                              .getCurrentSurahDataByAyahUniqueNumber(
                                ayahUniqueNumber: ayahs[ayahIndex].ayahUQNumber,
                              )
                              .surahNumber,
                          ayahNum: ayahs[ayahIndex].ayahNumber,
                          ayahText: ayahs[ayahIndex].text,
                          pageIndex: pageIndex,
                          ayahTextNormal: ayahs[ayahIndex].text,
                          ayahUQNum: ayahs[ayahIndex].ayahUQNumber,
                          surahName: quranCtrl.state.surahs
                              .firstWhere(
                                (s) => s.ayahs.contains(ayahs[ayahIndex]),
                              )
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
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.inversePrimary,
                                ),
                                children: [
                                  ayahIndex == 0
                                      ? span(
                                          isFirstAyah: true,
                                          text:
                                              "${ayahs[ayahIndex].text[0].replaceAll('\n', '')}${ayahs[ayahIndex].text.substring(1).replaceAll('\n', '')}",
                                          fontFamily: 'uthmanic2',
                                          pageIndex: pageIndex,
                                          isSelected:
                                              quranCtrl.state.isSelected,
                                          letterSpacing: 0.0,
                                          fontSize: sl<GeneralController>()
                                              .state
                                              .fontSizeArabic
                                              .value,
                                          surahNum: quranCtrl
                                              .getSurahDataByAyahUQ(
                                                ayahs[ayahIndex].ayahUQNumber,
                                              )
                                              .surahNumber,
                                          ayahNum:
                                              ayahs[ayahIndex].ayahUQNumber,
                                        )
                                      : span(
                                          isFirstAyah: false,
                                          text: ayahs[ayahIndex].text
                                              .replaceAll('\n', ''),
                                          fontFamily: 'uthmanic2',
                                          pageIndex: pageIndex,
                                          isSelected:
                                              quranCtrl.state.isSelected,
                                          letterSpacing: 0.0,
                                          fontSize: sl<GeneralController>()
                                              .state
                                              .fontSizeArabic
                                              .value,
                                          surahNum: quranCtrl
                                              .getSurahDataByAyahUQ(
                                                ayahs[ayahIndex].ayahUQNumber,
                                              )
                                              .surahNumber,
                                          ayahNum:
                                              ayahs[ayahIndex].ayahUQNumber,
                                        ),
                                  TextSpan(
                                    text:
                                        ' ' +
                                        ayahs[ayahIndex].ayahNumber
                                            .toString()
                                            .convertEnglishNumbersToArabic(
                                              ayahs[ayahIndex].ayahNumber
                                                  .toString(),
                                            ),
                                    style: TextStyle(
                                      fontFamily: 'uthmanic2',
                                      fontSize:
                                          sl<GeneralController>()
                                              .state
                                              .fontSizeArabic
                                              .value +
                                          3,
                                      height: 2,
                                      color: const Color(0xff77554B),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const Gap(16),
                        TranslateBuild(
                          ayahs: ayahs,
                          ayahIndex: ayahIndex,
                          pageIndex: pageIndex,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          );
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
              ),
            ),
            child: Text(
              '${ayahs[i].page.toString().convertNumbersToCurrentLang()}',
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).colorScheme.primaryContainer,
                fontFamily: 'naskh',
              ),
            ),
          ),
        ),
      ],
    );
  }
}
