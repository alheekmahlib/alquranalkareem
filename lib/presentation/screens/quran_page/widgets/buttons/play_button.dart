import 'package:flutter/material.dart';

import '../../../../../core/services/services_locator.dart';
import '../../../../../core/utils/constants/svg_picture.dart';
import '../../../../controllers/audio_controller.dart';
import '../../../../controllers/general_controller.dart';
import '../../../../controllers/quran_controller.dart';

class PlayButton extends StatelessWidget {
  final int surahNum;
  final int ayahNum;
  final int ayahUQNum;
  final VoidCallback? cancel;
  PlayButton(
      {super.key,
      required this.surahNum,
      required this.ayahNum,
      required this.ayahUQNum,
      this.cancel});
  final generalCtrl = sl<GeneralController>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Semantics(
        button: true,
        enabled: true,
        label: 'Play Ayah',
        child: play_arrow(height: 20.0),
      ),
      onTap: () {
        sl<AudioController>().startPlayingToggle();
        sl<QuranController>().isPlayExpanded.value = true;
        sl<AudioController>().playAyahOnTap(surahNum, ayahNum, ayahUQNum);
        if (cancel != null) {
          cancel!();
        }
      },
    );
  }
}
