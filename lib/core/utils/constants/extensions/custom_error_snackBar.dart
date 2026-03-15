import 'package:alquranalkareem/core/utils/constants/extensions/svg_extensions.dart';
import 'package:alquranalkareem/core/utils/constants/svg_constants.dart';
import 'package:alquranalkareem/core/utils/helpers/app_text_styles.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:flutter/material.dart';

extension CustomErrorSnackBarExtension on BuildContext {
  void showCustomErrorSnackBar(String text, {bool? isDone = false}) {
    final backgroundColor = Theme.of(this).colorScheme.primaryContainer;
    DelightToastBar(
      autoDismiss: true,
      snackbarDuration: const Duration(seconds: 2),
      builder: (context) => ToastCard(
        color: backgroundColor,
        leading: const SizedBox().customSvgWithColor(
          isDone! ? SvgPath.svgCheckMark : SvgPath.svgAlert,
          height: 25,
          color: isDone ? Colors.green : Theme.of(this).colorScheme.surface,
        ),
        title: Text(text, style: AppTextStyles.titleMedium()),
      ),
    ).show(this);
  }
}
