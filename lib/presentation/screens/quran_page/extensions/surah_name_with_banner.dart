part of '../quran.dart';

extension CustomSurahNameWithBannerExtension on Widget {
  Widget surahNameWidget(String num, Color color,
      {double? height, double? width}) {
    return SvgPicture.asset(
      'assets/svg/surah_name/00$num.svg',
      height: height ?? 30,
      width: width,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  }

  // Widget bannerWithSurahName(Widget child, String number) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 8.0),
  //     child: Stack(
  //       alignment: Alignment.center,
  //       children: [
  //         child,
  //         SizedBox(
  //             height: Get.height * .2,
  //             width: Get.height * .8,
  //             child: surahNameWidget(number, Get.theme.hintColor)),
  //       ],
  //     ),
  //   );
  // }

  Widget bannerAyahWithSurahName(Widget child, String number) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          child,
          SizedBox(
              height: Get.height * .03,
              width: Get.height * .8,
              child: surahNameWidget(number, Get.theme.hintColor)),
        ],
      ),
    );
  }

  // Widget surahBannerWidget(String number) {
  //   return bannerWithSurahName(
  //       customSvg(quranCtrl.surahBannerPath,
  //           width: Get.width * .75, height: Get.height * .19),
  //       number);
  // }

  Widget surahAyahBannerWidget(String number) {
    return bannerAyahWithSurahName(
        customSvg(quranCtrl.surahBannerPath,
            width: Get.width * .35, height: Get.height * .19),
        number);
  }

  Widget surahAyahBannerFirstPlace(int pageIndex, int i) {
    final ayahs = QuranLibrary()
        .quranCtrl
        .getCurrentPageAyahsSeparatedForBasmalah(pageIndex)[i];
    return ayahs.first.ayahNumber == 1
        ? GestureDetector(
            onTap: () => QuranLibrary().getSurahInfoDialog(
                context: Get.context!,
                surahNumber: QuranLibrary()
                    .getCurrentSurahDataByPageNumber(pageNumber: pageIndex)
                    .surahNumber,
                languageCode: Get.locale!.languageCode,
                surahInfoStyle: SurahInfoStyle(
                  ayahCount: 'aya_count'.tr,
                  backgroundColor: Get.theme.colorScheme.primaryContainer,
                  closeIconColor: Get.theme.colorScheme.inversePrimary,
                  firstTabText: 'surahNames'.tr,
                  secondTabText: 'aboutSurah'.tr,
                  indicatorColor: Get.theme.colorScheme.surface,
                  primaryColor:
                      Get.theme.colorScheme.surface.withValues(alpha: .2),
                  surahNameColor: Get.theme.colorScheme.primary,
                  surahNumberColor: Get.theme.hintColor,
                  textColor: Get.theme.colorScheme.inversePrimary,
                  titleColor: Get.theme.colorScheme.primary,
                )),
            child: Container(
                margin: const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                    color: Get.theme.colorScheme.surface.withValues(alpha: .4),
                    borderRadius: const BorderRadius.all(Radius.circular(8))),
                width: double.infinity,
                child: Column(
                  children: [
                    surahAyahBannerWidget(quranCtrl
                        .getSurahDataByAyah(ayahs.first)
                        .surahNumber
                        .toString()),
                    quranCtrl.getSurahDataByAyah(ayahs.first).surahNumber ==
                                9 ||
                            quranCtrl
                                    .getSurahDataByAyah(ayahs.first)
                                    .surahNumber ==
                                1
                        ? const SizedBox.shrink()
                        : ayahs.first.ayahNumber == 1
                            ? (quranCtrl
                                            .getSurahDataByAyah(ayahs.first)
                                            .surahNumber ==
                                        95 ||
                                    quranCtrl
                                            .getSurahDataByAyah(ayahs.first)
                                            .surahNumber ==
                                        97)
                                ? customSvgWithColor(SvgPath.svgBesmAllah2,
                                    width: generalCtrl.ifBigScreenSize(
                                        100.0.w, 150.0.w),
                                    color: Get.theme.cardColor
                                        .withValues(alpha: .8))
                                : customSvgWithColor(SvgPath.svgBesmAllah,
                                    width: generalCtrl.ifBigScreenSize(
                                        100.0.w, 150.0.w),
                                    color: Get.theme.cardColor
                                        .withValues(alpha: .8))
                            : const SizedBox.shrink(),
                    const Gap(6),
                  ],
                )),
          )
        : const SizedBox.shrink();
  }

  // Widget surahBannerLastPlace(int pageIndex, int i) {
  //   final ayahs =
  //       quranCtrl.getCurrentPageAyahsSeparatedForBasmalah(pageIndex)[i];
  //   Surah surah = quranCtrl.getSurahDataByAyah(ayahs.first);
  //   return GestureDetector(
  //     onTap: () => Get.dialog(surahInfoWidget(pageIndex, i, 1)),
  //     child: quranCtrl.downThePageIndex.contains(pageIndex)
  //         ? SizedBox(
  //             height: quranCtrl.textScale(Get.height * .2, 60.0),
  //             child: surahBannerWidget((surah.surahNumber + 1).toString()))
  //         : const SizedBox.shrink(),
  //   );
  // }

  // Widget surahBannerFirstPlace(int pageIndex, int i) {
  //   final ayahs =
  //       quranCtrl.getCurrentPageAyahsSeparatedForBasmalah(pageIndex)[i];
  //   Surah surah = quranCtrl.getSurahDataByAyah(ayahs.first);
  //   return GestureDetector(
  //     onTap: () => Get.dialog(surahInfoWidget(pageIndex, i, 0)),
  //     child: ayahs.first.ayahNumber == 1
  //         ? quranCtrl.topOfThePageIndex.contains(pageIndex)
  //             ? const SizedBox.shrink()
  //             : SizedBox(
  //                 height: quranCtrl.textScale(Get.height * .2, 57.0),
  //                 child: surahBannerWidget(surah.surahNumber.toString()))
  //         : const SizedBox.shrink(),
  //   );
  // }
}
