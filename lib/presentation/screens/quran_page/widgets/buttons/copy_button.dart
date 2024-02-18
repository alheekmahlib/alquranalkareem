import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../../core/utils/constants/svg_picture.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../quran_text/widgets/widgets.dart';

class CopyButton extends StatelessWidget {
  final int ayahNum;
  final String ayahTextNormal;
  final Function? cancel;
  const CopyButton(
      {super.key,
      required this.ayahNum,
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
                    '﴿${ayahTextNormal}﴾ [$surahName-${arabicNumber.convert(ayahNum.toString())}]'))
            .then((value) => customErrorSnackBar('copyAyah'.tr));
      },
    );
  }
}
