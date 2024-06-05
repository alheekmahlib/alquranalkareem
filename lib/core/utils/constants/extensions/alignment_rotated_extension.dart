import 'package:flutter/material.dart';
import 'package:get/get.dart';

extension StringExtension on String {
  bool isRtlLanguage() {
    const rtlLang = ['العربية', 'עברית', 'فارسی', 'اردو', 'کوردی'];
    return rtlLang.contains(this);
  }

  bool isRtlLanguageWPassLang(String language) {
    const rtlLang = ['العربية', 'עברית', 'فارسی', 'اردو', 'کوردی'];
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

  alignmentLayout(BuildContext context, var rtl, var ltr) {
    if ('lang'.tr.isRtlLanguage()) {
      return rtl;
    } else {
      return ltr;
    }
  }

  alignmentLayoutWPassLang(String language, var rtl, var ltr) {
    if ('lang'.tr.isRtlLanguageWPassLang(language)) {
      return rtl;
    } else {
      return ltr;
    }
  }
}
