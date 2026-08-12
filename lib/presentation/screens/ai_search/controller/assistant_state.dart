part of '../ai_search.dart';

/// نماذج الأدوار في محادثة المساعد (موافقة لأدوار OpenAI).
enum ChatRole { user, assistant, tool }

/// نوع النص المنقول من مصدر موثوق (يحدّد شكل العرض في QuotationCard).
enum QuotationType { hadith, ayah, tafsir, scholar, fiqh, aqeedah, seerah, other }

/// نصٌّ منقولٌ حرفياً من مصدر موثوق (كتاب/تفسير/حديث) — لا يُمرَّر للـ LLM إطلاقاً.
///
/// يُؤخذ مباشرة من نتائج أدوات MCP ويُعرض للمستخدم في بطاقة اقتباس مميزة،
/// لضمان نسخٍ حرفيٍّ بلا أي تحريف أو إعادة صياغة.
class Quotation {
  /// النص الأصلي حرفياً من MCP (لا يُمَس ولا يُعاد صياغته).
  final String text;

  /// نسبة المصدر: اسم الكتاب + المؤلف (كما ظهرا في نتائج MCP).
  final String? attribution;

  /// نوع النص المنقول (يحدّد التصميم البصري في QuotationCard).
  final QuotationType type;

  /// اسم الأداة التي جلبت هذا النص (للتشخيص فقط).
  final String? toolName;

  /// نسبة المصدر العام (مثل «مركز تفسير» أو «مكتبة الحكمة») — تُعرض تحت النسبة التفصيلية.
  /// لا تدخل في أي منطق بحث/استخراج، فقط للعرض.
  final String? sourceLabel;

  /// المعرّف الرقمي للقطعة في خادم MCP (لجلب النص الكامل عبر fetch_passage).
  /// يكون null للنصوص التي لا تدعم الجلب (آيات، تفاسير من fetch_tafsir).
  /// يكون موجوداً لنتائج search_* من heekmah/seerah (كل نتيجة لها معرّف).
  final int? passageId;

  /// اسم الكتاب كما جاء من MCP (مثل «المجموع شرح المهذب - ط المنيرية»).
  /// يُستخدم لمطابقة الكتاب في BooksController للتنقل لصفحته.
  /// يكون null للاقتباسات التي لا تدعم التنقل (آيات، تفاسير من tafsir-mcp).
  final String? bookSourceName;

  /// رقم الصفحة في الكتاب (مستخرج من حقل المرجع في MCP).
  /// يُستخدم مع bookSourceName للتنقل للصفحة الصحيحة.
  final int? pageNumber;

  /// حواشي الكتاب (فروق النسخ، تخريج الأحاديث) من tafsir-mcp.
  /// تُعرض كحواشي مرقمة في أسفل البطاقة. فارغة للاقتباسات بلا حواشي.
  final List<String> footnotes;

  const Quotation({
    required this.text,
    required this.type,
    this.attribution,
    this.toolName,
    this.sourceLabel,
    this.passageId,
    this.bookSourceName,
    this.pageNumber,
    this.footnotes = const [],
  });

  factory Quotation.fromJson(Map<String, dynamic> json) {
    final typeStr = json['tp'] as String? ?? 'other';
    QuotationType parseType(String s) {
      switch (s) {
        case 'hadith':
          return QuotationType.hadith;
        case 'ayah':
          return QuotationType.ayah;
        case 'tafsir':
          return QuotationType.tafsir;
        case 'scholar':
          return QuotationType.scholar;
        case 'fiqh':
          return QuotationType.fiqh;
        case 'aqeedah':
          return QuotationType.aqeedah;
        case 'seerah':
          return QuotationType.seerah;
        default:
          return QuotationType.other;
      }
    }
    return Quotation(
      text: json['tx'] as String? ?? '',
      attribution: (json['at'] as String?)?.trim().isEmpty == true
          ? null
          : json['at'] as String?,
      type: parseType(typeStr),
      toolName: json['tn'] as String?,
      sourceLabel: (json['sl'] as String?)?.trim().isEmpty == true
          ? null
          : json['sl'] as String?,
      passageId: json['pid'] as int?,
      bookSourceName: (json['bn'] as String?)?.trim().isEmpty == true
          ? null
          : json['bn'] as String?,
      pageNumber: json['pg'] as int?,
      footnotes: (json['fn'] as List?)
              ?.map((f) => f.toString())
              .toList(growable: false) ??
          const [],
    );
  }

  Map<String, dynamic> toJson() => {
        'tx': text,
        if (attribution != null && attribution!.isNotEmpty) 'at': attribution,
        'tp': type.name,
        if (toolName != null) 'tn': toolName,
        if (sourceLabel != null && sourceLabel!.isNotEmpty) 'sl': sourceLabel,
        if (passageId != null) 'pid': passageId,
        if (bookSourceName != null && bookSourceName!.isNotEmpty)
          'bn': bookSourceName,
        if (pageNumber != null) 'pg': pageNumber,
        if (footnotes.isNotEmpty) 'fn': footnotes,
      };
}

/// رسالة واحدة في محادثة المساعد الذكي.
class ChatMessage {
  final ChatRole role;
  final String content;

  /// اسم الأداة المرتبطة (لرسائل role=tool فقط).
  final String? toolName;

  /// النصوص المنقولة من مصادر موثوقة المرتبطة بهذه الرسالة (لرسائل role=assistant).
  ///
  /// هذه الاقتباسات تُؤخذ مباشرة من نتائج MCP دون تمريرها للـ LLM، وتُعرض
  /// للمستخدم في بطاقات اقتباس مميزة أسفل مقدمة المساعد. تضمن نسخاً حرفياً بلا تحريف.
  final List<Quotation> quotations;

  const ChatMessage({
    required this.role,
    required this.content,
    this.toolName,
    this.quotations = const [],
  });

  bool get isUser => role == ChatRole.user;
  bool get isAssistant => role == ChatRole.assistant;
  bool get isTool => role == ChatRole.tool;

  /// هل تحوي الرسالة اقتباسات منقولة؟
  bool get hasQuotations => quotations.isNotEmpty;

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    final roleStr = json['r'] as String? ?? 'user';
    final rawQuotations = json['qs'] as List? ?? [];
    return ChatMessage(
      role: roleStr == 'assistant'
          ? ChatRole.assistant
          : roleStr == 'tool'
              ? ChatRole.tool
              : ChatRole.user,
      content: json['c'] as String? ?? '',
      toolName: json['t'] as String?,
      quotations: rawQuotations
          .map((q) => Quotation.fromJson(q as Map<String, dynamic>))
          .toList(growable: false),
    );
  }

  Map<String, dynamic> toJson() => {
        'r': role.name,
        'c': content,
        if (toolName != null) 't': toolName,
        if (quotations.isNotEmpty)
          'qs': quotations.map((q) => q.toJson()).toList(),
      };
}
