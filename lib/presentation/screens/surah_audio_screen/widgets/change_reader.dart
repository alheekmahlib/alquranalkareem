import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/services/services_locator.dart';
import '../../../../core/utils/constants/lists.dart';
import '../../../../core/utils/constants/shared_pref_services.dart';
import '../../../../core/utils/constants/shared_preferences_constants.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../controllers/surah_audio_controller.dart';

class ChangeSurahReader extends StatelessWidget {
  const ChangeSurahReader({super.key});

  @override
  Widget build(BuildContext context) {
    final surahAudioCtrl = sl<SurahAudioController>();
    return GestureDetector(
      onTap: () => surahReaderDropDown(context),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(() {
            return Text(
              surahReaderInfo[surahAudioCtrl.surahReaderIndex.value]['name'],
              style: TextStyle(
                  color: Get.theme.colorScheme.primary,
                  fontSize: 14,
                  fontFamily: 'kufi'),
            );
          }),
          Semantics(
            button: true,
            enabled: true,
            label: 'Change Reader',
            child: Icon(Icons.keyboard_arrow_down_outlined,
                size: 20, color: Get.theme.colorScheme.primary),
          ),
        ],
      ),
    );
  }

  surahReaderDropDown(BuildContext context) {
    final surahAudioCtrl = sl<SurahAudioController>();
    dropDownModalBottomSheet(
      context,
      MediaQuery.sizeOf(context).height / 1 / 2,
      MediaQuery.sizeOf(context).width,
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  height: 30,
                  width: 30,
                  margin: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                      color: Get.theme.colorScheme.background,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(8),
                      ),
                      border: Border.all(
                          width: 2, color: Get.theme.colorScheme.primary)),
                  child: Icon(
                    Icons.close_outlined,
                    color: Get.theme.colorScheme.primary,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: Text(
                  'select_player'.tr,
                  style: TextStyle(
                      color: Get.theme.colorScheme.primary,
                      fontSize: 22,
                      fontFamily: "kufi"),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 70.0),
              child: ListView.builder(
                itemCount: surahReaderInfo.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      Container(
                        child: Obx(
                          () => ListTile(
                            title: Text(
                              surahReaderInfo[index]['name'],
                              style: TextStyle(
                                  color: surahAudioCtrl.sorahReaderNameValue ==
                                          surahReaderInfo[index]['readerN']
                                      ? Get.theme.primaryColorLight
                                      : const Color(0xffcdba72),
                                  fontSize: 14,
                                  fontFamily: 'kufi'),
                            ),
                            trailing: Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(2.0)),
                                border: Border.all(
                                    color: surahAudioCtrl
                                                .sorahReaderNameValue ==
                                            surahReaderInfo[index]['readerN']
                                        ? Get.theme.primaryColorLight
                                        : const Color(0xffcdba72),
                                    width: 2),
                                color: const Color(0xff39412a),
                              ),
                              child: surahAudioCtrl.sorahReaderNameValue ==
                                      surahReaderInfo[index]['readerN']
                                  ? const Icon(Icons.done,
                                      size: 14, color: Color(0xfffcbb76))
                                  : null,
                            ),
                            onTap: () async {
                              surahAudioCtrl.sorahReaderValue.value =
                                  surahReaderInfo[index]['readerD'];
                              surahAudioCtrl.sorahReaderNameValue.value =
                                  surahReaderInfo[index]['readerN'];

                              await sl<SharedPrefServices>().saveString(
                                  SURAH_AUDIO_PLAYER_SOUND,
                                  surahReaderInfo[index]['readerD']);
                              await sl<SharedPrefServices>().saveString(
                                  SURAH_AUDIO_PLAYER_NAME,
                                  surahReaderInfo[index]['readerN']);
                              await sl<SharedPreferences>()
                                  .setInt(SURAH_READER_INDEX, index);
                              surahAudioCtrl.surahReaderIndex.value = index;
                              surahAudioCtrl.changeAudioSource();
                              Navigator.pop(context);
                            },
                            leading: Container(
                              height: 80.0,
                              width: 80.0,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/${surahReaderInfo[index]['readerI']}.jpg'),
                                    fit: BoxFit.fitWidth,
                                    opacity: surahAudioCtrl
                                                .sorahReaderNameValue ==
                                            surahReaderInfo[index]['readerN']
                                        ? 1
                                        : .4,
                                  ),
                                  shape: BoxShape.rectangle,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(4.0)),
                                  border: Border.all(
                                      color: Get.theme.colorScheme.primary,
                                      width: 2)),
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8.0)),
                            border: Border.all(
                                color: Get.theme.colorScheme.primary,
                                width: 1)),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 4.0),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
