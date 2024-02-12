import 'package:alquranalkareem/presentation/controllers/quran_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../core/services/services_locator.dart';
import '../../../../core/utils/constants/lists.dart';
import '/presentation/controllers/general_controller.dart';

class PagesIndicator extends StatelessWidget {
  PagesIndicator({super.key});

  final generalCtrl = sl<GeneralController>();
  final quranCtrl = sl<QuranController>();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = 80;
    quranCtrl.indicatorScroll(context);
    return Container(
      height: 40,
      width: screenWidth * .67,
      margin: const EdgeInsets.only(bottom: 6.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: ListView.builder(
        controller: quranCtrl.scrollIndicatorController,
        scrollDirection: Axis.horizontal,
        itemCount: 604,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.all(4),
            color: Get.theme.colorScheme.background.withOpacity(.1),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                index.isEven
                    ? Obx(() {
                        return GestureDetector(
                          onTap: () {
                            quranCtrl.indicatorOnTap(
                                index, itemWidth, screenWidth);
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 6.0),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Opacity(
                                  opacity:
                                      generalCtrl.currentPage.value == index
                                          ? 1
                                          : .5,
                                  child: SvgPicture.asset(
                                    themeList[0][
                                        'svgUrl'], // Assuming themeList is your items list
                                    height: 20,
                                  ),
                                ),
                                Text(
                                  generalCtrl.convertNumbers('${index + 1}'),
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'naskh',
                                      color: Get.theme.colorScheme.primary),
                                )
                              ],
                            ),
                          ),
                        );
                      })
                    : const SizedBox.shrink(),
                index.isEven
                    ? Obx(() {
                        return GestureDetector(
                          onTap: () {
                            quranCtrl.indicatorOnTap(
                                index + 1, itemWidth, screenWidth);
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 6.0),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Opacity(
                                  opacity:
                                      generalCtrl.currentPage.value == index + 1
                                          ? 1
                                          : .5,
                                  child: SvgPicture.asset(
                                    themeList[0][
                                        'svgUrl'], // Assuming themeList is your items list
                                    height: 20,
                                  ),
                                ),
                                Text(
                                  generalCtrl.convertNumbers('${index + 2}'),
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'naskh',
                                      color: Get.theme.colorScheme.primary),
                                )
                              ],
                            ),
                          ),
                        );
                      })
                    : const SizedBox.shrink(),
              ],
            ),
          );
        },
      ),
    );
  }
}
