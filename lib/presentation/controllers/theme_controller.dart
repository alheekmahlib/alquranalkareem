import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../core/services/home_widget_service.dart';
import '../../core/utils/constants/shared_preferences_constants.dart';
import '../../core/utils/helpers/app_themes.dart';

enum AppTheme { blue, brown, green, dark }

class ThemeController extends GetxController {
  static ThemeController get instance =>
      GetInstance().putOrFind(() => ThemeController());
  AppTheme? initialTheme;
  ThemeData? initialThemeData;
  Rx<AppTheme> _currentTheme = AppTheme.green.obs;
  RxString _fontFamily = 'playpen'.obs;
  final box = GetStorage();

  @override
  void onInit() async {
    var theme = await loadThemePreference();
    setTheme(theme);
    // Load saved font family
    String savedFont = box.read(APP_FONT_FAMILY) ?? 'playpen';
    _fontFamily.value = savedFont;
    super.onInit();
  }

  void checkTheme() {
    switch (initialTheme) {
      case AppTheme.blue:
        initialThemeData = blueTheme;
        break;
      case AppTheme.brown:
        initialThemeData = brownTheme;
        break;
      case AppTheme.green:
        initialThemeData = greenTheme;
        break;
      case AppTheme.dark:
        initialThemeData = darkTheme;
        break;
      default:
        initialThemeData = greenTheme;
    }
  }

  Future<AppTheme> loadThemePreference() async {
    String themeString = box.read(SET_THEME) ?? AppTheme.green.toString();
    return initialTheme = AppTheme.values.firstWhere(
      (e) => e.toString() == themeString,
      orElse: () => AppTheme.green,
    );
  }

  void setTheme(AppTheme theme) {
    _currentTheme.value = theme;
    ThemeData newThemeData;
    switch (theme) {
      case AppTheme.blue:
        newThemeData = blueTheme;
        break;
      case AppTheme.brown:
        newThemeData = brownTheme;
        break;
      case AppTheme.green:
        newThemeData = greenTheme;
        break;
      case AppTheme.dark:
        newThemeData = darkTheme;
        break;
    }

    Get.changeTheme(newThemeData);
    Get.forceAppUpdate();

    // Save theme preference
    box.write(SET_THEME, theme.toString());
    HomeWidgetService.instance.updateTheme();
  }

  ThemeData get currentThemeData {
    switch (_currentTheme.value) {
      case AppTheme.blue:
        return blueTheme;
      case AppTheme.brown:
        return brownTheme;
      case AppTheme.green:
        return greenTheme;
      case AppTheme.dark:
        return darkTheme;
    }
  }

  AppTheme get currentTheme => _currentTheme.value;

  bool get isBlueMode => _currentTheme.value == AppTheme.blue;
  bool get isBrownMode => _currentTheme.value == AppTheme.brown;
  bool get isGreenMode => _currentTheme.value == AppTheme.green;
  bool get isDarkMode => _currentTheme.value == AppTheme.dark;

  // ══════════════════════════════════════════════
  //                  FONT FAMILY
  // ══════════════════════════════════════════════

  static const List<String> availableFontFamilies = [
    'playpen',
    'naskh',
    'kufi',
  ];

  static const Map<String, String> fontFamilyTranslationKeys = {
    'playpen': 'playpenFont',
    'naskh': 'naskhFont',
    'kufi': 'kufiFont',
  };

  String get currentFontFamily => _fontFamily.value;

  String get currentFontDisplayName =>
      fontFamilyTranslationKeys[_fontFamily.value] ?? 'playpenFont';

  void setFontFamily(String fontFamily) {
    _fontFamily.value = fontFamily;
    box.write(APP_FONT_FAMILY, fontFamily);
    update(['font_family']);
    Get.forceAppUpdate();
  }
}
