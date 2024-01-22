import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
        'name': 'reader1'.tr,
        'readerD': 'Abdul_Basit_Murattal_192kbps',
        'readerI': 'basit'
      },
      {
        'name': 'reader2'.tr,
        'readerD': 'Minshawy_Murattal_128kbps',
        'readerI': 'minshawy'
      },
      {'name': 'reader3'.tr, 'readerD': 'Husary_128kbps', 'readerI': 'husary'},
      // {
      //   'name': 'reader4'.tr,
      //   'readerD': 'Ahmed_ibn_Ali_al-Ajamy_64kbps_QuranExplorer.Com',
      //   'readerI': 'ajamy'
      // },
      {
        'name': 'reader5'.tr,
        'readerD': 'MaherAlMuaiqly128kbps',
        'readerI': 'muaiqly'
      },
      {'name': 'reader6'.tr, 'readerD': 'Ghamadi_40kbps', 'readerI': 'Ghamadi'}
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
                width: 1, color: Get.theme.dividerColor.withOpacity(.5))),
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
                        color: Get.isDarkMode
                            ? Get.theme.colorScheme.surface
                            : Get.theme.primaryColor,
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
                    color: Get.isDarkMode
                        ? Get.theme.colorScheme.surface
                        : Get.theme.primaryColor),
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
                        color: Get.theme.colorScheme.background,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8),
                        ),
                        border: Border.all(
                            width: 2, color: Get.theme.dividerColor)),
                    child: Icon(
                      Icons.close_outlined,
                      color: Get.theme.colorScheme.surface,
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
                        color: Get.theme.dividerColor,
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
                                      ? Get.theme.primaryColorLight
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
                                        ? Get.theme.primaryColorLight
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
                                      color: Get.theme.dividerColor, width: 2)),
                            ),
                          ),
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8.0)),
                              border: Border.all(
                                  color: Get.theme.dividerColor, width: 1)),
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
