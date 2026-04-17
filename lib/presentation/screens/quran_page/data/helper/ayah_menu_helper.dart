import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:quran_library/quran.dart';

import '/core/utils/constants/extensions/extensions.dart';
import '/core/utils/helpers/app_text_styles.dart';
import '/core/widgets/container_button.dart';
import '/core/widgets/share/share_ayah_options.dart';
import '/presentation/controllers/theme_controller.dart';
import '../../../../../core/utils/constants/extensions/bottom_sheet_extension.dart';
import '../../../../../core/utils/constants/extensions/convert_number_extension.dart';
import '../../../../../core/utils/constants/svg_constants.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/tab_bar_widget.dart';
import '../../controllers/mutashabihat_controller.dart';
import '../../quran.dart';
import '../../widgets/mutashabihat/mutashabihat_browse_sheet.dart';
import '../../widgets/mutashabihat/mutashabihat_dialog.dart';
import '../../widgets/search/controller/quran_search_controller.dart';

class AyahMenuHelper {
  const AyahMenuHelper._();

  static Worker? _playbackWorker;
  static StreamSubscription<int?>? _indexSubscription;
  static final ScrollController _ayahScrollController = ScrollController();

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

    // تتبع الكلمة الحالية عبر currentIndexStream مباشرة
    final svc = WordAudioService.instance;
    _playbackWorker?.dispose();
    _playbackWorker = null;
    _indexSubscription?.cancel();
    _indexSubscription = null;

    // عند بدء تشغيل كلمات الآية، نستمع لتغيّر الفهرس
    _playbackWorker = ever(svc.isPlayingAyahWords, (playing) {
      if (playing) {
        _indexSubscription?.cancel();
        _indexSubscription = svc.player.currentIndexStream.listen((index) {
          if (index != null && svc.isPlayingAyahWords.value) {
            final ref = WordRef(
              surahNumber: surah.surahNumber,
              ayahNumber: ayah.ayahNumber,
              wordNumber: index + 1,
            );
            quranCtrl.state.ref.value = ref;
            svc.currentPlayingRef.value = ref;
            WordInfoCtrl.instance.update(['word_info_kind']);
            QuranCtrl.instance.update([
              'single_ayah_${surah.surahNumber}-${ayah.ayahNumber}',
            ]);
            _scrollToCurrentWord(ref, ayah);
          }
        });
      } else {
        _indexSubscription?.cancel();
        _indexSubscription = null;
      }
    });

    BottomSheetExtension(null).customBottomSheet(
      backgroundColor: Get.theme.colorScheme.primaryContainer,
      handleChild: context.customOrientation(
        Text(
          '${'${ayah.ayahNumber}'.convertEnglishNumbersToArabic(ayah.ayahNumber.toString())}',
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
            child: _ayahBuild(
              surah,
              ayah,
              quranCtrl,
              wordCtrl,
              pageIndex,
              isDark,
            ),
          ),
          const Gap(8),
          Container(
            height: 191.h,
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
                  controller: _ayahScrollController,
                  scrollDirection: Axis.horizontal,
                  child: Obx(() {
                    final svc = WordAudioService.instance;
                    final playingRef =
                        (svc.isPlayingAyahWords.value &&
                            svc.currentPlayingRef.value != null &&
                            svc.currentPlayingRef.value!.wordNumber > 0)
                        ? svc.currentPlayingRef.value
                        : null;
                    return GetSingleAyah(
                      surahNumber: surah.surahNumber,
                      ayahNumber: ayah.ayahNumber,
                      enableWordSelection: true,
                      isDark: isDark,
                      enabledTajweed:
                          QuranCtrl.instance.state.isTajweedEnabled.value,
                      externalSelectedWordRef: playingRef,
                      onWordTap: (ref) {
                        quranCtrl.state.ref.value = ref;
                        print(
                          'سورة: ${ref.surahNumber}, آية: ${ref.ayahNumber}, كلمة: ${ref.wordNumber}',
                        );
                        WordInfoCtrl.instance.update(['word_info_kind']);
                      },
                      selectedWordColor: Colors.amber.withValues(alpha: 0.3),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
        const Gap(8),
        GetBuilder<WordInfoCtrl>(
          id: 'word_info_kind',
          builder: (wordCtrl) {
            final words = ayah.text
                .trim()
                .split(RegExp(r'\s+'))
                .where((w) => RegExp(r'[\u0620-\u064A]').hasMatch(w))
                .toList();
            final wordsSearch = ayah.ayaTextEmlaey
                .trim()
                .split(RegExp(r'\s+'))
                .where((w) => RegExp(r'[\u0620-\u064A]').hasMatch(w))
                .toList();
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
      child: FittedBox(
        fit: BoxFit.scaleDown,
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
            const Gap(15),
            // Mutashabihat button - shows similar verses
            Builder(
              builder: (context) {
                final count = MutashabihatController.instance
                    .getPhrasesCountForVerse(
                      surah.surahNumber,
                      ayah.ayahNumber,
                    );
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    CustomButton(
                      height: 40,
                      width: 35,
                      iconSize: 35,
                      isCustomSvgColor: true,
                      svgPath: SvgPath.svgQuranMutashabihat,
                      svgColor: Get.theme.canvasColor,
                      onPressed: () {
                        if (Get.context != null && count > 0) {
                          MutashabihatBottomSheet.show(
                            context: Get.context!,
                            surahNumber: surah.surahNumber,
                            ayahNumber: ayah.ayahNumber,
                          );
                        } else {
                          MutashabihatBrowseSheet.show(context);
                        }
                      },
                    ),
                    if (count > 0)
                      PositionedDirectional(
                        top: -4,
                        end: -4,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Get.theme.colorScheme.surface,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '$count'.convertNumbersToCurrentLang(),
                            style: AppTextStyles.titleSmall().copyWith(
                              fontSize: 12,
                              color: Get.theme.colorScheme.primaryContainer,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  static void _scrollToCurrentWord(WordRef ref, AyahModel ayah) {
    if (!_ayahScrollController.hasClients) return;
    final totalWords = WordAudioService.instance.getAyahWordCount(
      ref.surahNumber,
      ref.ayahNumber,
    );
    if (totalWords <= 1) return;
    final maxScroll = _ayahScrollController.position.maxScrollExtent;
    final wordIndex = ref.wordNumber - 1;
    final targetScroll = maxScroll * wordIndex / (totalWords - 1);
    _ayahScrollController.animateTo(
      targetScroll.clamp(0.0, maxScroll),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }
}
