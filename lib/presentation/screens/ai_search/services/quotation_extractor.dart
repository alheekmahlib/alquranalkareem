part of '../ai_search.dart';

/// نتيجة استخراج الاقتباسات من مخرجات أداة MCP.
///
/// [quotations] = النصوص المنقولة كاملةً (تُعرض للمستخدم مباشرة، لا تمر عبر LLM).
/// [llmSummary] = ملخص قصير آمن يُمرَّر للـ LLM بدل النص الكامل (يمنع إعادة الصياغة).
/// [rawText] = النص الخام الكامل المنظَّف (للعرض المباشر عند الحاجة).
class ExtractionResult {
  final List<Quotation> quotations;
  final String llmSummary;
  final String rawText;

  const ExtractionResult({
    required this.quotations,
    required this.llmSummary,
    required this.rawText,
  });

  bool get isEmpty => quotations.isEmpty && rawText.trim().isEmpty;
}

/// يحوّل نتيجة أداة MCP إلى [ExtractionResult] آمن.
///
/// **المبدأ الجوهري:** النصوص المنقولة من الكتب (أحاديث، آيات، تفاسير، أقوال
/// العلماء) تُستخرج هنا مباشرةً من مخرجات MCP وتُخزَّن كـ [Quotation] منفصلة،
/// ولا تُمرَّر للـ LLM إطلاقاً. الـ LLM يرى فقط [ExtractionResult.llmSummary] —
/// ملخصاً قصيراً يصف ما وُجد دون أن يحوي النص الكامل. هذا يضمن نسخاً حرفياً
/// بلا أي تحريف أو إعادة صياغة.
///
/// يدعم مصدري الشكل:
/// - **tafsir-mcp:** JSON منظَّم (حقول `text` و`attribution`/`source_attribution`).
/// - **heekmah/seerah-mcp:** نص Markdown خام مقسَّم بـ `### النتيجة N`،
///   النسبة في سطر `المصدر: ... | المؤلف: ... | المرجع: ...`.
class QuotationExtractor {
  /// يستخرج الاقتباسات + الملخص الآمن للـ LLM من مخرجات أداة MCP.
  ///
  /// [toolResult] = النص الخام المُعاد من `McpToolResult.text` (محتوى `content[].text`).
  /// [toolName] = اسم الأداة (يحدّد كيفية الاستخراج).
  /// [source] = الخادم المصدر (tafsir / heekmah / seerah).
  static ExtractionResult extract({
    required String toolResult,
    required String toolName,
    required _McpSource source,
  }) {
    if (toolResult.trim().isEmpty) {
      return const ExtractionResult(
        quotations: [],
        llmSummary: 'لا توجد نتائج.',
        rawText: '',
      );
    }

    // **هام:** لا نُطبّق _cleanRaw على كامل النص قبل فكّ JSON، لأن استبدال
    // `\\n` بسطر فعلي يُفسد تسلسلات الهروب داخل نصوص JSON ويجعلها غير صالحة.
    // بدلاً من ذلك، نفكّ JSON من النص الخام، ونُنظّف فقط القيم المستخرجة.
    final List<Quotation> quotations;
    switch (source) {
      case _McpSource.tafsir:
        quotations = _extractTafsir(toolResult, toolName);
        break;
      case _McpSource.heekmah:
        quotations = _extractHeekmahStyle(_cleanRaw(toolResult), toolName);
        break;
      case _McpSource.seerah:
        quotations = _extractHeekmahStyle(_cleanRaw(toolResult), toolName);
        break;
    }

    // لو لم نتمكن من الاستخراج المنظَّم، اعتبر النص كله اقتباساً واحداً —
    // **لكن فقط إذا لم يكن JSON خاماً** (JSON الخام لا يُفيد المستخدم كاقتباس).
    if (quotations.isEmpty && toolResult.trim().isNotEmpty) {
      final looksLikeJson = toolResult.trimLeft().startsWith('{') ||
          toolResult.trimLeft().startsWith('[');
      if (looksLikeJson) {
        // JSON لم نتمكن من فكّه — لا تعرضه كاقتباس. أخبر الـ LLM فقط.
        return ExtractionResult(
          quotations: const [],
          llmSummary: 'وُجدت بيانات منسَّقة (JSON) لم يُمكن استخراج نصٍّ منها تلقائياً.',
          rawText: toolResult,
        );
      }
      final cleaned = _cleanRaw(toolResult);
      return ExtractionResult(
        quotations: [
          Quotation(
            text: cleaned.trim(),
            type: QuotationType.other,
            attribution: null,
            toolName: toolName,
            sourceLabel: _sourceLabelFor(source),
          ),
        ],
        llmSummary: _buildFallbackSummary(cleaned),
        rawText: cleaned,
      );
    }

    // أضف نسبة المصدر العام لكل اقتباس (للعرض فقط، لا تدخل في المنطق).
    final labeled = quotations
        .map((q) => Quotation(
              text: q.text,
              type: q.type,
              attribution: q.attribution,
              toolName: q.toolName,
              sourceLabel: _sourceLabelFor(source),
            ))
        .toList();

    return ExtractionResult(
      quotations: labeled,
      llmSummary: _buildLlmSummary(labeled),
      rawText: _cleanRaw(toolResult),
    );
  }

