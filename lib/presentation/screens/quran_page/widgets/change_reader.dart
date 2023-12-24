import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:theme_provider/theme_provider.dart';

import '../../../../core/services/l10n/app_localizations.dart';
import '../../../../core/services/services_locator.dart';
import '../../../../core/utils/constants/shared_pref_services.dart';
import '../../../../core/utils/constants/shared_preferences_constants.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../controllers/audio_controller.dart';

class ChangeReader extends StatelessWidget {
  const ChangeReader({super.key});

  @override
  Widget build(BuildContext context) {
    List ayahReaderInfo = [
      {
        'name': AppLocalizations.of(context)!.reader1,
        'readerD': 'Abdul_Basit_Murattal_192kbps',
        'readerI': 'basit'
      },
      {
        'name': AppLocalizations.of(context)!.reader2,
        'readerD': 'Minshawy_Murattal_128kbps',
        'readerI': 'minshawy'
      },
      {
        'name': AppLocalizations.of(context)!.reader3,
        'readerD': 'Husary_128kbps',
        'readerI': 'husary'
      },
      // {
      //   'name': AppLocalizations.of(context)!.reader4,
      //   'readerD': 'Ahmed_ibn_Ali_al-Ajamy_64kbps_QuranExplorer.Com',
      //   'readerI': 'ajamy'
      // },
      {
        'name': AppLocalizations.of(context)!.reader5,
        'readerD': 'MaherAlMuaiqly128kbps',
        'readerI': 'muaiqly'
      },
      {
        'name': AppLocalizations.of(context)!.reader6,
        'readerD': 'Ghamadi_40kbps',
        'readerI': 'Ghamadi'
      }
    ];
    return GestureDetector(
      child: Container(
        height: 35,
        width: 200,
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            border: Border.all(
                width: 1,
                color: Theme.of(context).dividerColor.withOpacity(.5))),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              flex: 8,
              child: Obx(
                () => FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    ayahReaderInfo[sl<AudioController>().readerIndex.value]
                        ['name'],
                    style: TextStyle(
                        color: ThemeProvider.themeOf(context).id == 'dark'
                            ? Theme.of(context).colorScheme.surface
                            : Theme.of(context).primaryColor,
                        fontSize: 14,
                        fontFamily: "kufi"),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 8.0,
            ),
            Expanded(
              child: Semantics(
                button: true,
                enabled: true,
                label: 'Change Reader',
                child: Icon(Icons.person_search_outlined,
                    size: 20,
                    color: ThemeProvider.themeOf(context).id == 'dark'
                        ? Theme.of(context).colorScheme.surface
                        : Theme.of(context).primaryColor),
              ),
            ),
          ],
        ),
      ),
      onTap: () => dropDownModalBottomSheet(
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
                  itemCount: ayahReaderInfo.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        Container(
                          child: ListTile(
                            title: Text(
                              ayahReaderInfo[index]['name'],
                              style: TextStyle(
                                  color: sl<AudioController>().readerValue ==
                                          ayahReaderInfo[index]['readerD']
                                      ? Theme.of(context).primaryColorLight
                                      : const Color(0xffcdba72),
                                  fontSize: 14,
                                  fontFamily: "kufi"),
                            ),
                            trailing: Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(2.0)),
                                border: Border.all(
                                    color: sl<AudioController>().readerValue ==
                                            ayahReaderInfo[index]['readerD']
                                        ? Theme.of(context).primaryColorLight
                                        : const Color(0xffcdba72),
                                    width: 2),
                                color: const Color(0xff39412a),
                              ),
                              child: sl<AudioController>().readerValue ==
                                      ayahReaderInfo[index]['readerD']
                                  ? const Icon(Icons.done,
                                      size: 14, color: Color(0xffcdba72))
                                  : null,
                            ),
                            onTap: () async {
                              sl<AudioController>().readerName.value =
                                  ayahReaderInfo[index]['name'];
                              sl<AudioController>().readerValue =
                                  ayahReaderInfo[index]['readerD'];
                              sl<AudioController>().readerIndex.value = index;
                              await sl<SharedPrefServices>().saveString(
                                  AUDIO_PLAYER_SOUND,
                                  ayahReaderInfo[index]['readerD']);
                              await sl<SharedPrefServices>().saveString(
                                  READER_NAME, ayahReaderInfo[index]['name']);
                              await sl<SharedPrefServices>()
                                  .saveInteger(READER_INDEX, index);
                              Navigator.pop(context);
                            },
                            leading: Container(
                              height: 80.0,
                              width: 80.0,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/${ayahReaderInfo[index]['readerI']}.jpg'),
                                    fit: BoxFit.fitWidth,
                                    opacity:
                                        sl<AudioController>().readerValue ==
                                                ayahReaderInfo[index]['readerD']
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
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8.0)),
                              border: Border.all(
                                  color: Theme.of(context).dividerColor,
                                  width: 1)),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 4.0),
                        ),
                        // const Divider(
                        //   endIndent: 16,
                        //   indent: 16,
                        //   height: 3,
                        // ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
