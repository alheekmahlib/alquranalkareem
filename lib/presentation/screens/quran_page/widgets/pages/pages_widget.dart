import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/services/services_locator.dart';
import '../../../../../core/utils/constants/size_config.dart';
import '../../../../controllers/bookmarks_controller.dart';
import '../../../../controllers/quran_controller.dart';
import '/core/utils/constants/extensions/menu_extension.dart';
import '/core/utils/constants/extensions/surah_name_with_banner.dart';
import '/core/utils/constants/svg_picture.dart';
import '/presentation/controllers/audio_controller.dart';
import 'custom_span.dart';

class PagesWidget extends StatelessWidget {
  final int pageIndex;

  PagesWidget({super.key, required this.pageIndex});

  final audioCtrl = sl<AudioController>();

  @override
  Widget build(BuildContext context) {
    sl<BookmarksController>().getBookmarksText();
    SizeConfig().init(context);
    return GetBuilder<QuranController>(builder: (quranCtrl) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: quranCtrl.pages.isEmpty
            ? const CircularProgressIndicator.adaptive()
            : Column(
                children: List.generate(
                    quranCtrl
                        .getCurrentPageAyahsSeparatedForBasmalah(pageIndex)
                        .length, (i) {
                  final ayahs = quranCtrl
                      .getCurrentPageAyahsSeparatedForBasmalah(pageIndex)[i];
                  quranCtrl.showVerseToast(pageIndex);
                  return Column(children: [
                    context.surahBannerFirstPlace(pageIndex, i),
                    quranCtrl.getSurahNumberByAyah(ayahs.first) == 9 ||
                            quranCtrl.getSurahNumberByAyah(ayahs.first) == 1
                        ? const SizedBox.shrink()
                        : ayahs.first.ayahNumber == 1
                            ? (quranCtrl.getSurahNumberByAyah(ayahs.first) ==
                                        95 ||
                                    quranCtrl.getSurahNumberByAyah(
                                            ayahs.first) ==
                                        97)
                                ? besmAllah2()
                                : besmAllah()
                            : const SizedBox.shrink(),
                    Obx(() {
                      return RichText(
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(
                            fontFamily: 'page${pageIndex + 1}',
                            fontSize: getProportionateScreenWidth(19),
                            height: 2,
                            letterSpacing: 2,
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                          children: List.generate(ayahs.length, (ayahIndex) {
                            quranCtrl.isSelected = quranCtrl.selectedAyahIndexes
                                .contains(ayahs[ayahIndex].ayahUQNumber);
                            if (ayahIndex == 0) {
                              return span(
                                  isFirstAyah: true,
                                  text:
                                      "${ayahs[ayahIndex].code_v2[0]}${ayahs[ayahIndex].code_v2.substring(1)}",
                                  pageIndex: pageIndex,
                                  isSelected: quranCtrl.isSelected,
                                  fontSize: getProportionateScreenWidth(19),
                                  surahNum: quranCtrl
                                      .getSurahNumberFromPage(pageIndex),
                                  ayahNum: ayahs[ayahIndex].ayahUQNumber,
                                  onLongPressStart:
                                      (LongPressStartDetails details) {
                                    quranCtrl.toggleAyahSelection(
                                        ayahs[ayahIndex].ayahUQNumber);
                                    context.showAyahMenu(
                                        quranCtrl
                                            .getSurahNumberFromPage(pageIndex),
                                        ayahs[ayahIndex].ayahNumber,
                                        ayahs[ayahIndex].code_v2,
                                        pageIndex,
                                        ayahs[ayahIndex].text,
                                        ayahs[ayahIndex].ayahUQNumber,
                                        quranCtrl
                                            .getSurahNameFromPage(pageIndex),
                                        details: details);
                                  });
                            }
                            return span(
                                isFirstAyah: false,
                                text: ayahs[ayahIndex].code_v2,
                                pageIndex: pageIndex,
                                isSelected: quranCtrl.isSelected,
                                fontSize: getProportionateScreenWidth(19),
                                surahNum:
                                    quranCtrl.getSurahNumberFromPage(pageIndex),
                                ayahNum: ayahs[ayahIndex].ayahUQNumber,
                                onLongPressStart:
                                    (LongPressStartDetails details) {
                                  quranCtrl.toggleAyahSelection(
                                      ayahs[ayahIndex].ayahUQNumber);
                                  context.showAyahMenu(
                                      quranCtrl
                                          .getSurahNumberFromPage(pageIndex),
                                      ayahs[ayahIndex].ayahNumber,
                                      ayahs[ayahIndex].code_v2,
                                      pageIndex,
                                      ayahs[ayahIndex].text,
                                      ayahs[ayahIndex].ayahUQNumber,
                                      quranCtrl.getSurahNameFromPage(pageIndex),
                                      details: details);
                                });
                          }),
                        ),
                      );
                    }),
                    context.surahBannerLastPlace(pageIndex, i),
                  ]);
                }),
              ),
      );
    });
  }
}
