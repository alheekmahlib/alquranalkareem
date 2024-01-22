import 'dart:io' show File;

import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/services/services_locator.dart';
import '../../../core/utils/constants/shared_pref_services.dart';
import '../../../core/utils/constants/svg_picture.dart';
import '../../../core/widgets/theme_change.dart';
import '../../../core/widgets/widgets.dart';
import '../../controllers/settings_controller.dart';
import '/core/utils/constants/extensions.dart';
import '/core/utils/constants/shared_preferences_constants.dart';

class AboutApp extends StatelessWidget {
  const AboutApp({Key? key}) : super(key: key);

  Future<void> _launchEmail() async {
    // ios specification
    const String subject = "القرآن الكريم - مكتبة الحكمة";
    const String stringText =
        "يرجى كتابة أي ملاحظة أو إستفسار\n| جزاكم الله خيرًا |";
    String uri =
        'mailto:haozo89@gmail.com?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(stringText)}';
    if (await canLaunchUrl(Uri.parse(uri))) {
      await launchUrl(Uri.parse(uri));
    } else {
      print("No email client found");
    }
  }

  Future<void> _launchUrl() async {
    // ios specification
    String uri = 'https://www.facebook.com/alheekmahlib';
    if (await canLaunchUrl(Uri.parse(uri))) {
      await launchUrl(Uri.parse(uri));
    } else {
      print("No url client found");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      right: false,
      left: false,
      child: Scaffold(
        backgroundColor: Get.theme.colorScheme.background,
        body: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: context.customOrientation(
                  const EdgeInsets.only(top: 64.0),
                  const EdgeInsets.only(top: 16.0)),
              child: Stack(
                children: [
                  customClose2(context),
                  const Divider(
                    height: 58,
                    thickness: 2,
                    endIndent: 16,
                    indent: 16,
                  ),
                  Padding(
                    padding: context.customOrientation(
                        const EdgeInsets.only(top: 30, right: 16, left: 16),
                        const EdgeInsets.only(top: 30, right: 64, left: 64)),
                    child: ListView(
                      children: [
                        Center(
                          child: spaceLine(
                            30,
                            MediaQuery.sizeOf(context).width * 3 / 4,
                          ),
                        ),
                        customContainer(
                            context,
                            Semantics(
                              button: true,
                              enabled: true,
                              label: 'Version:',
                              child: Text(
                                '${'version'.tr}: 3.1.0',
                                style: TextStyle(
                                  color: Get.isDarkMode
                                      ? Colors.white
                                      : Get.theme.primaryColor,
                                  fontSize: 16,
                                  fontFamily: 'kufi',
                                ),
                              ),
                            )),
                        const SizedBox(
                          height: 16.0,
                        ),
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: Semantics(
                            button: true,
                            enabled: true,
                            label: 'Change Language',
                            child: Container(
                              color:
                                  Get.theme.colorScheme.surface.withOpacity(.2),
                              child: Column(
                                children: [
                                  customContainer(
                                    context,
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/svg/line.svg',
                                          height: 15,
                                        ),
                                        Text(
                                          'langChange'.tr,
                                          style: TextStyle(
                                              color: Get.isDarkMode
                                                  ? Colors.white
                                                  : Get.theme.primaryColor,
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
                                    child: Obx(
                                      () => ExpansionTileCard(
                                        elevation: 0.0,
                                        initialElevation: 0.0,
                                        title: Text(
                                          sl<SettingsController>()
                                              .languageName
                                              .value,
                                          style: TextStyle(
                                            fontFamily: sl<SettingsController>()
                                                .languageFont
                                                .value,
                                            fontSize: 16,
                                            color: Get.isDarkMode
                                                ? Colors.white
                                                : Get.theme.primaryColor,
                                          ),
                                        ),
                                        baseColor: Get
                                            .theme.colorScheme.background
                                            .withOpacity(.2),
                                        expandedColor: Get
                                            .theme.colorScheme.background
                                            .withOpacity(.2),
                                        children: <Widget>[
                                          const Divider(
                                            thickness: 1.0,
                                            height: 1.0,
                                          ),
                                          ButtonBar(
                                              alignment:
                                                  MainAxisAlignment.spaceAround,
                                              buttonHeight: 42.0,
                                              buttonMinWidth: 90.0,
                                              children: List.generate(
                                                  sl<SettingsController>()
                                                      .languageList
                                                      .length, (index) {
                                                final lang =
                                                    sl<SettingsController>()
                                                        .languageList[index];
                                                return InkWell(
                                                  child: SizedBox(
                                                    height: 30,
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          height: 20,
                                                          width: 20,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                const BorderRadius
                                                                    .all(
                                                                    Radius.circular(
                                                                        2.0)),
                                                            border: Border.all(
                                                                color: 'appLang'
                                                                            .tr ==
                                                                        lang[
                                                                            'appLang']
                                                                    ? Theme.of(
                                                                            context)
                                                                        .secondaryHeaderColor
                                                                    : Theme.of(
                                                                            context)
                                                                        .colorScheme
                                                                        .surface
                                                                        .withOpacity(
                                                                            .5),
                                                                width: 2),
                                                            color: const Color(
                                                                0xff39412a),
                                                          ),
                                                          child: 'appLang'.tr ==
                                                                  lang[
                                                                      'appLang']
                                                              ? Icon(Icons.done,
                                                                  size: 14,
                                                                  color: Theme.of(
                                                                          context)
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
                                                            color: 'appLang'
                                                                        .tr ==
                                                                    lang[
                                                                        'appLang']
                                                                ? Theme.of(
                                                                        context)
                                                                    .secondaryHeaderColor
                                                                : Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .surface
                                                                    .withOpacity(
                                                                        .8),
                                                            fontSize: 16,
                                                            fontFamily: 'noto',
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  onTap: () async {
                                                    sl<SettingsController>()
                                                        .setLocale(
                                                            Locale.fromSubtags(
                                                                languageCode:
                                                                    lang[
                                                                        'lang']));
                                                    await sl<
                                                            SharedPrefServices>()
                                                        .saveString(
                                                            LANG, lang['lang']);
                                                    await sl<
                                                            SharedPrefServices>()
                                                        .saveString(LANG_NAME,
                                                            lang['name']);
                                                    await sl<
                                                            SharedPrefServices>()
                                                        .saveString(
                                                            LANGUAGE_FONT,
                                                            lang['font']);

                                                    sl<SettingsController>()
                                                        .languageName
                                                        .value = lang['name'];
                                                    sl<SettingsController>()
                                                        .languageFont
                                                        .value = lang['font'];
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
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: Semantics(
                            button: true,
                            enabled: true,
                            label: 'Change Theme',
                            child: Container(
                              color:
                                  Get.theme.colorScheme.surface.withOpacity(.2),
                              child: Column(
                                children: [
                                  customContainer(
                                    context,
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/svg/line.svg',
                                          height: 15,
                                        ),
                                        Text(
                                          'themeTitle'.tr,
                                          style: TextStyle(
                                              color: Get.isDarkMode
                                                  ? Colors.white
                                                  : Get.theme.primaryColor,
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
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [ThemeChange()],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        Container(
                          color: Get.theme.colorScheme.surface.withOpacity(.2),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Semantics(
                                  button: true,
                                  enabled: true,
                                  excludeSemantics: true,
                                  label: 'Share App',
                                  child: InkWell(
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.share_outlined,
                                          color: Get.isDarkMode
                                              ? Colors.white
                                              : Get.theme.primaryColor,
                                          size: 22,
                                        ),
                                        Container(
                                          width: 2,
                                          height: 20,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 8),
                                          color: Get.isDarkMode
                                              ? Colors.white
                                              : Get.theme.primaryColor,
                                        ),
                                        Text(
                                          'share'.tr,
                                          style: TextStyle(
                                              color: Get.isDarkMode
                                                  ? Colors.white
                                                  : Get.theme.primaryColor,
                                              fontFamily: 'kufi',
                                              fontStyle: FontStyle.italic,
                                              fontSize: 14),
                                        ),
                                      ],
                                    ),
                                    onTap: () async {
                                      share();
                                    },
                                  ),
                                ),
                                const Divider(),
                                Semantics(
                                  button: true,
                                  enabled: true,
                                  excludeSemantics: true,
                                  label: 'Connect with us',
                                  child: InkWell(
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.email_outlined,
                                          color: Get.isDarkMode
                                              ? Colors.white
                                              : Get.theme.primaryColor,
                                          size: 22,
                                        ),
                                        Container(
                                          width: 2,
                                          height: 20,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 8),
                                          color: Get.isDarkMode
                                              ? Colors.white
                                              : Get.theme.primaryColor,
                                        ),
                                        Text(
                                          'email'.tr,
                                          style: TextStyle(
                                              color: Get.isDarkMode
                                                  ? Colors.white
                                                  : Get.theme.primaryColor,
                                              fontFamily: 'kufi',
                                              fontStyle: FontStyle.italic,
                                              fontSize: 14),
                                        ),
                                      ],
                                    ),
                                    onTap: () {
                                      _launchEmail();
                                    },
                                  ),
                                ),
                                const Divider(),
                                Semantics(
                                  button: true,
                                  enabled: true,
                                  excludeSemantics: true,
                                  label: 'Follow us on Facebook',
                                  child: InkWell(
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.facebook_rounded,
                                          color: Get.isDarkMode
                                              ? Colors.white
                                              : Get.theme.primaryColor,
                                          size: 22,
                                        ),
                                        Container(
                                          width: 2,
                                          height: 20,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 8),
                                          color: Get.isDarkMode
                                              ? Colors.white
                                              : Get.theme.primaryColor,
                                        ),
                                        Text(
                                          'facebook'.tr,
                                          style: TextStyle(
                                              color: Get.isDarkMode
                                                  ? Colors.white
                                                  : Get.theme.primaryColor,
                                              fontFamily: 'kufi',
                                              fontStyle: FontStyle.italic,
                                              fontSize: 14),
                                        ),
                                      ],
                                    ),
                                    onTap: () {
                                      _launchUrl();
                                    },
                                  ),
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
                    ),
                  ),
                ],
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
    final file = await File('${tempDir.path}/AlQuranAlKareem.jpg').create();
    file.writeAsBytesSync(list);
    await Share.shareXFiles(
      [XFile((file.path))],
      text:
          'الدَّالَّ على الخيرِ كفاعِلِهِ\n\nعن أبي هريرة رضي الله عنه أن رسول الله صلى الله عليه وسلم قال: من دعا إلى هدى كان له من الأجر مثل أجور من تبعه لا ينقص ذلك من أجورهم شيئا، ومن دعا إلى ضلالة كان عليه من الإثم مثل آثام من تبعه لا ينقص ذلك من آثامهم شيئا.\n\nالقرآن الكريم - مكتبة الحكمة\nروابط التحميل:\nللايفون: https://apps.apple.com/us/app/القرآن-الكريم-مكتبة-الحكمة/id1500153222\nللاندرويد:\nPlay Store: https://play.google.com/store/apps/details?id=com.alheekmah.alquranalkareem.alquranalkareem\nApp Gallery: https://appgallery.cloud.huawei.com/marketshare/app/C102051725?locale=en_US&source=appshare&subsource=C102051725',
    );
  }
}
