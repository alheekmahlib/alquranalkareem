import 'package:quran_library/quran_library.dart';

/// لقطة خطأ تسميع واحدة قابلة للتسلسل — تُشتق من [RecitationError] عند
/// الحفظ وتُعاد بناءها للعرض لاحقًا، فتُعرض النتائج المحفوظة بنفس
/// [TasmeeErrorCard] دون تعديل نماذج المكتبة.
///
/// تُخزَّن فقط الحقول التي تُعرض فعلًا: نوعا الخطأ، الكلمة، الفونيمات،
/// أطوال المد، الموضع في المصحف، واسم القاعدة الأول (عربي/إنجليزي).
class TasmeeErrorSnapshot {
  const TasmeeErrorSnapshot({
    required this.errorType,
    required this.speechErrorType,
    this.wordText,
    this.expectedPh,
    this.predictedPh,
    this.expectedLen,
    this.predictedLen,
    this.suraIdx,
    this.ayaIdx,
    this.wordIdx,
    this.ruleNameAr,
    this.ruleNameEn,
  });

  /// نوع الخطأ: 'tajweed' أو 'normal' أو 'tashkeel'.
  final String errorType;

  /// نوع خطأ النطق: 'insert' أو 'delete' أو 'replace'.
  final String speechErrorType;

  /// الكلمة القرآنية المتأثرة بالخطأ (إن عُرفت).
  final String? wordText;

  /// الفونيمات المتوقعة/المنطوقة فعلاً.
  final String? expectedPh;
  final String? predictedPh;

  /// الطول المتوقع/الفعلي (عدد الحركات للمدود).
  final int? expectedLen;
  final int? predictedLen;

  /// موضع الخطأ في المصحف (سورة، آية 1-based، كلمة 0-based).
  final int? suraIdx;
  final int? ayaIdx;
  final int? wordIdx;

  /// اسم قاعدة التجويد الأولى إن وُجدت (لعنوان البطاقة).
  final String? ruleNameAr;
  final String? ruleNameEn;

  factory TasmeeErrorSnapshot.fromRecitationError(RecitationError error) {
    final rules = [
      ...error.refTajweedRules,
      ...error.insertedTajweedRules,
      ...error.replacedTajweedRules,
      ...error.missingTajweedRules,
    ];
    final rule = rules.isNotEmpty ? rules.first : null;
    return TasmeeErrorSnapshot(
      errorType: error.errorType,
      speechErrorType: error.speechErrorType,
      wordText: error.wordText,
      expectedPh: error.expectedPh,
      predictedPh: error.predictedPh,
      expectedLen: error.expectedLen,
      predictedLen: error.predictedLen,
      suraIdx: error.suraIdx,
      ayaIdx: error.ayaIdx,
      wordIdx: error.wordIdx,
      ruleNameAr: rule?.nameAr,
      ruleNameEn: rule?.nameEn,
    );
  }

  factory TasmeeErrorSnapshot.fromJson(Map<String, dynamic> json) =>
      TasmeeErrorSnapshot(
        errorType: json['errorType'] as String? ?? 'normal',
        speechErrorType: json['speechErrorType'] as String? ?? 'replace',
        wordText: json['wordText'] as String?,
        expectedPh: json['expectedPh'] as String?,
        predictedPh: json['predictedPh'] as String?,
        expectedLen: (json['expectedLen'] as num?)?.toInt(),
        predictedLen: (json['predictedLen'] as num?)?.toInt(),
        suraIdx: (json['suraIdx'] as num?)?.toInt(),
        ayaIdx: (json['ayaIdx'] as num?)?.toInt(),
        wordIdx: (json['wordIdx'] as num?)?.toInt(),
        ruleNameAr: json['ruleNameAr'] as String?,
        ruleNameEn: json['ruleNameEn'] as String?,
      );

