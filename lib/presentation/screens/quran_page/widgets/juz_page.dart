import 'package:alquranalkareem/core/utils/constants/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../core/services/services_locator.dart';
import '../../../controllers/general_controller.dart';
import '../../../controllers/quran_controller.dart';

class QuranJuz extends StatelessWidget {
  final controller = ScrollController();

  QuranJuz({super.key});

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
              itemCount: 30,
              controller: sl<GeneralController>().surahListController,
              itemBuilder: (_, index) {
                final surah = quranCtrl.surahs[index];
                final juz = quranCtrl.allAyahs.firstWhere(
                  (a) => a.juz == index + 1,
                );
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 450),
                  child: SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              '${'juz'.tr} ${generalCtrl.convertNumbers((index + 1).toString())}',
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
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: ShaderMask(
                                      shaderCallback: (Rect bounds) {
                                        return const LinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          colors: [
                                            Colors.transparent,
                                            Colors.black
                                          ],
                                          stops: [0.0, 0.2],
                                        ).createShader(bounds);
                                      },
                                      blendMode: BlendMode.dstIn,
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
                                                    '${generalCtrl.convertNumbers((index + 1).toString())}',
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
                                                Text(
                                                  '${juz.text}',
                                                  style: TextStyle(
                                                    color: Get.isDarkMode
                                                        ? Get.theme.colorScheme
                                                            .secondary
                                                        : Get.theme
                                                            .primaryColorDark,
                                                    fontFamily: "uthmanic2",
                                                    fontSize: 20,
                                                    height: 2,
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow
                                                      .clip, // Change overflow to clip
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 8.0),
                                                  child: Text(
                                                    '${surah.arabicName} ${generalCtrl.convertNumbers(surah.surahNumber.toString())} - ${'page'.tr} ${generalCtrl.convertNumbers(juz.page.toString())}',
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
                                        ],
                                      ),
                                    ),
                                  ),
                                )),
                            onTap: () {
                              sl<GeneralController>().currentPage.value =
                                  surah.ayahs.first.page - 1;
                              sl<GeneralController>()
                                  .quranPageController
                                  .animateToPage(
                                    surah.ayahs.first.page - 1,
                                    duration: const Duration(milliseconds: 500),
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
                );
              }),
        ),
      ),
    );
  }
}
