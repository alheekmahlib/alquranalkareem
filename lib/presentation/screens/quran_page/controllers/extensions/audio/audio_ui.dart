part of '../../../quran.dart';

extension AudioUi on AudioCtrl {
  /// -------- [Getters] ----------

  AyahDownloadManagerStyle get ayahDownloadManagerStyle =>
      AyahDownloadManagerStyle.defaults(
        isDark: ThemeController.instance.isDarkMode,
        context: Get.context!,
      ).copyWith(
        avatarDownloadedColor: Get.theme.colorScheme.surface,
        avatarUndownloadedColor: Get.theme.colorScheme.surface.withValues(
          alpha: .5,
        ),
        backgroundColor: Get.theme.colorScheme.primary,
        downloadForeground: Get.theme.colorScheme.surface,
        downloadBackground: Get.theme.colorScheme.surface,
        handleColor: Get.theme.hintColor,
        itemVerticalPadding: 2.0,
        progressBackgroundColor: Get.theme.colorScheme.surface.withValues(
          alpha: .2,
        ),
        surahSubtitleStyle: AppTextStyles.titleSmall(),
        surahTitleStyle: TextStyle(
          color: Get.theme.colorScheme.inversePrimary,
          fontFamily: "surahName",
          fontSize: 30,
          height: 1.2,
          fontFamilyFallback: const ["surahName"],
          inherit: false,
          package: "quran_library",
        ),
        progressColor: Get.theme.colorScheme.surface,
        headerIcon: Column(
          children: [
            Container(
              width: 70,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(Get.context!).canvasColor,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const Gap(8),
            Get.context!.hDivider(
              color: Theme.of(Get.context!).colorScheme.secondaryContainer,
              height: 1,
              width: 70,
            ),
            Text(
              'manager_ayah_downloads'.tr,
              style: AppTextStyles.titleMedium(),
            ),
            const Gap(8),
          ],
        ),
      );

  AyahAudioStyle get ayahAudioStyle =>
      AyahAudioStyle.defaults(
        isDark: ThemeController.instance.isDarkMode,
        context: Get.context!,
      ).copyWith(
        playIconColor: Get.theme.colorScheme.surface,
        backgroundColor: Get.theme.colorScheme.primary,
        dialogBackgroundColor: Get.theme.colorScheme.primaryContainer,
        dialogReaderTextColor: Get.theme.colorScheme.inversePrimary,
        textColor: Get.theme.colorScheme.inversePrimary,
        readerNameInItemColor: Get.theme.colorScheme.inversePrimary,
        dialogSelectedReaderColor: Get.theme.colorScheme.surface,
        dialogUnSelectedReaderColor: Colors.transparent,
        dialogHeaderTitleColor: Get.theme.colorScheme.inversePrimary,
        currentReaderColor: Get.theme.hintColor,
        currentReaderTextStyle: AppTextStyles.titleMedium(
          color: Get.theme.hintColor,
          fontWeight: FontWeight.w500,
          height: 1.2,
        ),
        tabLabelStyle: AppTextStyles.titleMedium(),
        headerDialogTitleStyle: AppTextStyles.titleLarge(height: 1),
        readerDialogTitleStyle: AppTextStyles.titleMedium(),
        dialogHeaderBackgroundGradient: LinearGradient(
          colors: [
            Get.theme.colorScheme.surface.withValues(alpha: .5),
            Get.theme.colorScheme.primaryContainer,
          ],
        ),
        tabIndicatorColor: Get.theme.colorScheme.surface,
        dialogCloseIconColor: Get.theme.colorScheme.inversePrimary,
        tabLabelColor: Get.theme.colorScheme.inversePrimary,
        tabUnselectedLabelColor: Get.theme.colorScheme.inversePrimary
            .withValues(alpha: .5),
        readerDropdownWidget: const SizedBox().customSvgWithColor(
          SvgPath.svgHomeArrowDown,
          color: Get.theme.colorScheme.surface,
          height: 10,
        ),
      );
}
