import 'package:alquranalkareem/core/widgets/container_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_library/quran_library.dart';

/// زر تحميل بيانات أحكام التجويد.
///
/// مستخرج من زر [TafsirStyle.tajweedDownloadButtonWidget] ليُستدعى في
/// تبويب أحكام التجويد وفي خيارات مشاركة الآية كصورة. تفاعلي ذاتيًا
/// عبر Obx (تقدم التنزيل/التحضير) فيصلح داخل GetBuilder أو مستقلًا.
class TajweedDownloadButton extends StatelessWidget {
  const TajweedDownloadButton({super.key, this.width = 250.0});

  final double width;

  @override
  Widget build(BuildContext context) {
    final tajweedCtrl = TajweedAyaCtrl.instance;
    return Obx(() {
      final isDownloading = tajweedCtrl.isDownloading.value;
      return ContainerButton(
        onPressed: () async {
          isDownloading ? null : await tajweedCtrl.download();
        },
        height: 40.0,
        width: width,
        isTitleCentered: true,
        title: isDownloading ? 'downloading' : 'download',
        horizontalPadding: 16.0,
        verticalPadding: 2.0,
        backgroundColor: Get.theme.colorScheme.surface,
        progressColor: Get.theme.colorScheme.primary.withValues(alpha: .2),
        isDownloading: isDownloading,
        downloadProgress: tajweedCtrl.downloadProgress.value.toStringAsFixed(0),
        isPreparingDownload:
            isDownloading || tajweedCtrl.isPreparingDownload.value,
      );
    });
  }
}
