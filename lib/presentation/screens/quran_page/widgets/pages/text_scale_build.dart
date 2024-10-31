import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/convert_number_extension.dart';
import '/core/utils/constants/extensions/menu_extension.dart';
import '/core/utils/constants/extensions/svg_extensions.dart';
import '/presentation/screens/quran_page/extensions/surah_name_with_banner.dart';
import '../../../../../core/utils/constants/svg_constants.dart';
import '../../../../controllers/general/general_controller.dart';
import '../../controllers/audio/audio_controller.dart';
import '../../controllers/extensions/quran/quran_getters.dart';
import '../../controllers/extensions/quran/quran_ui.dart';
import '../../controllers/quran/quran_controller.dart';
import 'custom_span.dart';

class TextScaleBuild extends StatelessWidget {
  final int pageIndex;

  TextScaleBuild({super.key, required this.pageIndex});

  final audioCtrl = AudioController.instance;
  final generalCtrl = GeneralController.instance;
  final quranCtrl = QuranController.instance;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
          quranCtrl.getCurrentPageAyahsSeparatedForBasmalah(pageIndex).length,
          (i) {
        final ayahs =
            quranCtrl.getCurrentPageAyahsSeparatedForBasmalah(pageIndex)[i];
        return Flexible(
          child: SingleChildScrollView(
            child: Column(children: [
              Column(
                children: [
                  surahBannerFirstPlace(pageIndex, i),
                  quranCtrl.getSurahDataByAyah(ayahs.first).surahNumber == 9 ||
                          quranCtrl
                                  .getSurahDataByAyah(ayahs.first)
                                  .surahNumber ==
                              1
                      ? const SizedBox.shrink()
                      : Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: ayahs.first.ayahNumber == 1
                              ? (quranCtrl
                                              .getSurahDataByAyah(ayahs.first)
                                              .surahNumber ==
                                          95 ||
                                      quranCtrl
                                              .getSurahDataByAyah(ayahs.first)
                                              .surahNumber ==
                                          97)
                                  ? customSvgWithColor(SvgPath.svgBesmAllah2,
                                      width: Get.width * .5,
                                      height: quranCtrl.textScale(
                                          Get.height * .2, 45.0),
                                      color:
                                          Get.theme.cardColor.withOpacity(.8))
                                  : customSvgWithColor(SvgPath.svgBesmAllah,
                                      width: Get.width * .5,
                                      height: quranCtrl.textScale(
                                          Get.height * .2, 45.0),
                                      color:
                                          Get.theme.cardColor.withOpacity(.8))
                              : const SizedBox.shrink(),
                        ),
                ],
              ),
              GetBuilder<QuranController>(
                id: 'bookmarked',
                builder: (quranCtrl) => RichText(
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.justify,
                  text: TextSpan(
                    style: TextStyle(
                      fontFamily: 'uthmanic2',
                      fontSize: 20 * quranCtrl.state.scaleFactor.value,
                      height: 1.7,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                    children: List.generate(ayahs.length, (ayahIndex) {
                      quranCtrl.state.isSelected = quranCtrl
                          .state.selectedAyahIndexes
                          .contains(ayahs[ayahIndex].ayahUQNumber);
                      return customSpan(
                          text: "${ayahs[ayahIndex].text}",
                          ayahNumber:
                              '${ayahs[ayahIndex].ayahNumber.toString().convertNumbers()}',
                          pageIndex: pageIndex,
                          isSelected: quranCtrl.state.isSelected,
                          fontSize: 20 * quranCtrl.state.scaleFactor.value,
                          surahNum: quranCtrl
                              .getSurahDataByAyahUQ(
                                  ayahs[ayahIndex].ayahUQNumber)
                              .surahNumber,
                          ayahNum: ayahs[ayahIndex].ayahUQNumber,
                          onLongPressStart: (LongPressStartDetails details) {
                            quranCtrl.toggleAyahSelection(
                                ayahs[ayahIndex].ayahUQNumber);
                            context.showAyahMenu(
                                quranCtrl
                                    .getSurahDataByAyahUQ(
                                        ayahs[ayahIndex].ayahUQNumber)
                                    .surahNumber,
                                ayahs[ayahIndex].ayahNumber,
                                ayahs[ayahIndex].code_v2,
                                pageIndex,
                                ayahs[ayahIndex].text,
                                ayahs[ayahIndex].ayahUQNumber,
                                quranCtrl
                                    .getCurrentSurahByPage(pageIndex)
                                    .arabicName,
                                ayahIndex,
                                details: details);
                          });
                    }),
                  ),
                ),
              ),
              surahBannerLastPlace(pageIndex, i),
            ]),
          ),
        );
      }),
    );
  }
}
