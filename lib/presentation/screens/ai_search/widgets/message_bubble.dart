part of '../ai_search.dart';

/// فقاعة رسالة في محادثة المساعد الذكي — بأسلوب ChatGPT.
///
/// - **رسالة المستخدم**: فقاعة على اليمين (RTL)، عرض محدود.
/// - **رسالة المساعد**: **بدون فقاعة**، تأخذ كامل عرض الشاشة، مع تنسيق Markdown
///   وجداول ملتفّة (بدون تمرير أفقي)، وأزرار نسخ/مشاركة أسفلها.
class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.message,
    this.associatedQuestion,
    this.isLastMessage = false,
    this.textColor,
    this.iconColor,
  });

  final ChatMessage message;

  /// نص السؤال المرتبط بهذه الإجابة (لإدراجه عند النسخ/المشاركة). null لرسائل المستخدم.
  final String? associatedQuestion;

  /// هل هذه آخر رسالة مساعد؟ (تُعرض بحركة streaming وهمية، البقية فوراً).
  final bool isLastMessage;

  final Color? textColor;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    if (message.isAssistant) return _buildAssistantAnswer(context);
    return _buildUserQuestion(context);
  }

  /// فقاعة سؤال المستخدم — على اليمين، مطابقة لـ `_buildUserQuery` في SemanticMode.
  Widget _buildUserQuestion(BuildContext context) {
    final theme = context.theme;
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        constraints: BoxConstraints(maxWidth: Get.width * 0.82),
        margin: const EdgeInsets.only(right: 16, left: 48, top: 8, bottom: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color:
              iconColor?.withValues(alpha: 0.2) ??
              theme.colorScheme.surface.withValues(alpha: 0.08),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(4),
            bottomLeft: Radius.circular(16),
          ),
        ),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Text(
            message.content,
            style: AppTextStyles.titleMedium(
              fontSize: 17,
              height: 1.4,
              color: textColor ?? theme.colorScheme.surface,
            ),
          ),
        ),
      ),
    );
  }

  /// إجابة المساعد — بدون فقاعة، كامل العرض، مع Markdown + أزرار نسخ/مشاركة.
  ///
  /// تعرض مقدمة المساعد (نص الـ LLM) متبوعةً ببطاقات الاقتباسات المنقولة من MCP
  /// (تُعرض كاملةً كما جاءت من المصدر، دون تمريرها عبر LLM، لضمان نسخ حرفي بلا تحريف).
  ///
  /// الاقتباسات تظهر تدريجياً (fade-in) بعد انتهاء streaming المقدمة، بأسلوب ChatGPT.
  Widget _buildAssistantAnswer(BuildContext context) {
    final theme = context.theme;
    final ctrl = AiSearchController.instance;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // نص مقدمة المساعد بتنسيق Markdown + محاكاة streaming (كلمة بكلمة).
          // الرسالة الأخيرة: حركة streaming؛ الرسائل السابقة (من السجل): فورية.
          // highlightBuilder يطبّق خط المصحف (uthmanic2) على الآيات المحاطة بـ backticks.
          if (message.content.trim().isNotEmpty)
            Directionality(
              textDirection: TextDirection.rtl,
              child: DefaultTextStyle(
                style: AppTextStyles.titleMedium(
                  fontSize: 17,
                  height: 1.6,
                  color: textColor ?? theme.canvasColor,
                ),
                child: StreamingTextMarkdown(
                  text: message.content,
                  wordByWord: true,
                  chunkSize: 1,
                  markdownEnabled: true,
                  animationsEnabled: isLastMessage,
                  styleSheet: AppTextStyles.titleMedium(
                    fontSize: 17,
                    height: 1.6,
                    color: textColor ?? theme.canvasColor,
                  ),
                  textDirection: TextDirection.rtl,
                  fadeInEnabled: false,
                  highlightBuilder: (ctx, text, style) =>
                      _buildAyahWidget(ctx, text, style, theme),
                ),
              ),
            ),
          // بطاقات الاقتباسات المنقولة من MCP (نصوص الكتب كاملةً كما هي).
          // النص يظهر تدريجياً (streaming كلمة بكلمة) لكل الرسائل.
          ...message.quotations.map(
            (q) => QuotationCard(
              quotation: q,
              textColor: textColor,
              enableStreaming: true,
            ),
          ),
          context.hDivider(
            width: Get.width * 0.5,
            color:
                iconColor?.withValues(alpha: 0.2) ??
                theme.canvasColor.withValues(alpha: 0.08),
          ),
          // أزرار نسخ/مشاركة أسفل الإجابة (مثل ChatGPT).
          _buildActionButtons(context, ctrl),
        ],
      ),
    );
  }

  /// شريط أزرار النسخ/المشاركة — مطابق للنمط المعتمد في share_controller.
  Widget _buildActionButtons(BuildContext context, AiSearchController ctrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // زر النسخ.
          _iconActionButton(
            context,
            svgPath: SvgPath.svgQuranCopy,
            tooltip: 'copyAnswer'.tr,
            onPressed: () => ctrl.copyAssistantAnswer(
              context,
              message.content,
              associatedQuestion,
              message.quotations,
            ),
          ),
          // زر المشاركة.
          _iconActionButton(
            context,
            svgPath: SvgPath.svgHomeShare,
            tooltip: 'shareText'.tr,
            onPressed: () => ctrl.shareAssistantAnswer(
                message.content, associatedQuestion, message.quotations),
          ),
        ],
      ),
    );
  }

  Widget _iconActionButton(
    BuildContext context, {
    required String svgPath,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    final theme = context.theme;
    return Tooltip(
      message: tooltip,
      child: CustomButton(
        height: 35,
        width: 35,
        onPressed: onPressed,
        svgPath: svgPath,
        isCustomSvgColor: true,
        horizontalPadding: 8,
        svgColor:
            iconColor?.withValues(alpha: 0.8) ??
            theme.colorScheme.surface.withValues(alpha: 0.6),
      ),
    );
  }

  /// يبني widget لعرض الآية القرآنية بخط المصحف (uthmanic2) + حجم أكبر.
  ///
  /// يُستدعى عبر `highlightBuilder` للنصوص المحاطة بـ backticks (الآيات).
  Widget _buildAyahWidget(
    BuildContext context,
    String text,
    TextStyle style,
    ThemeData theme,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color:
            iconColor?.withValues(alpha: 0.2) ??
            theme.colorScheme.surface.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        textDirection: TextDirection.rtl,
        style: style.copyWith(
          fontFamily: 'uthmanic2',
          fontSize: 22,
          height: 1.9,
          color: textColor ?? theme.canvasColor,
        ),
      ),
    );
  }
}
