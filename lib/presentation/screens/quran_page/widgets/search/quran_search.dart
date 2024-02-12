import 'package:alquranalkareem/presentation/controllers/quran_controller.dart';
import 'package:alquranalkareem/presentation/screens/quran_page/data/model/surahs_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/services/services_locator.dart';
import '../../../../../core/utils/constants/lottie.dart';
import '../../../../controllers/general_controller.dart';
import '../../../../controllers/search_controller.dart';
import '/core/utils/constants/extensions.dart';
import 'search_bar_widget.dart';

class QuranSearch extends StatelessWidget {
  QuranSearch({super.key});
  final generalCtrl = sl<GeneralController>();
  final searchCtrl = sl<QuranSearchController>();
  final quranCtrl = sl<QuranController>();

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
            Expanded(
              child: Obx(
                () {
                  if (searchCtrl.searchResults.isEmpty) {
                    return search(200.0, 200.0);
                  } else if (searchCtrl.searchResults.isNotEmpty) {
                    return ListView.builder(
                      controller: searchCtrl.scrollController,
                      itemCount: searchCtrl.searchResults.length,
                      itemBuilder: (context, index) {
                        Ayah search = searchCtrl.searchResults[index];
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
                                      search.page - 1,
                                      // 19,
                                      duration:
                                          const Duration(milliseconds: 500),
                                      curve: Curves.easeIn,
                                    );
                                    Get.back();
                                  },
                                  title: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      search.text,
                                      style: TextStyle(
                                        fontFamily: "uthmanic2",
                                        fontWeight: FontWeight.normal,
                                        fontSize: 22,
                                        color: Get.isDarkMode
                                            ? Get.theme.canvasColor
                                            : Get.theme.primaryColorDark,
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
                                                color: Get.theme.primaryColor,
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  topRight: Radius.circular(4),
                                                  bottomRight:
                                                      Radius.circular(4),
                                                )),
                                            // TODO:
                                            child: Text(
                                              quranCtrl.getSurahNameFromPage(
                                                  search.page - 1),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Get.isDarkMode
                                                      ? Get.theme.canvasColor
                                                      : Get.theme.colorScheme
                                                          .background,
                                                  fontSize: 12),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                              color:
                                                  Get.theme.primaryColorLight,
                                              child: Text(
                                                " ${'part'.tr}: ${search.juz}",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Get.isDarkMode
                                                        ? Get.theme.canvasColor
                                                        : Get.theme.colorScheme
                                                            .background,
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
                                                " ${'page'.tr}: ${search.page}",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Get.isDarkMode
                                                        ? Get.theme.canvasColor
                                                        : Get.theme.colorScheme
                                                            .background,
                                                    fontSize: 12),
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
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
