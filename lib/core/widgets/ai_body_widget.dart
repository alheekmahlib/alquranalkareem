import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../presentation/screens/ai_search/ai_search.dart';
import '../utils/constants/extensions/bottom_sheet_extension.dart';
import '../utils/constants/svg_constants.dart';
import 'custom_button.dart';

class AiBodyWidget extends StatelessWidget {
  AiBodyWidget({super.key});

  final ctrl = AiSearchController.instance;

  @override
  Widget build(BuildContext context) {
    // اضبط وضع المساعد في AiSearchController ليقرأه AssistantView.
    ctrl.state.midasMode.value = MidasMode.assistant;
    return Container(
      height: Get.height,
      width: Get.width,
      color: context.theme.colorScheme.primaryContainer,
      child: SafeArea(
        child: Column(
          children: [
            const Gap(16),
            // واجهة المساعد الموحَّد (المحادثة + مؤشر التفكير + أزرار النسخ).
            Expanded(
              child: UnifiedAssistantView(
                isInMidad: false,
                iconColor: context.theme.primaryColorLight,
                textColor: context.theme.colorScheme.inversePrimary,
              ),
            ),
            // شريط اختيار النموذج (ModelSelectorWidget من ai_search).
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  // سجل المحادثة — يظهر في الوضعين (موحّد).
                  CustomButton(
                    // tooltip: 'newChat'.tr,
                    onPressed: () =>
                        customBottomSheet(const ChatHistorySheet()),
                    isCustomSvgColor: true,
                    svgPath: SvgPath.svgHomeHistory,
                    svgColor: context.theme.primaryColorLight,
                  ),
                  ModelSelectorWidget(
                    textColor: context.theme.colorScheme.inversePrimary,
                    backgroundColor: context.theme.primaryColorLight,
                  ),
                  CustomButton(
                    // tooltip: 'newChat'.tr,
                    onPressed: () => ctrl.clearConversation(),
                    isCustomSvgColor: true,
                    svgPath: SvgPath.svgHomeNewChat,
                    svgColor: context.theme.primaryColorLight,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
