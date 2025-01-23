import 'package:alquranalkareem/core/utils/constants/svg_constants.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

extension CustomErrorSnackBarExtension on BuildContext {
  void showCustomErrorSnackBar(String text, {bool? isDone = false}) {
    final backgroundColor = Theme.of(this).colorScheme.primaryContainer;
    final borderColor =
        Theme.of(this).colorScheme.primary.withValues(alpha: .3);
    final hintColor = Theme.of(this).hintColor;
    BotToast.showCustomNotification(
      enableSlideOff: true,
      useSafeArea: true,
      toastBuilder: (cancelFunc) {
        return Container(
          height: 50,
          decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(8),
              ),
              border: Border.all(
                color: borderColor,
                width: 2,
              )),
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Opacity(
                    opacity: .8,
                    child: SvgPicture.asset(
                      isDone! ? SvgPath.svgCheckMark : SvgPath.svgAlert,
                      height: 25,
                    ),
                  ),
                ),
              ),
              const Gap(16),
              Expanded(
                flex: 8,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      text,
                      style: TextStyle(
                          color: hintColor, fontFamily: 'naskh', fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      duration: const Duration(milliseconds: 3000),
    );
  }
}
