part of '../quran.dart';

/// نسخة محلية قابلة للتحديد من ActualTafsirWidget (حزمة quran_library) —
/// تعرّيف محلي بنفس الاسم يحجب نسخة الحزمة داخل هذه المكتبة فقط.
///
/// سبب النسخة: نص التفسير في الحزمة يُرسم عبر ArabicJustifiedRichText التي تنتهي
/// إلى RichText عاري، وRichText لا يسجّل نفسه في SelectionArea المحيطة
/// (التسجيل يتم تلقائيًا فقط داخل Text.build)، لذا كان التحديد لا يعمل.
/// هنا يُعرض النص عبر Text.rich فيشارك في التحديد والنسخ.
class ActualTafsir extends StatelessWidget {
  const ActualTafsir({
    super.key,
    required this.isDark,
    this.tafsirStyle,
    required this.context,
    required this.ayahIndex,
    required this.tafsir,
    required this.ayahs,
    required this.isTafsir,
    required this.translationList,
    required this.fontSizeArabic,
    required this.language,
    this.pageIndex,
  });

  final bool isDark;
  final TafsirStyle? tafsirStyle;
  final BuildContext context;
  final int ayahIndex;
  final TafsirTableData tafsir;
  final AyahModel ayahs;
  final bool isTafsir;
  final List<TranslationModel> translationList;
  final double fontSizeArabic;
  final String language;
  final int? pageIndex;

  @override
  Widget build(BuildContext context) {
    // حلّ النمط: استخدام النمط الممرّر إن وجد، ثم القراءة من الـ Theme، ثم الافتراضي
    final TafsirStyle s =
        tafsirStyle ??
        (TafsirTheme.of(context)?.style ??
            TafsirStyle.defaults(isDark: isDark, context: context));
    return Column(
      children: [
        // رأس الآية يبقى غير قابل للتحديد — رموز خط QPC ليست نصًا مقروءًا
        GetSingleAyah(
          surahNumber: ayahs.surahNumber!,
          ayahNumber: ayahs.ayahNumber,
          fontSize: 24,
          isBold: false,
          ayahs: ayahs,
          isSingleAyah: false,
          isDark: isDark,
          pageIndex: pageIndex! + 1,
          textColor: s.textColor,
          textAlign: TextAlign.center,
          enabledTajweed: QuranCtrl.instance.state.isTajweedEnabled.value,
        ),
        // الفاصل ويدجت وليس نصًا — استثناؤه من التحديد حتى لا يظهر U+FFFC عند النسخ
        SelectionContainer.disabled(
          child: Text.rich(
            TextSpan(
              children: <InlineSpan>[
                WidgetSpan(
                  child: context.horizontalDivider(
                    color: s.dividerColor,
                    height: 1.5,
                  ),
                ),
              ],
            ),
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.justify,
          ),
        ),
        // ثيم التحديد: DefaultSelectionStyle يتقدم على textSelectionTheme
        // العام للتطبيق لهذه النافذة فقط، وقائمة النسخ مترجمة بمفاتيح التطبيق
        // بدل التسميات الافتراضية للنظام
        DefaultSelectionStyle(
          selectionColor: context.theme.colorScheme.surface.withValues(
            alpha: 0.30,
          ),
          child: SelectionArea(
            contextMenuBuilder: (context, selectableRegion) =>
                AdaptiveTextSelectionToolbar.buttonItems(
                  anchors: selectableRegion.contextMenuAnchors,
                  // زر النسخ بسلوك الإطار الرسمي وتسمية مترجمة بمفتاح التطبيق
                  buttonItems: [
                    for (final item in selectableRegion.contextMenuButtonItems)
                      if (item.type == ContextMenuButtonType.copy)
                        item.copyWith(label: 'copy'.tr),
                  ],
                ),
            child: Text.rich(
              // inherit: false يطابق سلوك RichText الأصلي — لا يرث DefaultTextStyle
              TextSpan(
                children: <InlineSpan>[
                  isTafsir
                      ? TextSpan(
                          children: tafsir.tafsirText.toFlutterText(isDark),
                          style: TextStyle(
                            color: s.textColor,
                            height: 1.5,
                            fontSize: fontSizeArabic,
                          ),
                        )
                      : TextSpan(
                          children: _buildTranslationSpans(),
                          style: TextStyle(
                            color: s.textColor,
                            height: 1.5,
                            fontSize: fontSizeArabic,
                          ),
                        ),
                ],
              ),
              style: const TextStyle(inherit: false),
              textDirection: context.alignmentLayoutWPassLang(
                language,
                TextDirection.rtl,
                TextDirection.ltr,
              ),
              textAlign: TextAlign.justify,
            ),
          ),
        ),
      ],
    );
  }

