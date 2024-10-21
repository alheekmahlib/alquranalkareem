import 'package:flutter/material.dart';

import '/core/widgets/seek_bar.dart';
import '../../controllers/playList_controller.dart';
import 'playList_play_button.dart';

class PlayListPlayWidget extends StatelessWidget {
  const PlayListPlayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final playList = PlayListController.instance;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const PlayListPlayButton(),
        Transform.translate(
          offset: const Offset(0, 2),
          child: Container(
            height: 69,
            margin: const EdgeInsets.symmetric(horizontal: 32.0),
            child: StreamBuilder<PositionData>(
              stream: playList.positionDataStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final positionData = snapshot.data;
                  return SliderWidget.player(
                    horizontalPadding: 0.0,
                    duration: positionData?.duration ?? Duration.zero,
                    position: positionData?.position ?? Duration.zero,
                    // bufferedPosition:
                    //     positionData?.bufferedPosition ?? Duration.zero,
                    activeTrackColor: Theme.of(context).colorScheme.primary,
                    onChangeEnd: playList.playlistAudioPlayer.seek,
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        )
      ],
    );
  }
}
