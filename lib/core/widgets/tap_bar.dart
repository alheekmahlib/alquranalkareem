import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/constants/svg_picture.dart';
import '/core/widgets/settings_list.dart';

class TapBarWidget extends StatelessWidget {
  final bool isChild;
  const TapBarWidget({super.key, required this.isChild});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 25,
          width: MediaQuery.sizeOf(context).width,
          color: Get.theme.colorScheme.primary,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => Get.bottomSheet(const SettingsList(),
                  isScrollControlled: true),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  button_curve(height: 45.0, width: 45.0),
                  Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4)),
                          border: Border.all(
                              width: 1, color: Get.theme.colorScheme.surface)),
                      child: options(height: 30.0, width: 30.0)),
                ],
              ),
            ),
            isChild
                ? GestureDetector(
                    onTap: () => Get.bottomSheet(Container()),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        button_curve(height: 45.0, width: 45.0),
                        Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(4)),
                                border: Border.all(
                                    width: 1,
                                    color: Get.theme.colorScheme.surface)),
                            child: options(height: 30.0, width: 30.0)),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        )
      ],
    );
  }
}