  /// يحدّد نسبة المصدر العام (للعرض تحت النسبة التفصيلية).
  /// لا تدخل في أي منطق بحث/استخراج — فقط للعرض في QuotationCard.
  static String _sourceLabelFor(_McpSource source) {
    switch (source) {
      case _McpSource.tafsir:
        return 'مركز تفسير (tafsir.net)';
      case _McpSource.heekmah:
      case _McpSource.seerah:
        return 'مكتبة الحكمة';
    }
  }

  // ─── الاستخراج من خادم tafsir-mcp (JSON منظَّم) ───────────────────

  /// يستخرج الاقتباسات من مخرجات tafsir-mcp.
  ///
  /// الأدوات تُعيد JSON بصور مختلفة:
  /// - `fetch_ayah`: `{text, text_uthmani, ...}` (آية واحدة).
  /// - `fetch_tafsir`: `{tafsirs: [{text, attribution, ...}]}`.
  /// - `fetch_nuzool_reason`: نص سبب النزول.
  /// - `search_quran_text`: `[{surah, ayah, text, snippet}]`.
  /// - `search_in_tafsir`: `[{tafsir_excerpt, source_attribution, ...}]`.
  /// - أدوات إحصاءات/إعراب: نصوص تقنية (ليست اقتباسات كتاب).
  static List<Quotation> _extractTafsir(String text, String toolName) {
    // محاولة فكّ JSON من النص الخام (دون _cleanRaw لتفادي إفساد تسلسلات الهروب).
    final decoded = _tryDecodeJson(text);
    if (decoded == null) {
      // ليس JSON — ربما نص سبب نزول أو إحصاءات. عالجه كاقتباس واحد.
      if (text.trim().isEmpty) return [];
      return [
        Quotation(
          text: _cleanRaw(text),
          type: _inferTafsirType(toolName),
          attribution: null,
          toolName: toolName,
        ),
      ];
    }

    final quotations = <Quotation>[];

    // الحالة 1: fetch_ayah — آية واحدة في حقل `text`.
    if (decoded is Map &&
        (decoded.containsKey('text') || decoded.containsKey('text_uthmani')) &&
        !decoded.containsKey('tafsirs')) {
      final ayahText = (decoded['text_uthmani'] ??
              decoded['text'] ??
              '')
          .toString();
      if (ayahText.isNotEmpty) {
        quotations.add(Quotation(
          text: _cleanRaw(ayahText),
          type: QuotationType.ayah,
          attribution: _formatSurahAyahRef(decoded),
          toolName: toolName,
        ));
      }
      return quotations;
    }

    // الحالة 2: fetch_tafsir — {tafsirs: [{text, attribution}]}.
    if (decoded is Map && decoded['tafsirs'] is List) {
      for (final t in decoded['tafsirs'] as List) {
        if (t is! Map) continue;
        final tText = (t['text'] ?? t['uthmanic_text'] ?? '').toString();
        final attribution = _cleanAttribution(
            (t['attribution'] ?? '').toString());
        if (tText.trim().isNotEmpty) {
          quotations.add(Quotation(
            text: _cleanRaw(tText),
            type: QuotationType.tafsir,
            attribution: attribution.isEmpty ? null : attribution,
            toolName: toolName,
          ));
        }
      }
      return quotations;
    }

    // الحالة 2-ب: fetch_nuzool_reason — {sources: [{text, attribution}]}.
    // أسباب النزول تأتي بصيغة مشابهة للتفسير لكن تحت مفتاح `sources` بدل `tafsirs`.
    if (decoded is Map && decoded['sources'] is List) {
      for (final s in decoded['sources'] as List) {
        if (s is! Map) continue;
        final sText = (s['text'] ?? s['text_clean'] ?? s['text_display'] ?? '')
            .toString();
        final attribution = _cleanAttribution(
            (s['attribution'] ?? '').toString());
        if (sText.trim().isNotEmpty) {
          quotations.add(Quotation(
            text: _cleanRaw(sText),
            // أسباب النزول = أقوال مروية عن الصحابة والتابعين.
            type: QuotationType.scholar,
            attribution: attribution.isEmpty ? null : attribution,
            toolName: toolName,
          ));
        }
      }
      return quotations;
    }

    // الحالة 3: search_quran_text — [{surah, ayah, text, snippet}].
    if (decoded is List &&
        decoded.isNotEmpty &&
        (decoded.first is Map) &&
        (decoded.first as Map).containsKey('text')) {
      for (final item in decoded) {
        if (item is! Map) continue;
        final ayahText = (item['text'] ?? '').toString();
        if (ayahText.trim().isNotEmpty) {
          quotations.add(Quotation(
            text: _cleanRaw(ayahText),
            type: QuotationType.ayah,
            attribution: _formatSurahAyahRef(item),
            toolName: toolName,
          ));
        }
      }
      return quotations;
    }

    // الحالة 4: search_in_tafsir — [{tafsir_excerpt, source_attribution}].
    if (decoded is List &&
        decoded.isNotEmpty &&
        (decoded.first is Map) &&
        (decoded.first as Map).containsKey('tafsir_excerpt')) {
      for (final item in decoded) {
        if (item is! Map) continue;
        final excerpt = (item['tafsir_excerpt'] ??
                item['tafsir_excerpt_clean'] ??
                item['tafsir_excerpt_raw'] ??
                '')
            .toString();
        final attribution = _cleanAttribution(
            (item['source_attribution'] ?? '').toString());
        if (excerpt.trim().isNotEmpty) {
          quotations.add(Quotation(
            text: _cleanRaw(excerpt),
            type: QuotationType.tafsir,
            attribution: attribution.isEmpty ? null : attribution,
            toolName: toolName,
          ));
        }
      }
      return quotations;
    }

    // الحالة 5: JSON عام غير معروف — لا تعرض JSON خام. أعد قائمة فارغة
    // ليتمسك الـ fallback بمنع عرض JSON (انظر extract()).
    return quotations;
  }

