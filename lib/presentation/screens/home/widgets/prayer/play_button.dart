import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../../../../../core/services/services_locator.dart';
import '../../../../../core/utils/constants/lottie.dart';
import '../../../../../core/utils/constants/lottie_constants.dart';
import '../../../../../core/utils/constants/svg_picture.dart';
import '../../../../controllers/notification_controller.dart';
import '../../data/model/adhan_data.dart';

class PlayButton extends StatelessWidget {
  final AdhanData adhanData;
  final int index;
  PlayButton({super.key, required this.adhanData, required this.index});

  final notificationCtrl = sl<NotificationController>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: Stack(
        alignment: Alignment.center,
        children: [
          StreamBuilder<PlayerState>(
            stream: notificationCtrl.audioPlayer.playerStateStream,
            builder: (context, snapshot) {
              final playerState = snapshot.data;
              final isCurrentlyPlaying =
                  notificationCtrl.adhanNumber.value == index;
              final isPlaying = playerState?.playing ?? false;

              if (playerState?.processingState == ProcessingState.buffering &&
                  isCurrentlyPlaying) {
                return customLottie(LottieConstants.assetsLottiePlayButton,
                    width: 20.0, height: 20.0);
              } else if (isCurrentlyPlaying && isPlaying) {
                return GestureDetector(
                  child: pause_arrow(height: 25.0),
                  onTap: () {
                    notificationCtrl.audioPlayer.pause();
                  },
                );
              } else {
                return GestureDetector(
                  child: play_arrow(height: 25.0),
                  onTap: () async {
                    notificationCtrl.adhanNumber.value = index;
                    await notificationCtrl.audioPlayer
                        .setUrl(adhanData.adhan.first.urlAndroidFullAdhan);
                    await notificationCtrl.audioPlayer.play();
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
