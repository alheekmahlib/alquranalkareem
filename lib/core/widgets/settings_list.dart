import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../utils/constants/svg_picture.dart';
import '/core/utils/constants/extensions.dart';
import 'language_list.dart';
import 'theme_change.dart';
import 'widgets.dart';

class SettingsList extends StatelessWidget {
  const SettingsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
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
            color: Get.theme.colorScheme.surface.withOpacity(.2),
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
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: context.customOrientation(size.width, 381.0),
                    margin: const EdgeInsets.symmetric(horizontal: 16.0),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 8.0),
                    decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(.7),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8.0),
                        )),
                    child: Column(
                      children: [
                        Text(
                          'appLang'.tr,
                          style: TextStyle(
                            fontFamily: 'kufi',
                            fontSize: 18,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        const LanguageList(),
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
            color: Get.theme.colorScheme.surface.withOpacity(.2),
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
