import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '/core/services/services_locator.dart';
import '/core/utils/constants/extensions/convert_number_extension.dart';
import '/core/utils/constants/extensions/extensions.dart';
import '/presentation/screens/quran_page/controller/extensions/quran_ui.dart';
import '../../../controllers/general_controller.dart';
import '../controller/quran_controller.dart';

class QuranSurahList extends StatelessWidget {
  QuranSurahList({super.key});

  @override
  Widget build(BuildContext context) {
    final quranCtrl = QuranController.instance;
    return AnimationLimiter(
      child: CupertinoScrollbar(
        controller: sl<GeneralController>().surahListController,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
          ),
          child: ListView.builder(
              padding: EdgeInsets.zero,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: quranCtrl.state.surahs.length,
              controller: sl<GeneralController>().surahListController,
              itemBuilder: (_, index) {
                final surah = quranCtrl.state.surahs[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        '${'juz'.tr} ${surah.ayahs.first.juz.toString()}',
                        style: TextStyle(
                            color: Theme.of(context).hintColor,
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
                                            ? Theme.of(context)
                                                .colorScheme
                                                .primary
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
                                                        colorFilter:
                                                            ColorFilter.mode(
                                                                Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .primary,
                                                                BlendMode
                                                                    .srcIn),
                                                      )),
                                                  Transform.translate(
                                                    offset: const Offset(0, 1),
                                                    child: Text(
                                                      '${'${surah.surahNumber}'.convertNumbers()}',
                                                      style: TextStyle(
                                                          color:
                                                              Theme.of(context)
                                                                  .hintColor,
                                                          fontFamily: "kufi",
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          height: 2),
                                                    ),
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
                                                      Theme.of(context)
                                                          .hintColor,
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
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .surface,
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
                                                          fontFamily: "naskh",
                                                          fontSize: 13,
                                                          color: Get
                                                              .theme
                                                              .colorScheme
                                                              .surface,
                                                        ),
                                                      ),
                                                      Text(
                                                        '${'${surah.ayahs.last.ayahNumber}'.convertNumbers()}',
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
                                onTap: () => quranCtrl.changeSurahListOnTap(
                                    surah.ayahs.first.page),
                              ),
                              context.hDivider(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary
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
