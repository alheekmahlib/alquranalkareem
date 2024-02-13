import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../presentation/controllers/aya_controller.dart';
import '../../presentation/screens/quran_page/widgets/search/search_bar.dart';
import '../services/services_locator.dart';
import '../utils/constants/svg_picture.dart';
import '/presentation/controllers/general_controller.dart';
import '/presentation/screens/home/home_screen.dart';
import 'settings_list.dart';

class TabBarWidget extends StatelessWidget {
  final bool isChild;
  final bool isIndicator;
  const TabBarWidget(
      {super.key, required this.isChild, required this.isIndicator});

  @override
  Widget build(BuildContext context) {
    final generalCtrl = sl<GeneralController>();
    return Column(
      children: [
        Container(
          height: 25,
          width: MediaQuery.sizeOf(context).width,
          color: Get.theme.colorScheme.primary,
        ),
        Row(
          // mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            isChild
                ? GestureDetector(
                    onTap: () => Get.to(() => const HomeScreen(),
                        transition: Transition.upToDown),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        button_curve(height: 45.0, width: 45.0),
                        Container(
                            padding: const EdgeInsets.all(4),
                            margin: const EdgeInsets.only(bottom: 5),
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(4)),
                                border: Border.all(
                                    width: 1,
                                    color: Get.theme.colorScheme.onSecondary)),
                            child: home(height: 25.0, width: 25.0)),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
            isIndicator
                ? OpenContainerWrapper(
                    transitionType: sl<AyaController>().transitionType,
                    closedBuilder:
                        (BuildContext _, VoidCallback openContainer) {
                      return SearchBarWidget(openContainer: openContainer);
                    },
                  )
                // Container(
                //         height: 40,
                //         width: MediaQuery.sizeOf(context).width * .67,
                //         // margin: const EdgeInsets.only(bottom: 6.0),
                //         decoration: BoxDecoration(
                //           color: Theme.of(context).colorScheme.primary,
                //           borderRadius: const BorderRadius.all(Radius.circular(8)),
                //         ),
                //       )
                : const SizedBox.shrink(),
            GestureDetector(
              onTap: () {
                Get.bottomSheet(const SettingsList(), isScrollControlled: true);
                generalCtrl.showSelectScreenPage.value = false;
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  button_curve(height: 45.0, width: 45.0),
                  Container(
                      padding: const EdgeInsets.all(4),
                      margin: const EdgeInsets.only(bottom: 5),
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4)),
                          border: Border.all(
                              width: 1,
                              color: Get.theme.colorScheme.onSecondary)),
                      child: options(height: 25.0, width: 25.0)),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}
