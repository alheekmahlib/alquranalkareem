import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/services/services_locator.dart';
import '../../../../../core/utils/constants/lists.dart';
import '../../../../../core/utils/constants/shared_preferences_constants.dart';
import '../../../../controllers/translate_controller.dart';

class ChangeTranslate extends StatelessWidget {
  ChangeTranslate({super.key});
  final translateCtrl = sl<TranslateDataController>();

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
            Semantics(
              button: true,
              enabled: true,
              label: 'Change Reader',
              child: Icon(Icons.keyboard_arrow_down_outlined,
                  size: 20, color: Get.theme.colorScheme.primary),
            ),
            Obx(() {
              return Text(
                translateName[translateCtrl.transValue.value],
                style: TextStyle(
                    color: Get.theme.colorScheme.surface,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'kufi'),
              );
            }),
          ],
        ),
      ),
      color: Get.theme.colorScheme.background,
      itemBuilder: (context) => List.generate(
          translateName.length,
          (index) => PopupMenuItem(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Obx(
                  () => Semantics(
                    button: true,
                    enabled: true,
                    excludeSemantics: true,
                    label: semanticsTranslateName[index],
                    child: ListTile(
                      title: Text(
                        translateName[index],
                        style: TextStyle(
                            color: translateCtrl.transValue.value == index
                                ? Get.theme.primaryColorLight
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
                              color: translateCtrl.transValue.value == index
                                  ? Get.theme.primaryColorLight
                                  : const Color(0xffcdba72),
                              width: 2),
                          color: const Color(0xff39412a),
                        ),
                        child: translateCtrl.transValue.value == index
                            ? const Icon(Icons.done,
                                size: 14, color: Color(0xffcdba72))
                            : null,
                      ),
                      onTap: () async {
                        translateCtrl.transValue.value == index;
                        await sl<SharedPreferences>()
                            .setInt(TRANSLATE_VALUE, index);
                        translateCtrl.translateHandleRadioValueChanged(index);
                        translateCtrl.fetchTranslate(context);
                        Navigator.pop(context);
                      },
                      leading: Container(
                          height: 85.0,
                          width: 41.0,
                          decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4.0)),
                              border: Border.all(
                                  color: Get.theme.dividerColor, width: 2)),
                          child: Opacity(
                            opacity: translateCtrl.transValue.value == index
                                ? 1
                                : .4,
                            child: SvgPicture.asset(
                              'assets/svg/tafseer_book.svg',
                            ),
                          )),
                    ),
                  ),
                ),
              )),
    );
  }
}
