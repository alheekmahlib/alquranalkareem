import 'dart:developer' show log;
import 'dart:io' show File;

import 'package:archive/archive.dart' show ZipDecoder;
import 'package:dio/dio.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../data/model/adhan_data.dart';

class AudioDownloader {
  Future<AdhanData> downloadAndUnzipAdhan(AdhanData adhanData,
      {void Function(int, int)? onReceiveProgress}) async {
    final androidFilePath = await _downloadAndExtractFile(
      adhanData.urlAndroidAdhanZip,
      adhanData.adhanFileName,
      'android',
      onReceiveProgress: onReceiveProgress,
    );

    final iosFilePath = await _downloadAndExtractFile(
      adhanData.urlIosAdhanZip,
      adhanData.adhanFileName,
      'ios',
      onReceiveProgress: onReceiveProgress,
    );

    return AdhanData(
      index: adhanData.index,
      adhanFileName: adhanData.adhanFileName,
      adhanName: adhanData.adhanName,
      urlAndroidAdhanZip: adhanData.urlAndroidAdhanZip,
      urlIosAdhanZip: adhanData.urlIosAdhanZip,
      urlPlayAdhan: adhanData.urlPlayAdhan,
      androidFilePath: androidFilePath,
      iosFilePath: iosFilePath,
    );
  }

  Future<String?> _downloadAndExtractFile(
      String url, String fileName, String platform,
      {void Function(int, int)? onReceiveProgress}) async {
    try {
      final response = await Dio().get(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          receiveTimeout: const Duration(seconds: 60),
        ),
        onReceiveProgress: onReceiveProgress,
      );
      final tempDir = await getTemporaryDirectory();
      final zipFilePath = path.join(tempDir.path, '$fileName.zip');
      final zipFile = File(zipFilePath);

      await zipFile.writeAsBytes(response.data);

      final bytes = zipFile.readAsBytesSync();
      final archive = ZipDecoder().decodeBytes(bytes);

      String? extractedFilePath;

      for (var file in archive) {
        if (file.isFile && file.name.endsWith('.wav') ||
            file.name.endsWith('.mp3')) {
          final outputPath = path.join(tempDir.path, fileName, platform);
          final extractedFile = File(path.join(outputPath, file.name));
          await extractedFile.create(recursive: true);
          await extractedFile.writeAsBytes(file.content as List<int>);

          // Return the path of the extracted file
          extractedFilePath = extractedFile.path;
          log('extractedFilePath: ${extractedFile.path}',
              name: 'AudioDownloader');
        }
      }

      // Delete the zip file after extraction
      await zipFile.delete();

      return extractedFilePath;
    } catch (e) {
      log("Error downloading or extracting file: $e");
      return null;
    }
  }
}
