part of '../quran.dart';

/// An extension on the `void` type to provide additional functionality
/// related to Surah information.
///
/// This extension is intended to add methods and properties that
/// enhance the handling and manipulation of Surah data within the
/// application.
extension SurahInfoExtension on void {
  /// Displays a bottomSheet widget with information about a specific Surah.
  ///
  /// This method shows a dialog containing details about the Surah specified
  /// by the [surahNumber]. The dialog is displayed in the given [context].
  ///
  /// Example:
  /// ```dart
  /// surahInfoDialogWidget(context, 1); // Displays information about Surah Al-Fatiha
  /// ```
  ///
  /// [context]: The BuildContext in which to display the bottomSheet.
  /// [surahNumber]: The number of the Surah to display information about.
  void surahInfoBottomSheet(
    BuildContext context,
    int surahNumber, {
    SurahInfoStyle? surahStyle,
    String? languageCode,
    Size? deviceWidth,
    bool isDark = false,
  }) {
    final quranCtrl = QuranCtrl.instance;
    final surah = quranCtrl.surahsList[surahNumber];
    BottomSheetExtension(null).customBottomSheet(
      backgroundColor: Get.theme.colorScheme.primaryContainer,
      ConstrainedBox(
        constraints: BoxConstraints(maxHeight: Get.height * 0.7),
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          const SizedBox().customSvgWithColor(
                            AssetsPath.assets.suraNum,
                            height: 70,
                            width: 70,
                            color: context.theme.colorScheme.surface.withValues(
                              alpha: 0.4,
                            ),
                          ),
                          Text(
                            '${surah.number}'.convertNumbersToCurrentLang(),
                            style: AppTextStyles.titleLarge(),
                          ),
                        ],
                      ),
                      const Gap(4),
                      Container(
                        decoration: BoxDecoration(
                          color: context.theme.colorScheme.surface.withValues(
                            alpha: 0.4,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          '${surah.number}',
                          style: TextStyle(
                            color: context.theme.colorScheme.inversePrimary,
                            fontFamily: "surahName",
                            fontSize: 38,
                            height: 1.4,
                            inherit: false,
                            fontFamilyFallback: ['surahName'],
                            package: "quran_library",
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        surah.revelationType.tr,
                        style: AppTextStyles.titleMedium(),
                      ),
                      Text(
                        ' - ${'aya_count'.tr}: ${surah.ayahsNumber}'
                            .convertNumbersToCurrentLang(),
                        style: AppTextStyles.titleMedium(),
                      ),
                    ],
                  ),
                ],
              ),
              const Gap(8),
              Expanded(
                child: DefaultTabController(
                  length: 2,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 38,
                        margin: const EdgeInsets.symmetric(horizontal: 8.0),
                        decoration: BoxDecoration(
                          color: context.theme.primaryColorDark.withValues(
                            alpha: .1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TabBar(
                          unselectedLabelColor: Colors.grey,
                          indicatorSize: TabBarIndicatorSize.tab,
                          dividerColor: Colors.transparent,
                          indicatorColor: context.theme.primaryColorDark
                              .withValues(alpha: .4),
                          indicatorWeight: 3,
                          labelStyle: AppTextStyles.titleSmall(height: 2.8),
                          unselectedLabelStyle: AppTextStyles.titleSmall(
                            height: 2.8,
                          ),
                          indicatorPadding: const EdgeInsets.all(4),
                          indicator: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8),
                            ),
                            color: context.theme.primaryColorDark.withValues(
                              alpha: .4,
                            ),
                          ),
                          tabs: [
                            Tab(text: 'surahNames'.tr),
                            Tab(text: 'aboutSurah'.tr),
                          ],
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          children: <Widget>[
                            // تبويب أسماء السورة
                            SingleChildScrollView(
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 8,
                                ),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: context.theme.primaryColorDark
                                      .withValues(alpha: .1),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: ArabicJustifiedRichText(
                                  excludedWords: const ['محمد'],
                                  textSpan: TextSpan(
                                    children: [
                                      TextSpan(
                                        children: surah.surahNames
                                            .customTextSpans(),
                                        style: AppTextStyles.titleMedium(),
                                      ),
                                      TextSpan(
                                        children: surah.surahNamesFromBook
                                            .customTextSpans(),
                                        style: AppTextStyles.titleMedium(),
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                            ),
                            // تبويب عن السورة
                            SingleChildScrollView(
                              child: Container(
                                width: Get.width,
                                margin: const EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 8,
                                ),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: context.theme.primaryColorDark
                                      .withValues(alpha: .1),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: ArabicJustifiedRichText(
                                  excludedWords: const ['محمد'],
                                  textSpan: TextSpan(
                                    children: [
                                      TextSpan(
                                        children: surah.surahInfo
                                            .customTextSpans(),
                                        style: AppTextStyles.titleMedium(),
                                      ),
                                      TextSpan(
                                        children: surah.surahInfoFromBook
                                            .customTextSpans(),
                                        style: AppTextStyles.titleMedium(),
                                      ),
                                      TextSpan(
                                        children: surah.surahInfoFromBook
                                            .customTextSpans(),
                                        style: AppTextStyles.titleMedium(),
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
