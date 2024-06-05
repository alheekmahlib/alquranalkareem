import 'dart:ui' show Locale;

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SettingsController extends GetxController {
  static SettingsController get instance =>
      Get.isRegistered<SettingsController>()
          ? Get.find<SettingsController>()
          : Get.put<SettingsController>(SettingsController());
  Locale? initialLang;
  RxString languageName = 'العربية'.obs;
  RxString languageFont = 'naskh'.obs;
  // RxString languageFont2 = 'kufi'.obs;
  RxBool settingsSelected = false.obs;
  final box = GetStorage();

  void setLocale(Locale value) {
    initialLang = value;
    update();
  }

  Future<void> loadLang() async {
    String? langCode = await box.read("lang");
    String? langName = await box.read("langName") ?? 'العربية';
    String? langFont = await box.read("languageFont") ?? 'naskh';
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

    languageName.value = langName;
    languageFont.value = langFont;
    // languageFont2.value = langFont2;

    print('get lang $initialLang');
  }

  List languageList = [
    {
      'lang': 'ar',
      'appLang': 'لغة التطبيق',
      'name': 'العربية',
      'font': 'naskh',
      'font2': 'kufi'
    },
    {
      'lang': 'en',
      'appLang': 'App Language',
      'name': 'English',
      'font': 'naskh',
      'font2': 'naskh'
    },
    {
      'lang': 'es',
      'appLang': 'Idioma de la aplicación',
      'name': 'Español',
      'font': 'naskh',
      'font2': 'naskh'
    },
    {
      'lang': 'bn',
      'appLang': 'অ্যাপের ভাষা',
      'name': 'বাংলা',
      'font': 'bn',
      'font2': 'bn'
    },
    {
      'lang': 'ur',
      'appLang': 'ایپ کی زبان',
      'name': 'اردو',
      'font': 'urdu',
      'font2': 'urdu'
    },
    {
      'lang': 'so',
      'appLang': 'Luqadda Appka',
      'name': 'Soomaali',
      'font': 'naskh'
    },
  ];
}
