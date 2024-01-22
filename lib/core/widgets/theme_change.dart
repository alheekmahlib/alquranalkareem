import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../presentation/controllers/theme_controller.dart';
import '../services/services_locator.dart';

class ThemeChange extends StatelessWidget {
  const ThemeChange({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeCtrl = sl<ThemeController>();
    return Column(
      children: [
        Obx(() {
          return InkWell(
            child: SizedBox(
              height: 30,
              width: MediaQuery.sizeOf(context).width,
              child: Row(
                children: [
                  Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(2.0)),
                      border:
                          Border.all(color: const Color(0xff91a57d), width: 2),
                      color: const Color(0xff39412a),
                    ),
                    child: themeCtrl.isBlueMode
                        ? const Icon(Icons.done,
                            size: 14, color: Color(0xffF27127))
                        : null,
                  ),
                  const SizedBox(
                    width: 16.0,
                  ),
                  Text(
                    'green'.tr,
                    style: TextStyle(
                      color: themeCtrl.isBlueMode
                          ? const Color(0xffF27127)
                          : const Color(0xffcdba72),
                      fontSize: 14,
                      fontFamily: 'kufi',
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
              themeCtrl.setTheme(AppTheme.blue);
            },
          );
        }),
        Obx(() {
          return InkWell(
            child: SizedBox(
              height: 30,
              width: MediaQuery.sizeOf(context).width,
              child: Row(
                children: [
                  Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(2.0)),
                      border:
                          Border.all(color: const Color(0xffbc6c25), width: 2),
                      color: const Color(0xff814714),
                    ),
                    child: themeCtrl.isBrownMode
                        ? const Icon(Icons.done,
                            size: 14, color: Color(0xffF27127))
                        : null,
                  ),
                  const SizedBox(
                    width: 16.0,
                  ),
                  Text(
                    'brown'.tr,
                    style: TextStyle(
                      color: themeCtrl.isBrownMode
                          ? const Color(0xffF27127)
                          : const Color(0xffcdba72),
                      fontSize: 14,
                      fontFamily: 'kufi',
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
              themeCtrl.setTheme(AppTheme.brown);
            },
          );
        }),
        Obx(() {
          return InkWell(
            child: SizedBox(
              height: 30,
              width: MediaQuery.sizeOf(context).width,
              child: Row(
                children: [
                  Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(2.0)),
                      border:
                          Border.all(color: const Color(0xff4d4d4d), width: 2),
                      color: const Color(0xff2d2d2d),
                    ),
                    child: themeCtrl.isDarkMode
                        ? const Icon(Icons.done,
                            size: 14, color: Color(0xffF27127))
                        : null,
                  ),
                  const SizedBox(
                    width: 16.0,
                  ),
                  Text(
                    'dark'.tr,
                    style: TextStyle(
                      color: themeCtrl.isDarkMode
                          ? const Color(0xffF27127)
                          : const Color(0xffcdba72),
                      fontSize: 14,
                      fontFamily: 'kufi',
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
              themeCtrl.setTheme(AppTheme.dark);
            },
          );
        }),
      ],
    );
  }
}
