import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:quran_library/quran.dart';

import '/core/tour/app_tour.dart';
import '/core/tour/mushaf_tour_script.dart';
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
import '../../widgets/mutashabihat/mutashabihat_bottom_sheet.dart';
import '../../widgets/mutashabihat/mutashabihat_browse_sheet.dart';
import '../../widgets/search/controller/quran_search_controller.dart';

class AyahMenuHelper {
  const AyahMenuHelper._();

  static Worker? _playbackWorker;
  static StreamSubscription<int?>? _indexSubscription;
  static final ScrollController _ayahScrollController = ScrollController();

  /// هل صفحة الخيارات ظاهرة الآن؟ تقرأها جولة المصحف (MushafTourScript) لتعرف
  /// أن تشرح داخلها. يُضبط عند الفتح، ويسقط حين يُفكّ محتوى الورقة (_SheetTracker)
  /// كيفما أُغلقت: سحباً، أو زر رجوع، أو إزالة المسار.
  static bool get isOpen => _isOpen;
  static bool _isOpen = false;

  /// آخر ما فُتحت له الورقة: يُعاد الفتح به إن طلبت الجولة ذلك راجعة.
  static ({SurahModel surah, AyahModel ayah, int pageIndex})? _lastOpened;

  /// سياق داخل الورقة (نسخة قياسها أو نسختها الظاهرة) لتُغلق من داخله.
  static BuildContext? _sheetContext;

  /// family_bottom_sheet تركّب صفحة الورقة مرتين، فيوجد من المتتبع حالتان.
  static final Set<_SheetTrackerState> _trackers = {};

  static AppTour? get _tour =>
      Get.isRegistered<AppTour>() ? AppTour.instance : null;

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

    _lastOpened = (surah: surah, ayah: ayah, pageIndex: pageIndex);
    // قبل الدفع: تقرأه الجولة فور فتح الورقة بالضغطة المطوّلة.
    _isOpen = true;

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
      _SheetTracker(
        child: Column(
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
              key: MushafTourKeys.wordInfo,
              height: 191.h,
              width: Get.width,
              alignment: .centerStart,
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
      ),
    );

