part of '../prayers.dart';

class HorizontalProgressBar extends StatelessWidget {
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

  HorizontalProgressBar({
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
              RoundedProgressBar(
                height: 32,
                style: RoundedProgressBarStyle(
                  borderWidth: 0,
                  widthShadow: 5,
                  backgroundProgress: Colors.transparent,
                  colorProgress: progressColor,
                  colorProgressDark: progressColor.withOpacity(.5),
                  colorBorder: Colors.transparent,
                  colorBackgroundIcon: Colors.transparent,
                ),
                // margin: EdgeInsets.symmetric(vertical: 16),
                borderRadius: borderRadius,
                percent: progress,
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
