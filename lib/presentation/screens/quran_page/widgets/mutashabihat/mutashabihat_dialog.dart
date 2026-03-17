import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:quran_library/quran.dart';

import '/core/utils/constants/extensions/extensions.dart';
import '/core/utils/constants/svg_constants.dart';
import '/core/utils/helpers/app_text_styles.dart';
import '/core/widgets/title_widget.dart';
import '/presentation/controllers/general/general_controller.dart';
import '/presentation/controllers/theme_controller.dart';
import '../../../../../core/utils/constants/extensions/alignment_rotated_extension.dart';
import '../../../../../core/utils/constants/extensions/convert_number_extension.dart';
import '../../../../../core/utils/constants/extensions/custom_error_snackBar.dart';
import '../../../../../core/utils/constants/extensions/svg_extensions.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/expansion_tile_widget.dart';
import '../../controllers/mutashabihat_controller.dart';
import '../../data/models/mutashabihat_model.dart';
import '../../quran.dart';

/// Dialog widget for displaying mutashabihat (similar) phrases
class MutashabihatBottomSheet extends StatelessWidget {
  final int surahNumber;
  final int ayahNumber;

  const MutashabihatBottomSheet({
    super.key,
    required this.surahNumber,
    required this.ayahNumber,
  });

  /// Show the mutashabihat dialog
  static void show({
    required BuildContext context,
    required int surahNumber,
    required int ayahNumber,
  }) {
    final controller = MutashabihatController.instance;
    controller.loadMutashabihat(surahNumber, ayahNumber);
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      constraints: BoxConstraints(
        // maxHeight: Get.height * 0.85,
        maxWidth: context.customOrientation(Get.width, Get.width * .5),
      ),
      builder: (context) => MutashabihatBottomSheet(
        surahNumber: surahNumber,
        ayahNumber: ayahNumber,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = MutashabihatController.instance;
    final isDark = ThemeController.instance.isDarkMode;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 8,
          width: 350,
          margin: const EdgeInsets.symmetric(horizontal: 62.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Theme.of(context).primaryColorLight,
          ),
        ),
        const Gap(8.0),
        Flexible(
          child: Container(
            width: Get.width,
            // constraints: BoxConstraints(maxHeight: Get.height * 0.85),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Gap(8.0),
                context.customArrowDown(),
                const Gap(16.0),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: TitleWidget(
                    title: 'mutashabihat'.tr,
                    horizontalPadding: 8.0,
                    textStyle: AppTextStyles.titleLarge(),
                  ),
                ),
                const Gap(8.0),

                // Header with title and navigation arrows
                Obx(() {
                  final hasNext = controller.hasNext;
                  final hasPrev = controller.hasPrevious;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        if (hasNext || hasPrev)
                          _NavArrow(
                            icon: Icons.arrow_back_ios_rounded,
                            enabled: hasPrev,
                            onTap: controller.navigateToPrevious,
                          ),
                        Expanded(
                          child: Obx(
                            () => Text(
                              '${'mutashabihat'.tr} (${'${controller.currentAyahNumber.value}'.convertNumbersToCurrentLang()})',
                              style: AppTextStyles.titleMedium(),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        if (hasNext || hasPrev)
                          _NavArrow(
                            icon: Icons.arrow_forward_ios_rounded,
                            enabled: hasNext,
                            onTap: controller.navigateToNext,
                          ),
                      ],
                    ),
                  );
                }),

                // Content
                Flexible(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Padding(
                        padding: EdgeInsets.all(40),
                        child: CircularProgressIndicator(),
                      );
                    }

                    final result = controller.currentResult.value;
                    if (result == null || !result.hasPhrases) {
                      return Padding(
                        padding: const EdgeInsets.all(40),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            customSvgWithColor(
                              SvgPath.svgAlert,
                              width: 48,
                              height: 48,
                              color: context.theme.colorScheme.surface
                                  .withValues(alpha: 0.8),
                            ),
                            const Gap(16),
                            Text(
                              'no_mutashabihat'.tr,
                              style: AppTextStyles.titleMedium(),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    }

                    // Get the current ayah text
                    final quranCtrl = QuranController.instance;
                    final ayah = quranCtrl.state.allAyahs.firstWhereOrNull(
                      (a) =>
                          a.surahNumber ==
                              controller.currentSurahNumber.value &&
                          a.ayahNumber == controller.currentAyahNumber.value,
                    );

                    return AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: Container(
                        width: Get.width,
                        padding: const EdgeInsets.all(4.0),
                        margin: const EdgeInsets.symmetric(
                          vertical: 4.0,
                          horizontal: 8.0,
                        ),
                        decoration: BoxDecoration(
                          color: context.theme.primaryColorLight.withValues(
                            alpha: 0.1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListView(
                          shrinkWrap: true,
                          padding: const EdgeInsets.all(4),
                          children: [
                            for (int i = 0; i < result.phrases.length; i++)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: _PhraseExpansionCard(
                                  index: i,
                                  phraseResult: result.phrases[i],
                                  currentVerseKey:
                                      '${controller.currentSurahNumber.value}:${controller.currentAyahNumber.value}',
                                  ayahText: ayah?.text ?? '',
                                  isDark: isDark,
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
                const Gap(16.0),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Navigation arrow button
class _NavArrow extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  const _NavArrow({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Icon(
          icon,
          size: 20,
          color: enabled
              ? context.theme.colorScheme.inverseSurface
              : context.theme.colorScheme.surface.withValues(alpha: 0.4),
        ),
      ),
    );
  }
}

/// Expansion card for a single phrase — uses ExpansionTileWidget
class _PhraseExpansionCard extends StatelessWidget {
  final int index;
  final MutashabihatPhraseResult phraseResult;
  final String currentVerseKey;
  final String ayahText;
  final bool isDark;

  const _PhraseExpansionCard({
    required this.index,
    required this.phraseResult,
    required this.currentVerseKey,
    required this.ayahText,
    required this.isDark,
  });

  String _extractPhrase() {
    final positions = phraseResult.wordPositions;
    if (positions.length < 2) return '';
    final from = positions[0];
    final to = positions[1];
    final words = ayahText.trim().split(RegExp(r'\s+'));
    if (from < 0 || to > words.length) return '';
    return words.sublist(from, to).join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final controller = MutashabihatController.instance;
    final phrase = phraseResult.phrase;
    final phraseText = _extractPhrase();

    // Parse source key
    final sourceParts = phrase.source.key.split(':');
    final sourceSurahNumber = int.tryParse(sourceParts[0]) ?? 0;
    final sourceAyahNumber =
        int.tryParse(sourceParts.length > 1 ? sourceParts[1] : '') ?? 0;
    final sourceAyah = QuranController.instance.state.allAyahs.firstWhereOrNull(
      (a) =>
          a.surahNumber == sourceSurahNumber &&
          a.ayahNumber == sourceAyahNumber,
    );
    final sourcePage = sourceAyah?.page ?? 0;
    final sourceSurah = QuranCtrl.instance.surahs.firstWhereOrNull(
      (s) => s.surahNumber == sourceSurahNumber,
    );
    final sourceSurahName =
        sourceSurah?.arabicName.replaceAll('سُورَةُ ', '') ?? '';

    final expansionName = 'mutashabihat_phrase_$index';

    return ExpansionTileWidget<MutashabihatController>(
      name: expansionName,
      manager: GeneralController.instance.state.expansionManager,
      getxCtrl: controller,
      backgroundColor: context.theme.primaryColorLight.withValues(alpha: 0.2),
      titleChild: Row(
        children: [
          // Ayah number ornament
          Stack(
            alignment: Alignment.center,
            children: [
              RepaintBoundary(
                child: const SizedBox().customSvgWithColor(
                  height: 54,
                  width: 54,
                  SvgPath.svgQuranSurahNumberZakhrafa,
                  color: context.theme.colorScheme.primaryContainer,
                ),
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    '$sourceAyahNumber'.convertNumbersToCurrentLang(),
                    style: AppTextStyles.titleSmall(),
                  ),
                ),
              ),
            ],
          ),
          const Gap(8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  phraseText,
                  style: TextStyle(
                    fontFamily: 'uthmanic2',
                    fontSize: 20,
                    height: 1.8,
                    color: Get.theme.colorScheme.inversePrimary,
                    package: 'quran_library',
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const Gap(2),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    _InfoChip(
                      label: 'repeated'.tr,
                      value: '${phrase.count}'.convertNumbersToCurrentLang(),
                    ),
                    _InfoChip(
                      label: 'surahs'.tr,
                      value: '${phrase.surahsCount}'
                          .convertNumbersToCurrentLang(),
                    ),
                    _InfoChip(
                      label: 'ayahs'.tr,
                      value: '${phrase.ayahsCount}'
                          .convertNumbersToCurrentLang(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      child: Column(
        children: [
          // Source info row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _InfoChip(
                      label: 'page'.tr,
                      value: '$sourcePage'.convertNumbersToCurrentLang(),
                    ),
                    const Gap(6),
                    _InfoChip(label: 'surah'.tr, value: sourceSurahName),
                  ],
                ),
                // Copy button
                CustomButton(
                  onPressed: () {
                    controller.copyPhraseToClipboard(phraseResult, phraseText);
                    context.showCustomErrorSnackBar(
                      'copyAyah'.tr,
                      isDone: true,
                    );
                  },
                  height: 30,
                  width: 40,
                  iconSize: 30,
                  verticalPadding: 2.0,
                  isCustomSvgColor: true,
                  svgPath: SvgPath.svgQuranCopy,
                  svgColor: context.theme.colorScheme.primary,
                ),
              ],
            ),
          ),
          // Similar verses list
          ...phraseResult.similarVerses.map(
            (verse) => Padding(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: _SimilarVerseTile(
                verse: verse,
                phrase: phrase,
                isDark: isDark,
              ),
            ),
          ),
          const Gap(4),
        ],
      ),
    );
  }
}

/// Small info chip for stats
class _InfoChip extends StatelessWidget {
  final String label;
  final String value;

  const _InfoChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label:',
            style: AppTextStyles.bodySmall(
              fontSize: 14,
              color: context.theme.colorScheme.inversePrimary.withValues(
                alpha: 0.8,
              ),
            ),
          ),
          const Gap(3),
          Text(value, style: AppTextStyles.titleSmall(fontSize: 14)),
        ],
      ),
    );
  }
}

/// Tile for a similar verse — shows highlighted verse text and navigation
class _SimilarVerseTile extends StatelessWidget {
  final SimilarVerseModel verse;
  final MutashabihatPhraseModel phrase;
  final bool isDark;

  const _SimilarVerseTile({
    required this.verse,
    required this.phrase,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final ayah = QuranController.instance.state.allAyahs.firstWhereOrNull(
      (a) =>
          a.surahNumber == verse.surahNumber &&
          a.ayahNumber == verse.ayahNumber,
    );
    final page = ayah?.page ?? 0;

    // تحديد نطاق كلمات العبارة المشتركة
    ({int fromWord, int toWord})? wordsRange;
    if (verse.positions.isNotEmpty && verse.positions.first.length >= 2) {
      final pos = verse.positions.first;
      wordsRange = (
        fromWord: pos[0] + 1, // تحويل من 0-based إلى 1-based
        toWord: pos[1],
      );
    }

    return InkWell(
      onTap: () {
        if (page > 0) {
          Get.back();
          QuranController.instance.changeSurahListOnTap(page);
        }
      },
      child: Container(
        width: Get.width,
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
        decoration: BoxDecoration(
          color: context.theme.colorScheme.primaryContainer.withValues(
            alpha: 0.7,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Surah name, ayah number, page
            Row(
              children: [
                Text(
                  'surah${verse.surahNumber.toString().padLeft(3, '0')} ',
                  style: TextStyle(
                    color: context.theme.colorScheme.inversePrimary,
                    letterSpacing: 5,
                    fontFamily: "surah-name-v4",
                    fontSize: 26,
                    package: "quran_library",
                  ),
                ),
                const Spacer(),
                Text(
                  '${'page'.tr}: ${'$page'.convertNumbersToCurrentLang()}',
                  style: AppTextStyles.bodySmall(),
                ),
                const Gap(4),
                RotatedBox(
                  quarterTurns: alignmentLayout(1, 3),
                  child: customSvgWithColor(
                    SvgPath.svgHomeArrowDown,
                    width: 14,
                    height: 14,
                    color: context.theme.colorScheme.surface,
                  ),
                ),
              ],
            ),
            const Gap(4),
            // عرض الآية بخط QPC مع تظليل كلمات العبارة المشتركة
            GetSingleAyah(
              surahNumber: verse.surahNumber,
              ayahNumber: verse.ayahNumber,
              isDark: isDark,
              textHeight: 2,
              fontSize: 22,
              enabledTajweed: QuranCtrl.instance.state.isTajweedEnabled.value,
              enableWordSelection: wordsRange != null,
              selectedWordsRange: wordsRange,
              showAyahNumber: false,
              selectedWordColor: context.theme.colorScheme.surface.withValues(
                alpha: 0.4,
              ),
              textAlign: TextAlign.right,
            ),
          ],
        ),
      ),
    );
  }
}
