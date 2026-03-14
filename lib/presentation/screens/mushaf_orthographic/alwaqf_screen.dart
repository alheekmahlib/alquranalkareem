import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils/constants/svg_constants.dart';
import 'controller/waqf_tajweed_screen_controller.dart';
import 'widgets/animated_segment_control.dart';
import 'widgets/group_buttons_widget.dart';
import 'widgets/tajweed_rules_list.dart';
import 'widgets/waqf_list_build.dart';

class AlwaqfScreen extends StatelessWidget {
  AlwaqfScreen({super.key});

  final screenCtrl = WaqfTajweedScreenController.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // Animated segment control
          Obx(
            () => AnimatedSegmentControl(
              labels: ['stopSigns'.tr, 'tajweedRules'.tr],
              svgIcons: const [SvgPath.svgAlwaqf, SvgPath.svgQuranIcS],
              selectedIndex: screenCtrl.selectedTab.value,
              onChanged: screenCtrl.switchTab,
            ),
          ),

          // Group buttons (visible only in Waqf tab)
          Obx(
            () => AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              child: screenCtrl.selectedTab.value == 0
                  ? GroupButtonsWidget()
                  : const SizedBox.shrink(),
            ),
          ),

          // Content area
          Expanded(
            child: Obx(
              () => IndexedStack(
                index: screenCtrl.selectedTab.value,
                children: [WaqfListBuild(), const TajweedRulesListWidget()],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
