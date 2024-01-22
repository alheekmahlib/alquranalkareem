import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../core/services/services_locator.dart';
import '../../../controllers/general_controller.dart';
import '../../../controllers/surah_audio_controller.dart';
import '/core/utils/constants/extensions.dart';

class LastListen extends StatelessWidget {
  const LastListen({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    return Semantics(
      button: true,
      enabled: true,
      label: 'lastListen'.tr,
      child: GestureDetector(
        child: Container(
          width: context.customOrientation(width, 300.0),
          height: 80,
          decoration: BoxDecoration(
            color: Get.theme.colorScheme.surface.withOpacity(.2),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
          margin: context.customOrientation(const EdgeInsets.all(16.0),
              const EdgeInsets.only(bottom: 16.0, left: 32.0)),
          child: Column(
            children: <Widget>[
              Container(
                width: width,
                height: 30,
                decoration: BoxDecoration(
                  color: Get.theme.colorScheme.surface,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'lastListen'.tr,
                      style: TextStyle(
                        fontFamily: 'kufi',
                        fontSize: 14,
                        color: Get.theme.canvasColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Divider(
                      endIndent: 8,
                      indent: 8,
                      height: 8,
                    ),
                    Icon(
                      Icons.record_voice_over_outlined,
                      color: Get.theme.canvasColor,
                      size: 22,
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Obx(
                    () => SvgPicture.asset(
                      'assets/svg/surah_name/00${sl<SurahAudioController>().surahNum}.svg',
                      width: 100,
                      colorFilter: ColorFilter.mode(
                          Get.isDarkMode
                              ? Get.theme.canvasColor
                              : Get.theme.primaryColorDark,
                          BlendMode.srcIn),
                    ),
                  ),
                  if (context.mounted)
                    GetX<SurahAudioController>(
                      builder: (surahAudioController) => Text(
                        '${sl<SurahAudioController>().formatDuration(Duration(seconds: sl<SurahAudioController>().lastPosition.value))}',
                        style: TextStyle(
                          fontFamily: 'kufi',
                          fontSize: 14,
                          color: Get.isDarkMode
                              ? Get.theme.canvasColor
                              : Get.theme.primaryColor,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
        onTap: () {
          sl<SurahAudioController>()
              .controller
              .jumpTo((sl<SurahAudioController>().surahNum.value - 1) * 65.0);
          sl<GeneralController>().widgetPosition.value = 0.0;
          sl<SurahAudioController>().lastAudioSource();
        },
      ),
    );
  }
}
