import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../presentation/controllers/settings_controller.dart';
import '../services/languages/app_constants.dart';
import '../services/languages/localization_controller.dart';
import '../services/services_locator.dart';

class LanguageList extends StatelessWidget {
  const LanguageList({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocalizationController>(
      builder: (localizationController) => Directionality(
        textDirection: TextDirection.rtl,
        child: ExpansionTileCard(
          elevation: 0.0,
          initialElevation: 0.0,
          expandedTextColor: Theme.of(context).primaryColorDark,
          title: SizedBox(
            width: 100.0,
            child: Obx(() {
              return Text(
                sl<SettingsController>().languageName.value,
                style: TextStyle(
                  fontFamily: 'kufi',
                  fontSize: 18,
                  color: Theme.of(context).primaryColorLight,
                ),
              );
            }),
          ),
          baseColor: Theme.of(context).colorScheme.background,
          expandedColor: Theme.of(context).colorScheme.background,
          children: <Widget>[
            const Divider(
              thickness: 1.0,
              height: 1.0,
            ),
            ButtonBar(
                alignment: MainAxisAlignment.spaceAround,
                buttonHeight: 42.0,
                buttonMinWidth: 90.0,
                children: List.generate(AppConstants.languages.length, (index) {
                  final lang = sl<SettingsController>().languageList[index];
                  return InkWell(
                    child: Container(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.8),
                      child: Row(
                        children: [
                          Container(
                            height: 30,
                            width: 30,
                            margin: const EdgeInsets.symmetric(
                                vertical: 4.0, horizontal: 16.0),
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20.0)),
                              border: Border.all(
                                  color: 'appLang'.tr == lang['appLang']
                                      ? Theme.of(context).dividerColor
                                      : Theme.of(context)
                                          .colorScheme
                                          .background,
                                  width: 3),
                              color: const Color(0xff3C2A21),
                            ),
                            child: 'appLang'.tr == lang['appLang']
                                ? Icon(Icons.done,
                                    size: 14,
                                    color: Theme.of(context).dividerColor)
                                : null,
                          ),
                          Text(
                            lang['name'],
                            style: TextStyle(
                              color: 'appLang'.tr == lang['appLang']
                                  ? Theme.of(context).primaryColorLight
                                  : Theme.of(context)
                                      .primaryColorLight
                                      .withOpacity(.5),
                              fontSize: 18,
                              fontFamily: 'noto',
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () async {
                      localizationController.changeLangOnTap(index);
                    },
                  );
                })),
          ],
        ),
      ),
    );
  }
}
