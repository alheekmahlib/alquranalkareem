import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/surah_name_with_banner.dart';
import '/core/utils/constants/extensions/svg_extensions.dart';
import '/presentation/controllers/audio_controller.dart';
import '../../../../../core/services/services_locator.dart';
import '../../../../../core/utils/constants/svg_constants.dart';
import '../../../../controllers/bookmarks_controller.dart';
import '../../../../controllers/general_controller.dart';
import '../../../../controllers/quran_controller.dart';
import 'text_build.dart';

class PagesWidget extends StatelessWidget {
  final int pageIndex;

  PagesWidget({super.key, required this.pageIndex});

  final audioCtrl = AudioController.instance;
  final generalCtrl = GeneralController.instance;

  @override
  Widget build(BuildContext context) {
    sl<BookmarksController>().getBookmarksText();
    return GetBuilder<QuranController>(builder: (quranCtrl) {
      return Container(
        padding: pageIndex == 0 || pageIndex == 1
            ? EdgeInsets.symmetric(horizontal: Get.width * .13)
            : const EdgeInsets.symmetric(horizontal: 0.0),
        margin: pageIndex == 0 || pageIndex == 1
            ? EdgeInsets.symmetric(vertical: Get.width * .34)
            : const EdgeInsets.symmetric(vertical: 32.0, horizontal: 6.0),
        child: quranCtrl.pages.isEmpty
            ? const CircularProgressIndicator.adaptive()
            : SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                      quranCtrl
                          .getCurrentPageAyahsSeparatedForBasmalah(pageIndex)
                          .length, (i) {
                    final ayahs = quranCtrl
                        .getCurrentPageAyahsSeparatedForBasmalah(pageIndex)[i];
                    return Column(children: [
                      surahBannerFirstPlace(pageIndex, i),
                      quranCtrl.getSurahNumberByAyah(ayahs.first) == 9 ||
                              quranCtrl.getSurahNumberByAyah(ayahs.first) == 1
                          ? const SizedBox.shrink()
                          : Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: ayahs.first.ayahNumber == 1
                                  ? (quranCtrl.getSurahNumberByAyah(
                                                  ayahs.first) ==
                                              95 ||
                                          quranCtrl.getSurahNumberByAyah(
                                                  ayahs.first) ==
                                              97)
                                      ? customSvgWithColor(
                                          SvgPath.svgBesmAllah2,
                                          width: sl<GeneralController>()
                                              .ifBigScreenSize(
                                                  100.0.w, 150.0.w),
                                          color: Get.theme.cardColor
                                              .withOpacity(.8))
                                      : customSvgWithColor(SvgPath.svgBesmAllah,
                                          width: sl<GeneralController>()
                                              .ifBigScreenSize(
                                                  100.0.w, 150.0.w),
                                          color: Get.theme.cardColor
                                              .withOpacity(.8))
                                  : const SizedBox.shrink(),
                            ),
                      TextBuild(
                        pageIndex: pageIndex,
                        ayahs: ayahs,
                      ),
                      surahBannerLastPlace(pageIndex, i),
                    ]);
                  }),
                ),
              ),
      );
    });
  }
}
