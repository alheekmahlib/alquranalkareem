import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../core/services/services_locator.dart';
import '../../../../core/utils/constants/lottie.dart';
import '../../../controllers/general_controller.dart';
import '../../quran_page/screens/quran_home.dart';
import '/core/utils/constants/extensions.dart';

class LastRead extends StatelessWidget {
  const LastRead({super.key});

  @override
  Widget build(BuildContext context) {
    final generalCtrl = sl<GeneralController>();
    return GestureDetector(
      onTap: () {
        Get.to(() => QuranHome(), transition: Transition.downToUp);
        generalCtrl.quranPageController.animateToPage(
          generalCtrl.lastReadSurahNumber.value,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeIn,
        );
      },
      child: Container(
        height: 125,
        width: 380,
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(8.0),
            Text(
              'lastRead'.tr,
              style: TextStyle(
                fontSize: 16.0,
                fontFamily: 'kufi',
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Container(
                height: 70,
                width: 380,
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(.15),
                    borderRadius: const BorderRadius.all(Radius.circular(8.0))),
                child: Obx(() {
                  return Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: SvgPicture.asset(
                          'assets/svg/surah_name/00${generalCtrl.lastReadSurahNumber.value}.svg',
                          height: 60,
                          colorFilter: ColorFilter.mode(
                              Get.theme.cardColor, BlendMode.srcIn),
                        ),
                      ),
                      context.vDivider(height: 30),
                      Expanded(
                        flex: 7,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${'pageNo'.tr} ${generalCtrl.currentPageNumber.value}',
                              style: TextStyle(
                                  fontSize: 20.0,
                                  fontFamily: 'naskh',
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).hintColor,
                                  height: 1.5),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.rtl,
                            ),
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                      color: Get.theme.colorScheme.primary,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(8))),
                                ),
                                RotatedBox(
                                    quarterTurns: 15,
                                    child: arrow(height: 50.0)),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
