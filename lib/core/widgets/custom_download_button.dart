import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDownloadButton extends StatelessWidget {
  /// حجم الزر (عرض وارتفاع).
  final double size;

  /// نسبة تقدّم التحميل (من 0.0 إلى 1.0).
  final double progress;

  /// هل التحميل جارٍ حالياً.
  final bool isDownloading;

  /// هل اكتمل التحميل.
  final bool isDownloaded;

  /// لون خلفية الحاوية الخارجية.
  final Color? backgroundColor;

  /// لون شريط التقدّم.
  final Color? progressColor;

  /// لون شريط التقدّم بعد اكتمال التحميل.
  final Color? completedColor;

  /// نصف قطر الحوافّ.
  final double borderRadius;

  /// مدة حركة الأنيميشن.
  final Duration animationDuration;

  /// الويدجت الذي يُعرض فوق شريط التقدّم (مثل أيقونة أو زر).
  final Widget child;

  const CustomDownloadButton({
    super.key,
    this.size = 60,
    required this.progress,
    required this.isDownloading,
    required this.isDownloaded,
    this.backgroundColor,
    this.progressColor,
    this.completedColor,
    this.borderRadius = 8,
    this.animationDuration = const Duration(milliseconds: 200),
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    progressColor ?? context.theme.primaryColorLight.withValues(alpha: .3);
    completedColor ?? context.theme.primaryColorLight.withValues(alpha: .1);
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color:
            backgroundColor ?? Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedContainer(
              duration: animationDuration,
              height: isDownloading
                  ? size * progress
                  : isDownloaded
                  ? size
                  : 0,
              width: size,
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: isDownloaded
                    ? (completedColor ?? progressColor)
                    : progressColor,
                borderRadius: BorderRadius.circular(borderRadius),
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}
