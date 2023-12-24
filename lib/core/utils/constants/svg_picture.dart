import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../presentation/controllers/bookmarks_controller.dart';
import '../../../presentation/controllers/general_controller.dart';
import '../../../presentation/controllers/surah_audio_controller.dart';
import '../../services/services_locator.dart';

besmAllah(BuildContext context) {
  return SvgPicture.asset(
    'assets/svg/besmAllah.svg',
    width: 250,
    colorFilter: ColorFilter.mode(
        Theme.of(context).cardColor.withOpacity(.8), BlendMode.srcIn),
  );
}

besmAllah2(BuildContext context) {
  return SvgPicture.asset(
    'assets/svg/besmAllah2.svg',
    width: 250,
    colorFilter: ColorFilter.mode(
        Theme.of(context).cardColor.withOpacity(.8), BlendMode.srcIn),
  );
}

spaceLine(double height, width) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: SvgPicture.asset(
      'assets/svg/space_line.svg',
      height: height,
      width: width,
    ),
  );
}

quranIcon(BuildContext context, double height, width) {
  return SvgPicture.asset(
    'assets/svg/quran_au_ic.svg',
    colorFilter: ColorFilter.mode(
        Theme.of(context).colorScheme.surface, BlendMode.srcIn),
    width: width,
    height: height,
  );
}

bookmarkIcon(BuildContext context, double height, double width,
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
            : ColorFilter.mode(
                Theme.of(context).colorScheme.surface, BlendMode.srcIn),
      ),
    );
  });
}

surahName(BuildContext context, double height, double width) {
  return SvgPicture.asset(
    'assets/svg/surah_name/00${sl<SurahAudioController>().surahNum}.svg',
    colorFilter: ColorFilter.mode(
        Theme.of(context).colorScheme.surface, BlendMode.srcIn),
    width: width,
    height: height,
  );
}

decorations(BuildContext context, {double? height, double? width}) {
  return Opacity(
    opacity: .6,
    child: SvgPicture.asset(
      'assets/svg/decorations.svg',
      width: width,
      height: height ?? 60,
    ),
  );
}
