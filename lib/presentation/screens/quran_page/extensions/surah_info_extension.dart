import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/convert_number_extension.dart';
import '/core/utils/constants/extensions/extensions.dart';
import '/core/utils/constants/extensions/text_span_extension.dart';
import '/presentation/screens/quran_page/controllers/extensions/quran_getters.dart';
import '/presentation/screens/quran_page/extensions/surah_name_with_banner.dart';
import '../../../../core/utils/constants/svg_constants.dart';
import '../controllers/quran/quran_controller.dart';
import '../data/model/surahs_model.dart';

final quranCtrl = QuranController.instance;

extension SurahInfoExtension on Widget {
  Widget surahInfoWidget(int pageIndex, int index, int firstPlace) {
    final ayahs = quranCtrl
        .getCurrentPageAyahsSeparatedForBasmalah(pageIndex + firstPlace)[index];
    Surah surah = quranCtrl.getSurahDataByAyah(ayahs.first);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Dialog(
        insetPadding: const EdgeInsets.all(16.0),
        alignment: Alignment.center,
        child: Container(
          height: 450,
          width: Get.width,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Get.theme.colorScheme.primaryContainer,
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Row(
                      children: [
                        Get.context!.customClose(height: 30),
                        const Gap(8),
                        Get.context!.vDivider(height: 30),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 10,
                    child: Transform.translate(
                      offset: const Offset(0, -5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          surahNameWidget((surah.surahNumber).toString(),
                              Get.theme.hintColor,
                              height: 40),
                          const Gap(8),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                  height: 35,
                                  width: 35,
                                  child: SvgPicture.asset(
                                    SvgPath.svgSoraNum,
                                    colorFilter: ColorFilter.mode(
                                        Get.theme.colorScheme.primary,
                                        BlendMode.srcIn),
                                  )),
                              Transform.translate(
                                offset: const Offset(0, 1),
                                child: Text(
                                  '${'${surah.surahNumber}'.convertNumbers()}',
                                  style: TextStyle(
                                      color: Get.theme.hintColor,
                                      fontFamily: "kufi",
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      height: 2),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(8),
              Container(
                height: 35,
                width: Get.width,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                    color: Get.theme.colorScheme.surface.withOpacity(.1),
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    border: Border.all(
                      width: 1,
                      color: Get.theme.colorScheme.surface.withOpacity(.3),
                    )),
                child: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Center(
                        child: Text(
                          surah.revelationType.tr,
                          style: TextStyle(
                              color: Get.theme.colorScheme.inversePrimary,
                              fontFamily: "kufi",
                              fontSize: 14,
                              height: 2),
                        ),
                      ),
                    ),
                    Get.context!.vDivider(height: 30),
                    Expanded(
                      flex: 4,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Center(
                          child: Text(
                            '${'aya_count'.tr}: ${surah.ayahs.length}'
                                .convertNumbers(),
                            style: TextStyle(
                                color: Get.theme.colorScheme.inversePrimary,
                                fontFamily: "kufi",
                                fontSize: 14,
                                height: 2),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(8),
              Flexible(
                child: DefaultTabController(
                  length: 2,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 35,
                        margin: const EdgeInsets.symmetric(horizontal: 8.0),
                        decoration: BoxDecoration(
                            color:
                                Get.theme.colorScheme.surface.withOpacity(.1),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                            border: Border.all(
                              width: 1,
                              color:
                                  Get.theme.colorScheme.surface.withOpacity(.3),
                            )),
                        child: TabBar(
                          unselectedLabelColor: Colors.grey,
                          indicatorSize: TabBarIndicatorSize.tab,
                          dividerColor: Colors.transparent,
                          indicatorColor: Get.theme.colorScheme.surface,
                          indicatorWeight: 3,
                          labelStyle: TextStyle(
                            color: Get.theme.colorScheme.surface,
                            fontFamily: 'kufi',
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                          unselectedLabelStyle: TextStyle(
                            color: Get.theme.colorScheme.surface,
                            fontFamily: 'kufi',
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                          indicator: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                            color:
                                Get.theme.colorScheme.primary.withOpacity(.1),
                          ),
                          tabs: [
                            Tab(text: 'surahNames'.tr),
                            Tab(text: 'aboutSurah'.tr),
                          ],
                        ),
                      ),
                      Container(
                        height: 290,
                        child: TabBarView(
                          children: <Widget>[
                            SingleChildScrollView(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        children:
                                            surah.surahNames.buildTextSpans(),
                                        style: TextStyle(
                                          color: Get
                                              .theme.colorScheme.inversePrimary,
                                          fontFamily: "naskh",
                                          fontSize: 22,
                                          height: 2,
                                        ),
                                      ),
                                      TextSpan(
                                        children: surah.surahNamesFromBook
                                            .buildTextSpans(),
                                        style: TextStyle(
                                          color: Get
                                              .theme.colorScheme.inversePrimary,
                                          fontFamily: "naskh",
                                          fontSize: 18,
                                          height: 2,
                                        ),
                                      )
                                    ],
                                  ),
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                            ),
                            SingleChildScrollView(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        children:
                                            surah.surahInfo.buildTextSpans(),
                                        style: TextStyle(
                                          color: Get
                                              .theme.colorScheme.inversePrimary,
                                          fontFamily: "naskh",
                                          fontSize: 22,
                                          height: 2,
                                        ),
                                      ),
                                      TextSpan(
                                        children: surah.surahInfoFromBook
                                            .buildTextSpans(),
                                        style: TextStyle(
                                          color: Get
                                              .theme.colorScheme.inversePrimary,
                                          fontFamily: "naskh",
                                          fontSize: 18,
                                          height: 2,
                                        ),
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.justify,
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
            ],
          ),
        ),
      ),
    );
  }
}
