import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '/core/services/services_locator.dart';
import '/core/widgets/share/share_ayah_options.dart';
import '../../../../presentation/screens/quran_page/quran.dart';
import 'extensions.dart';

extension ContextMenuExtension on BuildContext {
  void showAyahMenu(
      {required int surahNum,
      required int ayahNum,
      required String ayahText,
      required int pageIndex,
      required String ayahTextNormal,
      required int ayahUQNum,
      required String surahName,
      dynamic details}) {
    BotToast.showAttachedWidget(
      target: details.globalPosition,
      verticalOffset: 30.0,
      horizontalOffset: 0.0,
      preferDirection: sl<QuranController>().state.preferDirection,
      animationDuration: const Duration(microseconds: 700),
      animationReverseDuration: const Duration(microseconds: 700),
      attachedBuilder: (cancel) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        decoration: BoxDecoration(
          color: Get.theme.colorScheme.primary,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        child: Container(
          decoration: BoxDecoration(
              color:
                  Get.theme.colorScheme.primaryContainer.withValues(alpha: .95),
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              border: Border.all(
                  width: 2,
                  color: Get.theme.colorScheme.primary.withValues(alpha: .5))),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
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
                  cancel: cancel,
                ),
                const Gap(6),
                this.vDivider(height: 18.0),
                PlayButton(
                  surahNum: surahNum,
                  ayahNum: ayahNum,
                  ayahUQNum: ayahUQNum,
                  singleAyahOnly: true,
                  cancel: cancel,
                ),
                const Gap(6),
                this.vDivider(height: 18.0),
                // full surah playButton
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
                  ayahText: ayahText,
                  cancel: cancel,
                ),
                const Gap(6),
                this.vDivider(height: 18.0),
                const Gap(6),
                ShareAyahOptions(
                  ayahNumber: ayahNum,
                  ayahUQNumber: ayahUQNum,
                  surahNumber: surahNum,
                  ayahTextNormal: ayahTextNormal,
                  ayahText: ayahText,
                  surahName: 'surahName',
                  pageNumber: pageIndex,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
