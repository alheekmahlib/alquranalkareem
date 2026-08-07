import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/svg_extensions.dart';
import '/core/utils/constants/svg_constants.dart';
import '/core/utils/helpers/app_text_styles.dart';
import '/presentation/screens/ai_search/ai_search.dart';

class MidadWidget extends StatelessWidget {
  const MidadWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: GestureDetector(
        onTap: () => Get.to(
          () => AiSearchResults(),
          transition: Transition.fadeIn,
        ),
        child: Row(
          children: [
            const Gap(16),
            Container(
              width: 8,
              decoration: BoxDecoration(
                color: context.theme.primaryColorLight,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const Gap(8),
            // Leading Midad icon
            customSvgWithCustomColor(
              SvgPath.svgHomeMidadIcon,
              height: 32,
              width: 22,
              color: context.theme.primaryColorLight,
            ),
            Expanded(
              child: Container(
                width: Get.width,
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                decoration: BoxDecoration(
                  color: context.theme.primaryColorLight.withValues(alpha: .1),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  crossAxisAlignment: .center,
                  children: [
                    Container(
                      height: 40,
                      width: Get.width,
                      margin: const EdgeInsets.symmetric(vertical: 4.0),
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      decoration: BoxDecoration(
                        color: context.theme.colorScheme.surface.withValues(
                          alpha: .3,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        children: [
                          // Placeholder text
                          Expanded(
                            child: Text(
                              'askMidad'.tr,
                              style: AppTextStyles.titleSmall(
                                color: context.theme.colorScheme.inversePrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'midadWelcome'.tr,
                      style: AppTextStyles.titleSmall(
                        color: context.theme.colorScheme.inversePrimary,
                      ),
                      textAlign: .center,
                      maxLines: 1,
                      // overflow: TextOverflow.ellipsis,
                    ),
                    const Gap(6),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
