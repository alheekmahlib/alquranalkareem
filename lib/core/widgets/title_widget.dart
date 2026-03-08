import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../utils/helpers/app_text_styles.dart';

class TitleWidget extends StatelessWidget {
  final String title;
  final Color? titleColor;
  final Color? containerColor;
  final TextStyle? textStyle;
  const TitleWidget({
    super.key,
    required this.title,
    this.titleColor,
    this.containerColor,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              // height: 10,
              width: 8,
              margin: const EdgeInsets.symmetric(vertical: 4.0),
              decoration: BoxDecoration(
                color: containerColor ?? Theme.of(context).primaryColorLight,
                borderRadius: const BorderRadius.all(Radius.circular(8)),
              ),
            ),
            const Gap(8.0),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: Text(
                  title.tr,
                  style:
                      textStyle ??
                      AppTextStyles.titleMedium(
                        color: titleColor ?? Get.theme.hintColor,
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
