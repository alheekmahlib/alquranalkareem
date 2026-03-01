import 'package:alquranalkareem/core/utils/constants/extensions/svg_extensions.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../presentation/controllers/theme_controller.dart';
import '../utils/constants/lists.dart';

class ThemeChange extends StatelessWidget {
  const ThemeChange({super.key});

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
              fontSize: 16,
            ),
          ),
          const Gap(8),
          Container(
            width: Get.width,
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.surface.withValues(alpha: 0.08),
              borderRadius: const BorderRadius.all(Radius.circular(16)),
            ),
            child: Wrap(
              alignment: WrapAlignment.center,
              children: List.generate(
                themeList.length,
                (index) => Obx(() {
                  final isSelected =
                      themeList[index]['name'] == themeCtrl.currentTheme;
                  return AnimatedScale(
                    scale: isSelected ? 1.0 : 0.95,
                    duration: const Duration(milliseconds: 300),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(14),
                        ),
                        border: Border.all(
                          color: isSelected
                              ? Theme.of(context).colorScheme.surface
                              : Theme.of(
                                  context,
                                ).colorScheme.surface.withValues(alpha: 0.2),
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.surface.withValues(alpha: 0.25),
                                  blurRadius: 10,
                                  spreadRadius: 1,
                                ),
                              ]
                            : null,
                      ),
                      padding: const EdgeInsets.all(6.0),
                      margin: const EdgeInsets.all(4.0),
                      child: AnimatedOpacity(
                        opacity: isSelected ? 1 : .5,
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
                                      color: Theme.of(context).hintColor,
                                      fontFamily: 'kufi',
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ),
                              const Gap(4),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                    child: customSvg(
                                      themeList[index]['svgUrl'],
                                      height: 75,
                                    ),
                                  ),
                                  const Gap(6),
                                  Container(
                                    height: 22,
                                    width: 22,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(22.0),
                                      ),
                                      border: Border.all(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.surface,
                                        width: 2,
                                      ),
                                      gradient: isSelected
                                          ? LinearGradient(
                                              colors: [
                                                Theme.of(
                                                  context,
                                                ).colorScheme.surface,
                                                Theme.of(
                                                  context,
                                                ).colorScheme.primary,
                                              ],
                                            )
                                          : null,
                                      color: isSelected
                                          ? null
                                          : Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                    ),
                                    child: isSelected
                                        ? const Icon(
                                            Icons.done,
                                            size: 14,
                                            color: Colors.white,
                                          )
                                        : null,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
