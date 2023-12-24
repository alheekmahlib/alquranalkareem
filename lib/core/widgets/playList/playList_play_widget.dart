import 'package:flutter/material.dart';

import '/core/widgets/widgets.dart';
import '../../../presentation/controllers/playList_controller.dart';
import '../../services/services_locator.dart';
import '../../utils/constants/svg_picture.dart';
import '../seek_bar.dart';
import 'playList_play_button.dart';

class PlayListPlayWidget extends StatelessWidget {
  const PlayListPlayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final playList = sl<PlayListController>();
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: audioContainer(
          context,
          height: 110,
          margin: const EdgeInsets.symmetric(vertical: 32.0),
          Stack(
            children: [
              Align(
                alignment: Alignment.bottomRight,
                child: decorations(context),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: RotatedBox(
                  quarterTurns: 2,
                  child: decorations(context),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const PlayListPlayButton(),
                  Transform.translate(
                    offset: const Offset(0, 2),
                    child: Container(
                      height: 50,
                      width: 250,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                          color: Theme.of(context).dividerColor.withOpacity(.4),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8))),
                      child: StreamBuilder<PositionData>(
                        stream: playList.positionDataStream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final positionData = snapshot.data;
                            return SeekBar(
                              timeShow: true,
                              duration: positionData?.duration ?? Duration.zero,
                              position: positionData?.position ?? Duration.zero,
                              bufferedPosition:
                                  positionData?.bufferedPosition ??
                                      Duration.zero,
                              activeTrackColor:
                                  Theme.of(context).colorScheme.surface,
                              textColor: Theme.of(context).primaryColorLight,
                              onChangeEnd: playList.playlistAudioPlayer.seek,
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                  )
                ],
              ),
            ],
          )),
    );
  }
}
