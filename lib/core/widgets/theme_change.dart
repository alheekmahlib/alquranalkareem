import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../presentation/controllers/theme_controller.dart';
import '../services/services_locator.dart';
import '../utils/constants/lists.dart';

class ThemeChange extends StatelessWidget {
  const ThemeChange({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeCtrl = sl<ThemeController>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
                color: Get.theme.colorScheme.primary.withOpacity(.2),
                borderRadius: const BorderRadius.all(Radius.circular(4))),
            child: Text(
              'themeTitle'.tr,
              style: TextStyle(
                  color: Get.isDarkMode ? Colors.white : Get.theme.primaryColor,
                  fontFamily: 'kufi',
                  fontStyle: FontStyle.italic,
                  fontSize: 16),
            ),
          ),
          const Gap(8),
          Container(
            padding: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
                border:
                    Border.all(color: Get.theme.colorScheme.surface, width: 1),
                borderRadius: const BorderRadius.all(Radius.circular(8))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                  themeList.length,
                  (index) => Obx(() {
                        return AnimatedOpacity(
                          opacity:
                              themeList[index]['name'] == themeCtrl.currentTheme
                                  ? 1
                                  : .5,
                          duration: const Duration(milliseconds: 300),
                          child: GestureDetector(
                            onTap: () {
                              // TODO here theme changes
                              themeCtrl.setTheme(themeList[index]['name']);
                              themeCtrl.update();
                            },
                            child: Column(
                              children: [
                                SvgPicture.asset(
                                  themeList[index]['svgUrl'],
                                  height: 80,
                                ),
                                const Gap(6),
                                Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20.0)),
                                    border: Border.all(
                                        color: Get.theme.colorScheme.surface,
                                        width: 2),
                                    color: Get.theme.colorScheme.primary,
                                  ),
                                  child: themeList[index]['name'] ==
                                          themeCtrl.currentTheme
                                      ? const Icon(Icons.done,
                                          size: 14, color: Colors.white)
                                      : null,
                                ),
                              ],
                            ),
                          ),
                        );
                      })),
            ),
          ),
        ],
      ),
    );
  }
}
