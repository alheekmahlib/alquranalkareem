import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/adhan/adhan_controller.dart';
import '../controller/adhan/extensions/adhan_getters.dart';

class VerticalProgressBar extends StatelessWidget {
  final double progress;
  final Color backgroundColor;
  final Color progressColor;
  final double borderWidth;
  final double widthShadow;
  final BorderRadius borderRadius;
  final List<DateTime> stepTimes;
  final List<IconData> stepIcons;
  final DateTime startTime;
  final DateTime endTime;

  VerticalProgressBar({
    required this.progress,
    required this.backgroundColor,
    required this.progressColor,
    required this.borderWidth,
    required this.widthShadow,
    required this.borderRadius,
    required this.stepTimes,
    required this.stepIcons,
    required this.startTime,
    required this.endTime,
  });

  final adhanCtrl = AdhanController.instance;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        height: 40,
        // width: 320,
        padding: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: borderRadius,
        ),
        child: SizedBox(
          height: 40,
          width: Get.width,
          child: Stack(
            alignment: AlignmentDirectional.centerStart,
            children: [
              Container(
                height: double.infinity,
                padding: const EdgeInsetsDirectional.only(end: 8.0),
                decoration: BoxDecoration(
                  color: progressColor.withOpacity(.5),
                  borderRadius: borderRadius,
                ),
                child: Container(
                  width: (300 * progress) / 100,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: progressColor,
                    borderRadius: borderRadius,
                  ),
                ),
              ),
              ...List.generate(stepIcons.length, (index) {
                final stepTime = stepTimes[index];
                final totalDuration = endTime.difference(startTime).inSeconds;
                final stepPosition =
                    (stepTime.difference(startTime).inSeconds / totalDuration) *
                        300;

                return Positioned(
                  right: stepPosition,
                  child: Transform.translate(
                    offset: const Offset(-15, 0),
                    child: Icon(
                      stepIcons[index],
                      color: adhanCtrl.getCurrentSelectedPrayer(index).value
                          ? Theme.of(context).canvasColor
                          : Theme.of(context).canvasColor.withOpacity(.5),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
