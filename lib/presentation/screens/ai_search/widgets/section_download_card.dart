part of '../ai_search.dart';

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
      final isAnyDownloading = SearchSection.all.any(
        (s) => ctrl.state.isSectionDownloading(s.id).value,
      );
      final activeId = ctrl.state.downloadingSectionId.value;
      final isActive = activeId == section.id;
      final progress = isActive
          ? ctrl.state.sectionProgress(activeId).value
          : 0.0;
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            // height: 75,
            decoration: BoxDecoration(
              color: context.theme.colorScheme.surface.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: context.theme.colorScheme.surface.withValues(alpha: 0.2),
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: isDownloaded ? null : onDownload,
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
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
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
                            customSvgWithColor(
                              SvgPath.svgCheckMark,
                              height: 30,
                              color: context.theme.colorScheme.surface,
                            )
                          else
                            ContainerButton(
                              onPressed: isAnyDownloading && isActive
                                  ? () => ctrl.cancelDownload(activeId)
                                  : isDownloaded
                                  ? null
                                  : onDownload,
                              height: 35.0,
                              // width: 110.0,
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
      );
    });
  }
}
