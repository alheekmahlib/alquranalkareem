import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../core/services/services_locator.dart';
import '../../../controllers/general_controller.dart';
import '../../../controllers/surah_audio_controller.dart';

class LastListen extends StatelessWidget {
  const LastListen({super.key});

  @override
  Widget build(BuildContext context) {
    final surahAudioCtrl = sl<SurahAudioController>();
    return Semantics(
      button: true,
      enabled: true,
      label: 'lastListen'.tr,
      child: GestureDetector(
        child: Container(
          width: 280.0,
          height: 80,
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              border: Border.all(
                  color: Get.theme.colorScheme.primary.withOpacity(.2),
                  width: 1)),
          margin: const EdgeInsets.all(16.0),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'lastListen'.tr,
                    style: TextStyle(
                      fontFamily: 'kufi',
                      fontSize: 18,
                      color: Get.theme.colorScheme.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Expanded(
                flex: 7,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: MediaQuery.sizeOf(context).width,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6.0, vertical: 4.0),
                      decoration: BoxDecoration(
                          color: Get.theme.colorScheme.primary,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8))),
                      child: Obx(
                        () => SvgPicture.asset(
                          'assets/svg/surah_name/00${surahAudioCtrl.surahNum}.svg',
                          width: 110,
                          colorFilter: ColorFilter.mode(
                              Get.theme.colorScheme.secondary, BlendMode.srcIn),
                        ),
                      ),
                    ),
                    if (context.mounted)
                      GetX<SurahAudioController>(
                        builder: (surahAudioController) => Text(
                          '${surahAudioCtrl.formatDuration(Duration(seconds: surahAudioCtrl.lastPosition.value))}',
                          style: TextStyle(
                            fontFamily: 'kufi',
                            fontSize: 16,
                            color: Get.theme.hintColor,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          surahAudioCtrl.controller
              .jumpTo((surahAudioCtrl.surahNum.value - 1) * 65.0);
          sl<GeneralController>().widgetPosition.value = 0.0;
          surahAudioCtrl.lastAudioSource();
        },
      ),
    );
  }
}
