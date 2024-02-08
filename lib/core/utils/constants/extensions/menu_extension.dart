import 'package:alquranalkareem/presentation/controllers/audio_controller.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../presentation/controllers/ayat_controller.dart';
import '../../../../presentation/controllers/quran_controller.dart';
import '../../../services/services_locator.dart';
import '../../../widgets/share/share_ayah_options.dart';
import '../svg_picture.dart';
import '/core/utils/constants/extensions.dart';

extension ContextMenuExtension on BuildContext {
  void showAyahMenu(int surahNum, int ayahNum, String ayahText, int pageIndex,
      String ayahTextNormal, int ayahUQNum,
      {dynamic details}) {
    BotToast.showAttachedWidget(
      target: details.globalPosition,
      verticalOffset: 0.0,
      horizontalOffset: 0.0,
      preferDirection: sl<QuranController>().preferDirection,
      animationDuration: const Duration(microseconds: 700),
      animationReverseDuration: const Duration(microseconds: 700),
      attachedBuilder: (cancel) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            decoration: BoxDecoration(
              color: Get.theme.colorScheme.primary,
              borderRadius: const BorderRadius.all(Radius.circular(8)),
            ),
            child: Container(
              decoration: BoxDecoration(
                  color: Get.theme.colorScheme.background.withOpacity(.95),
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  border: Border.all(
                      width: 2,
                      color: Get.theme.colorScheme.primary.withOpacity(.5))),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      child: Semantics(
                        button: true,
                        enabled: true,
                        label: 'Show Tafseer',
                        child: tafsir_icon(height: 25.0),
                      ),
                      onTap: () {
                        sl<AyatController>().showTafsirOnTap(surahNum, ayahNum,
                            ayahText, pageIndex, ayahTextNormal, ayahUQNum);
                        cancel();
                      },
                    ),
                    const Gap(6),
                    this.vDivider(height: 18.0),
                    GestureDetector(
                      child: Semantics(
                        button: true,
                        enabled: true,
                        label: 'Play Ayah',
                        child: play_arrow(height: 25.0),
                      ),
                      onTap: () {
                        sl<AudioController>().startPlayingToggle();
                        sl<QuranController>().isPlayExpanded.value = true;
                        sl<AudioController>().playAyahOnTap(surahNum, ayahNum);
                        cancel();
                      },
                    ),
                    const Gap(2),
                    this.vDivider(height: 18.0),
                    const Gap(6),
                    GestureDetector(
                      child: Semantics(
                        button: true,
                        enabled: true,
                        label: 'Add Bookmark',
                        child: bookmark_icon(height: 25.0),
                      ),
                      onTap: () async {
                        cancel();
                      },
                    ),
                    const Gap(6),
                    this.vDivider(height: 18.0),
                    const Gap(6),
                    GestureDetector(
                      child: Semantics(
                        button: true,
                        enabled: true,
                        label: 'Copy Ayah',
                        child: copy_icon(height: 25.0),
                      ),
                      onTap: () {
                        cancel();
                      },
                    ),
                    const Gap(6),
                    this.vDivider(height: 18.0),
                    const Gap(6),
                    ShareAyahOptions(
                      verseNumber: ayahNum,
                      verseUQNumber: ayahUQNum,
                      surahNumber: surahNum,
                      ayahTextNormal: ayahTextNormal,
                      verseText: ayahTextNormal,
                      surahName: 'surahName',
                      textTranslate:
                          sl<AyatController>().currentText.value?.translate ??
                              '',
                    ),
                  ],
                ),
              ),
            ),
          ),
          menu_curve(height: 20.0)
        ],
      ),
    );
  }
}
