import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/services/services_locator.dart';
import '../../../../core/utils/constants/shared_pref_services.dart';
import '../../../../core/utils/constants/shared_preferences_constants.dart';
import '../../../controllers/audio_controller.dart';
import '../../../controllers/general_controller.dart';
import '../../../controllers/quranText_controller.dart';

ArabicNumbers arabicNumber = ArabicNumbers();

Widget animatedToggleSwitch(BuildContext context) {
  return GetX<QuranTextController>(
    builder: (controller) {
      return AnimatedToggleSwitch<int>.rolling(
        current: controller.value.value,
        values: const [0, 1],
        onChanged: (i) async {
          controller.value.value = i;
          await sl<SharedPrefServices>().saveInteger(SWITCH_VALUE, i);
          sl<AudioController>().cancelDownload();
          sl<GeneralController>().textWidgetPosition.value = -240.0;
          controller.selected.value = false;
          controller.update();
        },
        iconBuilder: rollingIconBuilder,
        borderWidth: 1,
        style: ToggleStyle(
          indicatorColor: Get.theme.colorScheme.surface,
          backgroundColor: Get.theme.canvasColor,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          // dif: 2.0,
          borderColor: Get.theme.colorScheme.surface,
        ),
        height: 25,
      );
    },
  );
}

Widget rollingIconBuilder(int value, bool foreground) {
  IconData data = Icons.textsms_outlined;
  if (value.isEven) data = Icons.text_snippet_outlined;
  return Semantics(
    button: true,
    enabled: true,
    label:
        'Changing from presenting the Qur’an in the form of pages and in the form of verses',
    child: Icon(
      data,
      size: 20,
      color: const Color(0xff161f07),
    ),
  );
}

Widget greeting(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(top: 8.0),
    child: Text(
      '| ${sl<GeneralController>().greeting.value} |',
      style: TextStyle(
        fontSize: 16.0,
        fontFamily: 'kufi',
        color: Get.theme.colorScheme.primary,
      ),
      textAlign: TextAlign.center,
    ),
  );
}

Widget buttonContainer(BuildContext context, Widget myWidget) {
  return Container(
      height: 50,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Get.theme.dividerColor.withOpacity(.2),
          borderRadius: const BorderRadius.all(Radius.circular(8))),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
            color: Get.theme.dividerColor.withOpacity(.4),
            borderRadius: const BorderRadius.all(Radius.circular(8))),
        child: myWidget,
      ));
}
