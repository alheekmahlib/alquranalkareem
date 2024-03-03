import 'package:alquranalkareem/core/utils/constants/extensions/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../services/services_locator.dart';
import '../size_config.dart';
import '../svg_picture.dart';
import '/presentation/controllers/quran_controller.dart';
import '/presentation/controllers/theme_controller.dart';

final themeCtrl = sl<ThemeController>();
final quranCtrl = sl<QuranController>();

extension CustomSurahNameWithBannerExtension on BuildContext {
  Widget surahNameWidget(String num, Color color, {double? height}) {
    return SvgPicture.asset(
      'assets/svg/surah_name/00$num.svg',
      height: height ?? 30,
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
          surahNameWidget(number, Get.theme.hintColor,
              height: getProportionateScreenWidth(25.h)),
        ],
      ),
    );
  }

  Widget surahBannerWidget(String number) {
    final customWidth = this.customOrientation(Get.width * .3, Get.width * .15);
    if (themeCtrl.isBlueMode) {
      return bannerWithSurahName(surah_banner1(height: customWidth), number);
    } else if (themeCtrl.isBrownMode) {
      return bannerWithSurahName(surah_banner2(height: customWidth), number);
    } else {
      return bannerWithSurahName(surah_banner3(height: customWidth), number);
    }
  }

  Widget surahAyahBannerWidget(String number) {
    if (themeCtrl.isBlueMode) {
      return bannerWithSurahName(surah_ayah_banner1(), number);
    } else if (themeCtrl.isBrownMode) {
      return bannerWithSurahName(surah_ayah_banner2(), number);
    } else {
      return bannerWithSurahName(surah_banner3(), number);
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
