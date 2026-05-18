part of '../ai_search.dart';

class SectionFilterWidget extends StatelessWidget {
  SectionFilterWidget({super.key});

  final ctrl = AiSearchController.instance;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final loadedCount = SearchSection.all
          .where((s) => ctrl.state.isSectionEnabled(s.id))
          .length;
      final totalLoaded = SearchSection.all
          .where((s) => ctrl.state.isSectionLoaded(s.id).value)
          .length;

      String label;
      if (totalLoaded == 0) {
        label = 'sections'.tr;
      } else if (loadedCount == totalLoaded) {
        label = 'all'.tr;
      } else if (loadedCount == 0) {
        label = 'none_sections'.tr;
      } else {
        label = '$loadedCount ${'sections'.tr}';
      }
      return DropdownButton2<String>(
        isExpanded: false,
        customButton: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: context.theme.colorScheme.surface.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.tune,
                size: 16,
                color: context.theme.colorScheme.surface.withValues(alpha: 0.6),
              ),
              const Gap(4),
              Text(
                label,
                style: AppTextStyles.titleMedium(
                  height: 2,
                  fontSize: 13,
                  color: context.theme.colorScheme.surface.withValues(
                    alpha: 0.6,
                  ),
                ),
              ),
            ],
          ),
        ),
        isDense: true,
        items: SearchSection.all.map((section) {
          return DropdownMenuItem<String>(
            value: section.id,
            enabled: ctrl.state.isSectionLoaded(section.id).value,
            // Obx inside each item so checkbox updates in-place
            child: Obx(() {
              final isLoaded = ctrl.state.isSectionLoaded(section.id).value;
              final isEnabled = ctrl.state.enabledSections.contains(section.id);
              return Opacity(
                opacity: isLoaded ? 1.0 : 0.8,
                child: IgnorePointer(
                  ignoring: !isLoaded,
                  child: GestureDetector(
                    onTap: isLoaded
                        ? () => ctrl.state.toggleSection(section.id)
                        : null,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: Checkbox(
                              value: isEnabled,
                              onChanged: isLoaded
                                  ? (_) => ctrl.state.toggleSection(section.id)
                                  : null,
                              fillColor: WidgetStateProperty.resolveWith((
                                states,
                              ) {
                                if (!isLoaded) {
                                  return context.theme.colorScheme.surface
                                      .withValues(alpha: 0.2);
                                }
                                if (isEnabled) {
                                  return context.theme.colorScheme.surface
                                      .withValues(alpha: 0.6);
                                }
                                return Colors.transparent;
                              }),
                              checkColor: context.theme.colorScheme.primary,
                              side: BorderSide(
                                color: context.theme.colorScheme.surface
                                    .withValues(alpha: 0.4),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                          const Gap(10),
                          Expanded(
                            child: Text(
                              section.titleAr.tr,
                              style: TextStyle(
                                fontSize: 14,
                                color: isLoaded
                                    ? context.theme.colorScheme.surface
                                    : context.theme.colorScheme.surface
                                          .withValues(alpha: 0.4),
                              ),
                            ),
                          ),
                          if (!isLoaded)
                            Text(
                              section.sizeLabel,
                              style: TextStyle(
                                fontSize: 11,
                                color: context.theme.colorScheme.surface
                                    .withValues(alpha: 0.3),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          );
        }).toList(),
        onChanged: (_) {
          // Selection handled by checkbox onTap
        },
        dropdownStyleData: DropdownStyleData(
          direction: DropdownDirection.left,
          isOverButton: true,
          maxHeight: 300,
          width: 220,
          padding: null,
          decoration: BoxDecoration(
            color: context.theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: context.theme.colorScheme.surface.withValues(alpha: 0.1),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          scrollbarTheme: ScrollbarThemeData(
            radius: const Radius.circular(4),
            thickness: WidgetStateProperty.all(4),
          ),
        ),
        menuItemStyleData: MenuItemStyleData(
          height: 44,
          padding: EdgeInsets.zero,
          overlayColor: WidgetStateProperty.all(Colors.transparent),
        ),
      );
    });
  }
}
