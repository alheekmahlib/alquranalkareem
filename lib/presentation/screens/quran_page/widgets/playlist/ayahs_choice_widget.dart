import 'package:alquranalkareem/presentation/controllers/general_controller.dart';
import 'package:alquranalkareem/presentation/controllers/quran_controller.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../../core/services/services_locator.dart';
import '../../../../../core/utils/constants/lottie.dart';
import '../../../../controllers/playList_controller.dart';
import '../../../quran_text/widgets/widgets.dart';
import 'playList_ayat_widget.dart';

class AyahsChoiceWidget extends StatelessWidget {
  AyahsChoiceWidget({super.key});
  final playList = sl<PlayListController>();
  final quranCtrl = sl<QuranController>();
  final generalCtrl = sl<GeneralController>();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Obx(
            () {
              if (quranCtrl.currentPageAyahs.isEmpty) {
                return Center(child: search(100.0, 40.0));
              } else {
                return PopupMenuButton(
                  position: PopupMenuPosition.under,
                  color: Get.theme.colorScheme.background,
                  child: Container(
                    height: 45,
                    padding: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      color: Get.theme.colorScheme.primary.withOpacity(.15),
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          '${'from'.tr}: ',
                          style: TextStyle(
                            fontFamily: 'kufi',
                            fontSize: 16,
                            color: Get.theme.hintColor,
                          ),
                        ),
                        Obx(
                          () => Text(
                            '${quranCtrl.getSurahNameFromPage(generalCtrl.currentPageNumber.value - 1)} | ${arabicNumber.convert(playList.firstAyah)}',
                            style: TextStyle(
                              fontFamily: 'kufi',
                              fontSize: 16,
                              color: Get.isDarkMode
                                  ? Colors.white
                                  : Get.theme.colorScheme.primary,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 20,
                          color: Get.theme.colorScheme.primary,
                        )
                      ],
                    ),
                  ),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: PlayListAyatWidget(startNum: true),
                    )
                  ],
                );
              }
            },
          ),
        ),
        const Gap(8),
        Expanded(
          child: Obx(
            () {
              if (quranCtrl.currentPageAyahs.isEmpty) {
                return Center(child: search(100.0, 40.0));
              } else {
                return PopupMenuButton(
                  position: PopupMenuPosition.under,
                  color: Get.theme.colorScheme.background,
                  child: Container(
                    height: 45,
                    padding: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      color: Get.theme.colorScheme.primary.withOpacity(.15),
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          '${'to'.tr}: ',
                          style: TextStyle(
                            fontFamily: 'kufi',
                            fontSize: 16,
                            color: Get.theme.hintColor,
                          ),
                        ),
                        Text(
                          '${quranCtrl.getSurahNameFromPage(generalCtrl.currentPageNumber.value - 1)} | ${arabicNumber.convert(playList.lastAyah)}',
                          style: TextStyle(
                            fontFamily: 'kufi',
                            fontSize: 16,
                            color: Get.isDarkMode
                                ? Colors.white
                                : Get.theme.colorScheme.primary,
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 20,
                          color: Get.theme.colorScheme.primary,
                        )
                      ],
                    ),
                  ),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: PlayListAyatWidget(endNum: true),
                    )
                  ],
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
