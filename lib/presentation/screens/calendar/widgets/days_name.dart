part of '../events.dart';

class DaysName extends StatelessWidget {
  DaysName({super.key});

  final eventCtrl = EventController.instance;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          7,
          (index) => Expanded(
            flex: 2,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                eventCtrl.getWeekdayShortName(index).tr,
                style: AppTextStyles.titleMedium().copyWith(
                  color: context.theme.canvasColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
