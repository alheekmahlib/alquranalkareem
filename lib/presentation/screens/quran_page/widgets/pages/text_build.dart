import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/convert_number_extension.dart';
import '/core/utils/constants/extensions/menu_extension.dart';
import '/presentation/screens/quran_page/controllers/extensions/quran_getters.dart';
import '/presentation/screens/quran_page/controllers/extensions/quran_ui.dart';
import '../../../../controllers/general/general_controller.dart';
import '../../controllers/audio/audio_controller.dart';
import '../../controllers/quran/quran_controller.dart';
import '../../data/model/surahs_model.dart';
import 'custom_span.dart';

class TextBuild extends StatelessWidget {
  final int pageIndex;
  final List<Ayah> ayahs;
  TextBuild({super.key, required this.pageIndex, required this.ayahs});

  final audioCtrl = AudioController.instance;
  final generalCtrl = GeneralController.instance;
  final quranCtrl = QuranController.instance;

  @override
  Widget build(BuildContext context) {
    return Obx(() => quranCtrl.textScale(
        FittedBox(
          fit: BoxFit.fitWidth,
          child: Obx(() => RichText(
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    fontFamily: 'page${pageIndex + 1}',
                    fontSize: 100,
                    height: 1.7,
                    letterSpacing: 2,
                    color: Theme.of(context).colorScheme.inversePrimary,
                    shadows: [
                      Shadow(
                        blurRadius: 0.5,
                        color: quranCtrl.state.isBold.value == 0
                            ? Colors.black
                            : Colors.transparent,
                        offset: const Offset(0.5, 0.5),
                      ),
                    ],
                  ),
                  children: List.generate(ayahs.length, (ayahIndex) {
                    quranCtrl.state.isSelected = quranCtrl
                        .state.selectedAyahIndexes
                        .contains(ayahs[ayahIndex].ayahUQNumber);
                    if (ayahIndex == 0) {
                      return span(
                          isFirstAyah: true,
                          text:
                              "${ayahs[ayahIndex].code_v2[0]}${ayahs[ayahIndex].code_v2.substring(1)}",
                          pageIndex: pageIndex,
                          isSelected: quranCtrl.state.isSelected,
                          fontSize: 100,
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
                                quranCtrl.state.surahs
                                    .firstWhere((s) =>
                                        s.ayahs.contains(ayahs[ayahIndex]))
                                    .arabicName,
                                ayahIndex,
                                details: details);
                          });
                    }
                    return span(
                        isFirstAyah: false,
                        text: ayahs[ayahIndex].code_v2,
                        pageIndex: pageIndex,
                        isSelected: quranCtrl.state.isSelected,
                        fontSize: 100,
                        surahNum: quranCtrl
                            .getSurahDataByAyahUQ(ayahs[ayahIndex].ayahUQNumber)
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
                                  .getSurahDataByAyahUQ(pageIndex)
                                  .arabicName,
                              ayahIndex,
                              details: details);
                        });
                  }),
                ),
              )),
        ),
        Obx(() => RichText(
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
                          .getSurahDataByAyahUQ(ayahs[ayahIndex].ayahUQNumber)
                          .surahNumber,
                      ayahNum: ayahs[ayahIndex].ayahUQNumber,
                      onLongPressStart: (LongPressStartDetails details) {
                        quranCtrl
                            .toggleAyahSelection(ayahs[ayahIndex].ayahUQNumber);
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
                                .getSurahDataByAyahUQ(pageIndex)
                                .arabicName,
                            ayahIndex,
                            details: details);
                      });
                }),
              ),
            ))));
  }
}
