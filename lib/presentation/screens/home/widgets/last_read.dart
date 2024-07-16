import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/alignment_rotated_extension.dart';
import '/core/utils/constants/extensions/convert_number_extension.dart';
import '/core/utils/constants/extensions/extensions.dart';
import '/core/utils/constants/lottie.dart';
import '/core/utils/constants/lottie_constants.dart';
import '/presentation/screens/quran_page/controller/extensions/quran_ui.dart';
import '../../../controllers/count_down_controller.dart';
import '../../../controllers/general_controller.dart';
import '../../quran_page/controller/quran_controller.dart';
import '../../quran_page/screens/quran_home.dart';

class LastRead extends StatelessWidget {
  LastRead({super.key});

  final countdownCtrl = CountdownController.instance;
  final generalCtrl = GeneralController.instance;
  final quranCtrl = QuranController.instance;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => QuranHome(), transition: Transition.downToUp)!.then(
            (value) => quranCtrl
                .changeSurahListOnTap(generalCtrl.currentPageNumber.value + 1));
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
                decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(.15),
                    borderRadius: const BorderRadius.all(Radius.circular(8.0))),
                child: Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    // SimpleAnimationProgressBar(
                    //   height: 70,
                    //   width: MediaQuery.sizeOf(context).width,
                    //   backgroundColor: Theme.of(context).canvasColor,
                    //   foregrondColor:
                    //       Theme.of(context).colorScheme.surface.withOpacity(.5),
                    //   ratio: generalCtrl.calculateProgress(
                    //       generalCtrl.currentPageNumber.value, 604),
                    //   direction: Axis.horizontal,
                    //   reverseAlignment: true,
                    //   curve: Curves.fastLinearToSlowEaseIn,
                    //   duration: const Duration(seconds: 3),
                    //   borderRadius: BorderRadius.circular(8),
                    // ),
                    Container(
                      height: 70,
                      width: countdownCtrl.calculateProgress(
                          generalCtrl.currentPageNumber.value, 604),
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .surface
                              .withOpacity(.5),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8.0))),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Obx(() {
                        return Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: SvgPicture.asset(
                                'assets/svg/surah_name/00${generalCtrl.lastReadSurahNumber.value}.svg',
                                height: 60,
                                colorFilter: ColorFilter.mode(
                                    Theme.of(context).cardColor,
                                    BlendMode.srcIn),
                              ),
                            ),
                            context.vDivider(height: 30),
                            Expanded(
                              flex: 7,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 120,
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        '${'pageNo'.tr}: ${generalCtrl.currentPageNumber.value.toString().convertNumbers()}',
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            fontFamily: 'naskh',
                                            fontWeight: FontWeight.w500,
                                            color: Theme.of(context).hintColor,
                                            height: 1.5),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        textDirection: TextDirection.rtl,
                                      ),
                                    ),
                                  ),
                                  Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Container(
                                        height: 30,
                                        width: 30,
                                        decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(8))),
                                      ),
                                      alignmentLayout(
                                          context,
                                          RotatedBox(
                                              quarterTurns: 15,
                                              child: customLottie(
                                                  LottieConstants
                                                      .assetsLottieArrow,
                                                  height: 50.0)),
                                          RotatedBox(
                                              quarterTurns: 25,
                                              child: customLottie(
                                                  LottieConstants
                                                      .assetsLottieArrow,
                                                  height: 50.0))),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
