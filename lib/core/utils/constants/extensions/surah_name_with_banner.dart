import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../services/services_locator.dart';
import '../svg_picture.dart';
import '/presentation/controllers/quran_controller.dart';
import '/presentation/controllers/theme_controller.dart';

final themeCtrl = sl<ThemeController>();
final quranCtrl = sl<QuranController>();

extension CustomSurahNameWithBannerExtension on BuildContext {
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
              // height: 27.h,
              width: 120.w,
              child: surahNameWidget(number, Get.theme.hintColor)),
        ],
      ),
    );
  }

  Widget surahBannerWidget(String number) {
    if (themeCtrl.isBlueMode) {
      return bannerWithSurahName(surah_banner1(width: Get.width * .8), number);
    } else if (themeCtrl.isBrownMode) {
      return bannerWithSurahName(surah_banner2(width: Get.width * .8), number);
    } else if (themeCtrl.isOldMode) {
      return bannerWithSurahName(surah_banner4(width: Get.width * .8), number);
    } else {
      return bannerWithSurahName(surah_banner3(width: Get.width * .8), number);
    }
  }

  Widget surahAyahBannerWidget(String number) {
    if (themeCtrl.isBlueMode) {
      return bannerWithSurahName(surah_ayah_banner1(), number);
    } else if (themeCtrl.isBrownMode) {
      return bannerWithSurahName(surah_ayah_banner2(), number);
    } else if (themeCtrl.isOldMode) {
      return bannerWithSurahName(surah_ayah_banner4(), number);
    } else {
      return bannerWithSurahName(surah_banner3(), number);
    }
  }

  String bookmarkPageIcon() {
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
                surahAyahBannerWidget(
                    quranCtrl.getSurahNumberByAyah(ayahs.first).toString()),
                quranCtrl.getSurahNumberByAyah(ayahs.first) == 9 ||
                        quranCtrl.getSurahNumberByAyah(ayahs.first) == 1
                    ? const SizedBox.shrink()
                    : ayahs.first.ayahNumber == 1
                        ? (quranCtrl.getSurahNumberByAyah(ayahs.first) == 95 ||
                                quranCtrl.getSurahNumberByAyah(ayahs.first) ==
                                    97)
                            ? besmAllah2()
                            : besmAllah()
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
            (quranCtrl.getSurahNumberByAyah(ayahs.first) + 1).toString())
        : const SizedBox.shrink();
  }

  Widget surahBannerFirstPlace(int pageIndex, int i) {
    final ayahs =
        quranCtrl.getCurrentPageAyahsSeparatedForBasmalah(pageIndex)[i];
    return ayahs.first.ayahNumber == 1
        ? quranCtrl.topOfThePageIndex.contains(pageIndex)
            ? const SizedBox.shrink()
            : surahBannerWidget(
                quranCtrl.getSurahNumberByAyah(ayahs.first).toString())
        : const SizedBox.shrink();
  }
}
