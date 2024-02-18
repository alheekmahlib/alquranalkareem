import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../core/services/services_locator.dart';
import '../../../../core/utils/constants/svg_picture.dart';
import '../../../../core/widgets/share/share_ayah_options.dart';
import '/presentation/controllers/ayat_controller.dart';

class ShareCopyWidget extends StatelessWidget {
  const ShareCopyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ayatCtrl = sl<AyatController>();
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
        margin: const EdgeInsets.symmetric(vertical: 16.0),
        decoration: BoxDecoration(
            color: Get.theme.colorScheme.background,
            borderRadius: const BorderRadius.all(Radius.circular(4)),
            border: Border.symmetric(
                vertical: BorderSide(
              width: 3,
              color: Get.theme.colorScheme.primary,
            ))),
        child: Row(
          children: [
            GestureDetector(
              child: Semantics(
                button: true,
                enabled: true,
                label: 'copy'.tr,
                child: copy_icon(height: 25.0),
              ),
              onTap: () async => await ayatCtrl.copyOnTap(),
            ),
            const Gap(16),
            ShareAyahOptions(
              verseNumber: ayatCtrl.ayahNumber.value,
              verseUQNumber: ayatCtrl.ayahUQNumber.value,
              surahNumber: ayatCtrl.surahNumber.value,
              ayahTextNormal: ayatCtrl.ayahTextNormal.value,
              verseText: ayatCtrl.tafseerAyah,
              surahName: 'surahName',
              textTranslate: ayatCtrl.currentText.value?.translate ?? '',
            ),
          ],
        ),
      ),
    );
  }
}
