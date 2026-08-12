part of '../ai_search.dart';

/// واجهة المحادثة الموحَّدة — تجمع القرآن وعلومه والأقسام الشرعية في محادثة واحدة.
///
/// تحلّ محلّ [AssistantView] و [HeekmahAssistantView] السابقتين. تقرأ من
/// `state.assistantMessages` (القائمة الموحّدة الوحيدة) وتستدعي `ctrl.sendMessage()`.
class UnifiedAssistantView extends StatelessWidget {
  final Color? textColor;
  final Color? iconColor;
  final bool isInMidad;

  UnifiedAssistantView({
    super.key,
    this.textColor,
    this.iconColor,
    this.isInMidad = true,
  });

  final ctrl = AiSearchController.instance;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // محتوى فارغ: شاشة الترحيب + الاقتراحات.
      if (ctrl.state.isAssistantEmpty &&
          ctrl.state.assistantError.value.isEmpty) {
        return _buildEmptyState(context);
      }
      // محادثة نشطة: قائمة الرسائل.
      return _buildConversation(context);
    });
  }

  /// شاشة الترحيب الافتراضية مع اقتراحات متنوعة (قرآنية وشرعية).
  Widget _buildEmptyState(BuildContext context) {
    final theme = context.theme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
            'unifiedWelcome'.tr,
            style: AppTextStyles.titleMedium(
              fontSize: 16,
              color: theme.colorScheme.surface,
            ),
            textAlign: TextAlign.center,
          ),
          const Gap(8),
          Text(
            'unifiedWelcomeDesc'.tr,
            style: AppTextStyles.titleMedium(
              fontSize: 14,
              color: (textColor ?? theme.colorScheme.surface).withValues(
                alpha: 0.7,
              ),
            ),
            textAlign: TextAlign.center,
          ),
          const Gap(32),
          // اقتراحات متنوعة: بعضها قرآني، بعضها من الأقسام الشرعية.
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
        ctrl.sendMessage(text);
        FocusManager.instance.primaryFocus?.unfocus();
      },
    );
  }

  /// قائمة رسائل المحادثة + مؤشر "يفكر".
  Widget _buildConversation(BuildContext context) {
    final theme = context.theme;
    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  if (isInMidad == true) const IconWidget(),
                  ListView.builder(
                    shrinkWrap: true,
                    controller: ctrl.assistantScrollController,
                    padding: const EdgeInsets.only(top: 16, bottom: 16),
                    itemCount: ctrl.state.assistantMessages.length,
                    itemBuilder: (context, index) {
                      final message = ctrl.state.assistantMessages[index];
                      if (message.isTool) return const SizedBox.shrink();
                      // ابحث عن نص السؤال المرتبط.
                      String? question;
                      if (message.isAssistant) {
                        for (int i = index - 1; i >= 0; i--) {
                          final prev = ctrl.state.assistantMessages[i];
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
                          int i = ctrl.state.assistantMessages.length - 1;
                          i >= 0;
                          i--
                        ) {
                          if (ctrl.state.assistantMessages[i].isAssistant) {
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

                  if (ctrl.state.isAssistantThinking.value)
                    IgnorePointer(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Obx(() {
                          // يظهر فقط عند التفكير (وليس أثناء استدعاء أداة — تلك لها مؤشرها الخاص).
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: .center,
                            children: [
                              Text(
                                'thinking'.tr,
                                style: AppTextStyles.titleMedium(
                                  fontSize: 18,
                                  color:
                                      textColor ??
                                      context.theme.colorScheme.surface,
                                ),
                              ),
                              const Gap(8),
                              AnimatedDrawingWidget(
                                svgPath: SvgPath.svgHomeMidadIcon,
                                height: 15,
                                width: 30,
                                isRepeat: true,
                                duration: 3,
                                customColor:
                                    iconColor ?? context.theme.canvasColor,
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
                ],
              ),
            ),
            // شريط رسالة الخطأ.
            Obx(() {
              final err = ctrl.state.assistantError.value;
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
        // مؤشر "يفكر".
        // Positioned.fill(
        //   child: IgnorePointer(
        //     child: Obx(() {
        //       if (!ctrl.state.isAssistantThinking.value ||
        //           ctrl.state.currentToolName.value.isNotEmpty) {
        //         return const SizedBox.shrink();
        //       }
        //       return Container(
        //         color: isInMidad == true
        //             ? theme.colorScheme.primary.withValues(alpha: 0.4)
        //             : Colors.transparent,
        //         alignment: Alignment.center,
        //         child: Column(
        //           mainAxisSize: MainAxisSize.min,
        //           children: [
        //             AnimatedDrawingWidget(
        //               svgPath: SvgPath.svgHomeMidadIcon,
        //               height: 80,
        //               width: 160,
        //               isRepeat: true,
        //               duration: 3,
        //               customColor: iconColor ?? theme.canvasColor,
        //             ),
        //             const Gap(16),
        //             Text(
        //               'thinking'.tr,
        //               style: AppTextStyles.titleMedium(
        //                 fontSize: 18,
        //                 color: textColor ?? theme.colorScheme.surface,
        //               ),
        //             ),
        //           ],
        //         ),
        //       );
        //     }),
        //   ),
        // ),
      ],
    );
  }

  /// اقتراحات متنوعة: قرآنية وشرعية لاختبار كلا الخادمين (عربية ثابتة — مداد عربي فقط).
  static const List<String> _defaultSuggestions = [
    'ما تفسير آية الكرسي في تفسير السعدي؟',
    'أحاديث عن الصبر',
    'ما حكم الصلاة في الثوب النجس؟',
    'ما سبب نزول آية المباهلة؟',
  ];
}
