import 'package:alquranalkareem/core/utils/constants/extensions.dart';
import 'package:alquranalkareem/core/utils/constants/svg_picture.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/services/services_locator.dart';
import '../../../../core/utils/constants/size_config.dart';
import '../../../controllers/general_controller.dart';
import '../../../controllers/quran_controller.dart';

class PagesWidget extends StatelessWidget {
  final int pageIndex;
  const PagesWidget({super.key, required this.pageIndex});

  @override
  Widget build(BuildContext context) {
    final quranCtrl = sl<QuranController>();
    // debugPrint(
    //     'Length=======================> ${quranCtrl.getCurrentPageAyahs(pageIndex).length}');
    // debugPrint(
    //     'Length=======================> ${quranCtrl.getCurrentPageAyahsSeparatedForBasmala(pageIndex).length}');
    SizeConfig().init(context);
    return SingleChildScrollView(
      child: InkWell(
        onTap: () {
          if (sl<GeneralController>().opened.value == true) {
            sl<GeneralController>().opened.value = false;
            sl<GeneralController>().update();
          } else {
            sl<GeneralController>().showControl();
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 16.0),
          child: quranCtrl.pages.isEmpty
              ? const CircularProgressIndicator.adaptive()
              : Column(
                  children: List.generate(
                      quranCtrl
                          .getCurrentPageAyahsSeparatedForBasmala(pageIndex)
                          .length, (i) {
                    final ayahs = quranCtrl
                        .getCurrentPageAyahsSeparatedForBasmala(pageIndex)[i];
                    return Column(children: [
                      if (ayahs.first.ayahNumber == 1) besmAllah(),
                      RichText(
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(
                            fontFamily: 'page${pageIndex + 1}',
                            fontSize: getProportionateScreenWidth(
                                context.customOrientation(19.0, 18.0)),
                            height: 1.9,
                            letterSpacing: 1.5,
                            color: Get.theme.colorScheme.inversePrimary,
                          ),
                          children: List.generate(ayahs.length, (ayahIndex) {
                            quranCtrl.isSelected = quranCtrl.selectedAyahIndexes
                                .contains(ayahIndex);
                            if (ayahIndex == 0) {
                              return span(
                                  text:
                                      "${ayahs[ayahIndex].code_v2[0]} ${ayahs[ayahIndex].code_v2.substring(1)}",
                                  pageIndex: pageIndex,
                                  isSelected: quranCtrl.isSelected,
                                  fontSize: getProportionateScreenWidth(
                                      context.customOrientation(19.0, 18.0)),
                                  onLongPressStart:
                                      (LongPressStartDetails details) {
                                    quranCtrl.toggleAyahSelection(ayahIndex);
                                    quranCtrl.menu(details: details);
                                  });
                            }
                            return span(
                                text: ayahs[ayahIndex].code_v2,
                                pageIndex: pageIndex,
                                isSelected: quranCtrl.isSelected,
                                fontSize: getProportionateScreenWidth(
                                    context.customOrientation(19.0, 18.0)),
                                onLongPressStart:
                                    (LongPressStartDetails details) {
                                  quranCtrl.toggleAyahSelection(ayahIndex);
                                  quranCtrl.menu(details: details);
                                });
                          }),
                        ),
                      ),
                    ]);
                  }),
                  // Obx(() {
                  //   if (quranCtrl.surahs.isEmpty) {
                  //     return const Center(child: CircularProgressIndicator());
                  //   }
                  // List<Ayah> ayahs = quranCtrl.pages[index];

                  // List<InlineSpan> spans = ayahs.asMap().entries.map((entry) {
                  //   int idx = entry.key;
                  //   Ayah ayah = entry.value;
                  //   String text = ayah.code_v2;

                  //   quranCtrl.isSelected =
                  //       quranCtrl.selectedAyahIndexes.contains(idx);

                  //   if (text.isNotEmpty) {
                  //     String mainText = text.substring(0, text.length - 1);
                  //     String lastLetter = text.substring(text.length - 1);

                  //     return TextSpan(
                  //       children: <TextSpan>[
                  //         TextSpan(
                  //           text: mainText,
                  //           recognizer: LongPressGestureRecognizer()
                  //             ..onLongPress = () {
                  //               quranCtrl.toggleAyahSelection(idx);
                  //             },
                  //           style: TextStyle(
                  //             backgroundColor: quranCtrl.isSelected
                  //                 ? Get.theme.colorScheme.primary.withOpacity(.25)
                  //                 : Colors.transparent,
                  //           ),
                  //         ),
                  //         TextSpan(
                  //           text: lastLetter,
                  //           style: TextStyle(
                  //             color: Get.theme.colorScheme.primary,
                  //             backgroundColor: quranCtrl.isSelected
                  //                 ? Get.theme.colorScheme.primary.withOpacity(.25)
                  //                 : Colors.transparent,
                  //           ),
                  //         ),
                  //       ],
                  //     );
                  //   } else {
                  //     return const TextSpan(text: "");
                  //   }
                  // }).toList();

                  /*return RichText(
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                  text: TextSpan(
                    style: TextStyle(
                      fontFamily: 'page${index + 1}',
                      fontSize: getProportionateScreenWidth(
                          context.customOrientation(19.0, 18.0)),
                      height: 1.9,
                      letterSpacing: 2,
                      color: Get.theme.colorScheme.inversePrimary,
                    ),
                    children: spans,
                  ),
                );*/
                  // }),
                ),
        ),
      ),
    );
  }
}

TextSpan span(
        {required String text,
        required int pageIndex,
        required bool isSelected,
        required double fontSize,
        required LongPressStartDetailsFunction onLongPressStart}) =>
    TextSpan(
      text: text,
      style: TextStyle(
        fontFamily: 'page${pageIndex + 1}',
        fontSize: fontSize,
        height: 1.9,
        letterSpacing: 1.5,
        color: Get.theme.colorScheme.inversePrimary,
        backgroundColor: isSelected
            ? Get.theme.colorScheme.primary.withOpacity(.25)
            : Colors.transparent,
      ),
      recognizer: LongPressGestureRecognizer(
          duration: const Duration(milliseconds: 500))
        ..onLongPressStart = onLongPressStart,
    );

typedef LongPressStartDetailsFunction = void Function(LongPressStartDetails)?;