  // ─── الاستخراج من خادمي heekmah/seerah (Markdown خام) ─────────────

  /// يستخرج الاقتباسات من نص Markdown خام بصيغة heekmah/seerah.
  ///
  /// صيغة `search_*`:
  /// ```
  /// وجدت N نتيجة لـ "query"
  ///
  /// ### النتيجة 1 — معرّف 98594
  /// <النص، التطابقات محاطة بـ <m>...</m>>
  /// المصدر: ... | المؤلف: ... | المرجع: ... | القسم: ...
  /// ```
  ///
  /// صيغة `fetch_passage`:
  /// ```
  /// ### القطعة رقم 98594 — الفقه
  /// <النص الكامل>
  /// المصدر: ... | المؤلف: ... | التصنيف: ... | المرجع: ...
  /// ```
  /// الحد الأقصى لعدد الاقتباسات المستخرجة من نتائج البحث (search_*).
  ///
  /// خادم MCP يرتّب نتائج البحث حسب الصلة، فالأولى هي الأكثر صلة. عرض 15 نتيجة
  /// كلها يُغرق المستخدم بنصوص قد لا تكون متعلقة. نكتفي بأعلى النتائج صلةً.
  /// (fetch_passage عادةً يُعيد قطعة واحدة فلا يتأثر بهذا الحد.)
  static const int _maxSearchQuotations = 3;

