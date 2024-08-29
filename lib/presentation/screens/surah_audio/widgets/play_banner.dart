import 'package:alquranalkareem/presentation/screens/surah_audio/controller/extensions/surah_audio_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:mini_music_visualizer/mini_music_visualizer.dart';

import '/core/utils/constants/extensions/extensions.dart';
import '../../../../core/services/services_locator.dart';
import '../controller/surah_audio_controller.dart';

class PlayBanner extends StatelessWidget {
  const PlayBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: true,
      label: 'Play Banner',
      child: GestureDetector(
        child: Container(
          width: 150,
          height: 50,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface.withOpacity(.2),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
          margin: context.customOrientation(
              const EdgeInsets.only(top: 75.0, right: 16.0),
              const EdgeInsets.only(bottom: 16.0, left: 32.0)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Obx(
                () => SvgPicture.asset(
                  'assets/svg/surah_name/00${sl<SurahAudioController>().state.surahNum}.svg',
                  width: 100,
                  colorFilter: ColorFilter.mode(
                      Theme.of(context).hintColor, BlendMode.srcIn),
                ),
              ),
              MiniMusicVisualizer(
                color: Theme.of(context).colorScheme.surface,
                width: 4,
                height: 15,
                animate: true,
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
          sl<SurahAudioController>()
              .jumpToSurah(sl<SurahAudioController>().state.surahNum.value - 1);
        },
      ),
    );
  }
}
