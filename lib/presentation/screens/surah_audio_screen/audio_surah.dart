import 'package:flutter/material.dart';
import 'package:flutter_sliding_box/flutter_sliding_box.dart';
import 'package:get/get.dart';

import '../../../core/services/services_locator.dart';
import '../../controllers/surah_audio_controller.dart';
import 'widgets/back_drop_widget.dart';
import 'widgets/collapsed_play_widget.dart';
import 'widgets/play_widget.dart';

class AudioScreen extends StatelessWidget {
  const AudioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final surahCtrl = sl<SurahAudioController>();
    surahCtrl.loadSurahReader();
    surahCtrl.loadLastSurahListen();
    // surahCtrl.initializeSurahDownloadStatus();
    return Scaffold(
      backgroundColor: Get.theme.colorScheme.background,
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: SlidingBox(
            controller: surahCtrl.boxController,
            minHeight: 80,
            maxHeight: 290,
            color: Theme.of(context).colorScheme.background,
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            animationCurve: Curves.easeInOut,
            animationDuration: const Duration(milliseconds: 250),
            draggableIconVisible: false,
            collapsed: true,
            backdrop: Backdrop(
              fading: false,
              overlay: false,
              color: Get.theme.colorScheme.background,
              body: const BackDropWidget(),
            ),
            collapsedBody: const CollapsedPlayWidget(),
            body: PlayWidget(),
          ),
        ),
      ),
    );
  }

  // @override
  bool get wantKeepAlive => true;
}
