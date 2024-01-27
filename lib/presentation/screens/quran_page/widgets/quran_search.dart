import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/services/services_locator.dart';
import '../../../../core/utils/constants/lottie.dart';
import '../../../controllers/aya_controller.dart';
import '../../../controllers/general_controller.dart';
import '../data/model/aya.dart';

class QuranSearch extends StatelessWidget {
  const QuranSearch({super.key});

  @override
  Widget build(BuildContext context) {
    final ayahCtrl = sl<AyaController>();
    final general = sl<GeneralController>();
    return SizedBox(
      height: MediaQuery.sizeOf(context).height,
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        children: <Widget>[
          Container(
            height: 60,
            padding:
                const EdgeInsets.only(top: 8, right: 30, left: 30, bottom: 8),
            child: TextField(
              textAlign: TextAlign.start,
              controller: general.searchTextEditing,
              autofocus: true,
              cursorHeight: 18,
              cursorWidth: 3,
              cursorColor: Get.theme.dividerColor,
              textInputAction: TextInputAction.search,
              onSubmitted: (value) {
                ayahCtrl.search(value);
              },
              onChanged: (value) {
                ayahCtrl.search(value);
              },
              onTapOutside: (event) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              onTap: sl<GeneralController>().panelController.anchor,
              style: TextStyle(
                  color: Get.theme.colorScheme.surface,
                  fontFamily: 'kufi',
                  fontSize: 15),
              decoration: InputDecoration(
                icon: IconButton(
                  onPressed: () => general.searchTextEditing.clear(),
                  icon: Icon(
                    Icons.clear,
                    color: Get.theme.colorScheme.surface,
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Get.theme.colorScheme.surface),
                ),
                hintText: 'search_word'.tr,
                label: Text(
                  'search_word'.tr,
                  style: TextStyle(color: Get.theme.colorScheme.surface),
                ),
                hintStyle: TextStyle(
                    // height: 1.5,
                    color: Get.theme.primaryColorLight.withOpacity(0.5),
                    fontFamily: 'kufi',
                    fontWeight: FontWeight.normal,
                    decorationColor: Get.theme.primaryColor,
                    fontSize: 14),
                contentPadding: const EdgeInsets.only(right: 16, left: 16),
              ),
            ),
          ),
          Expanded(
            child: Obx(
              () {
                if (ayahCtrl.ayahList.isEmpty) {
                  return search(200.0, 200.0);
                } else if (ayahCtrl.errorMessage.value.isNotEmpty) {
                  return ListView.builder(
                    controller: ayahCtrl.scrollController,
                    itemCount: ayahCtrl.ayahList.length,
                    itemBuilder: (context, index) {
                      final List<Aya> ayahList = ayahCtrl.ayahList;
                      final aya = ayahList[index];
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
                                  sl<GeneralController>()
                                      .quranPageController
                                      .animateToPage(
                                        aya.pageNum - 1,
                                        // 19,
                                        duration:
                                            const Duration(milliseconds: 500),
                                        curve: Curves.easeIn,
                                      );
                                  sl<GeneralController>().slideClose();
                                },
                                title: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    aya.text,
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
                                                bottomRight: Radius.circular(4),
                                              )),
                                          child: Text(
                                            aya.sorahName,
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
                                            color: Get.theme.primaryColorLight,
                                            child: Text(
                                              " ${'part'.tr}: ${aya.partNum}",
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
                                              " ${'page'.tr}: ${aya.pageNum}",
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
    );
  }
}
