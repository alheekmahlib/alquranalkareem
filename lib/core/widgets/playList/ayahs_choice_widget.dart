import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../presentation/controllers/ayat_controller.dart';
import '../../../presentation/controllers/playList_controller.dart';
import '../../../presentation/screens/quran_text/widgets/widgets.dart';
import '../../services/services_locator.dart';
import '../../utils/constants/lottie.dart';
import 'playList_ayat_widget.dart';

class AyahsChoiceWidget extends StatelessWidget {
  const AyahsChoiceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final playList = sl<PlayListController>();
    return Row(
      children: [
        Expanded(
          child: Obx(
            () {
              final ayatController = sl<AyatController>();
              if (ayatController.allAyatList.isEmpty) {
                return Center(child: search(100.0, 40.0));
              } else {
                return PopupMenuButton(
                  position: PopupMenuPosition.under,
                  color: Get.theme.colorScheme.background,
                  child: Container(
                    height: 45,
                    padding: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                        color: Get.theme.dividerColor.withOpacity(.4),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        border: Border.all(
                            width: 1, color: Get.theme.dividerColor)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          '${'from'.tr}: ',
                          style: TextStyle(
                            fontFamily: 'kufi',
                            fontSize: 16,
                            color: Get.isDarkMode
                                ? Colors.white
                                : Get.theme.primaryColor,
                          ),
                        ),
                        Obx(
                          () => Text(
                            '${ayatController.allAyatList.first.sorahName} | ${arabicNumber.convert(playList.firstAyah)}',
                            style: TextStyle(
                              fontFamily: 'kufi',
                              fontSize: 16,
                              color: Get.isDarkMode
                                  ? Colors.white
                                  : Get.theme.primaryColor,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 20,
                          color: Get.theme.colorScheme.surface,
                        )
                      ],
                    ),
                  ),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
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
              var ayatController = sl<AyatController>();
              if (ayatController.allAyatList.isEmpty) {
                return Center(child: search(100.0, 40.0));
              } else {
                return PopupMenuButton(
                  position: PopupMenuPosition.under,
                  color: Get.theme.colorScheme.background,
                  child: Container(
                    height: 45,
                    padding: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                        color: Get.theme.dividerColor.withOpacity(.4),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        border: Border.all(
                            width: 1, color: Get.theme.dividerColor)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          '${'to'.tr}: ',
                          style: TextStyle(
                            fontFamily: 'kufi',
                            fontSize: 16,
                            color: Get.isDarkMode
                                ? Colors.white
                                : Get.theme.primaryColor,
                          ),
                        ),
                        Text(
                          '${ayatController.allAyatList.first.sorahName} | ${arabicNumber.convert(playList.lastAyah)}',
                          style: TextStyle(
                            fontFamily: 'kufi',
                            fontSize: 16,
                            color: Get.isDarkMode
                                ? Colors.white
                                : Get.theme.primaryColor,
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 20,
                          color: Get.theme.colorScheme.surface,
                        )
                      ],
                    ),
                  ),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
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
