import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/svg_extensions.dart';
import '/presentation/controllers/ayat_controller.dart';
import '../../../../../core/utils/constants/svg_constants.dart';
import '../../../../../core/widgets/share/share_ayah_options.dart';

class ShareCopyWidget extends StatelessWidget {
  final int ayahNumber;
  final int ayahUQNumber;
  final int surahNumber;
  final String ayahTextNormal;
  final String ayahText;
  final String surahName;
  final String tafsirName;
  final String tafsir;
  const ShareCopyWidget(
      {super.key,
      required this.ayahNumber,
      required this.ayahUQNumber,
      required this.surahNumber,
      required this.ayahTextNormal,
      required this.ayahText,
      required this.surahName,
      required this.tafsir,
      required this.tafsirName});

  @override
  Widget build(BuildContext context) {
    final ayatCtrl = AyatController.instance;
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
        margin: const EdgeInsets.symmetric(vertical: 16.0),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: const BorderRadius.all(Radius.circular(4)),
            border: Border.symmetric(
                vertical: BorderSide(
              width: 3,
              color: Theme.of(context).colorScheme.primary,
            ))),
        child: Row(
          children: [
            GestureDetector(
              child: Semantics(
                button: true,
                enabled: true,
                label: 'copy'.tr,
                child: customSvg(
                  SvgPath.svgCopyIcon,
                  height: 25,
                ),
              ),
              onTap: () async => await ayatCtrl.copyOnTap(tafsirName, tafsir),
            ),
            const Gap(16),
            ShareAyahOptions(
              ayahNumber: ayahNumber,
              ayahUQNumber: ayahUQNumber,
              surahNumber: surahNumber,
              ayahTextNormal: ayahTextNormal,
              ayahText: ayahText,
              surahName: surahName,
            ),
          ],
        ),
      ),
    );
  }
}
