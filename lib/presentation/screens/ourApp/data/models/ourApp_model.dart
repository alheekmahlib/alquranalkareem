import '/core/utils/constants/api_constants.dart';

/// ترجمة اسم التطبيق (يأتي الاسم في حقل `name`).
class AppNameTranslation {
  final String lang;
  final String name;

  const AppNameTranslation({required this.lang, required this.name});

  factory AppNameTranslation.fromJson(Map<String, dynamic> json) {
    return AppNameTranslation(
      lang: json['lang'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() => {'lang': lang, 'name': name};
}

/// ترجمة شرح التطبيق (يأتي النص في حقل `value`).
class AppBodyTranslation {
  final String lang;
  final String value;

  const AppBodyTranslation({required this.lang, required this.value});

  factory AppBodyTranslation.fromJson(Map<String, dynamic> json) {
    return AppBodyTranslation(
      lang: json['lang'] as String,
      value: json['value'] as String,
    );
  }

  Map<String, dynamic> toJson() => {'lang': lang, 'value': value};
}

class OurAppInfo {
  final int id;
  final String slug;

  /// مصفوفة أسماء التطبيق بعدة لغات.
  final List<AppNameTranslation> appName;

  /// مصفوفة شروحات التطبيق بعدة لغات.
  final List<AppBodyTranslation> body;
  final String companyName;
  final String appLogo;
  final String appBanner;
  final List<String> banners;
  final String dynamicLink;
  final String urlAppStore;
  final String urlPlayStore;
  final String urlAppGallery;
  final String urlMacAppStore;
  final List<String> tags;

  OurAppInfo({
    required this.id,
    required this.slug,
    required this.appName,
    required this.body,
    required this.companyName,
    required this.appLogo,
    required this.appBanner,
    required this.banners,
    required this.dynamicLink,
    required this.urlAppStore,
    required this.urlPlayStore,
    required this.urlAppGallery,
    required this.urlMacAppStore,
    required this.tags,
  });

  factory OurAppInfo.fromJson(Map<String, dynamic> json) {
    return OurAppInfo(
      id: json['id'] as int,
      slug: json['slug'] as String? ?? '',
      appName: ((json['appName'] as List<dynamic>?) ?? const [])
          .map((e) => AppNameTranslation.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      body: ((json['body'] as List<dynamic>?) ?? const [])
          .map((e) => AppBodyTranslation.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      companyName: json['companyName'] as String? ?? '',
      appLogo: json['appLogo'] as String? ?? '',
      appBanner: json['appBanner'] as String? ?? '',
      banners: ((json['banners'] as List<dynamic>?) ?? const [])
          .map((e) => e as String)
          .toList(),
      dynamicLink: json['dynamicLink'] as String? ?? '',
      urlAppStore: json['urlAppStore'] as String? ?? '',
      urlPlayStore: json['urlPlayStore'] as String? ?? '',
      urlAppGallery: json['urlAppGallery'] as String? ?? '',
      urlMacAppStore: json['urlMacAppStore'] as String? ?? '',
      tags: ((json['tags'] as List<dynamic>?) ?? const [])
          .map((e) => e as String)
          .toList(),
    );
  }

  /// اسم التطبيق باللغة المحدّدة مع تراجع آمن:
  /// اللغة الحالية ← العربية ← أول ترجمة متاحة.
  String localizedAppTitle(String langCode) {
    final match = appName.where((t) => t.lang == langCode);
    if (match.isNotEmpty) return match.first.name;
    final arabic = appName.where((t) => t.lang == 'ar');
    if (arabic.isNotEmpty) return arabic.first.name;
    return appName.isNotEmpty ? appName.first.name : '';
  }

  /// شرح التطبيق باللغة المحدّدة مع تراجع آمن:
  /// اللغة الحالية ← العربية ← أول ترجمة متاحة.
  String localizedBody(String langCode) {
    final match = body.where((t) => t.lang == langCode);
    if (match.isNotEmpty) return match.first.value;
    final arabic = body.where((t) => t.lang == 'ar');
    if (arabic.isNotEmpty) return arabic.first.value;
    return body.isNotEmpty ? body.first.value : '';
  }

  /// يحوّل المسار النسبي القادم من الـ API (يبدأ بـ `/media`) إلى رابط مطلق،
  /// ويُرجع الروابط المطلقة (http/https) كما هي.
  static String _toAbsoluteUrl(String path) {
    if (path.isEmpty) return path;
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path;
    }
    return '${ApiConstants.appsMediaBaseUrl}$path';
  }

  /// رابط الشعار المطلق (PNG).
  String get logoUrl => _toAbsoluteUrl(appLogo);

  /// رابط البانر الرئيسي المطلق.
  String get bannerUrl => _toAbsoluteUrl(appBanner);

  /// روابط البانرات المتعددة المطلقة.
  List<String> get bannerUrls => banners.map(_toAbsoluteUrl).toList();
}
