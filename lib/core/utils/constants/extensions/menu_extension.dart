import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../services/services_locator.dart';
import '../../../widgets/share/share_ayah_options.dart';
import '/presentation/controllers/quran_controller.dart';
import '/presentation/screens/quran_page/widgets/buttons/add_bookmark_button.dart';
import '/presentation/screens/quran_page/widgets/buttons/copy_button.dart';
import '/presentation/screens/quran_page/widgets/buttons/play_button.dart';
import '/presentation/screens/quran_page/widgets/buttons/tafsir_button.dart';
import 'extensions.dart';

extension ContextMenuExtension on BuildContext {
  void showAyahMenu(int surahNum, int ayahNum, String ayahText, int pageIndex,
      String ayahTextNormal, int ayahUQNum, String surahName, int index,
      {dynamic details}) {
    sl<QuranController>().selectedAyahIndexes.isNotEmpty
        ? BotToast.showAttachedWidget(
            target: details.globalPosition,
            verticalOffset: 30.0,
            horizontalOffset: 0.0,
            preferDirection: sl<QuranController>().preferDirection,
            animationDuration: const Duration(microseconds: 700),
            animationReverseDuration: const Duration(microseconds: 700),
            attachedBuilder: (cancel) => Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
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
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 6.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TafsirButton(
                        surahNum: surahNum,
                        ayahNum: ayahNum,
                        ayahText: ayahText,
                        pageIndex: pageIndex,
                        ayahTextNormal: ayahTextNormal,
                        ayahUQNum: ayahUQNum,
                        index: index,
                        cancel: cancel,
                      ),
                      const Gap(6),
                      this.vDivider(height: 18.0),
                      PlayButton(
                        surahNum: surahNum,
                        ayahNum: ayahNum,
                        ayahUQNum: ayahUQNum,
                        cancel: cancel,
                      ),
                      const Gap(2),
                      this.vDivider(height: 18.0),
                      const Gap(6),
                      AddBookmarkButton(
                        surahNum: surahNum,
                        ayahNum: ayahNum,
                        ayahUQNum: ayahUQNum,
                        pageIndex: pageIndex,
                        surahName: surahName,
                        cancel: cancel,
                      ),
                      const Gap(6),
                      this.vDivider(height: 18.0),
                      const Gap(6),
                      CopyButton(
                        ayahNum: ayahNum,
                        surahName: surahName,
                        ayahTextNormal: ayahTextNormal,
                        cancel: cancel,
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
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        : null;
  }
}
