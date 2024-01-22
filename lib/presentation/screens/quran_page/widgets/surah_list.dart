import 'package:alquranalkareem/core/utils/constants/extensions.dart';
import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../core/services/services_locator.dart';
import '../../../controllers/general_controller.dart';
import '../../../controllers/surah_repository_controller.dart';

class SurahList extends StatelessWidget {
  SurahList({super.key});

  @override
  Widget build(BuildContext context) {
    sl<GeneralController>().surahPosition();
    ArabicNumbers arabicNumber = ArabicNumbers();
    double height = MediaQuery.sizeOf(context).height;
    return Container(
      height: context.customOrientation(height * .65, height),
      color: Get.theme.colorScheme.background,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: AnimationLimiter(
                child: Obx(
                  () => CupertinoScrollbar(
                    controller: sl<GeneralController>().surahListController,
                    child: ListView.builder(
                        padding: EdgeInsets.zero,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount:
                            sl<SurahRepositoryController>().sorahs.length,
                        controller: sl<GeneralController>().surahListController,
                        itemBuilder: (_, index) {
                          final surah =
                              sl<SurahRepositoryController>().sorahs[index];
                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 450),
                            child: SlideAnimation(
                              verticalOffset: 50.0,
                              child: FadeInAnimation(
                                child: GestureDetector(
                                  onTap: () {
                                    sl<GeneralController>().currentPage.value =
                                        surah.pageNum - 1;
                                    sl<GeneralController>()
                                        .quranPageController
                                        .animateToPage(
                                          surah.pageNum - 1,
                                          duration:
                                              const Duration(milliseconds: 500),
                                          curve: Curves.easeIn,
                                        );
                                    sl<GeneralController>().slideClose();
                                  },
                                  child: Container(
                                      height: 65,
                                      color: (index % 2 == 0
                                          ? Get.theme.colorScheme.background
                                          : Get.theme.dividerColor
                                              .withOpacity(.3)),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                SizedBox(
                                                    height: 40,
                                                    width: 40,
                                                    child: SvgPicture.asset(
                                                      'assets/svg/sora_num.svg',
                                                    )),
                                                Text(
                                                  arabicNumber
                                                      .convert(surah.id),
                                                  style: TextStyle(
                                                      color: Get.isDarkMode
                                                          ? Get
                                                              .theme.canvasColor
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
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SvgPicture.asset(
                                                  'assets/svg/surah_name/00${index + 1}.svg',
                                                  colorFilter: Get.isDarkMode
                                                      ? ColorFilter.mode(
                                                          Get.theme.canvasColor,
                                                          BlendMode.srcIn)
                                                      : ColorFilter.mode(
                                                          Get.theme
                                                              .primaryColorDark,
                                                          BlendMode.srcIn),
                                                  width: 100,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 8.0),
                                                  child: Text(
                                                    surah.nameEn,
                                                    style: TextStyle(
                                                      fontFamily: "naskh",
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 10,
                                                      color: Get.isDarkMode
                                                          ? Get
                                                              .theme.canvasColor
                                                          : Get.theme
                                                              .primaryColorLight,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "| ${'aya_count'.tr} |",
                                                  style: TextStyle(
                                                    fontFamily: "uthman",
                                                    fontSize: 12,
                                                    color: Get.isDarkMode
                                                        ? Get.theme.canvasColor
                                                        : Get.theme
                                                            .primaryColorDark,
                                                  ),
                                                ),
                                                Text(
                                                  "| ${arabicNumber.convert(surah.ayaCount)} |",
                                                  style: TextStyle(
                                                    fontFamily: "kufi",
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Get.isDarkMode
                                                        ? Get.theme.canvasColor
                                                        : Get.theme
                                                            .primaryColorDark,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )),
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
