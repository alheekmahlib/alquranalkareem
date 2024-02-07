import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../presentation/controllers/bookmarks_controller.dart';
import '../../../presentation/controllers/general_controller.dart';
import '../../../presentation/controllers/surah_audio_controller.dart';
import '../../services/services_locator.dart';

Widget besmAllah() {
  return SvgPicture.asset(
    'assets/svg/besmAllah.svg',
    width: 250,
    colorFilter:
        ColorFilter.mode(Get.theme.cardColor.withOpacity(.8), BlendMode.srcIn),
  );
}

Widget besmAllah2() {
  return SvgPicture.asset(
    'assets/svg/besmAllah2.svg',
    width: 250,
    colorFilter:
        ColorFilter.mode(Get.theme.cardColor.withOpacity(.8), BlendMode.srcIn),
  );
}

Widget spaceLine(double height, width) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: SvgPicture.asset(
      'assets/svg/space_line.svg',
      height: height,
      width: width,
    ),
  );
}

Widget quranIcon({double? height, double? width}) {
  return SvgPicture.asset(
    'assets/svg/quran_au_ic.svg',
    colorFilter:
        ColorFilter.mode(Get.theme.colorScheme.surface, BlendMode.srcIn),
    width: width,
    height: height,
  );
}

Widget bookmarkIcon(BuildContext context, double height, double width,
    {int? pageNum}) {
  return Obx(() {
    return Semantics(
      button: true,
      enabled: true,
      label: 'Add Bookmark',
      child: SvgPicture.asset(
        'assets/svg/bookmark_ic.svg',
        width: width,
        height: height,
        colorFilter: sl<BookmarksController>().isPageBookmarked(
                pageNum ?? sl<GeneralController>().currentPage.value)
            ? null
            : ColorFilter.mode(Get.theme.colorScheme.surface, BlendMode.srcIn),
      ),
    );
  });
}

Widget surahName(double height, double width) {
  return SvgPicture.asset(
    'assets/svg/surah_name/00${sl<SurahAudioController>().surahNum}.svg',
    colorFilter:
        ColorFilter.mode(Get.theme.colorScheme.primary, BlendMode.srcIn),
    width: width,
    height: height,
  );
}

Widget decorations(BuildContext context, {double? height, double? width}) {
  return Opacity(
    opacity: .6,
    child: SvgPicture.asset(
      'assets/svg/decorations.svg',
      width: width,
      height: height ?? 60,
    ),
  );
}

Widget button_curve({double? height, double? width, Color? color}) {
  return SvgPicture.asset(
    'assets/svg/button_curve.svg',
    width: width,
    height: height ?? 60,
    colorFilter: ColorFilter.mode(
        color ?? Get.theme.colorScheme.primary, BlendMode.srcIn),
  );
}

Widget menu_curve({double? height, double? width, Color? color}) {
  return SvgPicture.asset(
    'assets/svg/menu_curve.svg',
    width: width,
    height: height ?? 60,
    colorFilter: ColorFilter.mode(
        color ?? Get.theme.colorScheme.primary.withOpacity(.7),
        BlendMode.srcIn),
  );
}

Widget options({double? height, double? width, Color? color}) {
  return SvgPicture.asset(
    'assets/svg/options.svg',
    width: width,
    height: height ?? 60,
    colorFilter: ColorFilter.mode(
        color ?? Get.theme.colorScheme.secondary, BlendMode.srcIn),
  );
}

Widget home({double? height, double? width, Color? color}) {
  return SvgPicture.asset(
    'assets/svg/home.svg',
    width: width,
    height: height ?? 60,
    colorFilter: ColorFilter.mode(
        color ?? Get.theme.colorScheme.secondary, BlendMode.srcIn),
  );
}

Widget quran_ic_s({double? height, double? width}) {
  return SvgPicture.asset(
    'assets/svg/quran_ic_s.svg',
    width: width,
    height: height ?? 60,
  );
}

Widget slider_ic2({double? height, double? width}) {
  return SvgPicture.asset(
    'assets/svg/slider_ic2.svg',
    width: width,
    height: height ?? 60,
  );
}

Widget azkar_b({double? height, double? width}) {
  return SvgPicture.asset(
    'assets/svg/azkar_b.svg',
    width: width,
    height: height ?? 60,
  );
}

Widget font_size({double? height, double? width, Color? color}) {
  return Transform.translate(
    offset: const Offset(0, -5),
    child: SvgPicture.asset(
      'assets/svg/font_size.svg',
      width: width,
      height: height ?? 35,
      colorFilter: ColorFilter.mode(
          color ?? Get.theme.colorScheme.secondary, BlendMode.srcIn),
    ),
  );
}

Widget splash_icon({double? height, double? width}) {
  return SvgPicture.asset(
    'assets/svg/splash_icon.svg',
    width: width,
    height: height ?? 60,
  );
}

Widget play_arrow({double? height, double? width}) {
  return SvgPicture.asset(
    'assets/svg/play-arrow.svg',
    width: width,
    height: height ?? 60,
  );
}

Widget pause_arrow({double? height, double? width}) {
  return SvgPicture.asset(
    'assets/svg/pause_arrow.svg',
    width: width,
    height: height ?? 60,
  );
}

Widget play_page({double? height, double? width}) {
  return SvgPicture.asset(
    'assets/svg/play_page.svg',
    width: width,
    height: height ?? 60,
  );
}

Widget playlist({double? height, double? width}) {
  return SvgPicture.asset(
    'assets/svg/playlist.svg',
    width: width,
    height: height ?? 60,
  );
}

Widget tafsir_icon({double? height, double? width}) {
  return SvgPicture.asset(
    'assets/svg/tafsir_icon.svg',
    width: width,
    height: height ?? 60,
  );
}

Widget bookmark_icon({double? height, double? width}) {
  return SvgPicture.asset(
    'assets/svg/bookmark_icon.svg',
    width: width,
    height: height ?? 60,
  );
}

Widget copy_icon({double? height, double? width}) {
  return SvgPicture.asset(
    'assets/svg/copy_icon.svg',
    width: width,
    height: height ?? 60,
  );
}

Widget share_icon({double? height, double? width}) {
  return SvgPicture.asset(
    'assets/svg/share_icon.svg',
    width: width,
    height: height ?? 60,
  );
}

Widget books_icon({double? height, double? width}) {
  return SvgPicture.asset(
    'assets/svg/books.svg',
    width: width,
    height: height ?? 60,
  );
}

Widget tafseer_icon({double? height, double? width}) {
  return SvgPicture.asset(
    'assets/svg/tafseer.svg',
    width: width,
    height: height ?? 60,
  );
}

Widget surah_banner1({double? height, double? width}) {
  return SvgPicture.asset(
    'assets/svg/surah_banner1.svg',
    width: width,
    height: height ?? 35,
  );
}

Widget surah_banner2({double? height, double? width}) {
  return SvgPicture.asset(
    'assets/svg/surah_banner2.svg',
    width: width,
    height: height ?? 35,
  );
}

Widget surah_banner3({double? height, double? width}) {
  return SvgPicture.asset(
    'assets/svg/surah_banner3.svg',
    width: width,
    height: height ?? 35,
  );
}
