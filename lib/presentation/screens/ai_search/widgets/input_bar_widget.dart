part of '../ai_search.dart';

/// شريط الإدخال الموحد لشاشة مداد — mode-aware.
///
/// في الوضع الدلالي: يوجّه الإدخال إلى `ctrl.search()` ويُظهر SectionFilterWidget.
/// في وضع المساعد الذكي: يوجّه الإدخال إلى `ctrl.sendAssistantMessage()`
/// ويُظهر ToolCallIndicator عند تنفيذ أداة، أو مؤشر تحميل أثناء المعالجة.
class InputBarWidget extends StatelessWidget {
  InputBarWidget({super.key});
  final ctrl = AiSearchController.instance;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Material(
      color: Colors.transparent,
      elevation: 0,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: theme.colorScheme.surface.withValues(alpha: 0.15),
          ),
        ),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            children: [
              // الصف العلوي: حقل النص + زر المسح.
              Obx(() {
                final isAssistant =
                    ctrl.state.midasMode.value == MidasMode.assistant;
                final hasText = ctrl.state.hasInputText.value;
                return Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextField(
                          minLines: 1,
                          maxLines: 5,
                          keyboardType: TextInputType.multiline,
                          controller: ctrl.state.searchTextEditing,
                          cursorColor: theme.colorScheme.surface,
                          style: AppTextStyles.titleMedium(
                            color: theme.colorScheme.surface,
                            fontSize: 15,
                          ),
                          decoration: InputDecoration(
                            hintText: 'askMidad'.tr,
                            hintStyle: AppTextStyles.titleMedium(
                              color: theme.colorScheme.surface,
                              fontSize: 15,
                            ),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 12,
                            ),
                          ),
                          textInputAction: TextInputAction.send,
                          onSubmitted: (query) {
                            if (query.trim().isEmpty) return;
                            if (isAssistant) {
                              if (!ctrl.state.isAssistantThinking.value) {
                                ctrl.sendMessage(query);
                                FocusManager.instance.primaryFocus?.unfocus();
                              }
                            } else {
                              ctrl.search(query);
                              FocusManager.instance.primaryFocus?.unfocus();
                            }
                          },
                        ),
                      ),
                    ),
                    // زر المسح.
                    if (hasText)
                      IconButton(
                        onPressed: () {
                          ctrl.state.searchTextEditing.clear();
                          if (!isAssistant) ctrl.clearSearch();
                        },
                        icon: Icon(
                          Icons.close,
                          size: 18,
                          color: theme.colorScheme.surface.withValues(
                            alpha: 0.4,
                          ),
                        ),
                      )
                    else
                      const SizedBox(width: 12),
                  ],
                );
              }),
              // الصف السفلي: زر الإرسال + عنصر جانبي حسب الوضع.
              Obx(() {
                final isAssistant =
                    ctrl.state.midasMode.value == MidasMode.assistant;
                final hasText = ctrl.state.hasInputText.value;
                final isBusy = isAssistant &&
                    (ctrl.state.isAssistantThinking.value ||
                        ctrl.state.currentToolName.value.isNotEmpty);
                return Row(
                  children: [
                    // زر الإرسال أو مؤشر تحميل أثناء المعالجة.
                    if (isBusy)
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: theme.colorScheme.surface,
                          ),
                        ),
                      )
                    else
                      IconButton(
                        onPressed: hasText
                            ? () {
                                final query = ctrl.state.searchTextEditing.text
                                    .trim();
                                if (query.isEmpty) return;
                                if (isAssistant) {
                                  ctrl.sendMessage(query);
                                } else {
                                  ctrl.state.currentQuery.value = query;
                                  ctrl.search(query);
                                }
                                FocusManager.instance.primaryFocus?.unfocus();
                              }
                            : null,
                        icon: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface.withValues(
                              alpha: hasText ? 0.25 : 0.1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.arrow_upward,
                            size: 18,
                            color: theme.colorScheme.surface,
                          ),
                        ),
                      ),
                    // العنصر الجانبي: مؤشر الأداة/اختيار النموذج (مساعد) أو فلتر (دلالي).
                    if (isAssistant)
                      Expanded(
                        child: ctrl.state.currentToolName.value.isNotEmpty
                            ? ToolCallIndicator(
                                toolName: ctrl.state.currentToolName.value,
                              )
                            : ModelSelectorWidget(),
                      )
                    else
                      SectionFilterWidget(),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
