import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/surah_name_with_banner.dart';
import '/core/utils/constants/extensions/svg_extensions.dart';
import '/presentation/controllers/audio_controller.dart';
import '/presentation/screens/quran_page/controller/extensions/quran_getters.dart';
import '../../../../../core/services/services_locator.dart';
import '../../../../../core/utils/constants/svg_constants.dart';
import '../../../../controllers/bookmarks_controller.dart';
import '../../../../controllers/general_controller.dart';
import '../../controller/quran_controller.dart';
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
            ? EdgeInsets.symmetric(horizontal: Get.width * .08)
            : const EdgeInsets.symmetric(horizontal: 0.0),
        margin: pageIndex == 0 || pageIndex == 1
            ? EdgeInsets.symmetric(vertical: Get.width * .16)
            : const EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
        child: quranCtrl.state.pages.isEmpty
            ? const CircularProgressIndicator.adaptive()
            : FittedBox(
                fit: BoxFit.scaleDown,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                      quranCtrl
                          .getCurrentPageAyahsSeparatedForBasmalah(pageIndex)
                          .length, (i) {
                    final ayahs = quranCtrl
                        .getCurrentPageAyahsSeparatedForBasmalah(pageIndex)[i];
                    return Column(children: [
                      Gap(Get.height * .06),
                      surahBannerFirstPlace(pageIndex, i),
                      Gap(Get.height * .06),
                      quranCtrl.getSurahNumberByAyah(ayahs.first).surahNumber ==
                                  9 ||
                              quranCtrl
                                      .getSurahNumberByAyah(ayahs.first)
                                      .surahNumber ==
                                  1
                          ? const SizedBox.shrink()
                          : Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: ayahs.first.ayahNumber == 1
                                  ? (quranCtrl
                                                  .getSurahNumberByAyah(
                                                      ayahs.first)
                                                  .surahNumber ==
                                              95 ||
                                          quranCtrl
                                                  .getSurahNumberByAyah(
                                                      ayahs.first)
                                                  .surahNumber ==
                                              97)
                                      ? customSvgWithColor(
                                          SvgPath.svgBesmAllah2,
                                          width: Get.width * .5,
                                          height: Get.height * .2,
                                          color: Get.theme.cardColor
                                              .withOpacity(.8))
                                      : customSvgWithColor(SvgPath.svgBesmAllah,
                                          width: Get.width * .5,
                                          height: Get.height * .2,
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
