import '../../../../controllers/audio_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

import '../../../../../core/services/services_locator.dart';

class SkipToPrevious extends StatelessWidget {
  SkipToPrevious({super.key});
  final audioCtrl = sl<AudioController>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SequenceState?>(
      stream: audioCtrl.audioPlayer.sequenceStateStream,
      builder: (context, snapshot) => GestureDetector(
        child: Semantics(
          button: true,
          enabled: true,
          label: 'skipToPrevious'.tr,
          child: Icon(
            Icons.skip_next,
            color: Theme.of(context).colorScheme.primary,
            size: 30,
          ),
        ),
        onTap: () async {
          await audioCtrl.skipPreviousAyah();
        },
      ),
    );
  }
}
