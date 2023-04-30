import 'dart:io';
import 'dart:typed_data';

import 'package:alquranalkareem/shared/widgets/theme_change.dart';
import 'package:alquranalkareem/shared/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../home_page.dart';
import '../../l10n/app_localizations.dart';
import '../custom_rect_tween.dart';
import '../hero_dialog_route.dart';



/// {@template add_todo_button}
/// Button to add a new [Todo].
///
/// Opens a [HeroDialogRoute] of [_AddTodoPopupCard].
///
/// Uses a [Hero] with tag [_heroAddTodo].
/// {@endtemplate}
class settingsButton extends StatelessWidget {
  /// {@macro add_todo_button}
  const settingsButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(HeroDialogRoute(builder: (context) {
            return const settingsPopupCard();
          }));
        },
        child: Container(
          height: 100,
          width: 100,
          color: Theme.of(context).colorScheme.surface,
          child: Hero(
            tag: heroAddTodo,
            createRectTween: (begin, end) {
              return CustomRectTween(begin: begin!, end: end!);
            },
            child: const Icon(
              Icons.settings,
              size: 28,
            ),
          ),
        ),
      ),
    );
  }
}

/// Tag-value used for the add todo popup button.
const String heroAddTodo = 'add-todo-hero';

/// {@template add_todo_popup_card}
/// Popup card to add a new [Todo]. Should be used in conjuction with
/// [HeroDialogRoute] to achieve the popup effect.
///
/// Uses a [Hero] with tag [_heroAddTodo].
/// {@endtemplate}
class settingsPopupCard extends StatelessWidget {
  /// {@macro add_todo_popup_card}
  const settingsPopupCard({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 70.0, right: 16.0, left: 16.0),
        child: SizedBox(
          height: orientation(context,
              MediaQuery.of(context).size.height * 1/2,
              MediaQuery.of(context).size.height * 1/2 * 1.6),
          width: 450,
          child: Hero(
            tag: heroAddTodo,
            createRectTween: (begin, end) {
              return CustomRectTween(begin: begin!, end: end!);
            },
            child: Material(
              color: Theme.of(context).colorScheme.background,
              elevation: 1,
              shape:
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  padding: EdgeInsets.zero,
                  // direction: Axis.vertical,
                  children: [
                    Center(
                      child: SizedBox(
                          height: 60,
                          width: MediaQuery.of(context).size.width * 3 / 4,
                          child: SvgPicture.asset(
                            'assets/svg/space_line.svg',
                          )),
                    ),
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: Container(
                        color: Theme.of(context)
                            .colorScheme.surface
                            .withOpacity(.2),
                        child: Column(
                          children: [
                            customContainer(
                              context,
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SvgPicture.asset(
                                    'assets/svg/line.svg',
                                    height: 15,
                                  ),
                                  Text(
                                    AppLocalizations.of(context)!
                                        .langChange,
                                    style: TextStyle(
                                        color:
                                        ThemeProvider.themeOf(context)
                                            .id ==
                                            'dark'
                                            ? Colors.white
                                            : Theme.of(context)
                                            .primaryColor,
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
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  InkWell(
                                    child: SizedBox(
                                      height: 30,
                                      width:
                                      MediaQuery.of(context).size.width,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            height: 20,
                                            width: 20,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              const BorderRadius.all(
                                                  Radius.circular(2.0)),
                                              border: Border.all(
                                                  color: AppLocalizations.of(
                                                      context)!
                                                      .appLang ==
                                                      "لغة التطبيق"
                                                      ? Theme.of(context)
                                                      .secondaryHeaderColor
                                                      : Theme.of(context)
                                                      .colorScheme.surface
                                                      .withOpacity(.5),
                                                  width: 2),
                                              color:
                                              const Color(0xff39412a),
                                            ),
                                            child: AppLocalizations.of(
                                                context)!
                                                .appLang ==
                                                "لغة التطبيق"
                                                ? Icon(Icons.done,
                                                size: 14,
                                                color: Theme.of(context)
                                                    .colorScheme.surface)
                                                : null,
                                          ),
                                          const SizedBox(
                                            width: 16.0,
                                          ),
                                          Text(
                                            'العربية',
                                            style: TextStyle(
                                              color: AppLocalizations.of(
                                                  context)!
                                                  .appLang ==
                                                  "لغة التطبيق"
                                                  ? Theme.of(context)
                                                  .secondaryHeaderColor
                                                  : Theme.of(context)
                                                  .colorScheme.surface
                                                  .withOpacity(.5),
                                              fontSize: 14,
                                              fontFamily: 'kufi',
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      HomePage.of(context)!.setLocale(
                                          const Locale.fromSubtags(
                                              languageCode: "ar"));
                                    },
                                  ),
                                  InkWell(
                                    child: SizedBox(
                                      height: 30,
                                      width:
                                      MediaQuery.of(context).size.width,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            height: 20,
                                            width: 20,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              const BorderRadius.all(
                                                  Radius.circular(2.0)),
                                              border: Border.all(
                                                  color: AppLocalizations.of(
                                                      context)!
                                                      .appLang ==
                                                      "App Language"
                                                      ? Theme.of(context)
                                                      .secondaryHeaderColor
                                                      : Theme.of(context)
                                                      .colorScheme.surface
                                                      .withOpacity(.5),
                                                  width: 2),
                                              color:
                                              const Color(0xff39412a),
                                            ),
                                            child: AppLocalizations.of(
                                                context)!
                                                .appLang ==
                                                "App Language"
                                                ? Icon(Icons.done,
                                                size: 14,
                                                color: Theme.of(context)
                                                    .colorScheme.surface)
                                                : null,
                                          ),
                                          const SizedBox(
                                            width: 16.0,
                                          ),
                                          Text(
                                            'English',
                                            style: TextStyle(
                                              color: AppLocalizations.of(
                                                  context)!
                                                  .appLang ==
                                                  "App Language"
                                                  ? Theme.of(context)
                                                  .secondaryHeaderColor
                                                  : Theme.of(context)
                                                  .colorScheme.surface
                                                  .withOpacity(.5),
                                              fontSize: 14,
                                              fontFamily: 'kufi',
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      HomePage.of(context)!.setLocale(
                                          const Locale.fromSubtags(
                                              languageCode: "en"));
                                    },
                                  ),
                                  InkWell(
                                    child: SizedBox(
                                      height: 30,
                                      width:
                                      MediaQuery.of(context).size.width,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            height: 20,
                                            width: 20,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              const BorderRadius.all(
                                                  Radius.circular(2.0)),
                                              border: Border.all(
                                                  color: AppLocalizations.of(
                                                      context)!
                                                      .appLang ==
                                                      "Idioma de la aplicación"
                                                      ? Theme.of(context)
                                                      .secondaryHeaderColor
                                                      : Theme.of(context)
                                                      .colorScheme.surface
                                                      .withOpacity(.5),
                                                  width: 2),
                                              color:
                                              const Color(0xff39412a),
                                            ),
                                            child: AppLocalizations.of(
                                                context)!
                                                .appLang ==
                                                "Idioma de la aplicación"
                                                ? Icon(Icons.done,
                                                size: 14,
                                                color: Theme.of(context)
                                                    .colorScheme.surface)
                                                : null,
                                          ),
                                          const SizedBox(
                                            width: 16.0,
                                          ),
                                          Text(
                                            'Español',
                                            style: TextStyle(
                                              color: AppLocalizations.of(
                                                  context)!
                                                  .appLang ==
                                                  "Idioma de la aplicación"
                                                  ? Theme.of(context)
                                                  .secondaryHeaderColor
                                                  : Theme.of(context)
                                                  .colorScheme.surface
                                                  .withOpacity(.5),
                                              fontSize: 14,
                                              fontFamily: 'kufi',
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      HomePage.of(context)!.setLocale(
                                          const Locale.fromSubtags(
                                              languageCode: "es"));
                                    },
                                  ),
                                ],
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
                        color: Theme.of(context)
                            .colorScheme.surface
                            .withOpacity(.2),
                        child: Column(
                          children: [
                            customContainer(
                              context,
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  SvgPicture.asset(
                                    'assets/svg/line.svg',
                                    height: 15,
                                  ),
                                  Text(
                                    AppLocalizations.of(context)!
                                        .themeTitle,
                                    style: TextStyle(
                                        color:
                                        ThemeProvider.themeOf(context)
                                            .id ==
                                            'dark'
                                            ? Colors.white
                                            : Theme.of(context)
                                            .primaryColor,
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
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ThemeChange(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Center(
                      child: SizedBox(
                          height: 60,
                          width: MediaQuery.of(context).size.width * 3 / 4,
                          child: SvgPicture.asset(
                            'assets/svg/space_line.svg',
                          )),
                    ),
                    // Flexible(
                    //   flex: 1,
                    //   child: ListView(
                    //     children: [
                    //
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  Future<void> share() async {
    final ByteData bytes =
    await rootBundle.load('assets/images/AlQuranAlKareem.jpg');
    final Uint8List list = bytes.buffer.asUint8List();

    final tempDir = await getTemporaryDirectory();
    final file =
    await File('${tempDir.path}/AlQuranAlKareem.jpg').create();
    file.writeAsBytesSync(list);
    await Share.shareXFiles(
      [
        XFile((file.path))
      ],
      text:
      'الدَّالَّ على الخيرِ كفاعِلِهِ\n\nعن أبي هريرة رضي الله عنه أن رسول الله صلى الله عليه وسلم قال: من دعا إلى هدى كان له من الأجر مثل أجور من تبعه لا ينقص ذلك من أجورهم شيئا، ومن دعا إلى ضلالة كان عليه من الإثم مثل آثام من تبعه لا ينقص ذلك من آثامهم شيئا.\n\nالقرآن الكريم - مكتبة الحكمة\nروابط التحميل:\nللايفون: https://apps.apple.com/us/app/القرآن-الكريم-مكتبة-الحكمة/id1500153222\nللاندرويد:\nPlay Store: https://play.google.com/store/apps/details?id=com.alheekmah.alquranalkareem.alquranalkareem\nApp Gallery: https://appgallery.cloud.huawei.com/marketshare/app/C102051725?locale=en_US&source=appshare&subsource=C102051725',
    );
  }
}