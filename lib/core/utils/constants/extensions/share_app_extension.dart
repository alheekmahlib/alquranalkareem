import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../api_constants.dart';

extension ShareAppExtension on void {
  Future<void> shareApp() async {
    final box = Get.context!.findRenderObject() as RenderBox?;
    final ByteData bytes = await rootBundle.load(
      'assets/images/quran_banner.png',
    );
    final Uint8List list = bytes.buffer.asUint8List();

    final tempDir = await getTemporaryDirectory();
    final file = await File('${tempDir.path}/quran_banner.png').create();
    file.writeAsBytesSync(list);
    final params = ShareParams(
      text:
          'تطبيق "القرآن الكريم - مكتبة الحكمة" التطبيق الأمثل لقراءة القرآن.\n\nللتحميل:\n${ApiConstants.appUrl}',
      files: [XFile((file.path))],
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );

    await SharePlus.instance.share(params);
  }
}