  // بناء spans للترجمة مع الحواشي
  List<InlineSpan> _buildTranslationSpans() {
    if (translationList.isEmpty || ayahIndex <= 0) {
      return [const TextSpan(text: '')];
    }

    // استخدام دالة helper من TafsirCtrl للحصول على الترجمة
    final translation = TafsirCtrl.instance.getTranslationForAyahModel(
      ayahs,
      ayahIndex,
    );

    if (translation!.cleanText.isEmpty) {
      if (kDebugMode) {
        print(
          'No translation found for Surah: ${ayahs.surahNumber}, Ayah: ${ayahs.ayahNumber}, Index: $ayahIndex, Total translations: ${translationList.length}',
        );
      }
      final s =
          tafsirStyle ??
          (TafsirTheme.of(context)?.style ??
              TafsirStyle.defaults(isDark: isDark, context: context));
      return [
        TextSpan(text: s.tafsirIsEmptyNote, style: QuranLibrary().cairoStyle),
      ];
    }
    final spans = <InlineSpan>[
      // النص الأساسي بدون HTML tags
      TextSpan(children: translation.text.toFlutterText(isDark)),
    ];

    // إضافة الحواشي إذا وجدت
    final footnotes = translation.orderedFootnotesWithNumbers;
    if (footnotes.isNotEmpty) {
      spans.add(const TextSpan(text: '\n\n'));

      // خط فاصل
      spans.add(
        WidgetSpan(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            height: 1,
            color:
                (tafsirStyle ??
                        (TafsirTheme.of(context)?.style ??
                            TafsirStyle.defaults(
                              isDark: isDark,
                              context: context,
                            )))
                    .dividerColor,
          ),
        ),
      );
      spans.add(const TextSpan(text: '\n'));

      spans.add(
        TextSpan(
          text:
              '${(tafsirStyle ?? (TafsirTheme.of(context)?.style ?? TafsirStyle.defaults(isDark: isDark, context: context))).footnotesName ?? 'الحواشي:'}\n',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: fontSizeArabic * 0.95,
            color:
                (tafsirStyle ??
                        (TafsirTheme.of(context)?.style ??
                            TafsirStyle.defaults(
                              isDark: isDark,
                              context: context,
                            )))
                    .textColor,
          ),
        ),
      );

      for (final footnoteEntry in footnotes) {
        final number = footnoteEntry.key;
        final footnoteData = footnoteEntry.value;

        spans.add(
          TextSpan(
            children: [
              TextSpan(
                text: '($number) ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: fontSizeArabic * 0.9,
                  color:
                      (tafsirStyle ??
                              (TafsirTheme.of(context)?.style ??
                                  TafsirStyle.defaults(
                                    isDark: isDark,
                                    context: context,
                                  )))
                          .textColor,
                ),
              ),
              TextSpan(
                text: '${footnoteData.value}\n\n',
                style: TextStyle(
                  fontSize: fontSizeArabic * 0.85,
                  color:
                      (tafsirStyle ??
                              (TafsirTheme.of(context)?.style ??
                                  TafsirStyle.defaults(
                                    isDark: isDark,
                                    context: context,
                                  )))
                          .textColor,
                  height: 1.4,
                ),
              ),
            ],
          ),
        );
      }
    }

    return spans;
  }
}
