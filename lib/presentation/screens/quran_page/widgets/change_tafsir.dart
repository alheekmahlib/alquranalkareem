import 'package:alquranalkareem/core/utils/constants/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/services/services_locator.dart';
import '../../../../core/utils/constants/lists.dart';
import '../../../../core/utils/constants/shared_preferences_constants.dart';
import '../../../controllers/ayat_controller.dart';
import '../../../controllers/translate_controller.dart';

class ChangeTafsir extends StatelessWidget {
  const ChangeTafsir({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      position: PopupMenuPosition.under,
      child: Semantics(
        button: true,
        enabled: true,
        label: 'Change Font Size',
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(() {
              return Text(
                tafsirName[sl<AyatController>().radioValue.value]['name'],
                style: TextStyle(
                    color: Get.theme.colorScheme.primary,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
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
      ),
      color: Get.theme.colorScheme.background,
      itemBuilder: (context) => List.generate(
          tafsirName.length,
          (index) => PopupMenuItem(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        tafsirName[index]['name'],
                        style: TextStyle(
                            color:
                                sl<AyatController>().radioValue.value == index
                                    ? Get.theme.primaryColorLight
                                    : const Color(0xffCDAD80),
                            fontSize: 14,
                            fontFamily: 'kufi'),
                      ),
                      subtitle: Text(
                        tafsirName[index]['bookName'],
                        style: TextStyle(
                            color:
                                sl<AyatController>().radioValue.value == index
                                    ? Get.theme.primaryColorLight
                                    : const Color(0xffCDAD80),
                            fontSize: 12,
                            fontFamily: 'kufi'),
                      ),
                      trailing: Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20.0)),
                          border: Border.all(
                              color:
                                  sl<AyatController>().radioValue.value == index
                                      ? Get.theme.primaryColorLight
                                      : const Color(0xffCDAD80),
                              width: 2),
                          color: Get.theme.colorScheme.background,
                        ),
                        child: sl<AyatController>().radioValue.value == index
                            ? const Icon(Icons.done,
                                size: 14, color: Color(0xff404C6E))
                            : null,
                      ),
                      onTap: () async {
                        print("IconButton pressed, calling updateTextText");
                        sl<AyatController>().handleRadioValueChanged(index);
                        await sl<SharedPreferences>()
                            .setInt(TAFSEER_VAL, index);
                        sl<TranslateDataController>().fetchTranslate(context);
                        Get.back();
                      },
                      leading: Container(
                          height: 85.0,
                          width: 41.0,
                          decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4.0)),
                              border: Border.all(
                                  color: Get.theme.cardColor, width: 2)),
                          child: Opacity(
                            child: SvgPicture.asset(
                              'assets/svg/tafseer_book.svg',
                            ),
                            opacity:
                                sl<AyatController>().radioValue.value == index
                                    ? 1
                                    : .4,
                          )),
                    ),
                    index == 4
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              children: [
                                Expanded(
                                    flex: 2,
                                    child: context.hDivider(width: 70)),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    'translation'.tr,
                                    style: TextStyle(
                                        color: sl<AyatController>()
                                                    .radioValue
                                                    .value ==
                                                index
                                            ? Get.theme.primaryColorLight
                                            : const Color(0xffCDAD80),
                                        fontSize: 14,
                                        fontFamily: 'kufi'),
                                  ),
                                ),
                                Expanded(
                                    flex: 6,
                                    child: context.hDivider(width: 200)),
                              ],
                            ),
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
              )),
    );
  }
}
