class AdhanData {
  final String adhanFileName;
  final String adhanName;
  final String urlAndroidAdhanZip;
  final String urlIosAdhanZip;
  final String urlPlayAdhan;

  AdhanData({
    required this.adhanFileName,
    required this.adhanName,
    required this.urlAndroidAdhanZip,
    required this.urlIosAdhanZip,
    required this.urlPlayAdhan,
  });

  factory AdhanData.fromJson(Map<String, dynamic> json) {
    return AdhanData(
      adhanFileName: json['adhanFileName'] as String,
      adhanName: json['adhanName'] as String,
      urlAndroidAdhanZip: json['urlAndroidAdhanZip'] as String,
      urlIosAdhanZip: json['urlIosAdhanZip'] as String,
      urlPlayAdhan: json['urlPlayAdhan'] as String,
    );
  }
}
