import 'package:alquranalkareem/core/utils/constants/extensions/svg_extensions.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../presentation/controllers/theme_controller.dart';
import '../utils/constants/lists.dart';

class ThemeChange extends StatelessWidget {
  const ThemeChange({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeCtrl = ThemeController.instance;
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
            width: Get.width,
            padding: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
                border: Border.all(
                    color: Theme.of(context).colorScheme.surface, width: 1),
                borderRadius: const BorderRadius.all(Radius.circular(8))),
            child: Wrap(
              alignment: WrapAlignment.center,
              children: List.generate(
                  themeList.length,
                  (index) => Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Theme.of(context).colorScheme.surface,
                                width: 1),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8))),
                        padding: const EdgeInsets.all(4.0),
                        margin: const EdgeInsets.all(4.0),
                        child: Obx(() => AnimatedOpacity(
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
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: RotatedBox(
                                        quarterTurns: 1,
                                        child: Text(
                                          '${themeList[index]['title']}'.tr,
                                          style: TextStyle(
                                              color:
                                                  Theme.of(context).hintColor,
                                              fontFamily: 'kufi',
                                              fontStyle: FontStyle.italic,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10),
                                        ),
                                      ),
                                    ),
                                    const Gap(4),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        customSvg(
                                          themeList[index]['svgUrl'],
                                          height: 75,
                                        ),
                                        const Gap(6),
                                        Container(
                                          height: 20,
                                          width: 20,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
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
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )),
                      )),
            ),
          ),
        ],
      ),
    );
  }
}
