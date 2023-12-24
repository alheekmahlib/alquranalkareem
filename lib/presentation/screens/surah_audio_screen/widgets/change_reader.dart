import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/services/l10n/app_localizations.dart';
import '../../../../core/services/services_locator.dart';
import '../../../../core/utils/constants/shared_pref_services.dart';
import '../../../../core/utils/constants/shared_preferences_constants.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../controllers/surah_audio_controller.dart';

class ChangeSurahReader extends StatelessWidget {
  const ChangeSurahReader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      width: 35,
      margin: const EdgeInsets.all(28.0),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          border: Border.all(
              color: Theme.of(context).dividerColor.withOpacity(.5), width: 1)),
      child: IconButton(
        icon: Semantics(
          button: true,
          enabled: true,
          label: 'Change Reader',
          child: Icon(Icons.person_search_outlined,
              size: 20, color: Theme.of(context).colorScheme.surface),
        ),
        onPressed: () => sorahReaderDropDown(context),
      ),
    );
  }

  sorahReaderDropDown(BuildContext context) {
    List surahReaderInfo = [
      {
        'name': AppLocalizations.of(context)!.reader1,
        'readerD': 'https://server7.mp3quran.net/',
        'readerN': 'basit/',
        'readerI': 'basit'
      },
      {
        'name': AppLocalizations.of(context)!.reader2,
        'readerD': 'https://server10.mp3quran.net/',
        'readerN': 'minsh/',
        'readerI': 'minshawy'
      },
      {
        'name': AppLocalizations.of(context)!.reader3,
        'readerD': 'https://server13.mp3quran.net/',
        'readerN': 'husr/',
        'readerI': 'husary'
      },
      {
        'name': AppLocalizations.of(context)!.reader4,
        'readerD': 'https://server10.mp3quran.net/',
        'readerN': 'ajm/',
        'readerI': 'ajamy'
      },
      {
        'name': AppLocalizations.of(context)!.reader5,
        'readerD': 'https://server12.mp3quran.net/',
        'readerN': 'maher/',
        'readerI': 'muaiqly'
      },
      {
        'name': AppLocalizations.of(context)!.reader6,
        'readerD': 'https://server7.mp3quran.net/',
        'readerN': 's_gmd/',
        'readerI': 'Ghamadi'
      }
    ];

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
                      color: Theme.of(context).colorScheme.background,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(8),
                      ),
                      border: Border.all(
                          width: 2, color: Theme.of(context).dividerColor)),
                  child: Icon(
                    Icons.close_outlined,
                    color: Theme.of(context).colorScheme.surface,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: Text(
                  AppLocalizations.of(context)!.select_player,
                  style: TextStyle(
                      color: Theme.of(context).dividerColor,
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
                                  color: sl<SurahAudioController>()
                                              .sorahReaderNameValue ==
                                          surahReaderInfo[index]['readerN']
                                      ? Theme.of(context).primaryColorLight
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
                                    color: sl<SurahAudioController>()
                                                .sorahReaderNameValue ==
                                            surahReaderInfo[index]['readerN']
                                        ? Theme.of(context).primaryColorLight
                                        : const Color(0xffcdba72),
                                    width: 2),
                                color: const Color(0xff39412a),
                              ),
                              child: sl<SurahAudioController>()
                                          .sorahReaderNameValue ==
                                      surahReaderInfo[index]['readerN']
                                  ? const Icon(Icons.done,
                                      size: 14, color: Color(0xfffcbb76))
                                  : null,
                            ),
                            onTap: () async {
                              sl<SurahAudioController>()
                                  .sorahReaderValue
                                  .value = surahReaderInfo[index]['readerD'];
                              sl<SurahAudioController>()
                                  .sorahReaderNameValue
                                  .value = surahReaderInfo[index]['readerN'];

                              await sl<SharedPrefServices>().saveString(
                                  SURAH_AUDIO_PLAYER_SOUND,
                                  surahReaderInfo[index]['readerD']);
                              await sl<SharedPrefServices>().saveString(
                                  SURAH_AUDIO_PLAYER_NAME,
                                  surahReaderInfo[index]['readerN']);
                              sl<SurahAudioController>().changeAudioSource();
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
                                    opacity: sl<SurahAudioController>()
                                                .sorahReaderNameValue ==
                                            surahReaderInfo[index]['readerN']
                                        ? 1
                                        : .4,
                                  ),
                                  shape: BoxShape.rectangle,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(4.0)),
                                  border: Border.all(
                                      color: Theme.of(context).dividerColor,
                                      width: 2)),
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8.0)),
                            border: Border.all(
                                color: Theme.of(context).dividerColor,
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
