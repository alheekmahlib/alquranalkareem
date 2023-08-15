import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

import '../controller/surah_audio_controller.dart';

class SkipToPrevious extends StatelessWidget {
  late final SurahAudioController surahAudioController =
      Get.put(SurahAudioController());

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 30,
          width: 30,
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(8),
                topLeft: Radius.circular(8),
              ),
              border:
                  Border.all(width: 2, color: Theme.of(context).dividerColor)),
        ),
        StreamBuilder<SequenceState?>(
          stream: surahAudioController.audioPlayer.sequenceStateStream,
          builder: (context, snapshot) => IconButton(
            icon: Icon(
              Icons.skip_next,
              color: Theme.of(context).colorScheme.surface,
            ),
            onPressed: () {
              if (surahAudioController.isDownloading.value) {
                if (surahAudioController.downAudioPlayer.hasPrevious) {
                  surahAudioController.downAudioPlayer.seekToPrevious();
                }
              } else {
                if (surahAudioController.audioPlayer.hasPrevious) {
                  surahAudioController.audioPlayer.seekToPrevious();
                }
              }
              print(
                  'PreviousIndex: ${surahAudioController.audioPlayer.previousIndex}');
              print(
                  'PreviousIndex: ${surahAudioController.downAudioPlayer.previousIndex}');
            },
          ),
        ),
      ],
    );
  }
}
