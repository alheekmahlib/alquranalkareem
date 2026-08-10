part of '../ai_search.dart';

/// بطاقة لعرض نصٍّ منقولٍ حرفياً من مصدر موثوق (كتاب/تفسير/حديث).
///
/// تُميّز هذه البطاقة النصوص المنقولة بصرياً عن كلام المساعد، فلا يلتبس على
/// المستخدم أيّ النص أصله من المصدر وأيّه صياغة المساعد. التصميم يختلف حسب
/// [QuotationType]: الآيات والأحاديث تأخذ خطاً أكبر وتمييزاً أوضح، بينما التفاسير
/// وكلام العلماء تأخذ تصميقاً محايداً.
///
/// **النص هنا يُعرض كما جاء من MCP حرفياً — لا تحريف ولا إعادة صياغة.**
class QuotationCard extends StatelessWidget {
  const QuotationCard({
    super.key,
    required this.quotation,
    this.textColor,
    this.enableStreaming = false,
  });

  /// النص المنقول من المصدر.
  final Quotation quotation;

  /// لون النص الخارجي (يُورَّث من MessageBubble لدعم الوضع الليلي/الفاتح).
  final Color? textColor;

  /// هل نُفعّل ظهور النص بالتدريج (streaming كلمة بكلمة)؟
  /// يُفعَّل فقط للرسالة الأخيرة الحية لتحقيق تأثير ChatGPT.
  /// الـ UI نفسه لا يتغيّر — فقط آلية العرض.
  final bool enableStreaming;

  /// هل النص من القرآن (يستخدم خط المصحف uthmanic2)؟
  bool get _isAyah => quotation.type == QuotationType.ayah;

