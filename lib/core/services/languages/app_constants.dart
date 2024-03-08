import 'language_models.dart';

class AppConstants {
  static const String COUNTRY_CODE = 'country_code';
  static const String LANGUAGE_CODE = 'language_code';

  static List<LanguageModel> languages = [
    LanguageModel(
      languageName: 'English',
      countryCode: 'US',
      languageCode: 'en',
    ),
    LanguageModel(
      languageName: 'العربية',
      countryCode: '',
      languageCode: 'ar',
    ),
    LanguageModel(
      languageName: 'Español',
      countryCode: '',
      languageCode: 'es',
    ),
    LanguageModel(
      languageName: 'বাংলা',
      countryCode: '',
      languageCode: 'bn',
    ),
    LanguageModel(
      languageName: 'اردو',
      countryCode: '',
      languageCode: 'ur',
    ),
    LanguageModel(
      languageName: 'Soomaali',
      countryCode: '',
      languageCode: 'so',
    ),
  ];
}
