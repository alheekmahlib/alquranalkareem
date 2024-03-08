import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/services_locator.dart';
import '../utils/constants/svg_picture.dart';
import '/presentation/controllers/general_controller.dart';
import '/presentation/screens/home/home_screen.dart';
import 'settings_list.dart';

class TabBarWidget extends StatelessWidget {
  final bool isFirstChild;
  final bool isCenterChild;
  final Widget? centerChild;
  const TabBarWidget(
      {super.key,
      required this.isFirstChild,
      required this.isCenterChild,
      this.centerChild});

  @override
  Widget build(BuildContext context) {
    final generalCtrl = sl<GeneralController>();
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
                        onTap: () => Get.offAll(() => const HomeScreen(),
                            transition: Transition.upToDown),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            button_curve(height: 45.0, width: 45.0),
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
                                child: home(height: 25.0, width: 25.0)),
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
                      SettingsList(),
                      isScrollControlled: true,
                    );
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
                                  color:
                                      Theme.of(context).colorScheme.surface)),
                          child: options(height: 25.0, width: 25.0)),
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
