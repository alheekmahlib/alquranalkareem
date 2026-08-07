part of '../ai_search.dart';

/// قائمة منسدلة لاختيار نموذج LLM (بنمط SectionFilterWidget).
///
/// تظهر فقط المزودين الذين لهم مفاتيح في .env.
class ModelSelectorWidget extends StatelessWidget {
  ModelSelectorWidget({super.key});

  final ctrl = AiSearchController.instance;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final theme = context.theme;
      final providers = ctrl.availableProviders;
      // لا قائمة إن لم يوجد أي مفتاح.
      if (providers.isEmpty) {
        return const SizedBox.shrink();
      }
      final selected = ctrl.state.selectedProvider.value;

      return DropdownButton2<LlmProvider>(
        isExpanded: false,
        underline: const SizedBox.shrink(),
        customButton: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.auto_awesome,
                size: 16,
                color: theme.colorScheme.surface.withValues(alpha: 0.6),
              ),
              const Gap(4),
              Text(
                selected.displayName,
                style: AppTextStyles.titleMedium(
                  height: 2,
                  fontSize: 13,
                  color: theme.colorScheme.surface,
                ),
              ),
            ],
          ),
        ),
        isDense: true,
        items: providers.map((provider) {
          final isSelected = provider.id == selected.id;
          return DropdownMenuItem<LlmProvider>(
            value: provider,
            // صف واحد بسيط (لا Column) لتفادي الفيض.
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Icon(
                    isSelected ? Icons.check_circle : Icons.circle_outlined,
                    size: 18,
                    color: isSelected
                        ? theme.colorScheme.surface.withValues(alpha: 0.8)
                        : theme.colorScheme.surface.withValues(alpha: 0.4),
                  ),
                  const Gap(10),
                  Expanded(
                    child: Text(
                      provider.displayName,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.colorScheme.surface,
                      ),
                    ),
                  ),
                  if (provider.isFreeUnlimited)
                    Text(
                      'freeUnlimited'.tr,
                      style: TextStyle(
                        fontSize: 11,
                        color: theme.colorScheme.surface.withValues(alpha: 0.5),
                      ),
                    ),
                ],
              ),
            ),
          );
        }).toList(),
        onChanged: (provider) {
          if (provider != null) {
            ctrl.selectProvider(provider);
          }
        },
        dropdownStyleData: DropdownStyleData(
          direction: DropdownDirection.left,
          isOverButton: true,
          maxHeight: 300,
          width: 220,
          padding: null,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: theme.colorScheme.surface.withValues(alpha: 0.1),
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
