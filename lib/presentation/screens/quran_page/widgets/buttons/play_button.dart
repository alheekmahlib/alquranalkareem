import 'package:flutter/material.dart';

import '/core/services/services_locator.dart';
import '/core/utils/constants/extensions/svg_extensions.dart';
import '/core/utils/constants/svg_constants.dart';
import '/presentation/screens/quran_page/controllers/extensions/audio_ui.dart';
import '../../../../controllers/general_controller.dart';
import '../../controllers/audio/audio_controller.dart';
import '../../controllers/quran/quran_controller.dart';

class PlayButton extends StatelessWidget {
  final int surahNum;
  final int ayahNum;
  final int ayahUQNum;
  final VoidCallback? cancel;

  /// just play the selected ayah.
  final bool singleAyahOnly;
  PlayButton(
      {super.key,
      required this.surahNum,
      required this.ayahNum,
      required this.ayahUQNum,
      this.singleAyahOnly = false,
      this.cancel});
  final generalCtrl = GeneralController.instance;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Semantics(
        button: true,
        enabled: true,
        label: singleAyahOnly ? 'Play Ayah' : 'Play Surah',
        child: customSvg(
          SvgPath.svgPlayArrow,
          height: 20,
        ),
      ),
      onTap: () {
        sl<AudioController>().startPlayingToggle();
        sl<QuranController>().state.isPlayExpanded.value = true;
        debugPrint('SurahNum: $surahNum');
        sl<AudioController>()
            .playAyahOnTap(surahNum, ayahNum, ayahUQNum, singleAyahOnly);
        if (cancel != null) {
          cancel!();
        }
      },
    );
  }
}
