import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:mini_music_visualizer/mini_music_visualizer.dart';
import 'package:theme_provider/theme_provider.dart';

import '../../shared/services/controllers_put.dart';
import '../../shared/widgets/widgets.dart';

class PlayBanner extends StatelessWidget {
  const PlayBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: 150,
        height: 50,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withOpacity(.2),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        margin: orientation(
            context,
            const EdgeInsets.only(top: 75.0, right: 16.0),
            const EdgeInsets.only(bottom: 16.0, left: 32.0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Obx(
              () => SvgPicture.asset(
                'assets/svg/surah_name/00${surahAudioController.sorahNum}.svg',
                width: 100,
                colorFilter: ColorFilter.mode(
                    ThemeProvider.themeOf(context).id == 'dark'
                        ? Theme.of(context).canvasColor
                        : Theme.of(context).primaryColorLight,
                    BlendMode.srcIn),
              ),
            ),
            MiniMusicVisualizer(
              color: Theme.of(context).colorScheme.surface,
              width: 4,
              height: 15,
            ),
            Container(
              height: 80,
              width: 10,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        surahAudioController.controller
            .jumpTo((surahAudioController.sorahNum.value - 1) * 65.0);
        generalController.widgetPosition.value = 0.0;
      },
    );
  }
}
