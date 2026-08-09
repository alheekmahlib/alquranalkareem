part of '../ai_search.dart';

/// واجهة محادثة مساعد الأقسام الإسلامية (alheekmah-mcp).
///
/// نسخة من [AssistantView] لكنها تقرأ من `state.heekmahMessages` بدلاً من
/// `state.assistantMessages`. تُعرض داخل `_buildSemanticMode` عند تفعيل
/// المبدّل الأونلاين. شريط الإدخال موحّد ويُوفَّر من الشاشة الأم (InputBarWidget).
///
/// تُعيد استخدام [MessageBubble] كما هو (نموذج عام يعرض أي [ChatMessage]).
class HeekmahAssistantView extends StatelessWidget {
  final Color? textColor;
  final Color? iconColor;

  HeekmahAssistantView({super.key, this.textColor, this.iconColor});

  final ctrl = AiSearchController.instance;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // محتوى فارغ: شاشة الترحيب + الاقتراحات.
      if (ctrl.state.isHeekmahEmpty && ctrl.state.heekmahError.value.isEmpty) {
        return _buildEmptyState(context);
      }
      // محادثة نشطة: قائمة الرسائل.
      return _buildConversation(context);
    });
  }

  /// شاشة الترحيب الافتراضية مع اقتراحات أسئلة.
  Widget _buildEmptyState(BuildContext context) {
    final theme = context.theme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox().customSvgWithCustomColor(
            SvgPath.svgHomeMidadIcon,
            height: 70,
            color: iconColor ?? theme.canvasColor,
          ),
          const Gap(8),
          Text(
            'heekmahWelcome'.tr,
            style: AppTextStyles.titleMedium(
              fontSize: 16,
              color: theme.colorScheme.surface,
            ),
            textAlign: TextAlign.center,
          ),
          const Gap(8),
          Text(
            'heekmahWelcomeDesc'.tr,
            style: AppTextStyles.titleMedium(
              fontSize: 14,
              color: (textColor ?? theme.colorScheme.surface).withValues(
                alpha: 0.7,
              ),
            ),
            textAlign: TextAlign.center,
          ),
          const Gap(32),
          // اقتراحات أسئلة جاهزة.
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: _defaultSuggestions
                .map((s) => _suggestionChip(context, s))
                .toList(),
          ),
          const Gap(32),
        ],
      ),
    );
  }

  Widget _suggestionChip(BuildContext context, String text) {
    return ContainerButton(
      title: text,
      horizontalPadding: 8.0,
      backgroundColor: context.theme.colorScheme.surface,
      titleStyle: AppTextStyles.titleSmall(color: Colors.black),
      onPressed: () {
        ctrl.state.searchTextEditing.text = text;
        ctrl.sendHeekmahMessage(text);
        FocusManager.instance.primaryFocus?.unfocus();
      },
    );
  }

  /// قائمة رسائل المحادثة + مؤشر "يفكر" (overlay في الوسط).
  Widget _buildConversation(BuildContext context) {
    final theme = context.theme;
    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  const IconWidget(),
                  ListView.builder(
                    shrinkWrap: true,
                    controller: ctrl.heekmahScrollController,
                    padding: const EdgeInsets.only(top: 16, bottom: 16),
                    itemCount: ctrl.state.heekmahMessages.length,
                    itemBuilder: (context, index) {
                      final message = ctrl.state.heekmahMessages[index];
                      // رسائل الأداة لا تُعرض كفقاعات.
                      if (message.isTool) return const SizedBox.shrink();
                      // ابحث عن نص السؤال المرتبط.
                      String? question;
                      if (message.isAssistant) {
                        for (int i = index - 1; i >= 0; i--) {
                          final prev = ctrl.state.heekmahMessages[i];
                          if (prev.isUser) {
                            question = prev.content;
                            break;
                          }
                        }
                      }
                      // هل هذه آخر رسالة مساعد؟ (لعرضها بحركة streaming).
                      bool isLast = false;
                      if (message.isAssistant) {
                        for (
                          int i = ctrl.state.heekmahMessages.length - 1;
                          i >= 0;
                          i--
                        ) {
                          if (ctrl.state.heekmahMessages[i].isAssistant) {
                            isLast = (i == index);
                            break;
                          }
                        }
                      }
                      return MessageBubble(
                        message: message,
                        associatedQuestion: question,
                        isLastMessage: isLast,
                        textColor: textColor,
                        iconColor: iconColor,
                      );
                    },
                  ),
                ],
              ),
            ),
            // شريط رسالة الخطأ (إن وُجد).
            Obx(() {
              final err = ctrl.state.heekmahError.value;
              if (err.isEmpty) return const SizedBox.shrink();
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: theme.colorScheme.error.withValues(alpha: 0.3),
                  ),
                ),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(
                    err,
                    style: AppTextStyles.titleMedium(
                      fontSize: 13,
                      color: textColor ?? theme.colorScheme.error,
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
        // مؤشر "يفكر" — overlay في وسط الشاشة.
        Positioned.fill(
          child: IgnorePointer(
            child: Obx(() {
              if (!ctrl.state.isHeekmahThinking.value ||
                  ctrl.state.heekmahToolName.value.isNotEmpty) {
                return const SizedBox.shrink();
              }
              return Container(
                color: theme.colorScheme.primary.withValues(alpha: 0.4),
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedDrawingWidget(
                      svgPath: SvgPath.svgHomeMidadIcon,
                      height: 80,
                      width: 160,
                      isRepeat: true,
                      duration: 3,
                      customColor: iconColor ?? theme.canvasColor,
                    ),
                    const Gap(16),
                    Text(
                      'thinking'.tr,
                      style: AppTextStyles.titleMedium(
                        fontSize: 18,
                        color: textColor ?? theme.colorScheme.surface,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  /// اقتراحات أسئلة افتراضية تختبر أدوات خادم alheekmah-mcp (الأقسام).
  List<String> get _defaultSuggestions => [
    'heekmahSuggestion2'.tr, // أحاديث عن الصبر
    'heekmahSuggestion3'.tr, // أدلة على صفات الله من السنة
    'heekmahSuggestion4'.tr, // ما هي شروط لا إله إلا الله؟
    'heekmahSuggestion1'.tr, // ما حكم الصلاة في الثوب النجس؟
  ];
}
