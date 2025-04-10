import 'dart:developer';
import 'dart:ui' show Locale;

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../core/services/languages/app_constants.dart';

class SettingsController extends GetxController {
  static SettingsController get instance =>
      GetInstance().putOrFind(() => SettingsController());
  Locale? initialLang;
  RxString languageName = ''.obs;
  RxString languageFont = 'naskh'.obs;
  // RxString languageFont2 = 'kufi'.obs;
  RxBool settingsSelected = false.obs;
  final box = GetStorage();

  void getLanguageName() {
    // Get the language name from the box.
    // الحصول على اسم اللغة من الصندوق.
    int langIndex = AppConstants.languages.indexWhere((l) =>
        l.languageCode == PlatformDispatcher.instance.locale.languageCode);
    String? langName = box.read("langName");
    if (langName != null) {
      languageName.value = langName;
    } else {
      languageName.value = AppConstants.languages[langIndex].languageName;
    }
  }

  void setLocale(Locale value) {
    initialLang = value;

    // Update the app's locale.
    // تحديث لغة التطبيق.
    Get.updateLocale(value);

    // Log the language change for debugging.
    // تسجيل تغيير اللغة للتصحيح.
    log('Language changed to: ${value.languageCode}',
        name: 'SettingsController');

    update();
  }

  void changeLanguage(Locale locale, String languageName) {
    // تغيير لغة التطبيق
    initialLang = locale;
    this.languageName.value = languageName;

    // تحديث لغة التطبيق في التخزين
    box.write("lang", locale.languageCode);
    box.write("langName", languageName);

    // تحديث لغة التطبيق في GetX
    Get.updateLocale(locale);

    // تسجيل العملية للتصحيح
    log('Language changed to: ${locale.languageCode}',
        name: 'SettingsController');

    update();
  }

  void loadLang() {
    getLanguageName();
    String? langCode = box.read("lang");
    // String? langName = box.read("langName") ?? '';
    String? langFont = box.read("languageFont") ?? 'naskh';
    // String? langFont2 =
    //     await box.read("languageFont2");

    print(
        'Lang code: $langCode'); // Add this line to debug the value of langCode

    if (langCode == null || langCode.isEmpty) {
      initialLang = const Locale('ar', 'AE');
    } else {
      initialLang = Locale(
          langCode, ''); // Make sure langCode is not null or invalid here
    }

    // languageName.value = langName;
    languageFont.value = langFont;
    // languageFont2.value = langFont2;

    print('get lang $initialLang');
  }
}