  static List<Quotation> _extractHeekmahStyle(String text, String toolName) {
    final quotations = <Quotation>[];

    // ارفض رسائل «لا توجد نتائج» — لا تعرضها كاقتباس للمستخدم.
    // خادم MCP يُعيد رسائل صريحة مثل: «لا توجد نتائج مطابقة لـ ... في الفقه».
    if (text.contains('لا توجد نتائج') ||
        text.contains('لا توجد مطابقات') ||
        text.contains('لم يتم العثور')) {
      return [];
    }

    // قسّم النص على عناوين النتائج/القطع.
    // نطابق: "### النتيجة N" أو "### القطعة رقم N".
    final sectionRegex = RegExp(
      r'^###\s+(?:النتيجة\s+\d+|القطعة\s+رقم\s+\d+).*$',
      multiLine: true,
    );
    final matches = sectionRegex.allMatches(text);

    // لو لم نجد أقساماً، ربما النتيجة كلها قطعة واحدة (مثل fetch_passage لمقطع واحد).
    if (matches.isEmpty) {
      final parsed = _parseHeekmahBlock(text, toolName);
      if (parsed != null) return [parsed];
      return [];
    }

    // قسّم النص إلى كتل حسب مواضع العناوين.
    final startIndices = matches.map((m) => m.start).toList();
    // هل هذا بحث (search_*) أم جلب مقطع (fetch_passage)؟
    // search_* يُعيد عدة نتائج مرتبة حسب الصلة — نأخذ أعلى N فقط.
    // fetch_passage عادةً يُعيد قطعة واحدة فنأخذها كلها.
    final isSearch = toolName.startsWith('search_');
    final limit = isSearch
        ? startIndices.length.clamp(0, _maxSearchQuotations)
        : startIndices.length;

    for (int i = 0; i < limit; i++) {
      final start = startIndices[i];
      final end = i + 1 < startIndices.length ? startIndices[i + 1] : text.length;
      final block = text.substring(start, end);
      final parsed = _parseHeekmahBlock(block, toolName);
      if (parsed != null) quotations.add(parsed);
    }

    return quotations;
  }

