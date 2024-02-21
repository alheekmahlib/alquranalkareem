import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
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
      builder: (localizationController) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(.2),
                  borderRadius: const BorderRadius.all(Radius.circular(4))),
              child: Text(
                'langChange'.tr,
                style: TextStyle(
                    color: Theme.of(context).hintColor,
                    fontFamily: 'kufi',
                    fontStyle: FontStyle.italic,
                    fontSize: 16),
              ),
            ),
            const Gap(8),
            Container(
              padding: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Theme.of(context).colorScheme.surface, width: 1),
                  borderRadius: const BorderRadius.all(Radius.circular(8))),
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
                        color: Theme.of(context).hintColor,
                      ),
                    );
                  }),
                ),
                baseColor:
                    Theme.of(context).colorScheme.primary.withOpacity(.2),
                expandedColor:
                    Theme.of(context).colorScheme.primary.withOpacity(.2),
                children: <Widget>[
                  const Divider(
                    thickness: 1.0,
                    height: 1.0,
                  ),
                  ButtonBar(
                      alignment: MainAxisAlignment.spaceAround,
                      buttonHeight: 42.0,
                      buttonMinWidth: 90.0,
                      children:
                          List.generate(AppConstants.languages.length, (index) {
                        final lang =
                            sl<SettingsController>().languageList[index];
                        return InkWell(
                          child: Container(
                            constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.8),
                            child: Row(
                              children: [
                                Container(
                                  height: 30,
                                  width: 30,
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 4.0, horizontal: 16.0),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20.0)),
                                    border: Border.all(
                                        color: 'appLang'.tr == lang['appLang']
                                            ? Theme.of(context)
                                                .colorScheme
                                                .surface
                                            : Theme.of(context)
                                                .colorScheme
                                                .background
                                                .withOpacity(.5),
                                        width: 3),
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  child: 'appLang'.tr == lang['appLang']
                                      ? Icon(Icons.done,
                                          size: 14,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surface)
                                      : null,
                                ),
                                Text(
                                  lang['name'],
                                  style: TextStyle(
                                    color: 'appLang'.tr == lang['appLang']
                                        ? Theme.of(context).colorScheme.surface
                                        : Theme.of(context)
                                            .canvasColor
                                            .withOpacity(.5),
                                    fontSize: 18,
                                    fontWeight: 'appLang'.tr == lang['appLang']
                                        ? FontWeight.bold
                                        : FontWeight.normal,
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
          ],
        ),
      ),
    );
  }
}
