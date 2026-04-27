import 'package:alquranalkareem/core/utils/helpers/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../utils/constants/extensions/alignment_rotated_extension.dart';
import '../utils/constants/extensions/svg_extensions.dart';

class ButtomWithLine extends StatelessWidget {
  final String svgPath;
  final Function() onTap;
  final bool isRtl;
  final String? title;
  const ButtomWithLine({
    super.key,
    required this.svgPath,
    required this.onTap,
    this.isRtl = false,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: IntrinsicHeight(
        child: Row(
          textDirection: isRtl
              ? alignmentLayout(TextDirection.rtl, TextDirection.ltr)
              : alignmentLayout(TextDirection.ltr, TextDirection.rtl),
          children: [
            Container(
              width: 8,
              decoration: BoxDecoration(
                color: context.theme.primaryColorLight,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const Gap(8),
            Container(
              height: 70,
              width: 70,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: context.theme.primaryColorLight.withValues(alpha: 0.5),
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              ),
              child: Get.locale!.languageCode == 'ar'
                  ? customSvg(svgPath, height: 80, width: 80)
                  : Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          title?.tr.replaceAll(' ', '\n') ?? '',
                          style: AppTextStyles.titleMedium(
                            color: context.theme.canvasColor,
                            fontSize: 20,
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
