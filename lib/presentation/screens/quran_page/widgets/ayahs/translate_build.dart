import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../../core/services/services_locator.dart';
import '../../../../../core/utils/constants/lottie.dart';
import '../../../../controllers/general_controller.dart';
import '../../../../controllers/settings_controller.dart';
import '../../../../controllers/translate_controller.dart';
import '../text_overflow_detector.dart';
import 'change_translate.dart';

class TranslateBuild extends StatelessWidget {
  final dynamic ayahs;
  final int ayahIndex;
  TranslateBuild({super.key, required this.ayahs, required this.ayahIndex});

  final translateCtrl = sl<TranslateDataController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: ChangeTranslate(),
          ),
          const Gap(16),
          Obx(
            () {
              if (translateCtrl.isLoading.value) {
                return search(50.0, 50.0);
              }
              return ReadMoreLess(
                text: translateCtrl.data[ayahs[ayahIndex].ayahUQNumber - 1]
                        ['text'] ??
                    '',
                textStyle: TextStyle(
                  fontSize: sl<GeneralController>().fontSizeArabic.value - 3,
                  fontFamily: sl<SettingsController>().languageFont.value,
                  color: Theme.of(context).hintColor,
                ),
                // textAlign: TextAlign.justify,
                readMoreText: 'readMore'.tr,
                readLessText: 'readLess'.tr,
                buttonTextStyle: TextStyle(
                  fontSize: 12,
                  fontFamily: 'kufi',
                  color: Theme.of(context).hintColor,
                ),
                iconColor: Theme.of(context).hintColor,
              );
            },
          ),
        ],
      ),
    );
  }
}
