import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../core/utils/constants/shared_preferences_constants.dart';
import '../../core/utils/helpers/app_themes.dart';

enum AppTheme { blue, brown, old, dark }

class ThemeController extends GetxController {
  static ThemeController get instance =>
      GetInstance().putOrFind(() => ThemeController());
  AppTheme? initialTheme;
  ThemeData? initialThemeData;
  Rx<AppTheme> _currentTheme = AppTheme.blue.obs;
  final box = GetStorage();

  @override
  void onInit() async {
    var theme = await loadThemePreference();
    setTheme(theme);
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
      case AppTheme.old:
        initialThemeData = oldTheme;
        break;
      case AppTheme.dark:
        initialThemeData = darkTheme;
        break;
      default:
        initialThemeData = blueTheme;
    }
  }

  Future<AppTheme> loadThemePreference() async {
    String themeString = box.read(SET_THEME) ?? AppTheme.blue.toString();
    return initialTheme = AppTheme.values.firstWhere(
      (e) => e.toString() == themeString,
      orElse: () => AppTheme.blue,
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
      case AppTheme.old:
        newThemeData = oldTheme;
        break;
      case AppTheme.dark:
        newThemeData = darkTheme;
        break;
      default:
        newThemeData = blueTheme;
    }

    Get.changeTheme(newThemeData);
    Get.forceAppUpdate();

    // Save theme preference
    box.write(SET_THEME, theme.toString());
  }

  ThemeData get currentThemeData {
    switch (_currentTheme.value) {
      case AppTheme.blue:
        return blueTheme;
      case AppTheme.brown:
        return brownTheme;
      case AppTheme.old:
        return oldTheme;
      case AppTheme.dark:
        return darkTheme;
      default:
        return blueTheme;
    }
  }

  AppTheme get currentTheme => _currentTheme.value;

  bool get isBlueMode => _currentTheme.value == AppTheme.blue;
  bool get isBrownMode => _currentTheme.value == AppTheme.brown;
  bool get isOldMode => _currentTheme.value == AppTheme.old;
  bool get isDarkMode => _currentTheme.value == AppTheme.dark;
}
