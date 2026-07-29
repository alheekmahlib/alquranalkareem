part of '../ai_search.dart';

class FloatingMenuWidget extends StatelessWidget {
  const FloatingMenuWidget({super.key, required this.ctrl});

  final AiSearchController ctrl;

  @override
  Widget build(BuildContext context) {
    return FloatingMenuExpendable(
      controller: FloatingMenuExpendableController(initialIsOpen: false),
      panelWidth: 460,
      panelHeight: 460,
      handleWidth: 40,
      handleHeight: 40,
      expandPanelFromHandle: true,
      initialPosition: ctrl.floatingMenuPosition,
      startDocked: false,
      onPositionChanged: ctrl.savePosition,
      openMode: FloatingMenuExpendableOpenMode.vertical,
      style: FloatingMenuExpendableStyle(
        showBarrierWhenOpen: true,
        barrierDismissible: true,
        barrierColor: context.theme.colorScheme.primaryContainer.withValues(
          alpha: 0.3,
        ),
        barrierBlurSigmaX: 10,
        barrierBlurSigmaY: 10,
        handleMaterialColor: context.theme.canvasColor,
        panelDecoration: BoxDecoration(
          color: context.theme.colorScheme.primary,
          borderRadius: BorderRadius.circular(8),
        ),
        panelBorderRadius: BorderRadius.circular(8),
      ),
      handleChild: const SizedBox().customSvg(
        SvgPath.svgHomeSetting,
        height: 30,
      ),
      panelChild: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ...SearchSection.all.map(
            (section) => SectionDownloadCard(
              section: section,
              onDownload: () => ctrl.downloadSection(section),
            ),
          ),
          const Gap(12),
          // Download all button
          Obx(() {
            if (!ctrl.state.isSharedLoaded.value)
              return const SizedBox.shrink();
            final hasUndownloaded = SearchSection.all.any((s) {
              return !ctrl.state.isSectionLoaded(s.id).value;
            });
            if (!hasUndownloaded) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: () => ctrl.downloadAllSections(ctrl),
                  icon: Icon(
                    Icons.download_rounded,
                    size: 18,
                    color: context.theme.colorScheme.surface.withValues(
                      alpha: 0.8,
                    ),
                  ),
                  label: Text(
                    'downloadAll'.tr,
                    style: AppTextStyles.titleMedium(
                      fontSize: 14,
                      color: context.theme.colorScheme.surface.withValues(
                        alpha: 0.8,
                      ),
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                        color: context.theme.colorScheme.surface.withValues(
                          alpha: 0.2,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
          const Gap(16),
        ],
      ),
    );
  }
}
