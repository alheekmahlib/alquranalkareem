import 'package:alquranalkareem/core/utils/constants/extensions.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/services/services_locator.dart';
import '../../../../core/utils/constants/size_config.dart';
import '../../../controllers/general_controller.dart';
import '../../../controllers/quran_controller.dart';
import '../data/model/surahs_model.dart';

class PagesWidget extends StatelessWidget {
  final int index;
  const PagesWidget({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final quranCtrl = sl<QuranController>();
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
          child: Column(
            children: [
              // Obx(() => quranCtrl.besmAllahWidget(
              //     quranCtrl.surahs[index + 1], index + 1)),
              Obx(() {
                if (quranCtrl.surahs.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                List<Ayah> ayahs = quranCtrl.getAyahsForCurrentPage(index + 1);
                // todo: Helal fix me please
                List<InlineSpan> spans = ayahs.asMap().entries.map((entry) {
                  int idx = entry.key;
                  Ayah ayah = entry.value;
                  String text = ayah.code_v2;

                  quranCtrl.isSelected =
                      quranCtrl.selectedAyahIndexes.contains(idx);

                  if (text.isNotEmpty) {
                    String mainText = text.substring(0, text.length - 1);
                    String lastLetter = text.substring(text.length - 1);

                    return TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: mainText,
                          recognizer: LongPressGestureRecognizer()
                            ..onLongPress = () {
                              quranCtrl.toggleAyahSelection(idx);
                            },
                          style: TextStyle(
                            backgroundColor: quranCtrl.isSelected!
                                ? Get.theme.colorScheme.primary.withOpacity(.25)
                                : Colors.transparent,
                          ),
                        ),
                        TextSpan(
                          text: lastLetter,
                          style: TextStyle(
                            color: Get.theme.colorScheme.primary,
                            backgroundColor: quranCtrl.isSelected!
                                ? Get.theme.colorScheme.primary.withOpacity(.25)
                                : Colors.transparent,
                          ),
                        ),
                      ],
                    );
                  } else {
                    return const TextSpan(text: "");
                  }
                }).toList();

                return Column(
                  children: [
                    quranCtrl.besmAllahWidget(index + 1),
                    RichText(
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
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
