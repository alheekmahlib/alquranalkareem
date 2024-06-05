import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/svg_extensions.dart';
import '/core/widgets/select_screen_build.dart';
import '/presentation/controllers/general_controller.dart';
import '/presentation/controllers/quran_controller.dart';
import '/presentation/controllers/theme_controller.dart';
import '../../presentation/screens/about_app/about_app.dart';
import '../../presentation/screens/ourApp/ourApps_screen.dart';
import '../utils/constants/extensions/extensions.dart';
import '../utils/constants/svg_constants.dart';
import 'language_list.dart';
import 'mushaf_settings.dart';
import 'select_screen.dart';
import 'theme_change.dart';

class SettingsList extends StatelessWidget {
  SettingsList({Key? key}) : super(key: key);
  final generalCtrl = GeneralController.instance;
  final quranCtrl = QuranController.instance;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return GetBuilder<ThemeController>(builder: (_) {
      return Container(
        height: size.height * .9,
        width: size.width,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            )),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Obx(() => generalCtrl.showSelectScreenPage.value
                ? const SelectScreenBuild(
                    isButtonBack: true,
                    isButton: false,
                  )
                : Column(
                    children: [
                      Row(
                        children: [
                          context.customClose(),
                          const Gap(32),
                          Text(
                            'setting'.tr,
                            style: TextStyle(
                                color: Theme.of(context).hintColor,
                                fontFamily: 'kufi',
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ],
                      ),
                      const Gap(8),
                      Flexible(
                        child: ListView(
                          children: [
                            const Gap(32),
                            const LanguageList(),
                            const Gap(24),
                            const ThemeChange(),
                            const Gap(24),
                            const SelectScreen(),
                            const Gap(24),
                            const MushafSettings(),
                            const Gap(24),
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color:
                                          Theme.of(context).colorScheme.surface,
                                      width: 1),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8))),
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary
                                            .withOpacity(.2),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(8))),
                                    child: InkWell(
                                      child: SizedBox(
                                        height: 45,
                                        child: Row(
                                          children: [
                                            Expanded(
                                                flex: 2,
                                                child: customSvgWithColor(
                                                    SvgPath.svgAlheekmahLogo,
                                                    width: 60.0,
                                                    color: Get.theme.colorScheme
                                                        .primary)),
                                            context.vDivider(height: 20.0),
                                            Expanded(
                                              flex: 8,
                                              child: Text(
                                                'ourApps'.tr,
                                                style: TextStyle(
                                                  fontFamily: 'kufi',
                                                  fontSize: 16,
                                                  color: Theme.of(context)
                                                      .hintColor,
                                                ),
                                              ),
                                            ),
                                            const Spacer(),
                                            Expanded(
                                              flex: 1,
                                              child: Icon(
                                                Icons
                                                    .arrow_forward_ios_outlined,
                                                color:
                                                    Theme.of(context).hintColor,
                                                size: 18,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      onTap: () {
                                        Get.to(() => const OurApps(),
                                            transition: Transition.downToUp);
                                      },
                                    ),
                                  ),
                                  const Gap(8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary
                                            .withOpacity(.2),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(8))),
                                    child: InkWell(
                                      child: SizedBox(
                                        height: 45,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: customSvg(
                                                SvgPath.svgSplashIcon,
                                                height: 35,
                                              ),
                                            ),
                                            context.vDivider(height: 20.0),
                                            Expanded(
                                              flex: 8,
                                              child: Text(
                                                'aboutApp'.tr,
                                                style: TextStyle(
                                                  fontFamily: 'kufi',
                                                  fontSize: 16,
                                                  color: Theme.of(context)
                                                      .hintColor,
                                                ),
                                              ),
                                            ),
                                            const Spacer(),
                                            Expanded(
                                              flex: 1,
                                              child: Icon(
                                                Icons
                                                    .arrow_forward_ios_outlined,
                                                color:
                                                    Theme.of(context).hintColor,
                                                size: 18,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      onTap: () {
                                        Get.to(() => const AboutApp(),
                                            transition: Transition.downToUp);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
          ),
        ),
      );
    });
  }
}
