import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '/core/utils/constants/extensions/svg_extensions.dart';
import '/presentation/screens/prayers/controller/prayers_notifications/extensions/prayers_noti_ui.dart';
import '../../../../../core/utils/constants/lottie.dart';
import '../../../../../core/utils/constants/lottie_constants.dart';
import '../../../../../core/utils/constants/svg_constants.dart';
import 'controller/prayers_notifications/prayers_notifications_controller.dart';
import 'data/model/adhan_data.dart';

class PlayButton extends StatelessWidget {
  final List<AdhanData> adhanData;
  final int index;
  PlayButton({super.key, required this.adhanData, required this.index});

  final notificationCtrl = PrayersNotificationsCtrl.instance;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: Stack(
        alignment: Alignment.center,
        children: [
          StreamBuilder<PlayerState>(
            stream: notificationCtrl.state.audioPlayer.playerStateStream,
            builder: (context, snapshot) {
              final playerState = snapshot.data;
              final isCurrentlyPlaying =
                  notificationCtrl.state.downloadedAdhanData.length > index &&
                      notificationCtrl.state.selectedAdhanPath.value ==
                          notificationCtrl
                              .state.downloadedAdhanData[index].path;
              final isPlaying = playerState?.playing ?? false;

              if (playerState?.processingState == ProcessingState.buffering &&
                  isCurrentlyPlaying) {
                return customLottie(LottieConstants.assetsLottiePlayButton,
                    width: 20.0, height: 20.0);
              } else if (isCurrentlyPlaying && isPlaying) {
                return GestureDetector(
                  child: customSvg(
                    SvgPath.svgPauseArrow,
                    height: 25,
                  ),
                  onTap: () {
                    notificationCtrl.state.audioPlayer.pause();
                  },
                );
              } else {
                return GestureDetector(
                  child: customSvg(
                    SvgPath.svgPlayArrow,
                    height: 25,
                  ),
                  onTap: () async =>
                      notificationCtrl.playButtonOnTap(adhanData[index]),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
