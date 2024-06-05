import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/surah_name_with_banner.dart';
import '../../../presentation/controllers/bookmarks_controller.dart';
import '../../../presentation/controllers/general_controller.dart';
import '../../../presentation/controllers/surah_audio_controller.dart';
import '../../services/services_locator.dart';

Widget besmAllah() {
  return SvgPicture.asset(
    'assets/svg/besmAllah.svg',
    width: sl<GeneralController>().ifBigScreenSize(100.0.w, 150.0.w),
    colorFilter:
        ColorFilter.mode(Get.theme.cardColor.withOpacity(.8), BlendMode.srcIn),
  );
}

Widget besmAllah2() {
  return SvgPicture.asset(
    'assets/svg/besmAllah2.svg',
    width: sl<GeneralController>().ifBigScreenSize(100.0.w, 150.0.w),
    colorFilter:
        ColorFilter.mode(Get.theme.cardColor.withOpacity(.8), BlendMode.srcIn),
  );
}

Widget bookmarkIcon({double? height, double? width, int? pageNum}) {
  return Obx(() {
    return Semantics(
      button: true,
      enabled: true,
      label: 'Add Bookmark',
      child: SvgPicture.asset(
        sl<BookmarksController>().isPageBookmarked(
                pageNum ?? sl<GeneralController>().currentPageNumber.value)
            ? 'assets/svg/bookmarked.svg'
            : Get.context!.bookmarkPageIconPath(),
        width: width,
        height: height,
      ),
    );
  });
}

Widget bookmarkPageIcon({double? height, double? width, int? pageNum}) {
  return SvgPicture.asset(
    sl<BookmarksController>().isPageBookmarked(
            pageNum ?? sl<GeneralController>().currentPageNumber.value)
        ? 'assets/svg/bookmarked.svg'
        : Get.context!.bookmarkPageIconPath(),
    width: width,
    height: height,
  );
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
