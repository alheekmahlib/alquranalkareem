import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

import '../controller/surah_audio_controller.dart';

class SkipToNext extends StatelessWidget {
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
              Icons.skip_previous,
              color: Theme.of(context).colorScheme.surface,
            ),
            onPressed: () {
              if (surahAudioController.isDownloading.value) {
                if (surahAudioController.downAudioPlayer.hasNext) {
                  surahAudioController.downAudioPlayer.seekToNext();
                }
              } else {
                if (surahAudioController.audioPlayer.hasNext) {
                  surahAudioController.audioPlayer.seekToNext();
                }
              }
              print(
                  'audioPlayer SequenceState: ${surahAudioController.audioPlayer.sequenceState}');
              print(
                  'downAudioPlayer SequenceState: ${surahAudioController.downAudioPlayer.sequenceState}');

              print('nextIndex: ${surahAudioController.audioPlayer.nextIndex}');
              print(
                  'nextIndex: ${surahAudioController.downAudioPlayer.nextIndex}');
            },
          ),
        ),
      ],
    );
  }
}
