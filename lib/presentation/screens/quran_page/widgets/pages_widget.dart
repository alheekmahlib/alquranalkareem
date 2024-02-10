import 'package:alquranalkareem/core/utils/constants/extensions.dart';
import 'package:alquranalkareem/core/utils/constants/extensions/menu_extension.dart';
import 'package:alquranalkareem/core/utils/constants/svg_picture.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/services/services_locator.dart';
import '../../../../core/utils/constants/size_config.dart';
import '../../../controllers/bookmarksText_controller.dart';
import '../../../controllers/quran_controller.dart';
import '../data/model/surahs_model.dart';
import 'custom_span.dart';

class PagesWidget extends StatelessWidget {
  final int pageIndex;

  const PagesWidget({super.key, required this.pageIndex});

  @override
  Widget build(BuildContext context) {
    sl<BookmarksTextController>().getBookmarksText();
    SizeConfig().init(context);
    return GetBuilder<QuranController>(builder: (quranCtrl) {
      return SingleChildScrollView(
        child: InkWell(
          onTap: () {
            quranCtrl.clearSelection();
          },
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 30.0, horizontal: 8.0),
            child: quranCtrl.pages.isEmpty
                ? const CircularProgressIndicator.adaptive()
                : Column(
                    children: List.generate(
                        quranCtrl
                            .getCurrentPageAyahsSeparatedForBasmala(pageIndex)
                            .length, (i) {
                      List<Ayah> currentPageAyahs = quranCtrl.pages[pageIndex];
                      quranCtrl.getSajdaInfoForPage(currentPageAyahs)
                          ? quranCtrl.showVerseToast(i, currentPageAyahs.length)
                          : const SizedBox.shrink();
                      final ayahs = quranCtrl
                          .getCurrentPageAyahsSeparatedForBasmala(pageIndex)[i];
                      return Column(children: [
                        quranCtrl.surahBannerFirstPlace(pageIndex, i),
                        quranCtrl.getSurahNumberByAyah(ayahs.first) == 9 ||
                                quranCtrl.getSurahNumberByAyah(ayahs.first) == 1
                            ? const SizedBox.shrink()
                            : ayahs.first.ayahNumber == 1
                                ? (quranCtrl.getSurahNumberByAyah(
                                                ayahs.first) ==
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
                                fontSize: getProportionateScreenWidth(
                                    context.customOrientation(20.0, 18.0)),
                                height: 2,
                                letterSpacing: 2,
                                color: Get.theme.colorScheme.inversePrimary,
                              ),
                              children:
                                  List.generate(ayahs.length, (ayahIndex) {
                                quranCtrl.isSelected = quranCtrl
                                    .selectedAyahIndexes
                                    .contains(ayahs[ayahIndex].ayahUQNumber);
                                if (ayahIndex == 0) {
                                  return span(
                                      isFirstAyah: true,
                                      text:
                                          "${ayahs[ayahIndex].code_v2[0]}${ayahs[ayahIndex].code_v2.substring(1)}",
                                      pageIndex: pageIndex,
                                      isSelected: quranCtrl.isSelected,
                                      fontSize: getProportionateScreenWidth(
                                          context.customOrientation(
                                              20.0, 18.0)),
                                      surahNum: quranCtrl
                                          .getSurahNumberFromPage(pageIndex),
                                      ayahNum: ayahs[ayahIndex].ayahNumber,
                                      onLongPressStart:
                                          (LongPressStartDetails details) {
                                        quranCtrl.toggleAyahSelection(
                                            ayahs[ayahIndex].ayahUQNumber);
                                        context.showAyahMenu(
                                            quranCtrl.getSurahNumberFromPage(
                                                pageIndex),
                                            ayahs[ayahIndex].ayahNumber,
                                            ayahs[ayahIndex].code_v2,
                                            pageIndex,
                                            ayahs[ayahIndex].text,
                                            ayahs[ayahIndex].ayahUQNumber,
                                            quranCtrl.getSurahNameFromPage(
                                                pageIndex),
                                            details: details);
                                      });
                                }
                                return span(
                                    isFirstAyah: false,
                                    text: ayahs[ayahIndex].code_v2,
                                    pageIndex: pageIndex,
                                    isSelected: quranCtrl.isSelected,
                                    fontSize: getProportionateScreenWidth(
                                        context.customOrientation(20.0, 18.0)),
                                    surahNum: quranCtrl
                                        .getSurahNumberFromPage(pageIndex),
                                    ayahNum: ayahs[ayahIndex].ayahNumber,
                                    onLongPressStart:
                                        (LongPressStartDetails details) {
                                      quranCtrl.toggleAyahSelection(
                                          ayahs[ayahIndex].ayahUQNumber);
                                      context.showAyahMenu(
                                          quranCtrl.getSurahNumberFromPage(
                                              pageIndex),
                                          ayahs[ayahIndex].ayahNumber,
                                          ayahs[ayahIndex].code_v2,
                                          pageIndex,
                                          ayahs[ayahIndex].text,
                                          ayahs[ayahIndex].ayahUQNumber,
                                          quranCtrl
                                              .getSurahNameFromPage(pageIndex),
                                          details: details);
                                    });
                              }),
                            ),
                          );
                        }),
                        quranCtrl.surahBannerLastPlace(pageIndex, i),
                      ]);
                    }),
                  ),
          ),
        ),
      );
    });
  }
}