  /// هل النص حديث نبوي؟
  bool get _isHadith => quotation.type == QuotationType.hadith;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final accent = _accentColor(theme);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // شريط النوع + المصدر في الأعلى.
          _buildHeader(theme, accent),
          const Gap(8),
          // النص المنقول حرفياً.
          _buildQuotedText(theme),
          // النسبة التفصيلية في الأسفل إن وُجدت.
          if (quotation.attribution != null &&
              quotation.attribution!.isNotEmpty) ...[
            const Gap(8),
            _buildAttribution(theme, accent),
          ],
          // نسبة المصدر العام (مركز تفسير / مكتبة الحكمة) في الأسفل.
          if (quotation.sourceLabel != null &&
              quotation.sourceLabel!.isNotEmpty) ...[
            const Gap(4),
            _buildSourceLabel(theme, accent),
          ],
        ],
      ),
    );
  }

  /// لون التمييز حسب نوع النص (يساعد المستخدم على التمييز السريع).
  Color _accentColor(ThemeData theme) {
    final base = textColor ?? theme.canvasColor;
    // استخدم primary من الثيم كأساس، مع تلميح نوعي خفيف.
    switch (quotation.type) {
      case QuotationType.ayah:
        // الآيات: لون مميز (ذهبي/أخضر حسب الثيم).
        return const Color(0xFFC9A86A);
      case QuotationType.hadith:
        // الأحاديث: لون دافئ.
        return const Color(0xFF6A9F6A);
      case QuotationType.tafsir:
      case QuotationType.scholar:
        // التفاسير وأقوال العلماء: لون محايد.
        return base.withValues(alpha: 0.6);
      case QuotationType.fiqh:
      case QuotationType.aqeedah:
      case QuotationType.seerah:
      case QuotationType.other:
        return base.withValues(alpha: 0.5);
    }
  }

  /// شريط علوي يوضّح نوع النص (آية، حديث، تفسير...) بأيقونة مختصرة.
  Widget _buildHeader(ThemeData theme, Color accent) {
    final (label, icon) = _typeLabel();
    final headerColor = accent.withValues(alpha: 0.85);
    return Row(
      children: [
        Icon(icon, size: 14, color: headerColor),
        const Gap(5),
        Text(
          label,
          style: AppTextStyles.titleMedium(
            color: headerColor,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  /// يعيد (التسمية، الأيقونة) حسب نوع النص.
  (String, IconData) _typeLabel() {
    switch (quotation.type) {
      case QuotationType.ayah:
        return ('آية قرآنية', Icons.menu_book);
      case QuotationType.hadith:
        return ('حديث نبوي', Icons.auto_stories);
      case QuotationType.tafsir:
        return ('تفسير', Icons.library_books);
      case QuotationType.scholar:
        return ('قول لعالم', Icons.format_quote);
      case QuotationType.fiqh:
        return ('نص فقهي', Icons.gavel);
      case QuotationType.aqeedah:
        return ('نص عقدي', Icons.shield);
      case QuotationType.seerah:
        return ('سيرة وتاريخ', Icons.history_edu);
      case QuotationType.other:
        return ('نص منقول', Icons.bookmark_outline);
    }
  }

  /// النص المنقول حرفياً — يُعرض كنصٍّ عاديٍّ (Text) لا كـ Markdown،
  /// لمنع معالجة الرموز الخاصة (مثل الأقواس `{}` وعلامات الترقيم) كصياغة Markdown،
  /// فقد تُظهر النص كأنه JSON أو تُغيّر ترتيبه.
  Widget _buildQuotedText(ThemeData theme) {
    final baseColor = textColor ?? theme.canvasColor;

    // الآيات: خط المصحف، حجم أكبر، توسيط.
    if (_isAyah) {
      final style = AppTextStyles.titleMedium(
        fontFamily: 'uthmanic2',
        fontSize: 24,
        height: 1.9,
        color: baseColor,
      );
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: enableStreaming
            ? _buildStreamingText(
                quotation.text,
                style,
                align: TextAlign.center,
              )
            : Text(
                quotation.text,
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
                style: style,
              ),
      );
    }

    // الأحاديث: خط أكبر قليلاً ومسافة أسطر مريحة، مع علامتي تنصيص بصريتين.
    if (_isHadith) {
      final style = AppTextStyles.titleMedium(
        fontSize: 19,
        height: 1.8,
        color: baseColor,
      );
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: enableStreaming
            ? _buildStreamingText('«${quotation.text}»', style)
            : Text(
                '«${quotation.text}»',
                textAlign: TextAlign.start,
                textDirection: TextDirection.rtl,
                style: style,
              ),
      );
    }

    // بقية النصوص (تفاسير، فقه، إلخ): نص عادي بحجم مريح.
    final style = AppTextStyles.titleMedium(
      fontSize: 17,
      height: 1.8,
      color: baseColor,
    );
    return Container(
      width: double.infinity,
      child: enableStreaming
          ? _buildStreamingText(quotation.text, style, align: TextAlign.justify)
          : Text(
              quotation.text,
              textAlign: TextAlign.justify,
              textDirection: TextDirection.rtl,
              style: style,
            ),
    );
  }

  /// يبني النص بآلية streaming كلمة بكلمة (مثل ChatGPT) عند تفعيلها.
  /// الـ style مطابق تماماً للـ Text العادي — لا تغيير في الـ UI.
  /// البناء مطابق لما يستخدمه _buildAssistantAnswer في message_bubble.dart.
  Widget _buildStreamingText(
    String text,
    TextStyle style, {
    TextAlign align = TextAlign.start,
  }) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: DefaultTextStyle(
        style: style,
        textAlign: align,
        child: StreamingTextMarkdown(
          text: text,
          wordByWord: true,
          chunkSize: 1,
          markdownEnabled: true,
          animationsEnabled: true,
          styleSheet: style,
          textDirection: TextDirection.rtl,
          textAlign: align,
          fadeInEnabled: false,
        ),
      ),
    );
  }

  /// سطر النسبة في الأسفل (اسم الكتاب + المؤلف + المرجع).
  Widget _buildAttribution(ThemeData theme, Color accent) {
    final baseColor = textColor ?? theme.canvasColor;
    return Row(
      children: [
        Icon(
          Icons.bookmark_outline,
          size: 11,
          color: accent.withValues(alpha: 0.7),
        ),
        const Gap(4),
        Expanded(
          child: Text(
            quotation.attribution!,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.titleMedium(
              color: baseColor.withValues(alpha: 0.65),
              fontSize: 11,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  /// نسبة المصدر العام (مركز تفسير / مكتبة الحكمة) — في أسفل البطاقة.
  Widget _buildSourceLabel(ThemeData theme, Color accent) {
    final baseColor = textColor ?? theme.canvasColor;
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        'via ${quotation.sourceLabel}',
        textAlign: TextAlign.left,
        style: AppTextStyles.titleMedium(
          color: baseColor.withValues(alpha: 0.4),
          fontSize: 10,
          height: 1.3,
        ).copyWith(fontStyle: FontStyle.italic),
      ),
    );
  }
}
