part of '../ai_search.dart';

/// Shared files download card (must be downloaded before any section)
class SharedDownloadCard extends StatelessWidget {
  final VoidCallback onDownload;

  const SharedDownloadCard({super.key, required this.onDownload});

  @override
  Widget build(BuildContext context) {
    final ctrl = AiSearchController.instance;
    return Obx(() {
      final isDownloaded = ctrl.state.isSharedLoaded.value;
      final isDownloading = ctrl.state.isSharedDownloading.value;
      final progress = ctrl.state.sharedProgress.value;
      final status = ctrl.state.sharedStatus.value;

      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              color: context.theme.colorScheme.surface.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDownloaded
                    ? context.theme.colorScheme.surface.withValues(alpha: 0.4)
                    : context.theme.colorScheme.error.withValues(alpha: 0.4),
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: isDownloaded
                    ? null
                    : isDownloading
                    ? null
                    : onDownload,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (isDownloading)
                      RoundedProgressBar(
                        height: 70,
                        style: RoundedProgressBarStyle(
                          borderWidth: 0,
                          widthShadow: 0,
                          backgroundProgress: Colors.transparent,
                          colorProgress: context.theme.colorScheme.surface
                              .withValues(alpha: .2),
                          colorProgressDark: Colors.transparent,
                          colorBorder: Colors.transparent,
                          colorBackgroundIcon: Colors.transparent,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8),
                        ),
                        percent: progress > 0 ? progress * 100 : 0.0,
                      ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      isDownloaded
                                          ? Icons.check_circle_rounded
                                          : Icons.memory_rounded,
                                      size: 20,
                                      color: isDownloaded
                                          ? context.theme.colorScheme.surface
                                          : context.theme.colorScheme.error,
                                    ),
                                    const Gap(8),
                                    Text(
                                      isDownloading
                                          ? 'downloading'.tr
                                          : 'sharedFiles'.tr,
                                      style: AppTextStyles.titleMedium(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            context.theme.colorScheme.surface,
                                      ),
                                    ),
                                    const Gap(6),
                                    if (isDownloading)
                                      Text(
                                        '${(progress * 15).toStringAsFixed(1)} / 15 MB'
                                            .convertNumbersToCurrentLang(),
                                        style: AppTextStyles.titleSmall(
                                          fontSize: 11,
                                          color: context
                                              .theme
                                              .colorScheme
                                              .surface
                                              .withValues(alpha: 0.4),
                                        ),
                                      ),
                                  ],
                                ),
                                if (isDownloading && status.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2),
                                    child: Text(
                                      status,
                                      style: AppTextStyles.titleSmall(
                                        fontSize: 11,
                                        color: context.theme.colorScheme.surface
                                            .withValues(alpha: 0.5),
                                      ),
                                    ),
                                  )
                                else
                                  const Gap(2),
                                Text(
                                  'sharedFilesDesc'.tr,
                                  style: AppTextStyles.titleMedium(
                                    fontSize: 12,
                                    color: context.theme.colorScheme.surface
                                        .withValues(alpha: 0.5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Gap(8),
                          if (isDownloaded)
                            CustomButton(
                              onPressed: () => ctrl.deleteShared(),
                              svgPath: SvgPath.svgHomeRemove,
                              height: 35.0,
                              backgroundColor:
                                  context.theme.colorScheme.surface,
                            )
                          else
                            ContainerButton(
                              onPressed: isDownloading
                                  ? () => ctrl.cancelDownload('shared')
                                  : onDownload,
                              height: 35.0,
                              isTitleCentered: true,
                              title: isDownloading
                                  ? 'cancel'.tr
                                  : 'download'.tr +
                                        ' 15 MB'.convertNumbersToCurrentLang(),
                              titleStyle: AppTextStyles.titleSmall(),
                              horizontalPadding: 8.0,
                              verticalPadding: 2.0,
                              backgroundColor: Get.theme.colorScheme.surface,
                              progressColor: Get.theme.colorScheme.primary
                                  .withValues(alpha: .6),
                              progressBackgroundColor: Get
                                  .theme
                                  .colorScheme
                                  .primary
                                  .withValues(alpha: .2),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}

/// Section download card (shown when no sections are loaded)
class SectionDownloadCard extends StatelessWidget {
  final SearchSection section;
  final VoidCallback onDownload;

  SectionDownloadCard({required this.section, required this.onDownload});

  final ctrl = AiSearchController.instance;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isDownloaded = ctrl.state.isSectionLoaded(section.id).value;
      final isSharedReady = ctrl.state.isSharedLoaded.value;
      final isAnyDownloading =
          SearchSection.all.any(
            (s) => ctrl.state.isSectionDownloading(s.id).value,
          ) ||
          ctrl.state.isSharedDownloading.value;
      final activeId = ctrl.state.downloadingSectionId.value;
      final isActive = activeId == section.id;
      final progress = isActive
          ? ctrl.state.sectionProgress(activeId).value
          : 0.0;
      final canDownload = isSharedReady && !isDownloaded && !isAnyDownloading;

      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Opacity(
          opacity: isSharedReady ? 1.0 : 0.4,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              decoration: BoxDecoration(
                color: context.theme.colorScheme.surface.withValues(
                  alpha: 0.06,
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: context.theme.colorScheme.surface.withValues(
                    alpha: isSharedReady ? 0.2 : 0.08,
                  ),
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: canDownload ? onDownload : null,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      if (!isActive) const SizedBox.shrink(),
                      RoundedProgressBar(
                        height: 70,
                        style: RoundedProgressBarStyle(
                          borderWidth: 0,
                          widthShadow: 0,
                          backgroundProgress: Colors.transparent,
                          colorProgress: context.theme.colorScheme.surface
                              .withValues(alpha: .2),
                          colorProgressDark: Colors.transparent,
                          colorBorder: Colors.transparent,
                          colorBackgroundIcon: Colors.transparent,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8),
                        ),
                        percent: isAnyDownloading && progress > 0
                            ? progress * 100
                            : 0.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        isAnyDownloading && isActive
                                            ? 'downloading'.tr
                                            : section.titleAr.tr,
                                        style: AppTextStyles.titleMedium(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              context.theme.colorScheme.surface,
                                        ),
                                      ),
                                      const Gap(6),
                                      isAnyDownloading && isActive
                                          ? Text(
                                              '${(progress * double.parse(section.sizeLabel.replaceAll(' MB', ''))).toStringAsFixed(1)} / ${section.sizeLabel}'
                                                  .convertNumbersToCurrentLang(),
                                              style: AppTextStyles.titleSmall(
                                                fontSize: 11,
                                                color: context
                                                    .theme
                                                    .colorScheme
                                                    .surface
                                                    .withValues(alpha: 0.4),
                                              ),
                                            )
                                          : const SizedBox.shrink(),
                                    ],
                                  ),
                                  // Show download status text
                                  if (isAnyDownloading &&
                                      isActive &&
                                      ctrl.state
                                          .sectionStatus(section.id)
                                          .value
                                          .isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 2),
                                      child: Text(
                                        ctrl.state
                                            .sectionStatus(section.id)
                                            .value,
                                        style: AppTextStyles.titleSmall(
                                          fontSize: 11,
                                          color: context
                                              .theme
                                              .colorScheme
                                              .surface
                                              .withValues(alpha: 0.5),
                                        ),
                                      ),
                                    )
                                  else
                                    const Gap(2),
                                  Text(
                                    section.description.tr,
                                    style: AppTextStyles.titleMedium(
                                      fontSize: 12,
                                      color: context.theme.colorScheme.surface
                                          .withValues(alpha: 0.5),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Gap(8),
                            if (isDownloaded)
                              CustomButton(
                                onPressed: () => ctrl.deleteSection(section),
                                svgPath: SvgPath.svgHomeRemove,
                                height: 35.0,
                                backgroundColor:
                                    context.theme.colorScheme.surface,
                              )
                            else if (!isSharedReady)
                              Icon(
                                Icons.lock_outline_rounded,
                                size: 22,
                                color: context.theme.colorScheme.surface
                                    .withValues(alpha: 0.3),
                              )
                            else
                              ContainerButton(
                                onPressed: isAnyDownloading && isActive
                                    ? () => ctrl.cancelDownload(activeId)
                                    : isDownloaded
                                    ? null
                                    : onDownload,
                                height: 35.0,
                                isTitleCentered: true,
                                title: isAnyDownloading && isActive
                                    ? 'cancel'.tr
                                    : 'download'.tr +
                                          ' ${section.sizeLabel}'
                                              .convertNumbersToCurrentLang(),
                                titleStyle: AppTextStyles.titleSmall(),
                                horizontalPadding: 8.0,
                                verticalPadding: 2.0,
                                backgroundColor: Get.theme.colorScheme.surface,
                                progressColor: Get.theme.colorScheme.primary
                                    .withValues(alpha: .6),
                                progressBackgroundColor: Get
                                    .theme
                                    .colorScheme
                                    .primary
                                    .withValues(alpha: .2),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