  /// يحلّل كتلة واحدة (نتيجة/قطعة) من نص heekmah/seerah.
  ///
  /// يتوقع: سطر عنوان `### ...`، ثم نص، ثم سطر `المصدر: ... | المؤلف: ...`.
  static Quotation? _parseHeekmahBlock(String block, String toolName) {
    final lines = block.split('\n');

    // ابحث عن سطر "المصدر: ..." (النسبة).
    String? source, author, reference, section;
    int? metaLineIndex;
    for (int i = 0; i < lines.length; i++) {
      final line = lines[i].trim();
      if (line.startsWith('المصدر:') || line.startsWith('المصدر :')) {
        metaLineIndex = i;
        // حلّل الحقول المفصولة بـ |.
        final parts = line.split('|');
        for (final p in parts) {
          final kv = p.split(':');
          if (kv.length < 2) continue;
          final key = kv[0].trim();
          final value = kv.sublist(1).join(':').trim();
          switch (key) {
            case 'المصدر':
              source = value;
              break;
            case 'المؤلف':
              author = value;
              break;
            case 'المرجع':
              reference = value;
              break;
            case 'القسم':
            case 'التصنيف':
              section = value;
              break;
          }
        }
        break;
      }
    }

    // استخرج نص الكتلة: كل ما بعد سطر العنوان وحتى سطر المصدر (أو نهاية الكتلة).
    // نتخطى سطر العنوان (###) وأي سطور فارغة بعده مباشرة.
    int textStart = 0;
    for (int i = 0; i < lines.length; i++) {
      if (lines[i].trim().startsWith('###')) {
        textStart = i + 1;
        break;
      }
    }
    // تخطَّ الأسطر الفارغة في البداية.
    while (textStart < lines.length && lines[textStart].trim().isEmpty) {
      textStart++;
    }

    final textEnd = metaLineIndex ?? lines.length;
    final textLines = lines.sublist(textStart, textEnd);
    // نظّف علامات التطابق <m>...</m> واحتفظ بالنص.
    var body = textLines.join('\n').trim();
    body = _stripMatchMarkers(body);

    if (body.isEmpty) return null;

    // ابنِ نسبة المصدر: "اسم الكتاب — المؤلف" أو ما يتوفر.
    final attribution = _buildHeekmahAttribution(
      source: source,
      author: author,
      reference: reference,
    );

    return Quotation(
      text: body,
      type: _inferHeekmahType(section, toolName),
      attribution: attribution,
      toolName: toolName,
    );
  }

  // ─── مساعدات ─────────────────────────────────────────────────────

  /// ينظّف نص النسبة (attribution) من البيانات غير المرغوبة.
  ///
  /// يحذف: الروابط (http/https)، أسماء التطبيقات/القواعد الملتصقة، المسافات الزائدة.
  /// النسبة الناتجة يجب أن تكون: «اسم الكتاب + المؤلف» فقط.
  static String _cleanAttribution(String s) {
    if (s.trim().isEmpty) return '';
    var v = s.trim();
    // احذف الروابط.
    v = v.replaceAll(RegExp(r'https?://\S+'), '').trim();
    // احذف أسماء تطبيقات/قواعد معروفة إن تسللت (تظهر في بيانات خام أحياناً).
    const appNames = [
      'القرآن الكريم - مكتبة الحكمة',
      'مكتبة الحكمة',
      'قاعدة بيانات مركز تفسير',
      'قاعدة بيانات مكتبة الحكمة',
      'tafsir.net',
      'alheekmah-mcp',
    ];
    for (final name in appNames) {
      v = v.replaceAll(name, '').trim();
    }
    // احذف فواصل/شرطات زائدة في الأطراف بعد الحذف.
    // ملاحظة: الشرطة - يجب أن تكون في نهاية مجموعة الأحرف كي لا تُفسَّر كنطاق.
    v = v.replaceAll(RegExp(r'^[—–\|\s-]+'), '').trim();
    v = v.replaceAll(RegExp(r'[—–\|\s-]+$'), '').trim();
    return v;
  }

  /// ينظّف النص الخام من MCP: يحوّل `\n` الحرفية لأسطر، يحذف رموزاً تقنية معروفة.
  ///
  /// **هام:** لا يحذف الأحرف اللاتينية ولا يُحرّف النص — التنظيف محدود وآمن.
  static String _cleanRaw(String text) {
    var cleaned = text;
    // رموز تقنية من tafsir-mcp.
    const techPatterns = [
      'accordingtov2searchbyroot',
      'according_to_v2_search_by_root',
    ];
    for (final pattern in techPatterns) {
      cleaned = cleaned.replaceAll(pattern, '');
    }
    // حوّل رموز الأسطر الجديدة الحرفية لأسطر فعلية.
    cleaned = cleaned.replaceAll('\\n', '\n');
    // اقلب تسلسل الأسطر الفارغة الزائد.
    cleaned = cleaned.replaceAll(RegExp(r'\n{3,}'), '\n\n');
    return cleaned.trim();
  }

