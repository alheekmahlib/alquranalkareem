import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/services/services_locator.dart';
import '../../../../core/utils/constants/lists.dart';
import '../../../../core/utils/constants/shared_pref_services.dart';
import '../../../../core/utils/constants/shared_preferences_constants.dart';
import '../../../controllers/surah_audio_controller.dart';

class ChangeSurahReader extends StatelessWidget {
  const ChangeSurahReader({super.key});

  @override
  Widget build(BuildContext context) {
    final surahAudioCtrl = sl<SurahAudioController>();
    return PopupMenuButton(
      position: PopupMenuPosition.over,
      child: Semantics(
        button: true,
        enabled: true,
        label: 'Change Font Size',
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(() {
              return Text(
                surahReaderInfo[surahAudioCtrl.surahReaderIndex.value]['name'],
                style: TextStyle(
                    color: Theme.of(context).colorScheme.surface,
                    fontSize: 13,
                    fontFamily: 'kufi'),
              );
            }),
            Semantics(
              button: true,
              enabled: true,
              label: 'Change Reader',
              child: Icon(Icons.keyboard_arrow_down_outlined,
                  size: 20, color: Theme.of(context).hintColor),
            ),
          ],
        ),
      ),
      color: Theme.of(context).colorScheme.background,
      itemBuilder: (context) => List.generate(
          ayahReaderInfo.length,
          (index) => PopupMenuItem(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                child: ListTile(
                  title: Text(
                    surahReaderInfo[index]['name'],
                    style: TextStyle(
                        color: surahAudioCtrl.sorahReaderNameValue ==
                                surahReaderInfo[index]['readerN']
                            ? Theme.of(context).primaryColorLight
                            : const Color(0xffcdba72),
                        fontSize: 14,
                        fontFamily: "kufi"),
                  ),
                  trailing: Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(2.0)),
                      border: Border.all(
                          color: surahAudioCtrl.sorahReaderNameValue ==
                                  surahReaderInfo[index]['readerN']
                              ? Theme.of(context).primaryColorLight
                              : const Color(0xffcdba72),
                          width: 2),
                      color: const Color(0xff39412a),
                    ),
                    child: surahAudioCtrl.sorahReaderNameValue ==
                            surahReaderInfo[index]['readerN']
                        ? const Icon(Icons.done,
                            size: 14, color: Color(0xffcdba72))
                        : null,
                  ),
                  onTap: () async {
                    surahAudioCtrl.initializeSurahDownloadStatus();
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
                    Get.back();
                  },
                  leading: Container(
                    height: 80.0,
                    width: 80.0,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                              'assets/images/${ayahReaderInfo[index]['readerI']}.jpg'),
                          fit: BoxFit.fitWidth,
                          opacity: surahAudioCtrl.sorahReaderNameValue ==
                                  surahReaderInfo[index]['readerN']
                              ? 1
                              : .4,
                        ),
                        shape: BoxShape.rectangle,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(4.0)),
                        border: Border.all(
                            color: Theme.of(context).dividerColor, width: 2)),
                  ),
                ),
              )),
    );
  }
}
