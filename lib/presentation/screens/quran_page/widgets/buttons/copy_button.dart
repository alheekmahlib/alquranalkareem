import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../../core/services/services_locator.dart';
import '../../../../../core/utils/constants/svg_picture.dart';
import '../../../../controllers/general_controller.dart';
import '/core/utils/constants/extensions/custom_error_snackBar.dart';

class CopyButton extends StatelessWidget {
  final int ayahNum;
  final String surahName;
  final String ayahTextNormal;
  final Function? cancel;
  const CopyButton(
      {super.key,
      required this.ayahNum,
      required this.surahName,
      required this.ayahTextNormal,
      this.cancel});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Semantics(
        button: true,
        enabled: true,
        label: 'Copy Ayah',
        child: copy_icon(height: 20.0),
      ),
      onTap: () async {
        await Clipboard.setData(ClipboardData(
                text:
                    '﴿${ayahTextNormal}﴾ [$surahName-${sl<GeneralController>().arabicNumber.convert(ayahNum)}]'))
            .then((value) => context.showCustomErrorSnackBar('copyAyah'.tr));
      },
    );
  }
}
