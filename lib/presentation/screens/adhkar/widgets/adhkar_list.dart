import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';

import '/core/widgets/container_button.dart';
import '../controller/adhkar_controller.dart';
import '../screens/adhkar_item.dart';

class AdhkarList extends StatelessWidget {
  AdhkarList({super.key});

  final azkarCtrl = AzkarController.instance;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AnimationLimiter(
        child: Obx(() {
          return ListView.builder(
            controller: azkarCtrl.state.listController,
            itemCount: azkarCtrl.state.categories.length,
            padding: EdgeInsets.zero,
            itemBuilder: (BuildContext context, int index) {
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 450),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: ContainerButton(
                      onPressed: () {
                        azkarCtrl.filterByCategory(
                          azkarCtrl.state.categories[index],
                        );
                        Get.to(
                          () => const AdhkarItem(),
                          transition: Transition.leftToRight,
                        );
                        log('filterByCategory: $index');
                      },
                      value: true.obs,
                      width: Get.width,
                      withArrow: true,
                      verticalPadding: 12.0,
                      horizontalPadding: 8.0,
                      verticalMargin: 4.0,
                      horizontalMargin: 16.0,
                      selectedValueMargin: 0.0,
                      backgroundColor: context.theme.primaryColorLight
                          .withValues(alpha: .2),
                      title: azkarCtrl.state.categories[index].toString(),
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
