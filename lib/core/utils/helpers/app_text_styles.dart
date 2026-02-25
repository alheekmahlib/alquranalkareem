import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppTextStyles {
  AppTextStyles._(); // منع إنشاء instance

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
      fontFamily: 'playpen',
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
      fontFamily: 'playpen',
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
      fontFamily: 'playpen',
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
      height: height ?? 1.2,
      decoration: decoration,
      fontFamily: 'playpen',
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
      height: height ?? 1.2,
      decoration: decoration,
      fontFamily: 'playpen',
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
      height: height ?? 1.2,
      decoration: decoration,
      fontFamily: 'playpen',
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
      fontFamily: 'naskh',
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
      fontFamily: 'naskh',
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
      fontFamily: 'naskh',
    );
  }
}
