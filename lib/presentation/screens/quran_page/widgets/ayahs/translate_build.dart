part of '../../quran.dart';

class TranslateBuild extends StatelessWidget {
  final List<AyahModel> ayahs;
  final int ayahIndex;
  final int pageIndex;

  TranslateBuild(
      {super.key,
      required this.ayahs,
      required this.ayahIndex,
      required this.pageIndex});

  final translateCtrl = TafsirCtrl.instance;
  final transCtrl = TafsirAndTranslateController.instance;

  @override
  Widget build(BuildContext context) {
    transCtrl.expandedMap[ayahs[ayahIndex].ayahUQNumber - 1] =
        transCtrl.expandedMap[ayahs[ayahIndex].ayahUQNumber - 1] ?? false;
    // QuranController.instance.updateTafsir(pageIndex + 1);
    // QuranLibrary().initializeDatabase();
    // QuranLibrary().getTafsirOfPage(pageNumber: ayahs[ayahIndex].page);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: QuranLibrary().changeTafsirPopupMenu(
              TafsirStyle(
                  linesColor: Get.theme.colorScheme.primary,
                  selectedTafsirColor: Get.theme.colorScheme.surface,
                  unSelectedTafsirColor: Get.theme.colorScheme.inversePrimary,
                  translateName: 'translation'.tr),
            ),
          ),
          const Gap(16),
          GetBuilder<TafsirCtrl>(
              id: 'change_tafsir',
              builder: (tafsirCtrl) {
                // if (translateName[translateCtrl.transValue.value] == 'nothing') {
                //   return const SizedBox.shrink();
                // }
                if (translateCtrl.isLoading.value) {
                  return customLottie(LottieConstants.assetsLottieSearch,
                      height: 50.0, width: 50.0);
                }
                final tafsir = QuranLibrary().tafsirList.firstWhere(
                      (element) => element.id == ayahs[ayahIndex].ayahUQNumber,
                      orElse: () => const TafsirTableData(
                        id: 0,
                        tafsirText: '',
                        ayahNum: 0,
                        pageNum: 0,
                        surahNum: 0,
                      ),
                    );
                return QuranLibrary().isTafsir
                    ? ReadMoreLess(
                        text: tafsir.tafsirText.buildTextSpans(),
                        textStyle: TextStyle(
                          fontSize: sl<GeneralController>()
                                  .state
                                  .fontSizeArabic
                                  .value -
                              3,
                          fontFamily:
                              sl<SettingsController>().languageFont.value,
                          color: Theme.of(context).hintColor,
                          overflow: TextOverflow.fade,
                        ),
                        textAlign: TextAlign.justify,
                        animationDuration: const Duration(milliseconds: 300),
                        maxLines: 1,
                        collapsedHeight: 20,
                        readMoreText: 'readMore'.tr,
                        readLessText: 'readLess'.tr,
                        buttonTextStyle: TextStyle(
                          fontSize: 12,
                          fontFamily: 'kufi',
                          color: Theme.of(context).hintColor,
                        ),
                        iconColor: Theme.of(context).hintColor,
                      )
                    : readMore.ReadMoreLess(
                        text: QuranLibrary()
                            .translationList[ayahs[ayahIndex].ayahUQNumber - 1]
                            .text,
                        textStyle: TextStyle(
                          fontSize: sl<GeneralController>()
                                  .state
                                  .fontSizeArabic
                                  .value -
                              3,
                          fontFamily:
                              sl<SettingsController>().languageFont.value,
                          color: Theme.of(context).hintColor,
                          overflow: TextOverflow.fade,
                        ),
                        textAlign: TextAlign.center,
                        animationDuration: const Duration(milliseconds: 300),
                        maxLines: 1,
                        collapsedHeight: 20,
                        readMoreText: 'readMore'.tr,
                        readLessText: 'readLess'.tr,
                        buttonTextStyle: TextStyle(
                          fontSize: 12,
                          fontFamily: 'kufi',
                          color: Theme.of(context).hintColor,
                        ),
                        iconColor: Theme.of(context).hintColor,
                      );
              }),
        ],
      ),
    );
  }
}
