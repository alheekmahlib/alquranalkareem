import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils/constants/svg_constants.dart';
import '../../../core/widgets/app_bar_widget.dart';
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
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      appBar: AppBarWidget(
        isTitled: true,
        title: 'mushafOrthographicMarks'.tr,
        isFontSize: true,
        searchButton: const SizedBox.shrink(),
        isNotifi: false,
        isBooks: false,
      ),
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
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
        ),
      ),
    );
  }
}