  /// يحاول فكّ JSON من نص. يرجع null عند الفشل (النص ليس JSON).
  static dynamic _tryDecodeJson(String text) {
    final trimmed = text.trim();
    if (!trimmed.startsWith('{') && !trimmed.startsWith('[')) return null;
    try {
      return jsonDecode(trimmed);
    } catch (_) {
      // ربما JSON محاط بنص — حاول استخراج أول { ... } أو [ ... ].
      final objMatch = RegExp(r'\{[\s\S]*\}').firstMatch(trimmed);
      if (objMatch != null) {
        try {
          return jsonDecode(objMatch.group(0)!);
        } catch (_) {}
      }
      final arrMatch = RegExp(r'\[[\s\S]*\]').firstMatch(trimmed);
      if (arrMatch != null) {
        try {
          return jsonDecode(arrMatch.group(0)!);
        } catch (_) {}
      }
      return null;
    }
  }

  /// يبني نسبة "السورة:الآية" من كائن نتيجة tafsir-mcp.
  static String? _formatSurahAyahRef(Map<dynamic, dynamic> decoded) {
    final surah = decoded['surah'];
    final ayah = decoded['ayah'];
    if (surah == null || ayah == null) return null;
    return 'سورة رقم $surah — آية $ayah';
  }

  /// يستنتج نوع الاقتباس من اسم أداة tafsir.
  static QuotationType _inferTafsirType(String toolName) {
    switch (toolName) {
      case 'fetch_ayah':
      case 'search_quran_text':
      case 'get_qeraat_variants':
        return QuotationType.ayah;
      case 'fetch_tafsir':
      case 'search_in_tafsir':
        return QuotationType.tafsir;
      case 'fetch_nuzool_reason':
        return QuotationType.scholar; // أسباب النزول = أقوال مروية.
      default:
        return QuotationType.other; // إحصاءات، إعراب، إلخ.
    }
  }

  /// يستنتج نوع الاقتباس من قسم/تصنيف heekmah.
  static QuotationType _inferHeekmahType(String? section, String toolName) {
    final s = section?.toLowerCase() ?? '';
    if (s.contains('حديث')) return QuotationType.hadith;
    if (s.contains('فقه')) return QuotationType.fiqh;
    if (s.contains('عقيد')) return QuotationType.aqeedah;
    if (s.contains('سير') || s.contains('تاريخ')) return QuotationType.seerah;
    // استنتاج من اسم الأداة كـ fallback.
    if (toolName.contains('hadith')) return QuotationType.hadith;
    if (toolName.contains('fiqh')) return QuotationType.fiqh;
    if (toolName.contains('aqeedah')) return QuotationType.aqeedah;
    if (toolName.contains('seerah')) return QuotationType.seerah;
    return QuotationType.other;
  }

  /// يبني نسبة مصدر مختصرة لـ heekmah من الحقول المتوفرة.
  ///
  /// صيغة heekmah النموذجية:
  /// `المصدر: كتاب المجموع شرح المهذب | المؤلف: النووي | المرجع: كتاب المجموع... — ص 317 | القسم: الفقه`
  /// نُنتج: «المجموع شرح المهذب — النووي — ص 317» (بدون تكرار، وبدون «كتاب» الزائدة).
  static String? _buildHeekmahAttribution({
    String? source,
    String? author,
    String? reference,
  }) {
    final cleanSource = _cleanAttribution(source ?? '');
    final cleanAuthor = _cleanAttribution(author ?? '');
    final cleanReference = _cleanAttribution(reference ?? '');

    // المرجع عادةً يكرر المصدر + يضيف رقم صفحة. استخرج رقم الصفحة فقط إن تكرر المصدر.
    String? pageNumber;
    if (cleanReference.isNotEmpty && cleanSource.isNotEmpty &&
        cleanReference.contains(cleanSource)) {
      final tail = cleanReference.substring(cleanSource.length).trim();
      final pageMatch = RegExp(r'ص\s*\.?\s*(\d+)').firstMatch(tail);
      if (pageMatch != null) {
        pageNumber = 'ص ${pageMatch.group(1)}';
      }
    }

    // ابنِ النسبة: «المصدر — المؤلف — ص N».
    final parts = <String>[];
    if (cleanSource.isNotEmpty) parts.add(cleanSource);
    if (cleanAuthor.isNotEmpty) parts.add(cleanAuthor);
    if (pageNumber != null) {
      parts.add(pageNumber);
    } else if (cleanReference.isNotEmpty &&
        cleanSource.isNotEmpty &&
        !cleanReference.contains(cleanSource)) {
      parts.add(cleanReference);
    } else if (cleanReference.isNotEmpty && cleanSource.isEmpty) {
      parts.add(cleanReference);
    }

    final attribution = parts.join(' — ').trim();
    return attribution.isEmpty ? null : attribution;
  }

