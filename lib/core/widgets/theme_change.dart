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
          Text(
            'themeTitle'.tr,
            style: TextStyle(
                color: Theme.of(context).hintColor,
                fontFamily: 'kufi',
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                fontSize: 16),
          ),
          const Gap(4),
          Container(
            padding: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
                border: Border.all(
                    color: Theme.of(context).colorScheme.surface, width: 1),
                borderRadius: const BorderRadius.all(Radius.circular(8))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                  themeList.length,
                  (index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Obx(() {
                          return AnimatedOpacity(
                            opacity: themeList[index]['name'] ==
                                    themeCtrl.currentTheme
                                ? 1
                                : .5,
                            duration: const Duration(milliseconds: 300),
                            child: GestureDetector(
                              onTap: () {
                                themeCtrl.setTheme(themeList[index]['name']);
                                Get.forceAppUpdate().then((_) {
                                  Get.back();
                                });
                              },
                              child: Column(
                                children: [
                                  SvgPicture.asset(
                                    themeList[index]['svgUrl'],
                                    height: 75,
                                  ),
                                  const Gap(6),
                                  Row(
                                    children: [
                                      Container(
                                        height: 20,
                                        width: 20,
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(20.0)),
                                          border: Border.all(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .surface,
                                              width: 2),
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                        child: themeList[index]['name'] ==
                                                themeCtrl.currentTheme
                                            ? const Icon(Icons.done,
                                                size: 14, color: Colors.white)
                                            : null,
                                      ),
                                      const Gap(4),
                                      Text(
                                        '${themeList[index]['title']}'.tr,
                                        style: TextStyle(
                                            color: Theme.of(context).hintColor,
                                            fontFamily: 'kufi',
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      )),
            ),
          ),
        ],
      ),
    );
  }
}
