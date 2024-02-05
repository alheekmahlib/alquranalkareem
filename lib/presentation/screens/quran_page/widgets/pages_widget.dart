import 'package:alquranalkareem/core/utils/constants/extensions.dart';
import 'package:alquranalkareem/core/utils/constants/extensions/menu_extension.dart';
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
    SizeConfig().init(context);
    return GetBuilder<QuranController>(builder: (quranCtrl) {
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
            padding:
                const EdgeInsets.symmetric(vertical: 30.0, horizontal: 16.0),
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
                        Obx(() {
                          return RichText(
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
                              children:
                                  List.generate(ayahs.length, (ayahIndex) {
                                quranCtrl.isSelected = quranCtrl
                                    .selectedAyahIndexes
                                    .contains(ayahIndex);
                                if (ayahIndex == 0) {
                                  return span(
                                      text:
                                          "${ayahs[ayahIndex].code_v2[0]} ${ayahs[ayahIndex].code_v2.substring(1)}",
                                      pageIndex: pageIndex,
                                      isSelected: quranCtrl.isSelected,
                                      fontSize: getProportionateScreenWidth(
                                          context.customOrientation(
                                              19.0, 18.0)),
                                      onLongPressStart:
                                          (LongPressStartDetails details) {
                                        quranCtrl
                                            .toggleAyahSelection(ayahIndex);
                                        context.showAyahMenu(
                                            quranCtrl.getSurahNumberFromPage(
                                                pageIndex),
                                            ayahs[ayahIndex].ayahNumber,
                                            ayahs[ayahIndex].code_v2,
                                            pageIndex,
                                            ayahs[ayahIndex].text,
                                            details: details);
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
                                      context.showAyahMenu(
                                          quranCtrl.getSurahNumberFromPage(
                                              pageIndex),
                                          ayahs[ayahIndex].ayahNumber,
                                          ayahs[ayahIndex].code_v2,
                                          pageIndex,
                                          ayahs[ayahIndex].text,
                                          details: details);
                                    });
                              }),
                            ),
                          );
                        }),
                      ]);
                    }),
                  ),
          ),
        ),
      );
    });
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
