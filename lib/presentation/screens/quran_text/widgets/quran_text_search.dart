import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../core/services/services_locator.dart';
import '../../../../core/utils/constants/lottie.dart';
import '../../../../core/widgets/top_bar.dart';
import '../../../controllers/aya_controller.dart';
import '../../../controllers/quranText_controller.dart';
import '../../../controllers/surahTextController.dart';
import '../../quran_page/data/model/aya.dart';
import '../screens/text_page_view.dart';
import '/core/widgets/widgets.dart';

class QuranTextSearch extends StatelessWidget {
  QuranTextSearch({super.key});
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const TopBarWidget(),
        Container(
          height: 60,
          padding:
              const EdgeInsets.only(top: 8, right: 30, left: 30, bottom: 8),
          child: TextField(
            textAlign: TextAlign.start,
            controller: _controller,
            autofocus: true,
            cursorHeight: 18,
            cursorWidth: 3,
            cursorColor: Get.theme.dividerColor,
            textInputAction: TextInputAction.search,
            onSubmitted: (value) {
              sl<AyaController>().search(value);
            },
            onChanged: (value) {
              sl<AyaController>().search(value);
            },
            onTapOutside: (event) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            style: TextStyle(
                color: Get.theme.colorScheme.surface,
                fontFamily: 'kufi',
                fontSize: 15),
            decoration: InputDecoration(
              icon: IconButton(
                onPressed: () => _controller.clear(),
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
              if (sl<AyaController>().isLoading.value) {
                return search(200.0, 200.0);
              } else if (sl<AyaController>().ayahList.isNotEmpty) {
                return Directionality(
                  textDirection: TextDirection.rtl,
                  child: Container(
                      child: ListView.builder(
                          itemCount: sl<AyaController>().ayahList.length,
                          itemBuilder: (_, index) {
                            final List<Aya> ayahList =
                                sl<AyaController>().ayahList;
                            final aya = ayahList[index];
                            return Column(
                              children: <Widget>[
                                Container(
                                  color: (index % 2 == 0
                                      ? Get.theme.colorScheme.surface
                                          .withOpacity(.05)
                                      : Get.theme.colorScheme.surface
                                          .withOpacity(.1)),
                                  child: ListTile(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      Navigator.of(context)
                                          .push(animatRoute(TextPageView(
                                        surah: sl<SurahTextController>()
                                            .surahs[aya.surahNum - 1],
                                        nomPageF: sl<SurahTextController>()
                                            .surahs[aya.surahNum - 1]
                                            .ayahs!
                                            .first
                                            .page!,
                                        nomPageL: sl<SurahTextController>()
                                            .surahs[aya.surahNum - 1]
                                            .ayahs!
                                            .last
                                            .page!,
                                        pageNum:
                                            sl<QuranTextController>().value == 1
                                                ? (sl<SurahTextController>()
                                                        .surahs[
                                                            aya.surahNum - 1]
                                                        .ayahs![aya.ayaNum - 1]
                                                        .numberInSurah! -
                                                    2)
                                                : sl<SurahTextController>()
                                                    .surahs[aya.surahNum - 1]
                                                    .ayahs![aya.ayaNum - 1]
                                                    .pageInSurah!,
                                      )));
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
                                                    topRight:
                                                        Radius.circular(4),
                                                    bottomRight:
                                                        Radius.circular(4),
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
                                                color:
                                                    Get.theme.primaryColorLight,
                                                child: Text(
                                                  " ${'part'.tr}: ${aya.partNum}",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Get.isDarkMode
                                                          ? Get
                                                              .theme.canvasColor
                                                          : Get
                                                              .theme
                                                              .colorScheme
                                                              .background,
                                                      fontSize: 12),
                                                )),
                                          ),
                                          Expanded(
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    color:
                                                        Get.theme.primaryColor,
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(4),
                                                      bottomLeft:
                                                          Radius.circular(4),
                                                    )),
                                                child: Text(
                                                  " ${'page'.tr}: ${aya.pageNum}",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Get.isDarkMode
                                                          ? Get
                                                              .theme.canvasColor
                                                          : Get
                                                              .theme
                                                              .colorScheme
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
                            );
                          })),
                );
              } else if (sl<AyaController>().errorMessage.value.isNotEmpty) {
                return notFound();
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }
}

Widget ayaNum(context, Color color, String num) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 5),
    child: Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
            height: 35,
            width: 35,
            child: SvgPicture.asset('assets/svg/ayah_no.svg')),
        Text(
          num,
          style:
              TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    ),
  );
}
