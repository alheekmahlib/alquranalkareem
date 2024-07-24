import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/svg_extensions.dart';
import '/presentation/controllers/general/extensions/general_ui.dart';
import '/presentation/controllers/theme_controller.dart';
import '/presentation/screens/quran_page/controllers/extensions/quran_getters.dart';
import '../../../../presentation/controllers/general/general_controller.dart';
import '../../../../presentation/screens/quran_page/controllers/quran/quran_controller.dart';
import '../../../services/services_locator.dart';
import '../svg_constants.dart';

final themeCtrl = ThemeController.instance;
final quranCtrl = QuranController.instance;

extension BookmarkPageIconPath on BuildContext {
  String bookmarkPageIconPath() {
    if (themeCtrl.isBlueMode) {
      return 'assets/svg/bookmark.svg';
    } else if (themeCtrl.isBrownMode) {
      return 'assets/svg/bookmark2.svg';
    } else if (themeCtrl.isOldMode) {
      return 'assets/svg/bookmark3.svg';
    } else {
      return 'assets/svg/bookmark.svg';
    }
  }
}

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

  Widget bannerWithSurahName(Widget child, String number) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          child,
          SizedBox(
              height: Get.height * .2,
              width: Get.height * .8,
              child: surahNameWidget(number, Get.theme.hintColor)),
        ],
      ),
    );
  }

  String get surahBannerPath {
    if (themeCtrl.isBlueMode) {
      return SvgPath.svgSurahBanner1;
    } else if (themeCtrl.isBrownMode) {
      return SvgPath.svgSurahBanner2;
    } else if (themeCtrl.isOldMode) {
      return SvgPath.svgSurahBanner4;
    } else {
      return SvgPath.svgSurahBanner3;
    }
  }

  Widget surahBannerWidget(String number) {
    return bannerWithSurahName(
        customSvg(surahBannerPath,
            width: Get.width * .75, height: Get.height * .19),
        number);
  }

  Widget surahAyahBannerWidget(String number) {
    if (themeCtrl.isBlueMode) {
      return bannerWithSurahName(
          customSvg(SvgPath.svgSurahBannerAyah1), number);
    } else if (themeCtrl.isBrownMode) {
      return bannerWithSurahName(
          customSvg(SvgPath.svgSurahBannerAyah2), number);
    } else if (themeCtrl.isOldMode) {
      return bannerWithSurahName(customSvg(SvgPath.svgSurahBanner4), number);
    } else {
      return bannerWithSurahName(customSvg(SvgPath.svgSurahBanner3), number);
    }
  }

  Widget surahAyahBannerFirstPlace(int pageIndex, int i) {
    final ayahs =
        quranCtrl.getCurrentPageAyahsSeparatedForBasmalah(pageIndex)[i];
    return ayahs.first.ayahNumber == 1
        ? Container(
            margin: const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
                color: Get.theme.colorScheme.surface.withOpacity(.4),
                borderRadius: const BorderRadius.all(Radius.circular(8))),
            width: double.infinity,
            child: Column(
              children: [
                surahAyahBannerWidget(quranCtrl
                    .getSurahNumberByAyah(ayahs.first)
                    .surahNumber
                    .toString()),
                quranCtrl.getSurahNumberByAyah(ayahs.first).surahNumber == 9 ||
                        quranCtrl
                                .getSurahNumberByAyah(ayahs.first)
                                .surahNumber ==
                            1
                    ? const SizedBox.shrink()
                    : ayahs.first.ayahNumber == 1
                        ? (quranCtrl
                                        .getSurahNumberByAyah(ayahs.first)
                                        .surahNumber ==
                                    95 ||
                                quranCtrl
                                        .getSurahNumberByAyah(ayahs.first)
                                        .surahNumber ==
                                    97)
                            ? customSvgWithColor(SvgPath.svgBesmAllah2,
                                width: sl<GeneralController>()
                                    .ifBigScreenSize(100.0.w, 150.0.w),
                                color: Get.theme.cardColor.withOpacity(.8))
                            : customSvgWithColor(SvgPath.svgBesmAllah,
                                width: sl<GeneralController>()
                                    .ifBigScreenSize(100.0.w, 150.0.w),
                                color: Get.theme.cardColor.withOpacity(.8))
                        : const SizedBox.shrink(),
                const Gap(6),
              ],
            ))
        : const SizedBox.shrink();
  }

  Widget surahBannerLastPlace(int pageIndex, int i) {
    final ayahs =
        quranCtrl.getCurrentPageAyahsSeparatedForBasmalah(pageIndex)[i];
    return quranCtrl.downThePageIndex.contains(pageIndex)
        ? surahBannerWidget(
            (quranCtrl.getSurahNumberByAyah(ayahs.first).surahNumber + 1)
                .toString())
        : const SizedBox.shrink();
  }

  Widget surahBannerFirstPlace(int pageIndex, int i) {
    final ayahs =
        quranCtrl.getCurrentPageAyahsSeparatedForBasmalah(pageIndex)[i];
    return ayahs.first.ayahNumber == 1
        ? quranCtrl.topOfThePageIndex.contains(pageIndex)
            ? const SizedBox.shrink()
            : surahBannerWidget(quranCtrl
                .getSurahNumberByAyah(ayahs.first)
                .surahNumber
                .toString())
        : const SizedBox.shrink();
  }
}