    // الجولة تنتظر الضغطة المطوّلة: فتح الورقة ينقلها إلى شرح ما فيها.
    _tour?.onAyahMenuOpened();
  }

  /// يعيد فتح الورقة بآخر آية فُتحت لها، وبأول آية في الصفحة الحالية إن لم
  /// تُفتح من قبل. لا تفعل شيئاً وهي مفتوحة. يستدعيها مشهد الجولة حين يعود
  /// المستخدم بـ«السابق» إلى خطوات داخل الورقة.
  static void reopenLast() {
    if (_isOpen) return;
    final context = Get.context;
    if (context == null) return;
    final last = _lastOpened;
    if (last != null) {
      show(
        context,
        surah: last.surah,
        ayah: last.ayah,
        pageIndex: last.pageIndex,
      );
      return;
    }
    final quranCtrl = QuranCtrl.instance;
    final page = quranCtrl.state.currentPageNumber.value;
    final ayahs = quranCtrl.getPageAyahsByIndex(page - 1);
    if (ayahs.isEmpty) return;
    show(
      context,
      surah: quranCtrl.getCurrentSurahByPageNumber(page),
      ayah: ayahs.first,
      // الأزرار داخل الورقة تتعامل مع فهرس صفحة يبدأ من صفر.
      pageIndex: page - 1,
    );
  }

  /// يغلق الورقة إن كانت مفتوحة، من سياقها هي، فلا يُغلق طريقاً آخر فوقها.
  static void close() {
    final context = _sheetContext;
    if (!_isOpen || context == null || !context.mounted) return;
    Navigator.of(context).pop();
  }

  /// آخر نسخة من محتوى الورقة فُكّت: الورقة لم تعد ظاهرة.
  static void _onSheetGone() {
    _isOpen = false;
    _sheetContext = null;
    // قد يحدث التفكيك أثناء بناء الشاشة (إزالة المسارات كلها)، فالإعلام
    // في إطار لاحق. كانت الجولة تشرح داخل الورقة؟ تعود إلى خطوة الضغط.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _tour?.onAyahMenuClosed();
    });
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
          key: MushafTourKeys.ayahText,
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
                            key: MushafTourKeys.playWord,
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
                            key: MushafTourKeys.playAyahWords,
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
                            key: MushafTourKeys.searchWord,
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
            // مفاتيح الجولة (MushafTourKeys) عادية لا GlobalKey: هذا المحتوى
            // مركّب مرتين داخل الورقة (نسخة قياس ونسخة ظاهرة).
            TafsirButton(
              key: MushafTourKeys.tafsir,
              ayah: ayah,
              pageIndex: pageIndex,
              withBack: true,
            ),
            const Gap(12),
            PlayButton(
              key: MushafTourKeys.playAyah,
              ayah: ayah,
              surah: surah,
              singleAyahOnly: true,
              withBack: true,
            ),
            const Gap(12),
            // full surah playButton
            PlayButton(
              key: MushafTourKeys.playSurah,
              surah: surah,
              ayah: ayah,
              withBack: true,
            ),
            const Gap(12),
            AddBookmarkButton(
              key: MushafTourKeys.addAyahBookmark,
              surah: surah,
              ayah: ayah,
              pageIndex: pageIndex,
            ),
            const Gap(12),
            CopyButton(key: MushafTourKeys.copy, ayah: ayah, surah: surah),
            const Gap(15),
            ShareAyahOptions(
              key: MushafTourKeys.share,
              ayah: ayah,
              surah: surah,
              pageNumber: pageIndex,
              singleAyahMode: false,
            ),
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
                      key: MushafTourKeys.mutashabihat,
                      height: 40,
                      width: 35,
                      iconSize: 35,
                      isCustomSvgColor: true,
                      svgPath: SvgPath.svgQuranMutashabihat,
                      svgColor: Get.theme.canvasColor,
                      onPressed: () {
                        if (count > 0) {
                          MutashabihatBottomSheet.show(
                            context: context,
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
    scrollToWord(
      _ayahScrollController,
      wordNumber: ref.wordNumber,
      totalWords: WordAudioService.instance.getAyahWordCount(
        ref.surahNumber,
        ref.ayahNumber,
      ),
    );
  }

  /// يحرّك شريط كلمات الآية إلى الكلمة الجاري تشغيلها.
  ///
  /// family_bottom_sheet تركّب صفحة الورقة مرتين (نسخة Offstage لقياس
  /// الارتفاع ونسخة ظاهرة)، فقد يكون الـ [controller] مرتبطًا بعدة مواضع
  /// في آنٍ واحد؛ لذا نحرّك كل المواضع بدل قراءة .position التي تفترض
  /// موضعًا واحدًا وترمي AssertionError.
  @visibleForTesting
  static void scrollToWord(
    ScrollController controller, {
    required int wordNumber,
    required int totalWords,
  }) {
    if (!controller.hasClients || totalWords <= 1) return;
    for (final position in List.of(controller.positions)) {
      final maxScroll = position.maxScrollExtent;
      if (maxScroll <= 0) continue;
      final targetScroll = maxScroll * (wordNumber - 1) / (totalWords - 1);
      position.animateTo(
        targetScroll.clamp(0.0, maxScroll),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }
}

/// يتتبّع وجود صفحة الخيارات في الشجعة، فيبقى [AyahMenuHelper.isOpen]
/// صادقاً كيفما أُغلقت الورقة أو أُزيحت صفحتها: الاعتماد على وعد إغلاق
/// الطريق لا يكفي، فقد لا يكتمل حين يُزال المسار كله (Get.offAll).
///
/// family_bottom_sheet تركّب المحتوى مرتين (نسخة قياس ونسخة ظاهرة)، فيوجد
/// من هذا الودجت حالتان؛ تبقى الورقة قائمة ما بقيت إحداهما.
class _SheetTracker extends StatefulWidget {
  const _SheetTracker({required this.child});

  final Widget child;

  @override
  State<_SheetTracker> createState() => _SheetTrackerState();
}

class _SheetTrackerState extends State<_SheetTracker> {
  @override
  void initState() {
    super.initState();
    AyahMenuHelper._trackers.add(this);
    // قد تعود صفحة الخيارات بعد صفحة داخل الورقة نفسها (التفسير، المشاركة).
    AyahMenuHelper._isOpen = true;
    AyahMenuHelper._sheetContext = context;
  }

  @override
  void dispose() {
    AyahMenuHelper._trackers.remove(this);
    if (AyahMenuHelper._trackers.isEmpty) AyahMenuHelper._onSheetGone();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
