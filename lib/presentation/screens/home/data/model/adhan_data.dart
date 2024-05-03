class AdhanData {
  final List<Adhan> adhan;

  AdhanData({required this.adhan});

  factory AdhanData.fromJson(Map<String, dynamic> json) {
    return AdhanData(
      adhan: (json['adhan'] as List<dynamic>)
          .map((adhanJson) => Adhan.fromJson(adhanJson))
          .toList(),
    );
  }
}

class Adhan {
  final String partOfAdhanName;
  final String urlPartAdhan;
  final String fullAdhanName;
  final String urlAndroidFullAdhan;
  final String urlIosFullAdhanZip;
  final String urlAndroidFullAdhanZip;

  Adhan({
    required this.partOfAdhanName,
    required this.urlPartAdhan,
    required this.fullAdhanName,
    required this.urlAndroidFullAdhan,
    required this.urlIosFullAdhanZip,
    required this.urlAndroidFullAdhanZip,
  });

  factory Adhan.fromJson(Map<String, dynamic> json) {
    return Adhan(
      partOfAdhanName: json['partOfAdhanName'] as String,
      urlPartAdhan: json['urlPartAdhan'] as String,
      fullAdhanName: json['fullAdhanName'] as String,
      urlAndroidFullAdhan: json['urlAndroidFullAdhan'] as String,
      urlIosFullAdhanZip: json['urlIosFullAdhan'] as String,
      urlAndroidFullAdhanZip: json['urlAndroidFullAdhanZip'] as String,
    );
  }
}
