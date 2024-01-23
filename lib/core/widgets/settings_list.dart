import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions.dart';
import 'language_list.dart';
import 'theme_change.dart';

class SettingsList extends StatelessWidget {
  const SettingsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Container(
      height: size.height * .9,
      width: size.width,
      decoration: BoxDecoration(
          color: Get.theme.colorScheme.background,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          )),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // padding: EdgeInsets.zero,
            children: [
              const Gap(8),
              Row(
                children: [
                  context.customClose(),
                  const Gap(32),
                  Text(
                    'setting'.tr,
                    style: TextStyle(
                        color: Get.isDarkMode
                            ? Colors.white
                            : Get.theme.colorScheme.primary,
                        fontFamily: 'kufi',
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ],
              ),
              const Gap(32),
              const LanguageList(),
              const Gap(16),
              const ThemeChange(),
            ],
          ),
        ),
      ),
    );
  }
}
