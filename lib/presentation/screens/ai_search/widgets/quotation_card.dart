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
  final bool enableStreaming;

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
          // النص المنقول حرفياً (snippet أو النص الكامل بعد الجلب من الـ controller).
          _buildQuotedText(theme),
          // أزرار "النص الكامل" و"الانتقال للكتاب".
          const Gap(6),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (quotation.passageId != null) _buildFullTextButton(theme),
              const Spacer(),
              if (quotation.bookSourceName != null &&
                  quotation.pageNumber != null)
                _buildNavigateToBookButton(theme),
            ],
          ),
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
          // حواشي الكتاب (فروق النسخ، التخريج) — تُعرض كقائمة مرقمة في الأسفل.
          if (quotation.footnotes.isNotEmpty) ...[
            const Gap(8),
            _buildFootnotes(theme, accent),
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

  /// يبني قسم الحواشي (فروق النسخ، التخريج) في أسفل البطاقة.
  /// يُعرض كقائمة مرقمة بخط أصغر ومميّز، مثل حواشي الكتب المحققة.
  Widget _buildFootnotes(ThemeData theme, Color accent) {
    final baseColor = textColor ?? theme.canvasColor;
    final fnColor = baseColor.withValues(alpha: 0.55);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: accent.withValues(alpha: 0.2), width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final fn in quotation.footnotes)
            Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Text(
                fn,
                textAlign: TextAlign.start,
                textDirection: TextDirection.rtl,
                style: AppTextStyles.titleMedium(
                  color: fnColor,
                  fontSize: 11,
                  height: 1.5,
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// النص المنقول — يقرأ من الـ controller: النص الكامل إن جُلب، وإلا snippet الأصلي.
  /// يُعاد بناؤه تلقائياً عند تغيّر حالة الجلب (عبر Obx).
  Widget _buildQuotedText(ThemeData theme) {
    final baseColor = textColor ?? theme.canvasColor;
    final isAyah = quotation.type == QuotationType.ayah;
    final isHadith = quotation.type == QuotationType.hadith;
    final ctrl = AiSearchController.instance;

    // النص المعروض: النص الكامل إن جُلب، وإلا snippet الأصلي.
    final fullText = quotation.passageId != null
        ? ctrl.state.getFullText(quotation.passageId!)
        : null;
    final displayText = fullText ?? quotation.text;
    // عطّل streaming عند عرض النص الكامل (النص الطويل لا يحتاج streaming).
    final useStreaming = enableStreaming && fullText == null;

    if (isAyah) {
      final style = AppTextStyles.titleMedium(
        fontFamily: 'uthmanic2',
        fontSize: 24,
        height: 1.9,
        color: baseColor,
      );
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: useStreaming
            ? _buildStreamingText(displayText, style, align: TextAlign.center)
            : Text(
                displayText,
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
                style: style,
              ),
      );
    }
    if (isHadith) {
      final style = AppTextStyles.titleMedium(
        fontSize: 19,
        height: 1.8,
        color: baseColor,
      );
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: useStreaming
            ? _buildStreamingText('«$displayText»', style)
            : Text(
                '«$displayText»',
                textAlign: TextAlign.start,
                textDirection: TextDirection.rtl,
                style: style,
              ),
      );
    }
    final style = AppTextStyles.titleMedium(
      fontSize: 17,
      height: 1.8,
      color: baseColor,
    );
    return Container(
      width: double.infinity,
      child: useStreaming
          ? _buildStreamingText(displayText, style, align: TextAlign.justify)
          : Text(
              displayText,
              textAlign: TextAlign.justify,
              textDirection: TextDirection.rtl,
              style: style,
            ),
    );
  }

  /// يبني النص بآلية streaming كلمة بكلمة (مثل ChatGPT).
  /// markdownEnabled معطّل لأن النصوص المنقولة عربية خالصة لا تحتاج تنسيق Markdown،
  /// وتفعيله يُفسّر علامات الحاشية [1] [2] كروابط ويعرضها كدوائر سوداء.
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
          text: text.replaceAll('[', '(').replaceAll(']', ')'),
          wordByWord: true,
          chunkSize: 1,
          latexEnabled: true,
          markdownEnabled: true,
          animationsEnabled: true,
          styleSheet: style,
          latexStyle: style,
          textDirection: TextDirection.rtl,
          textAlign: align,
          fadeInEnabled: false,
        ),
      ),
    );
  }

  /// زر "عرض النص الكامل" — reactive عبر Obx يقرأ حالة الجلب من الـ controller.
  Widget _buildFullTextButton(ThemeData theme) {
    final baseColor = textColor ?? theme.canvasColor;
    final ctrl = AiSearchController.instance;
    return Obx(() {
      final pid = quotation.passageId!;
      final fullText = ctrl.state.getFullText(pid);
      // النص الكامل جُلب → لا زر.
      if (fullText != null) return const SizedBox.shrink();
      final isLoading = ctrl.state.isFetchingFullText(pid);
      final failed = ctrl.state.hasFetchFailed(pid);

      // جارٍ الجلب → مؤشر تحميل.
      if (isLoading) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(
                strokeWidth: 1.5,
                color: baseColor.withValues(alpha: 0.5),
              ),
            ),
            const Gap(6),
            Text(
              'جارٍ جلب النص الكامل...',
              style: AppTextStyles.titleMedium(
                color: baseColor.withValues(alpha: 0.5),
                fontSize: 11,
              ),
            ),
          ],
        );
      }

      // فشل الجلب → زر إعادة المحاولة.
      if (failed) {
        return TextButton.icon(
          onPressed: () => ctrl.fetchFullPassage(pid),
          icon: Icon(
            Icons.refresh,
            size: 14,
            color: baseColor.withValues(alpha: 0.6),
          ),
          label: Text(
            'إعادة المحاولة',
            style: AppTextStyles.titleMedium(
              color: baseColor.withValues(alpha: 0.6),
              fontSize: 11,
            ),
          ),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        );
      }

      // الحالة الافتراضية → زر "عرض النص الكامل".
      return TextButton.icon(
        onPressed: () => ctrl.fetchFullPassage(pid),
        icon: Icon(
          Icons.expand_more,
          size: 16,
          color: baseColor.withValues(alpha: 0.6),
        ),
        label: Text(
          'عرض النص الكامل',
          style: AppTextStyles.titleMedium(
            color: baseColor.withValues(alpha: 0.6),
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      );
    });
  }

  /// زر "الانتقال للكتاب" — يفتح الكتاب في الصفحة الصحيحة.
  Widget _buildNavigateToBookButton(ThemeData theme) {
    return CustomButton(
      onPressed: () => AiSearchController.instance.navigateQuotationToBook(
        quotation.bookSourceName!,
        quotation.pageNumber!,
      ),
      height: 25,
      width: 130,
      isCustomSvgColor: true,
      svgPath: SvgPath.svgBooksOpenBook,
      svgColor: theme.colorScheme.surface,
      title: 'الانتقال للكتاب',
      textStyle: AppTextStyles.titleMedium(
        color: theme.colorScheme.surface,
        fontSize: 12,
        height: 1.4,
      ),
    );
  }
}