  Map<String, dynamic> toJson() => {
    'errorType': errorType,
    'speechErrorType': speechErrorType,
    if (wordText != null) 'wordText': wordText,
    if (expectedPh != null) 'expectedPh': expectedPh,
    if (predictedPh != null) 'predictedPh': predictedPh,
    if (expectedLen != null) 'expectedLen': expectedLen,
    if (predictedLen != null) 'predictedLen': predictedLen,
    if (suraIdx != null) 'suraIdx': suraIdx,
    if (ayaIdx != null) 'ayaIdx': ayaIdx,
    if (wordIdx != null) 'wordIdx': wordIdx,
    if (ruleNameAr != null) 'ruleNameAr': ruleNameAr,
    if (ruleNameEn != null) 'ruleNameEn': ruleNameEn,
  };

  /// يعيد بناء [RecitationError] للعرض بنفس واجهات النتائج الحالية.
  RecitationError toRecitationError() {
    final hasRule =
        (ruleNameAr?.isNotEmpty ?? false) || (ruleNameEn?.isNotEmpty ?? false);
    return RecitationError(
      errorType: errorType,
      speechErrorType: speechErrorType,
      wordText: wordText,
      expectedPh: expectedPh,
      predictedPh: predictedPh,
      expectedLen: expectedLen,
      predictedLen: predictedLen,
      suraIdx: suraIdx,
      ayaIdx: ayaIdx,
      wordIdx: wordIdx,
      refTajweedRules: hasRule
          ? [
              TajweedRule(
                nameAr: ruleNameAr ?? '',
                nameEn: ruleNameEn ?? '',
                goldenLen: expectedLen,
              ),
            ]
          : const [],
    );
  }
}

/// نتيجة تسميع صفحة واحدة محفوظة — أحدث نتيجة لكل صفحة (upsert).
class TasmeePageResult {
  const TasmeePageResult({
    required this.pageNumber,
    required this.mode,
    required this.completedAt,
    required this.startSura,
    required this.startAya,
    required this.endSura,
    required this.endAya,
    required this.totalWords,
    required this.correctWords,
    required this.isFullyCorrect,
    required this.errors,
  });

  /// رقم صفحة المصحف (1–604) — مفتاح التخزين (نتيجة واحدة لكل صفحة).
  final int pageNumber;

  /// اسم نمط التسميع الذي أُنجزت به ('tasmee' أو 'corrector' أو 'teacher').
  final String mode;

  /// وقت إكمال الصفحة.
  final DateTime completedAt;

  /// بداية/نهاية النطاق المُسمَّع (سورة وآية) لشارة الموضع.
  final int startSura;
  final int startAya;
  final int endSura;
  final int endAya;

  /// إجمالي كلمات النطاق وعدد الكلمات الصحيحة.
  final int totalWords;
  final int correctWords;

  /// هل خلت الصفحة من الأخطاء تمامًا؟
  final bool isFullyCorrect;

  /// لقطات الأخطاء بترتيب ظهورها.
  final List<TasmeeErrorSnapshot> errors;

  int get totalErrors => errors.length;

  int get tajweedErrors => errors.where((e) => e.errorType == 'tajweed').length;

  int get normalErrors => errors.where((e) => e.errorType == 'normal').length;

  int get tashkeelErrors =>
      errors.where((e) => e.errorType == 'tashkeel').length;

  /// نسبة الكلمات الصحيحة (0–100).
  int get scorePercent => totalWords <= 0
      ? 0
      : (correctWords * 100 / totalWords).round().clamp(0, 100);

  /// يعيد بناء [RecitationResult] لعرضه بنفس [TasmeeResultWidget].
  RecitationResult toRecitationResult() => RecitationResult(
    start: SurahAyahPosition(suraIdx: startSura, ayaIdx: startAya),
    end: SurahAyahPosition(suraIdx: endSura, ayaIdx: endAya),
    // نص غير فارغ حتى تُعدّ النتيجة مطابِقة عند العرض (hasMatch).
    uthmaniText: ' ',
    errors: errors.map((e) => e.toRecitationError()).toList(),
  );
}