  /// يحذف علامات التطابق <m>...</m> ويبقي النص داخلها.
  static String _stripMatchMarkers(String text) {
    return text
        .replaceAll('</m>', '')
        .replaceAll(RegExp(r'<m>'), '');
  }

  /// يبني ملخصاً آمناً للـ LLM يصف ما وُجد دون ذكر النص الكامل.
  ///
  /// مثال: "وجدت 3 نصوص: حديث (المصدر: صحيح البخاري)، تفسير (السعد)، آية قرآنية."
  /// الـ LLM يرى هذا فقط فيعرف أن النصوص موجودة، لكنه لا يستطيع تحريفها.
  static String _buildLlmSummary(List<Quotation> quotations) {
    if (quotations.isEmpty) return 'لا توجد نتائج.';

    final buffer = StringBuffer();
    buffer.write('تم العثور على ${quotations.length} ');

    // وصفت النتائج بحسب النوع.
    final typeCounts = <QuotationType, int>{};
    for (final q in quotations) {
      typeCounts[q.type] = (typeCounts[q.type] ?? 0) + 1;
    }
    final typeNames = <QuotationType, String>{
      QuotationType.ayah: 'آية قرآنية',
      QuotationType.hadith: 'حديث',
      QuotationType.tafsir: 'تفسير',
      QuotationType.scholar: 'قول لعالم',
      QuotationType.fiqh: 'نص فقهي',
      QuotationType.aqeedah: 'نص عقدي',
      QuotationType.seerah: 'نص سيري',
      QuotationType.other: 'نص',
    };
    final typeParts = <String>[];
    typeCounts.forEach((type, count) {
      final name = typeNames[type] ?? 'نص';
      typeParts.add(count == 1 ? name : '$name ($count)');
    });
    buffer.write(typeParts.join('، '));
    buffer.write('.');

    // اذكر المصادر المتوفرة (للـ LLM ليكتب مقدمة دقيقة).
    final sources = quotations
        .map((q) => q.attribution)
        .whereType<String>()
        .where((s) => s.trim().isNotEmpty)
        .toSet();
    if (sources.isNotEmpty) {
      buffer.write(' المصادر: ');
      buffer.write(sources.take(4).join('، '));
      buffer.write('.');
    }

    // تلميح حرجة للـ LLM.
    buffer.write(' النصوص الكاملة تُعرض للمستخدم منفصلة، لا تنسخها ولا تذكرها حرفياً؛ '
        'اكتب فقط مقدمة قصيرة تربط السؤال بهذه النتائج.');
    return buffer.toString();
  }

  /// ملخص احتياطي حين فشل الاستخراج المنظَّم.
  static String _buildFallbackSummary(String rawText) {
    final length = rawText.length;
    final preview = rawText.length > 120
        ? '${rawText.substring(0, 120)}…'
        : rawText;
    return 'وُجد نص ($length حرف). النص الكامل يُعرض للمستخدم منفصلاً. '
        'لمحة: "$preview". '
        'لا تنسخ النص، فقط اكتب مقدمة قصيرة تربط السؤال به.';
  }
}
