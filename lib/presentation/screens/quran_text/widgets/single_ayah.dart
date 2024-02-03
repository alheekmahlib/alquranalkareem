import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/services/services_locator.dart';
import '../../../../core/utils/constants/lottie.dart';
import '../../../../core/utils/constants/svg_picture.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../controllers/bookmarksText_controller.dart';
import '../../../controllers/general_controller.dart';
import '../../../controllers/quranText_controller.dart';
import '../../../controllers/settings_controller.dart';
import '../../../controllers/translate_controller.dart';
import '/presentation/screens/quran_text/widgets/text_overflow_detector.dart';
import '/presentation/screens/quran_text/widgets/widgets.dart';

class SingleAyah extends StatelessWidget {
  final surah;
  final int index;
  final int nomPageF;
  final int nomPageL;
  const SingleAyah(
      {super.key,
      required this.surah,
      required this.index,
      required this.nomPageF,
      required this.nomPageL});

  @override
  Widget build(BuildContext context) {
    sl<QuranTextController>().backColor =
        Get.theme.colorScheme.surface.withOpacity(0.4);
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            sl<GeneralController>().textWidgetPosition.value = -240;
            sl<QuranTextController>().backColor = Colors.transparent;
          },
          // child: AutoScrollTag(
          //   key: ValueKey(index),
          //   controller: sl<QuranTextController>().scrollController!,
          //   index: index,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            width: MediaQuery.sizeOf(context).width,
            decoration: BoxDecoration(
                color: Get.theme.colorScheme.background,
                borderRadius: const BorderRadius.all(Radius.circular(4))),
            child: Column(
              children: [
                sl<QuranTextController>().besmAllahWidget(surah, index),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 64.0, right: 16.0, left: 16.0),
                  child: Obx(
                    () => SelectableText.rich(
                      showCursor: true,
                      cursorWidth: 3,
                      cursorColor: Get.theme.dividerColor,
                      cursorRadius: const Radius.circular(5),
                      scrollPhysics: const ClampingScrollPhysics(),
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.justify,
                      TextSpan(children: [
                        TextSpan(
                          text: '${surah!.ayahs![index].text!} ',
                          style: TextStyle(
                            fontSize:
                                sl<GeneralController>().fontSizeArabic.value,
                            fontWeight: FontWeight.normal,
                            fontFamily: 'uthmanic2',
                            color: Get.isDarkMode ? Colors.white : Colors.black,
                            // background: Paint()
                            //   ..color =
                            //       index == sl<AudioController>().ayahSelected.value
                            //           ? sl<QuranTextController>().selected.value
                            //               ? backColor
                            //               : Colors.transparent
                            //           : Colors.transparent
                            //   ..strokeJoin = StrokeJoin.round
                            //   ..strokeCap = StrokeCap.round
                            //   ..style = PaintingStyle.fill,
                          ),
                        ),
                        TextSpan(
                          text:
                              ' ${arabicNumber.convert(surah!.ayahs![index].numberInSurah)}',
                          style: TextStyle(
                            fontSize:
                                sl<GeneralController>().fontSizeArabic.value,
                            fontWeight: sl<BookmarksTextController>()
                                    .hasBookmark(surah!.number!,
                                        surah!.ayahs![index].numberInSurah!)
                                    .value
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontFamily: 'uthmanic2',
                            color: sl<BookmarksTextController>()
                                    .hasBookmark(surah!.number!,
                                        surah!.ayahs![index].numberInSurah!)
                                    .value
                                ? const Color(0xfffcbb76)
                                : Colors.black,
                            // background: Paint()
                            //   ..color =
                            //       index == sl<AudioController>().ayahSelected.value
                            //           ? sl<QuranTextController>().selected.value
                            //               ? backColor
                            //               : Colors.transparent
                            //           : Colors.transparent
                            //   ..strokeJoin = StrokeJoin.round
                            //   ..strokeCap = StrokeCap.round
                            //   ..style = PaintingStyle.fill,
                          ),
                        ),
                      ]),
                      // contextMenuBuilder: buildMyContextMenuText(),
                      // onSelectionChanged: handleSelectionChanged,
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Semantics(
                        button: true,
                        enabled: true,
                        label: 'Change The Translate',
                        child: Icon(
                          Icons.translate_rounded,
                          color: Get.theme.colorScheme.surface,
                          size: 24,
                        ),
                      ),
                      onPressed: () => translateDropDown(context),
                    ),
                    Expanded(
                        flex: 6,
                        child: spaceLine(
                          15,
                          MediaQuery.sizeOf(context).width,
                        )),
                    juzNumEn(
                      'Part\n${surah!.ayahs![index].juz}',
                      context,
                      Get.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      right: 16.0, left: 16.0, bottom: 16.0),
                  child: Obx(
                    () {
                      if (sl<TranslateDataController>().isLoading.value) {
                        return search(50.0, 50.0);
                      }
                      return ReadMoreLess(
                        text: (surah!.ayahs!.length > index &&
                                sl<TranslateDataController>().data.length >
                                    surah!.ayahs![index].number - 1)
                            ? sl<TranslateDataController>()
                                        .data[surah!.ayahs![index].number - 1]
                                    ['text'] ??
                                ''
                            : '',
                        textStyle: TextStyle(
                          fontSize:
                              sl<GeneralController>().fontSizeArabic.value - 10,
                          fontFamily:
                              sl<SettingsController>().languageFont.value,
                          color: Get.isDarkMode ? Colors.white : Colors.black,
                        ),
                        textAlign: TextAlign.center,
                        readMoreText: 'readMore'.tr,
                        readLessText: 'readLess'.tr,
                        buttonTextStyle: TextStyle(
                          fontSize: 12,
                          fontFamily: 'kufi',
                          color: Get.isDarkMode
                              ? Colors.white
                              : Get.theme.primaryColorLight,
                        ),
                        iconColor: Get.isDarkMode
                            ? Colors.white
                            : Get.theme.primaryColorLight,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Get.theme.colorScheme.background,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  juzNum('${surah!.ayahs![index].juz}', context,
                      Get.isDarkMode ? Colors.white : Colors.black, 25),
                  singleAyahMenu(
                      context,
                      index,
                      index,
                      // details,
                      sl<TranslateDataController>().data,
                      surah,
                      nomPageF,
                      nomPageL),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
