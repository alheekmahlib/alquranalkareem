import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/constants/svg_picture.dart';
import 'online_play_button.dart';
import 'skip_next.dart';
import 'skip_previous.dart';

class CollapsedPlayWidget extends StatelessWidget {
  const CollapsedPlayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(.15),
      ),
      child: Stack(
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    SkipToPrevious(),
                    OnlinePlayButton(
                      isRepeat: false,
                    ),
                    SkipToNext(),
                  ],
                ),
                Obx(
                  () => surahName(
                    50,
                    100,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
