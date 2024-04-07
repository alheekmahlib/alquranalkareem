import 'package:flutter/material.dart';

import '../../../../../core/services/services_locator.dart';
import '../../../../../core/utils/constants/svg_picture.dart';
import '../../../../controllers/ayat_controller.dart';

class TafsirButton extends StatelessWidget {
  final int surahNum;
  final int ayahNum;
  final String ayahText;
  final int pageIndex;
  final String ayahTextNormal;
  final int ayahUQNum;
  final int index;
  final Function? cancel;
  const TafsirButton(
      {super.key,
      required this.surahNum,
      required this.ayahNum,
      required this.ayahText,
      required this.pageIndex,
      required this.ayahTextNormal,
      required this.ayahUQNum,
      this.cancel,
      required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Semantics(
        button: true,
        enabled: true,
        label: 'Show Tafseer',
        child: tafsir_icon(height: 20.0),
      ),
      onTap: () {
        sl<AyatController>().showTafsirOnTap(surahNum, ayahNum, ayahText,
            pageIndex, ayahTextNormal, ayahUQNum, index);
        cancel!();
      },
    );
  }
}
