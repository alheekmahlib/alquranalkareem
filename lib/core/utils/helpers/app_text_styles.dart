import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/presentation/controllers/theme_controller.dart';

class AppTextStyles {
  AppTextStyles._(); // منع إنشاء instance

  static String get _defaultFontFamily =>
      ThemeController.instance.currentFontFamily;
  // ══════════════════════════════════════════════
  //                 HEADINGS
  // ══════════════════════════════════════════════

  /// العنوان الرئيسي الكبير - مثل عناوين الصفحات
  static TextStyle heading1({
    Color? color,
    FontWeight? fontWeight,
    double? fontSize,
    double? letterSpacing,
    double? height,
    TextDecoration? decoration,
    String? fontFamily,
  }) {
    return TextStyle(
      fontSize: fontSize ?? 20,
      fontWeight: fontWeight ?? FontWeight.bold,
      color: color ?? Get.theme.colorScheme.inversePrimary,
      letterSpacing: letterSpacing,
      height: height ?? 1.2,
      decoration: decoration,
      fontFamily: fontFamily ?? _defaultFontFamily,
    );
  }

  /// العنوان الثانوي
  static TextStyle heading2({
    Color? color,
    FontWeight? fontWeight,
    double? fontSize,
    double? letterSpacing,
    double? height,
    TextDecoration? decoration,
    String? fontFamily,
  }) {
    return TextStyle(
      fontSize: fontSize ?? 18,
      fontWeight: fontWeight ?? FontWeight.w600,
      color: color ?? Get.theme.colorScheme.inversePrimary,
      letterSpacing: letterSpacing,
      height: height ?? 1.2,
      decoration: decoration,
      fontFamily: fontFamily ?? _defaultFontFamily,
    );
  }

  /// العنوان الثالث
  static TextStyle heading3({
    Color? color,
    FontWeight? fontWeight,
    double? fontSize,
    double? letterSpacing,
    double? height,
    TextDecoration? decoration,
    String? fontFamily,
  }) {
    return TextStyle(
      fontSize: fontSize ?? 16,
      fontWeight: fontWeight ?? FontWeight.w400,
      color: color ?? Get.theme.colorScheme.inversePrimary,
      letterSpacing: letterSpacing,
      height: height ?? 1.2,
      decoration: decoration,
      fontFamily: fontFamily ?? _defaultFontFamily,
    );
  }

  // ══════════════════════════════════════════════
  //                  TITLES
  // ══════════════════════════════════════════════

  /// عنوان كبير - AppBar أو أقسام رئيسية
  static TextStyle titleLarge({
    Color? color,
    FontWeight? fontWeight,
    double? fontSize,
    double? letterSpacing,
    double? height,
    TextDecoration? decoration,
    String? fontFamily,
  }) {
    return TextStyle(
      fontSize: fontSize ?? 25,
      fontWeight: fontWeight ?? FontWeight.w700,
      color: color ?? Get.theme.colorScheme.inversePrimary,
      letterSpacing: letterSpacing,
      height: height ?? 1.5,
      decoration: decoration,
      fontFamily: fontFamily ?? _defaultFontFamily,
    );
  }

  /// عنوان متوسط - عناوين الكاردات
  static TextStyle titleMedium({
    Color? color,
    FontWeight? fontWeight,
    double? fontSize,
    double? letterSpacing,
    double? height,
    TextDecoration? decoration,
    String? fontFamily,
  }) {
    return TextStyle(
      fontSize: fontSize ?? 20,
      fontWeight: fontWeight ?? FontWeight.w400,
      color: color ?? Get.theme.colorScheme.inversePrimary,
      letterSpacing: letterSpacing,
      height: height ?? 1.5,
      decoration: decoration,
      fontFamily: fontFamily ?? _defaultFontFamily,
    );
  }

  /// عنوان صغير
  static TextStyle titleSmall({
    Color? color,
    FontWeight? fontWeight,
    double? fontSize,
    double? letterSpacing,
    double? height,
    TextDecoration? decoration,
    String? fontFamily,
  }) {
    return TextStyle(
      fontSize: fontSize ?? 14,
      fontWeight: fontWeight ?? FontWeight.w400,
      color: color ?? Get.theme.colorScheme.inversePrimary,
      letterSpacing: letterSpacing,
      height: height ?? 1.5,
      decoration: decoration,
      fontFamily: fontFamily ?? _defaultFontFamily,
    );
  }

  // ══════════════════════════════════════════════
  //                BODY TEXT
  // ══════════════════════════════════════════════

  /// نص الجسم الكبير
  static TextStyle bodyLarge({
    Color? color,
    FontWeight? fontWeight,
    double? fontSize,
    double? letterSpacing,
    double? height,
    TextDecoration? decoration,
    String? fontFamily,
  }) {
    return TextStyle(
      fontSize: fontSize ?? 22,
      fontWeight: fontWeight ?? FontWeight.normal,
      color: color ?? Get.theme.colorScheme.inversePrimary,
      letterSpacing: letterSpacing,
      height: height ?? 1.2,
      decoration: decoration,
      fontFamily: fontFamily ?? _defaultFontFamily,
    );
  }

  /// نص الجسم المتوسط - الأكثر استخداماً
  static TextStyle bodyMedium({
    Color? color,
    FontWeight? fontWeight,
    double? fontSize,
    double? letterSpacing,
    double? height,
    TextDecoration? decoration,
    String? fontFamily,
  }) {
    return TextStyle(
      fontSize: fontSize ?? 20,
      fontWeight: fontWeight ?? FontWeight.normal,
      color: color ?? Get.theme.colorScheme.inversePrimary,
      letterSpacing: letterSpacing,
      height: height ?? 1.2,
      decoration: decoration,
      fontFamily: fontFamily ?? _defaultFontFamily,
    );
  }

  /// نص الجسم الصغير
  static TextStyle bodySmall({
    Color? color,
    FontWeight? fontWeight,
    double? fontSize,
    double? letterSpacing,
    double? height,
    TextDecoration? decoration,
    String? fontFamily,
  }) {
    return TextStyle(
      fontSize: fontSize ?? 18,
      fontWeight: fontWeight ?? FontWeight.normal,
      color: color ?? Get.theme.colorScheme.inversePrimary,
      letterSpacing: letterSpacing,
      height: height ?? 1.2,
      decoration: decoration,
      fontFamily: fontFamily ?? _defaultFontFamily,
    );
  }
}
