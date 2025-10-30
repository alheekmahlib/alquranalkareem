import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

extension ShareAppExtension on void {
  Future<void> shareApp() async {
    final box = Get.context!.findRenderObject() as RenderBox?;
    final ByteData bytes =
        await rootBundle.load('assets/images/quran_banner.png');
    final Uint8List list = bytes.buffer.asUint8List();

    final tempDir = await getTemporaryDirectory();
    final file = await File('${tempDir.path}/quran_banner.png').create();
    file.writeAsBytesSync(list);
    await Share.shareXFiles(
      [XFile((file.path))],
      text:
          'تطبيق "القرآن الكريم - مكتبة الحكمة" التطبيق الأمثل لقراءة القرآن.\n\nللتحميل:\nhttps://alheekmahlib.github.io/alheekmahlib/#/download/quran',
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );
  }
}
