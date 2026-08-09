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
                // السويتش الآن داخل وضع assistant: isOnline = assistant + مُفعّل.
                final isOnline =
                    isAssistant && ctrl.state.isOnlineSearch.value;
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
                            // hint يتبدّل حسب الوضع.
                            hintText: isOnline
                                ? 'askHeekmah'.tr
                                : 'askMidad'.tr,
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
                            // افحص الأقسام الشرعية أولاً (isOnline يتطلب isAssistant).
                            if (isOnline) {
                              if (!ctrl.state.isHeekmahThinking.value) {
                                ctrl.sendHeekmahMessage(query);
                                FocusManager.instance.primaryFocus?.unfocus();
                              }
                            } else if (isAssistant) {
                              if (!ctrl.state.isAssistantThinking.value) {
                                ctrl.sendAssistantMessage(query);
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
                          if (!isAssistant && !isOnline) ctrl.clearSearch();
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
                // السويتش الآن داخل وضع assistant: isOnline = assistant + مُفعّل.
                final isOnline =
                    isAssistant && ctrl.state.isOnlineSearch.value;
                final hasText = ctrl.state.hasInputText.value;
                // مؤشر الانشغال: افحص الوضع النشط فقط (لا تخلط بين القسمين).
                final isBusy = isOnline
                    ? (ctrl.state.isHeekmahThinking.value ||
                        ctrl.state.heekmahToolName.value.isNotEmpty)
                    : isAssistant
                        ? (ctrl.state.isAssistantThinking.value ||
                            ctrl.state.currentToolName.value.isNotEmpty)
                        : false;
                return Row(
                  children: [
                    // زر الإرسال (سهم لأعلى) أو مؤشر تحميل أثناء المعالجة.
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
                                // افحص الأقسام الشرعية أولاً (isOnline يتطلب isAssistant).
                                if (isOnline) {
                                  ctrl.sendHeekmahMessage(query);
                                } else if (isAssistant) {
                                  ctrl.sendAssistantMessage(query);
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
                    // العنصر الجانبي حسب الوضع:
                    // - online (alheekmah-mcp): مؤشر الأداة أو اختيار النموذج.
                    // - assistant (tafsir-mcp): مؤشر الأداة أو اختيار النموذج.
                    // - محلي: فلتر الأقسام.
                    // ملاحظة: افحص isOnline أولاً لأنه يتطلب isAssistant=true.
                    if (isAssistant || isOnline)
                      Expanded(
                        child: (isOnline
                                ? ctrl.state.heekmahToolName.value
                                : ctrl.state.currentToolName.value)
                                .isNotEmpty
                            ? ToolCallIndicator(
                                toolName: isOnline
                                    ? ctrl.state.heekmahToolName.value
                                    : ctrl.state.currentToolName.value,
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
