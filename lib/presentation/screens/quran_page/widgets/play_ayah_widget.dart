import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:square_percent_indicater/square_percent_indicater.dart';

import '../../../../core/services/l10n/app_localizations.dart';
import '../../../../core/services/services_locator.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../controllers/audio_controller.dart';

class PlayAyah extends StatelessWidget {
  const PlayAyah({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SizedBox(
        width: 40,
        height: 40,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SquarePercentIndicator(
              width: 35,
              height: 35,
              startAngle: StartAngle.topRight,
              // reverse: true,
              borderRadius: 8,
              shadowWidth: 1.5,
              progressWidth: 2,
              shadowColor: Theme.of(context).dividerColor.withOpacity(.5),
              progressColor: sl<AudioController>().downloading.value
                  ? Theme.of(context).dividerColor
                  : Colors.transparent,
              progress: sl<AudioController>().progress.value,
            ),
            sl<AudioController>().downloading.value
                ? Container(
                    width: 35,
                    height: 35,
                    alignment: Alignment.center,
                    child: Text(
                      sl<AudioController>().progressString.value,
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'kufi',
                          color: Theme.of(context).colorScheme.surface),
                    ),
                  )
                : IconButton(
                    icon: Semantics(
                      button: true,
                      enabled: true,
                      label: 'Play Ayah',
                      child: Icon(
                        sl<AudioController>().isPlay.value
                            ? Icons.pause
                            : Icons.play_arrow,
                        size: 25,
                      ),
                    ),
                    color: Theme.of(context).colorScheme.surface,
                    onPressed: () {
                      sl<AudioController>().isPagePlay.value = false;
                      print(sl<AudioController>().progressString.value);
                      if (sl<AudioController>().pageAyahNumber == null) {
                        customErrorSnackBar(
                            context, AppLocalizations.of(context)!.choiceAyah);
                      } else {
                        sl<AudioController>().playAyah(context);
                      }
                      sl<AudioController>().isPagePlay.value = false;
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
