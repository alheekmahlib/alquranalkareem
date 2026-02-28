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
        surahSubtitleStyle: AppTextStyles.titleSmall(
          color: Get.theme.canvasColor,
        ),
        surahTitleStyle: TextStyle(
          color: Get.theme.canvasColor,
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
              style: TextStyle(
                color: Theme.of(Get.context!).canvasColor,
                fontFamily: 'kufi',
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
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
        dialogBackgroundColor: Get.theme.primaryColor,
        dialogReaderTextColor: Get.theme.canvasColor,
        textColor: Get.theme.colorScheme.inversePrimary,
        readerNameInItemColor: Get.theme.canvasColor,
        dialogSelectedReaderColor: Get.theme.colorScheme.surface,
        dialogUnSelectedReaderColor: Colors.transparent,
        dialogHeaderTitleColor: Get.theme.canvasColor,
        currentReaderColor: Get.theme.hintColor,
        currentReaderTextStyle: AppTextStyles.titleMedium(
          color: Get.theme.hintColor,
          fontWeight: FontWeight.w500,
          height: 1.2,
        ),
        tabLabelStyle: AppTextStyles.titleMedium(),
        headerDialogTitleStyle: AppTextStyles.titleLarge(
          color: Get.theme.canvasColor,
          height: 1,
        ),
        readerDialogTitleStyle: AppTextStyles.titleMedium(
          color: Get.theme.canvasColor,
        ),
        dialogHeaderBackgroundGradient: LinearGradient(
          colors: [
            Get.theme.colorScheme.surface.withValues(alpha: .5),
            Colors.transparent,
          ],
        ),
        tabIndicatorColor: Get.theme.colorScheme.surface,
        dialogCloseIconColor: Get.theme.canvasColor,
        tabLabelColor: Get.theme.canvasColor,
        tabUnselectedLabelColor: Get.theme.canvasColor.withValues(alpha: .5),
      );
}
