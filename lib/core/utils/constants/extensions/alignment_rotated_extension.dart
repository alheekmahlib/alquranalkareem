import 'package:flutter/material.dart';
import 'package:get/get.dart';

const rtlLang = ['العربية', 'עברית', 'فارسی', 'اردو', 'کوردی'];

extension StringExtension on String {
  bool isRtlLanguage() {
    return rtlLang.contains(this);
  }

  bool isRtlLanguageWPassLang(String language) {
    return rtlLang.contains(language);
  }
}

extension RotatedAndAlignmentExtension on Widget {
  Widget rotatedRtlLayout() {
    if ('lang'.tr.isRtlLanguage()) {
      return RotatedBox(quarterTurns: 0, child: this);
    } else {
      return RotatedBox(quarterTurns: 2, child: this);
    }
  }

  alignmentLayout(var rtl, var ltr) {
    if ('lang'.tr.isRtlLanguage()) {
      return rtl;
    } else {
      return ltr;
    }
  }

  alignmentLayoutWPassLang(String language, var rtl, var ltr) {
    if (language.isRtlLanguageWPassLangTaf(language)) {
      return rtl;
    } else {
      return ltr;
    }
  }
}

extension StringExtensionApp on String {
  /// تحقق من كون النص يحتوي على أحرف عربية أو فارسية أو عبرية
  /// Check if text contains Arabic, Persian, or Hebrew characters
  bool _containsRtlCharacters() {
    // نطاق الأحرف العربية والفارسية والعبرية
    final rtlRange = RegExp(
        r'[\u0590-\u05FF\u0600-\u06FF\u0750-\u077F\uFB50-\uFDFF\uFE70-\uFEFF]');
    return rtlRange.hasMatch(this);
  }

  /// تحقق من كون النص يبدأ بكلمة "تفسير" أو يحتوي على كلمات مفاتيح عربية
  /// Check if text starts with "tafsir" or contains Arabic keywords
  bool _isArabicIslamicText() {
    final arabicKeywords = [
      'تفسير',
      'تفسیر',
      'تفسير',
      'اللباب',
      'البحر',
      'الطبري',
      'القرطبي',
      'البغوي',
      'الجلالين',
      'البيضاوي',
      'النسفي',
      'السعدي',
      'كثير',
      'عطية',
      'البسيط',
      'الوسيط',
      'السمعاني',
      'الثعالبي',
      'أبي زمنين',
      'جُزَيّ',
      '(UR)',
    ];

    return arabicKeywords.any((keyword) => contains(keyword));
  }

  /// الكشف الذكي عن اللغات والنصوص العربية
  /// Smart detection for RTL languages and Arabic texts
  bool isRtlLanguageApp() {
    // إذا كان النص في القائمة المحددة مسبقاً
    if (rtlLang.contains(this)) return true;

    // إذا كان نصاً إسلامياً باللغة العربية
    if (_isArabicIslamicText()) return true;

    // إذا كان أكثر من 70% من النص يحتوي على أحرف RTL
    if (length > 0) {
      final rtlCharCount =
          split('').where((char) => char._containsRtlCharacters()).length;
      final rtlPercentage = rtlCharCount / length;
      if (rtlPercentage > 0.7) return true;
    }

    // إذا كان يحتوي على أحرف عربية أو فارسية أو عبرية
    return _containsRtlCharacters();
  }

  bool isRtlLanguageWPassLangTaf(String language) {
    return language.isRtlLanguageApp();
  }
}
