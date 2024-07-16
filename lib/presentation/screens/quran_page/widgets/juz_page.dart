import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/convert_number_extension.dart';
import '/presentation/screens/quran_page/controller/extensions/quran_ui.dart';
import '../../../../core/services/services_locator.dart';
import '../../../../core/utils/constants/extensions/extensions.dart';
import '../../../controllers/general_controller.dart';
import '../controller/quran_controller.dart';

class QuranJuz extends StatelessWidget {
  final controller = ScrollController();

  QuranJuz({super.key});

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
              itemCount: 30,
              controller: sl<GeneralController>().surahListController,
              itemBuilder: (_, index) {
                final surah = quranCtrl.state.surahs[index];
                final juz = quranCtrl.state.allAyahs.firstWhere(
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
                              '${'juz'.tr} ${(index + 1).toString().convertNumbers()}',
                              style: TextStyle(
                                  color: Theme.of(context).hintColor,
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
                                        ? Theme.of(context)
                                            .colorScheme
                                            .primary
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
                                                      '${(index + 1).toString().convertNumbers()}',
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
                                                Text(
                                                  '${juz.text}',
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .hintColor,
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
                                                    '${surah.arabicName} ${surah.surahNumber.toString().convertNumbers()} - ${'page'.tr} ${juz.page.toString().convertNumbers()}',
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
                                        ],
                                      ),
                                    ),
                                  ),
                                )),
                            onTap: () {
                              quranCtrl.clearAndAddSelection(juz.ayahUQNumber);
                              quranCtrl.changeSurahListOnTap(juz.page);
                            },
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
                );
              }),
        ),
      ),
    );
  }
}
