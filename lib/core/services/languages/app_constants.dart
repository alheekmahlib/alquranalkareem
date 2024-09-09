import 'language_models.dart';

class AppConstants {
  static const String COUNTRY_CODE = 'country_code';
  static const String LANGUAGE_CODE = 'language_code';

  static List<LanguageModel> languages = [
    LanguageModel(
      languageName: 'English',
      countryCode: 'US',
      languageCode: 'en',
      appLang: 'App Language',
    ),
    LanguageModel(
      languageName: 'العربية',
      countryCode: '',
      languageCode: 'ar',
      appLang: 'لغة التطبيق',
    ),
    LanguageModel(
      languageName: 'Español',
      countryCode: '',
      languageCode: 'es',
      appLang: 'Idioma de la aplicación',
    ),
    LanguageModel(
      languageName: 'বাংলা',
      countryCode: '',
      languageCode: 'bn',
      appLang: 'অ্যাপের ভাষা',
    ),
    LanguageModel(
      languageName: 'اردو',
      countryCode: '',
      languageCode: 'ur',
      appLang: 'ایپ کی زبان',
    ),
    LanguageModel(
      languageName: 'Soomaali',
      countryCode: '',
      languageCode: 'so',
      appLang: 'Luqadda Appka',
    ),
    LanguageModel(
      languageName: 'Indonesian',
      countryCode: '',
      languageCode: 'id',
      appLang: 'Bahasa Aplikasi',
    ),
    LanguageModel(
      languageName: 'Filipino',
      countryCode: '',
      languageCode: 'ph',
      appLang: 'Wika ng Aplikasyon',
    ),
  ];
}
