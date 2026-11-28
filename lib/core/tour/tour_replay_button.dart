import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/constants/svg_constants.dart';
import '../widgets/custom_button.dart';

/// زر إعادة جولة الشاشات المتداخلة (زر الاستفهام العائم): صفحة الكتاب
/// والقارئ وشاشة قسم الأذكار، فتحتاج كتاباً أو قسماً يختاره المستخدم ولا
/// تُفتح من الإعدادات. جولات الأقسام الأخرى تُعاد من الإعدادات. في الشاشات
/// ذات شريط سفلي (كقارئ المكتبة) يرتفع الزر فوقه بتمرير [bottom].
class TourReplayButton extends StatelessWidget {
  const TourReplayButton({super.key, required this.onPressed, this.bottom});

  final VoidCallback onPressed;

  /// المسافة بين الزر وحافة الشاشة السفلى.
  final double? bottom;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.bottomEnd,
      child: Padding(
        padding: EdgeInsets.only(bottom: bottom ?? 16.0, right: 8.0, left: 8.0),
        child: CustomButton(
          height: 50,
          width: 50,
          backgroundColor: context.theme.colorScheme.surface,
          isCustomSvgColor: true,
          svgPath: SvgPath.svgHomeCommentQuestion,
          svgColor: context.theme.canvasColor,
          onPressed: onPressed,
        ),
      ),
    );
  }
}
