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
  });

  final ChatMessage message;

  /// نص السؤال المرتبط بهذه الإجابة (لإدراجه عند النسخ/المشاركة). null لرسائل المستخدم.
  final String? associatedQuestion;

  /// هل هذه آخر رسالة مساعد؟ (تُعرض بحركة streaming وهمية، البقية فوراً).
  final bool isLastMessage;

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
          color: theme.colorScheme.surface.withValues(alpha: 0.08),
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
              color: theme.colorScheme.surface,
            ),
          ),
        ),
      ),
    );
  }

  /// إجابة المساعد — بدون فقاعة، كامل العرض، مع Markdown + أزرار نسخ/مشاركة.
  Widget _buildAssistantAnswer(BuildContext context) {
    final theme = context.theme;
    final ctrl = AiSearchController.instance;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // نص الإجابة بتنسيق Markdown + محاكاة streaming (كلمة بكلمة).
          // StreamingTextMarkdown يلفّ GptMarkdown داخلياً، وGptMarkdownTheme
          // (InheritedWidget) يُلتقط تلقائياً فتظهر الألوان والخطوط الصحيحة.
          // الرسالة الأخيرة: حركة streaming؛ الرسائل السابقة (من السجل): فورية.
          // highlightBuilder يطبّق خط المصحف (uthmanic2) على الآيات المحاطة بـ backticks.
          Directionality(
            textDirection: TextDirection.rtl,
            child: GptMarkdownTheme(
              gptThemeData: _buildMarkdownTheme(theme),
              child: DefaultTextStyle(
                style: AppTextStyles.titleMedium(
                  fontSize: 17,
                  height: 1.6,
                  color: theme.canvasColor,
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
                    color: theme.canvasColor,
                  ),
                  textDirection: TextDirection.rtl,
                  fadeInEnabled: false,
                  highlightBuilder: (ctx, text, style) =>
                      _buildAyahWidget(ctx, text, style, theme),
                ),
              ),
            ),
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
            ),
          ),
          // زر المشاركة.
          _iconActionButton(
            context,
            svgPath: SvgPath.svgHomeShare,
            tooltip: 'shareText'.tr,
            onPressed: () =>
                ctrl.shareAssistantAnswer(message.content, associatedQuestion),
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
        svgColor: theme.colorScheme.surface.withValues(alpha: 0.6),
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
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.08),
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
          color: theme.canvasColor,
        ),
      ),
    );
  }

  /// يبني ثيم GptMarkdown مخصصاً يجعل كل العناوين والروابط بلون canvasColor
  /// وخط التطبيق، بدل الأنماط الافتراضية السوداء (Typography.tall2021).
  GptMarkdownThemeData _buildMarkdownTheme(ThemeData theme) {
    final baseColor = theme.canvasColor;
    final fontFamily = ThemeController.instance.currentFontFamily;
    final baseStyle = TextStyle(color: baseColor, fontFamily: fontFamily);
    return GptMarkdownThemeData(
      brightness: theme.brightness,
      highlightColor: baseColor.withValues(alpha: 0.15),
      linkColor: theme.colorScheme.primary,
      linkHoverColor: theme.colorScheme.primary,
      hrLineColor: baseColor.withValues(alpha: 0.2),
      h1: baseStyle.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        height: 1.4,
      ),
      h2: baseStyle.copyWith(
        fontSize: 19,
        fontWeight: FontWeight.bold,
        height: 1.4,
      ),
      h3: baseStyle.copyWith(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        height: 1.4,
      ),
      h4: baseStyle.copyWith(fontSize: 16, fontWeight: FontWeight.w600),
      h5: baseStyle.copyWith(fontSize: 15, fontWeight: FontWeight.w600),
      h6: baseStyle.copyWith(fontSize: 14, fontWeight: FontWeight.w600),
    );
  }
}
