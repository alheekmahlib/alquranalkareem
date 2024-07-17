import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/svg_extensions.dart';
import '/core/utils/constants/svg_constants.dart';
import '/presentation/controllers/general_controller.dart';
import '/presentation/screens/home/home_screen.dart';
import '../../presentation/screens/quran_page/controllers/quran/quran_controller.dart';
import '../services/services_locator.dart';
import 'settings_list.dart';

class TabBarWidget extends StatelessWidget {
  final bool isFirstChild;
  final bool isCenterChild;
  final Widget? centerChild;
  final bool? isQuranSetting;
  const TabBarWidget(
      {super.key,
      required this.isFirstChild,
      required this.isCenterChild,
      this.centerChild,
      this.isQuranSetting});

  @override
  Widget build(BuildContext context) {
    final generalCtrl = GeneralController.instance;
    return Column(
      children: [
        Container(
          height: 15,
          width: MediaQuery.sizeOf(context).width,
          color: Theme.of(context).colorScheme.primary,
        ),
        Transform.translate(
          offset: const Offset(0, -1),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: isFirstChild
                    ? GestureDetector(
                        onTap: () {
                          Get.offAll(() => const HomeScreen(),
                              transition: Transition.upToDown);
                          sl<QuranController>()
                              .state
                              .selectedAyahIndexes
                              .clear();
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            customSvgWithColor(SvgPath.svgButtonCurve,
                                height: 45.0,
                                width: 45.0,
                                color: Get.theme.colorScheme.primary),
                            Container(
                                padding: const EdgeInsets.all(4),
                                margin: const EdgeInsets.only(bottom: 5),
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(4)),
                                    border: Border.all(
                                        width: 1,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surface)),
                                child: customSvgWithColor(SvgPath.svgHome,
                                    height: 25.0,
                                    width: 25.0,
                                    color: Get.theme.colorScheme.secondary)),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
              Expanded(
                  flex: 7,
                  child:
                      isCenterChild ? centerChild! : const SizedBox.shrink()),
              Expanded(
                flex: 2,
                child: GestureDetector(
                  onTap: () {
                    Get.bottomSheet(
                      SettingsList(
                        isQuranSetting: isQuranSetting,
                      ),
                      isScrollControlled: true,
                    );
                    generalCtrl.showSelectScreenPage.value = false;
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      customSvgWithColor(SvgPath.svgButtonCurve,
                          height: 45.0,
                          width: 45.0,
                          color: Get.theme.colorScheme.primary),
                      Container(
                          padding: const EdgeInsets.all(4),
                          margin: const EdgeInsets.only(bottom: 5),
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4)),
                              border: Border.all(
                                  width: 1,
                                  color:
                                      Theme.of(context).colorScheme.surface)),
                          child: customSvgWithColor(SvgPath.svgOptions,
                              height: 25.0,
                              width: 25.0,
                              color: Get.theme.colorScheme.secondary)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
