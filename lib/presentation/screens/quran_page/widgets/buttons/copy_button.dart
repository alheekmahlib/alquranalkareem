import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/custom_error_snackBar.dart';
import '/core/utils/constants/extensions/svg_extensions.dart';
import '../../../../../core/services/services_locator.dart';
import '../../../../../core/utils/constants/svg_constants.dart';
import '../../../../controllers/general_controller.dart';
import '../../controller/quran_controller.dart';

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
        child: customSvg(
          SvgPath.svgCopyIcon,
          height: 20,
        ),
      ),
      onTap: () async {
        await Clipboard.setData(ClipboardData(
                text:
                    '﴿${ayahTextNormal}﴾ [$surahName-${sl<GeneralController>().arabicNumber.convert(ayahNum)}]'))
            .then((value) => context.showCustomErrorSnackBar('copyAyah'.tr));
        cancel!();
        sl<QuranController>().state.selectedAyahIndexes.clear();
      },
    );
  }
}
