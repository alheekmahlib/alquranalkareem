part of '../events.dart';

class DaysName extends StatelessWidget {
  DaysName({super.key});

  final eventCtrl = EventController.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Get.theme.colorScheme.primary.withOpacity(.1),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          7,
          (index) => Expanded(
            flex: 2,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                eventCtrl.getWeekdayName(index).tr,
                style: TextStyle(
                  fontFamily: 'kufi',
                  fontSize: 16,
                  color: Theme.of(context).textTheme.bodyLarge!.color,
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
