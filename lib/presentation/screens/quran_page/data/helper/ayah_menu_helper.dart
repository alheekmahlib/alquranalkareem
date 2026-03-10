import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:quran_library/quran.dart';

import '/core/utils/constants/extensions/extensions.dart';
import '/core/widgets/container_button.dart';
import '/core/widgets/share/share_ayah_options.dart';
import '/presentation/controllers/theme_controller.dart';
import '../../../../../core/utils/constants/extensions/bottom_sheet_extension.dart';
import '../../../../../core/utils/constants/svg_constants.dart';
import '../../../../../core/widgets/tab_bar_widget.dart';
import '../../quran.dart';
import '../../widgets/search/controller/quran_search_controller.dart';

class AyahMenuHelper {
  const AyahMenuHelper._();

  static void show(
    BuildContext context, {
    required SurahModel surah,
    required AyahModel ayah,
    required int pageIndex,
    WordInfoKind initialKind = WordInfoKind.recitations,
  }) {
    final isDark = ThemeController.instance.isDarkMode;
    final quranCtrl = QuranController.instance;
    final wordCtrl = WordInfoCtrl.instance;
    wordCtrl.setSelectedKind(initialKind);
    BottomSheetExtension(null).customBottomSheet(
      backgroundColor: Get.theme.colorScheme.primaryContainer,
      handleChild: context.customOrientation(
        Text(
          '${'${ayah.ayahNumber}'.convertEnglishNumbersToArabic(ayah.ayahNumber.toString())}\u202F\u202F',
          style: const TextStyle(
            fontFamily: 'ayahNumber',
            fontSize: 60,
            height: 1.5,
            package: 'quran_library',
          ),
        ),
        const SizedBox.shrink(),
      ),
      Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _ayahBuild(surah, ayah, quranCtrl, wordCtrl, pageIndex, isDark),
                const Gap(8),
              ],
            ),
          ),
          const Gap(8),
          Container(
            height: 191,
            width: Get.width,
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            decoration: BoxDecoration(
              color: Get.theme.colorScheme.surface.withValues(alpha: .2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: GetBuilder<WordInfoCtrl>(
              id: 'word_info_kind',
              builder: (wordCtrl) => WordInfoWidget(
                ref: quranCtrl.state.ref.value,
                initialKind: initialKind,
                ctrl: wordCtrl,
                isDark: isDark,
                defaults: quranCtrl.wordInfoStyle,
              ),
            ),
          ),
          const Gap(8),
          _buttonsBuild(ayah, pageIndex, surah),
        ],
      ),
    );
  }

  static Widget _ayahBuild(
    SurahModel surah,
    AyahModel ayah,
    QuranController quranCtrl,
    WordInfoCtrl wordCtrl,
    int pageIndex,
    bool isDark,
  ) {
    final svc = WordAudioService.instance;
    final searchCtrl = QuranSearchController.instance;
    quranCtrl.state.ref.value = WordRef(
      surahNumber: surah.surahNumber,
      ayahNumber: ayah.ayahNumber,
      wordNumber: 1,
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Directionality(
          textDirection: TextDirection.rtl,
          child: Row(
            children: [
              Container(
                height: 45,
                width: 8,
                decoration: BoxDecoration(
                  color: Get.theme.primaryColorLight,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const Gap(8),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: GetSingleAyah(
                    surahNumber: surah.surahNumber,
                    ayahNumber: ayah.ayahNumber,
                    enableWordSelection: true,
                    isDark: isDark,
                    enabledTajweed:
                        QuranCtrl.instance.state.isTajweedEnabled.value,
                    onWordTap: (ref) {
                      quranCtrl.state.ref.value = ref;
                      print(
                        'سورة: ${ref.surahNumber}, آية: ${ref.ayahNumber}, كلمة: ${ref.wordNumber}',
                      );
                      WordInfoCtrl.instance.update(['word_info_kind']);
                    },
                    selectedWordColor: Colors.amber.withValues(alpha: 0.3),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Gap(8),
        GetBuilder<WordInfoCtrl>(
          id: 'word_info_kind',
          builder: (wordCtrl) {
            final words = ayah.text.trim().split(RegExp(r'\s+'));
            final wordsSearch = ayah.ayaTextEmlaey.trim().split(RegExp(r'\s+'));
            final wordIndex = quranCtrl.state.ref.value.wordNumber - 1;
            final selectedWord = (wordIndex >= 0 && wordIndex < words.length)
                ? words[wordIndex]
                : '';
            final selectedSearchWord =
                (wordIndex >= 0 && wordIndex < wordsSearch.length)
                ? wordsSearch[wordIndex]
                : '';
            return Row(
              children: [
                Expanded(
                  child: Obx(() {
                    final ref = quranCtrl.state.ref.value;
                    final playing = svc.isPlaying.value;
                    final loading = svc.isLoading.value;
                    final currentRef = svc.currentPlayingRef.value;
                    final isAyahMode = svc.isPlayingAyahWords.value;

                    final isWordPlaying =
                        playing && !isAyahMode && currentRef == ref;
                    final isAyahPlaying =
                        playing &&
                        isAyahMode &&
                        currentRef?.surahNumber == ref.surahNumber &&
                        currentRef?.ayahNumber == ref.ayahNumber;

                    final isWordLoading =
                        loading && !isAyahMode && currentRef == ref;
                    final isAyahLoading =
                        loading &&
                        isAyahMode &&
                        currentRef?.surahNumber == ref.surahNumber &&
                        currentRef?.ayahNumber == ref.ayahNumber;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: ContainerButton(
                            height: 40,
                            // width: 35,
                            isPreparingDownload: isWordLoading,
                            svgWithColorPath: isWordPlaying
                                ? SvgPath.svgAudioPauseArrow
                                : SvgPath.svgAudioPlayWord,
                            svgColor: Get.theme.hintColor,
                            backgroundColor: Colors.transparent,
                            onPressed: () async {
                              await wordCtrl.playWordAudio(
                                quranCtrl.state.ref.value,
                              );
                            },
                          ),
                        ),

                        Expanded(
                          child: ContainerButton(
                            height: 40,
                            // width: 35,
                            isPreparingDownload: isAyahLoading,
                            svgWithColorPath: isAyahPlaying
                                ? SvgPath.svgAudioPauseArrow
                                : SvgPath.svgAudioPlayAllWord,
                            svgColor: Get.theme.hintColor,
                            backgroundColor: Colors.transparent,
                            onPressed: () async {
                              await wordCtrl.playAyahWordsAudio(
                                quranCtrl.state.ref.value,
                              );
                            },
                          ),
                        ),
                        Expanded(
                          child: ContainerButton(
                            height: 40,
                            // width: 35,
                            svgWithColorPath: SvgPath.svgHomeSearch,
                            svgColor: Get.theme.hintColor,
                            backgroundColor: Colors.transparent,
                            onPressed: () {
                              Get.back();
                              searchCtrl.state.searchTextEditing.text =
                                  selectedSearchWord;
                              searchCtrl.search(selectedSearchWord);
                              searchCtrl.surahSearchMethod(selectedSearchWord);
                              quranCtrl.setTopBarType = TopBarType.search;
                              quranCtrl.state.tabBarController.toggle();
                            },
                          ),
                        ),
                      ],
                    );
                  }),
                ),
                Expanded(
                  child: Container(
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Get.theme.colorScheme.surface.withValues(
                        alpha: .2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      selectedWord,
                      style: TextStyle(
                        fontFamily: 'uthmanic2',
                        fontSize: 22,
                        height: 1.2,
                        color: Get.theme.colorScheme.inversePrimary,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  static Widget _buttonsBuild(AyahModel ayah, int pageIndex, SurahModel surah) {
    return Container(
      width: Get.width,
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: Get.theme.colorScheme.primary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TafsirButton(ayah: ayah, pageIndex: pageIndex, withBack: true),
          const Gap(12),
          PlayButton(
            ayah: ayah,
            surah: surah,
            singleAyahOnly: true,
            withBack: true,
          ),
          const Gap(12),
          // full surah playButton
          PlayButton(surah: surah, ayah: ayah, withBack: true),
          const Gap(12),
          AddBookmarkButton(surah: surah, ayah: ayah, pageIndex: pageIndex),
          const Gap(12),
          CopyButton(ayah: ayah, surah: surah),
          const Gap(15),
          ShareAyahOptions(ayah: ayah, surah: surah, pageNumber: pageIndex),
        ],
      ),
    );
  }
}
