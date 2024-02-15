import 'package:alquranalkareem/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/services/services_locator.dart';
import '../../../../../core/utils/constants/lottie.dart';
import '../../../../controllers/aya_controller.dart';
import '../../../../controllers/general_controller.dart';
import '../../data/model/aya.dart';
import '/core/utils/constants/extensions.dart';
import '/presentation/controllers/quran_controller.dart';
import 'search_bar_widget.dart';

class QuranSearch extends StatelessWidget {
  QuranSearch({super.key});
  final generalCtrl = sl<GeneralController>();
  final quranCtrl = sl<QuranController>();
  final ayahCtrl = sl<AyaController>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height,
      width: MediaQuery.sizeOf(context).width,
      child: SafeArea(
        child: Column(
          children: <Widget>[
            context.customClose(),
            SearchBarWidget(),
            Obx(
              () {
                if (ayahCtrl.surahList.isEmpty) {
                  return const SizedBox.shrink();
                } else if (ayahCtrl.surahList.isNotEmpty) {
                  return Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ListView.builder(
                        itemCount: ayahCtrl.surahList.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          Aya search = ayahCtrl.surahList[index];
                          return Directionality(
                            textDirection: TextDirection.rtl,
                            child: GestureDetector(
                              onTap: () {
                                generalCtrl.quranPageController.animateToPage(
                                  search.pageNum - 1,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeIn,
                                );
                                Get.back();
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 4.0, vertical: 10.0),
                                decoration: BoxDecoration(
                                    color: Get.theme.colorScheme.primary,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8))),
                                child: surahNameWidget(
                                    search.surahNum.toString(),
                                    Get.theme.canvasColor,
                                    height: 40),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                } else {
                  return notFound();
                }
              },
            ),
            Flexible(
              flex: 9,
              child: Obx(
                () {
                  if (ayahCtrl.ayahList.isEmpty) {
                    return search(200.0, 200.0);
                  } else if (ayahCtrl.ayahList.isNotEmpty) {
                    return ListView.builder(
                      controller: ayahCtrl.scrollController,
                      itemCount: ayahCtrl.ayahList.length,
                      itemBuilder: (context, index) {
                        Aya search = ayahCtrl.ayahList[index];
                        List<TextSpan> highlightedTextSpans =
                            ayahCtrl.highlightLine(search.SearchText);
                        return Directionality(
                          textDirection: TextDirection.rtl,
                          child: Container(
                              child: Column(
                            children: <Widget>[
                              Container(
                                color: (index % 2 == 0
                                    ? Get.theme.colorScheme.surface
                                        .withOpacity(.05)
                                    : Get.theme.colorScheme.surface
                                        .withOpacity(.1)),
                                child: ListTile(
                                  onTap: () {
                                    generalCtrl.quranPageController
                                        .animateToPage(
                                      search.pageNum - 1,
                                      // 19,
                                      duration:
                                          const Duration(milliseconds: 500),
                                      curve: Curves.easeIn,
                                    );
                                    Get.back();
                                  },
                                  title: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: RichText(
                                      text: TextSpan(
                                        children: highlightedTextSpans,
                                        style: TextStyle(
                                          fontFamily: "uthmanic2",
                                          fontWeight: FontWeight.normal,
                                          fontSize: 22,
                                          color: Get.theme.hintColor,
                                        ),
                                      ),
                                      textAlign: TextAlign.justify,
                                    ),
                                  ),
                                  subtitle: Container(
                                    height: 20,
                                    decoration: BoxDecoration(
                                        color: Get.theme.primaryColorLight,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(4))),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Expanded(
                                          child: Container(
                                              decoration: BoxDecoration(
                                                  color: Get
                                                      .theme.colorScheme.primary
                                                      .withOpacity(.7),
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(4),
                                                    bottomRight:
                                                        Radius.circular(4),
                                                  )),
                                              child: Text(
                                                " ${'part'.tr}: ${search.partNum}",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Get.theme.hintColor,
                                                    fontSize: 12),
                                              )),
                                        ),
                                        Expanded(
                                          child: Container(
                                              decoration: BoxDecoration(
                                                  color: Get.theme.primaryColor,
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    topLeft: Radius.circular(4),
                                                    bottomLeft:
                                                        Radius.circular(4),
                                                  )),
                                              child: Text(
                                                " ${'page'.tr}: ${search.pageNum}",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Get.theme.hintColor,
                                                    fontSize: 12),
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                  leading: surahNameWidget(
                                      search.surahNum.toString(),
                                      Get.theme.hintColor),
                                ),
                              ),
                              const Divider()
                            ],
                          )),
                        );
                      },
                    );
                  } else {
                    return notFound();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
