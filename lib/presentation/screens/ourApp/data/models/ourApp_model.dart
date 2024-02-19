class OurAppInfo {
  final int id;
  final String appTitle;
  final String body;
  final String appLogo;
  final String appBanner;
  final String banner1;
  final String banner2;
  final String banner3;
  final String banner4;
  final String aboutApp2;
  final String aboutApp3;
  final String urlAppStore;
  final String urlPlayStore;
  final String urlAppGallery;
  final String urlMacAppStore;

  OurAppInfo({
    required this.id,
    required this.appTitle,
    required this.body,
    required this.appLogo,
    required this.appBanner,
    required this.banner1,
    required this.banner2,
    required this.banner3,
    required this.banner4,
    required this.aboutApp2,
    required this.aboutApp3,
    required this.urlAppStore,
    required this.urlPlayStore,
    required this.urlAppGallery,
    required this.urlMacAppStore,
  });

  factory OurAppInfo.fromJson(Map<String, dynamic> json) {
    return OurAppInfo(
      id: json['id'],
      appTitle: json['appTitle'],
      body: json['body'],
      appLogo: json['appLogo'],
      appBanner: json['appBanner'],
      banner1: json['banner1'],
      banner2: json['banner2'],
      banner3: json['banner3'],
      banner4: json['banner4'],
      aboutApp2: json['aboutApp2'],
      aboutApp3: json['aboutApp3'],
      urlAppStore: json['urlAppStore'],
      urlPlayStore: json['urlPlayStore'],
      urlAppGallery: json['urlAppGallery'],
      urlMacAppStore: json['urlMacAppStore'],
    );
  }
}
