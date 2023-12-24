import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:theme_provider/theme_provider.dart';

import '../../presentation/controllers/settings_controller.dart';
import '../services/l10n/app_localizations.dart';
import '../services/services_locator.dart';
import '../utils/constants/shared_pref_services.dart';
import '../utils/constants/shared_preferences_constants.dart';
import '../utils/constants/svg_picture.dart';
import 'theme_change.dart';
import 'widgets.dart';

class SettingsList extends StatelessWidget {
  const SettingsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      // direction: Axis.vertical,
      children: [
        Center(
          child: spaceLine(
            30,
            MediaQuery.sizeOf(context).width * 3 / 4,
          ),
        ),
        Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            color: Theme.of(context).colorScheme.surface.withOpacity(.2),
            child: Column(
              children: [
                customContainer(
                  context,
                  FittedBox(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          'assets/svg/line.svg',
                          height: 15,
                        ),
                        Text(
                          AppLocalizations.of(context)!.langChange,
                          style: TextStyle(
                              color: ThemeProvider.themeOf(context).id == 'dark'
                                  ? Colors.white
                                  : Theme.of(context).primaryColor,
                              fontFamily: 'kufi',
                              fontStyle: FontStyle.italic,
                              fontSize: 16),
                        ),
                        SvgPicture.asset(
                          'assets/svg/line2.svg',
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Obx(
                    () => ExpansionTileCard(
                      elevation: 0.0,
                      initialElevation: 0.0,
                      title: SizedBox(
                        width: 100.0,
                        child: Text(
                          sl<SettingsController>().languageName.value,
                          style: TextStyle(
                            fontFamily:
                                sl<SettingsController>().languageFont.value,
                            fontSize: 16,
                            color: ThemeProvider.themeOf(context).id == 'dark'
                                ? Colors.white
                                : Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      baseColor: Theme.of(context)
                          .colorScheme
                          .background
                          .withOpacity(.2),
                      expandedColor: Theme.of(context)
                          .colorScheme
                          .background
                          .withOpacity(.2),
                      children: <Widget>[
                        const Divider(
                          thickness: 1.0,
                          height: 1.0,
                        ),
                        ButtonBar(
                            alignment: MainAxisAlignment.spaceAround,
                            buttonHeight: 42.0,
                            buttonMinWidth: 90.0,
                            children: List.generate(
                                sl<SettingsController>().languageList.length,
                                (index) {
                              final lang =
                                  sl<SettingsController>().languageList[index];
                              return InkWell(
                                child: Container(
                                  constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width *
                                              0.8),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 20,
                                        width: 20,
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(2.0)),
                                          border: Border.all(
                                              color:
                                                  AppLocalizations.of(context)!
                                                              .appLang ==
                                                          lang['appLang']
                                                      ? Theme.of(context)
                                                          .secondaryHeaderColor
                                                      : Theme.of(context)
                                                          .colorScheme
                                                          .surface
                                                          .withOpacity(.5),
                                              width: 2),
                                          color: const Color(0xff39412a),
                                        ),
                                        child: AppLocalizations.of(context)!
                                                    .appLang ==
                                                lang['appLang']
                                            ? Icon(Icons.done,
                                                size: 14,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .surface)
                                            : null,
                                      ),
                                      const SizedBox(
                                        width: 16.0,
                                      ),
                                      Text(
                                        lang['name'],
                                        style: TextStyle(
                                          color: AppLocalizations.of(context)!
                                                      .appLang ==
                                                  lang['appLang']
                                              ? Theme.of(context)
                                                  .secondaryHeaderColor
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .surface
                                                  .withOpacity(.8),
                                          fontSize: 16,
                                          fontFamily: 'noto',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () async {
                                  sl<SettingsController>().setLocale(
                                      Locale.fromSubtags(
                                          languageCode: lang['lang']));
                                  await sl<SharedPrefServices>()
                                      .saveString(LANG, lang['lang']);
                                  await sl<SharedPrefServices>()
                                      .saveString(LANG_NAME, lang['name']);
                                  await sl<SharedPrefServices>()
                                      .saveString(LANGUAGE_FONT, lang['font']);
                                  sl<SettingsController>().languageName.value =
                                      lang['name'];
                                  sl<SettingsController>().languageFont.value =
                                      lang['font'];
                                },
                              );
                            })),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 16.0,
        ),
        Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            color: Theme.of(context).colorScheme.surface.withOpacity(.2),
            child: Column(
              children: [
                customContainer(
                  context,
                  FittedBox(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SvgPicture.asset(
                          'assets/svg/line.svg',
                          height: 15,
                        ),
                        Text(
                          AppLocalizations.of(context)!.themeTitle,
                          style: TextStyle(
                              color: ThemeProvider.themeOf(context).id == 'dark'
                                  ? Colors.white
                                  : Theme.of(context).primaryColor,
                              fontFamily: 'kufi',
                              fontStyle: FontStyle.italic,
                              fontSize: 16),
                        ),
                        SvgPicture.asset(
                          'assets/svg/line2.svg',
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: ThemeChange(),
                ),
              ],
            ),
          ),
        ),
        Center(
          child: spaceLine(
            30,
            MediaQuery.sizeOf(context).width * 3 / 4,
          ),
        ),
      ],
    );
  }
}
