import 'dart:ui' show Locale;

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends GetxController {
  Locale? initialLang;
  RxString languageName = 'العربية'.obs;
  RxString languageFont = 'naskh'.obs;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  void setLocale(Locale value) {
    initialLang = value;
    update();
  }

  // Save & Load Last Page For Quran Page
  Future<void> saveLang(String lan, String name, String font) async {
    SharedPreferences prefs = await _prefs;
    await prefs.setString("lang", lan);
    await prefs.setString("langName", name);
    await prefs.setString("languageFont", font);
    update();
  }

  void loadLang() async {
    SharedPreferences prefs = await _prefs;
    initialLang = prefs.getString("lang") == null
        ? const Locale('ar', 'AE')
        : Locale(prefs.getString("lang")!);
    languageName.value = prefs.getString("langName") == null
        ? 'العربية'
        : prefs.getString("langName")!;
    languageFont.value = prefs.getString("languageFont") == null
        ? 'naskh'
        : prefs.getString("languageFont")!;
    print('get lang $initialLang');
  }

  List languageList = [
    {
      'lang': 'ar',
      'appLang': 'لغة التطبيق',
      'name': 'العربية',
      'font': 'naskh'
    },
    {
      'lang': 'en',
      'appLang': 'App Language',
      'name': 'English',
      'font': 'naskh'
    },
    {
      'lang': 'es',
      'appLang': 'Idioma de la aplicación',
      'name': 'Español',
      'font': 'naskh'
    },
    {'lang': 'bn', 'appLang': 'অ্যাপের ভাষা', 'name': 'বাংলা', 'font': 'bn'},
    {'lang': 'ur', 'appLang': 'ایپ کی زبان', 'name': 'اردو', 'font': 'urdu'},
    {
      'lang': 'so',
      'appLang': 'Luqadda Appka',
      'name': 'Soomaali',
      'font': 'naskh'
    },
  ];
}
