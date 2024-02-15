import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../core/services/services_locator.dart';
import '../../../controllers/general_controller.dart';
import '../../../controllers/quran_controller.dart';
import '/core/utils/constants/extensions.dart';

class QuranSurahList extends StatelessWidget {
  QuranSurahList({super.key});

  @override
  Widget build(BuildContext context) {
    final generalCtrl = sl<GeneralController>();
    final quranCtrl = sl<QuranController>();
    return AnimationLimiter(
      child: CupertinoScrollbar(
        controller: sl<GeneralController>().surahListController,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: Get.theme.colorScheme.background,
          ),
          child: ListView.builder(
              padding: EdgeInsets.zero,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: quranCtrl.surahs.length,
              controller: sl<GeneralController>().surahListController,
              itemBuilder: (_, index) {
                final surah = quranCtrl.surahs[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        '${'juz'.tr} ${surah.ayahs.first.juz.toString()}',
                        style: TextStyle(
                            color: Get.isDarkMode
                                ? Get.theme.colorScheme.secondary
                                : Get.theme.primaryColorDark,
                            fontFamily: "kufi",
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            height: 2),
                      ),
                    ),
                    AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 450),
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: Column(
                            children: [
                              GestureDetector(
                                child: Container(
                                    height: 60,
                                    decoration: BoxDecoration(
                                        color: (index % 2 == 0
                                            ? Get.theme.colorScheme.primary
                                                .withOpacity(.15)
                                            : Colors.transparent),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(8))),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  SizedBox(
                                                      height: 40,
                                                      width: 40,
                                                      child: SvgPicture.asset(
                                                        'assets/svg/sora_num.svg',
                                                      )),
                                                  Text(
                                                    generalCtrl.convertNumbers(
                                                        surah.surahNumber
                                                            .toString()),
                                                    style: TextStyle(
                                                        color: Get.isDarkMode
                                                            ? Get
                                                                .theme
                                                                .colorScheme
                                                                .secondary
                                                            : Get.theme
                                                                .primaryColorDark,
                                                        fontFamily: "kufi",
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        height: 2),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 8,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SvgPicture.asset(
                                                  'assets/svg/surah_name/00${index + 1}.svg',
                                                  colorFilter: ColorFilter.mode(
                                                      Get.isDarkMode
                                                          ? Get
                                                              .theme
                                                              .colorScheme
                                                              .primary
                                                          : Get.theme
                                                              .primaryColorDark,
                                                      BlendMode.srcIn),
                                                  width: 90,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 8.0),
                                                  child: Text(
                                                    surah.englishName,
                                                    style: TextStyle(
                                                      fontFamily: "naskh",
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 12,
                                                      color: Get.theme
                                                          .colorScheme.surface,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 5,
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  context.vDivider(
                                                      height: 30.0),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'aya_count'.tr,
                                                        style: TextStyle(
                                                          fontFamily: "uthman",
                                                          fontSize: 13,
                                                          color: Get
                                                              .theme
                                                              .colorScheme
                                                              .surface,
                                                        ),
                                                      ),
                                                      Text(
                                                        generalCtrl
                                                            .convertNumbers(surah
                                                                .ayahs
                                                                .last
                                                                .ayahNumber
                                                                .toString()),
                                                        style: TextStyle(
                                                          fontFamily: "kufi",
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Get
                                                              .theme.hintColor
                                                              .withOpacity(.7),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    )),
                                onTap: () {
                                  sl<GeneralController>().currentPage.value =
                                      surah.ayahs.first.page - 1;
                                  sl<GeneralController>()
                                      .quranPageController
                                      .animateToPage(
                                        surah.ayahs.first.page - 1,
                                        duration:
                                            const Duration(milliseconds: 500),
                                        curve: Curves.easeIn,
                                      );
                                  generalCtrl.drawerKey.currentState!.toggle();
                                },
                              ),
                              context.hDivider(
                                  color: Get.theme.colorScheme.primary
                                      .withOpacity(.2)),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                );
              }),
        ),
      ),
    );
  }
}
