import 'package:alquranalkareem/core/utils/constants/extensions.dart';
import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/services/services_locator.dart';
import '../../../controllers/surah_audio_controller.dart';

class SurahSearch extends StatelessWidget {
  const SurahSearch({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Semantics(
        button: true,
        enabled: true,
        label: 'searchToSurah'.tr,
        child: SizedBox(
          height: 40,
          child: AnimSearchBar(
            width: context.customOrientation(width * .75, 300.0),
            textController: sl<SurahAudioController>().textController,
            rtl: true,
            textFieldColor: Get.isDarkMode
                ? Get.theme.colorScheme.secondary
                : Get.theme.colorScheme.primary,
            helpText: 'searchToSurah'.tr,
            textFieldIconColor: Get.theme.colorScheme.secondary,
            searchIconColor: Get.theme.colorScheme.secondary,
            style: TextStyle(
                color: Get.theme.colorScheme.secondary,
                fontFamily: 'kufi',
                fontSize: 15),
            onSubmitted: (String value) {
              sl<SurahAudioController>().searchSurah(context, value);
            },
            autoFocus: false,
            color: Get.isDarkMode
                ? Get.theme.colorScheme.secondary
                : Get.theme.colorScheme.primary,
            onSuffixTap: () {
              sl<SurahAudioController>().textController.clear();
            },
          ),
        ),
      ),
    );
  }
}
