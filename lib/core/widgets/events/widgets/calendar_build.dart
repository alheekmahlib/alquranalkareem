part of '../events.dart';

class CalendarBuild extends StatelessWidget {
  final int firstDayWeekday;
  final int daysInMonth;
  final HijriCalendar month;
  CalendarBuild(
      {super.key,
      required this.firstDayWeekday,
      required this.daysInMonth,
      required this.month});

  final eventCtrl = EventController.instance;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
      physics: const ClampingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1.5,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: 42,
      itemBuilder: (context, index) {
        final dayOffset = index - firstDayWeekday + 1;
        if (dayOffset < 1 || dayOffset > daysInMonth) {
          return const SizedBox();
        }

        final isCurrentDay = eventCtrl.isCurrentDay(month, dayOffset).value;

        List<int> myMonths = [month.hMonth];
        return GestureDetector(
          onTap: eventCtrl.isEvent(myMonths, dayOffset).value
              ? () => eventCtrl.showEvent(dayOffset, month.hMonth)
              : null,
          child: Container(
            decoration: BoxDecoration(
              color: eventCtrl.getDayColor(isCurrentDay, myMonths, dayOffset),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).colorScheme.surface,
                width: 1,
              ),
            ),
            child: Center(
              child: Text(
                dayOffset.toString().convertNumbers(),
                style: TextStyle(
                  fontFamily: 'kufi',
                  fontSize: 16,
                  height: 2,
                  color: isCurrentDay
                      ? Theme.of(context).colorScheme.primaryContainer
                      : Theme.of(context).textTheme.bodyLarge!.color,
                  fontWeight:
                      isCurrentDay ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
