import 'package:get/get.dart';

class AdhanData {
  final int index;
  final String adhanFileName;
  final String adhanName;
  final String urlAndroidAdhanZip;
  final String urlIosAdhanZip;
  final String urlPlayAdhan;
  final String? androidFilePath;
  final String? iosFilePath;

  AdhanData({
    required this.index,
    required this.adhanFileName,
    required this.adhanName,
    required this.urlAndroidAdhanZip,
    required this.urlIosAdhanZip,
    required this.urlPlayAdhan,
    this.androidFilePath,
    this.iosFilePath,
  });

  String? get path =>
      GetPlatform.isIOS || GetPlatform.isMacOS ? iosFilePath : androidFilePath;

  factory AdhanData.fromJson(Map<String, dynamic> json) {
    return AdhanData(
      index: json['index'] as int,
      adhanFileName: json['adhanFileName'] as String,
      adhanName: json['adhanName'] as String,
      urlAndroidAdhanZip: json['urlAndroidAdhanZip'] as String,
      urlIosAdhanZip: json['urlIosAdhanZip'] as String,
      urlPlayAdhan: json['urlPlayAdhan'] as String,
      androidFilePath: json['androidFilePath'] as String?,
      iosFilePath: json['iosFilePath'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'adhanFileName': adhanFileName,
      'adhanName': adhanName,
      'urlAndroidAdhanZip': urlAndroidAdhanZip,
      'urlIosAdhanZip': urlIosAdhanZip,
      'urlPlayAdhan': urlPlayAdhan,
      'androidFilePath': androidFilePath,
      'iosFilePath': iosFilePath,
    };
  }
}
