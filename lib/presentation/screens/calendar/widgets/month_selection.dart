part of '../events.dart';

class MonthSelection extends StatelessWidget {
  MonthSelection({super.key});

  final eventCtrl = EventController.instance;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EventController>(
      builder: (eventCtrl) => Expanded(
        flex: 4,
        child: Container(
          width: Get.width * .45,
          // margin: const EdgeInsets.symmetric(horizontal: 16.0),
          decoration: BoxDecoration(
            color: Get.theme.colorScheme.surface.withValues(alpha: .2),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_left,
                    size: 30,
                    color: Theme.of(context).hintColor,
                  ),
                  onPressed: () {
                    if (eventCtrl.pageController.page! > 0) {
                      eventCtrl.pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                ),
              ),
              Expanded(
                flex: 6,
                child: Center(
                  child: CustomDropdown<HijriCalendarConfig>(
                    excludeSelected: false,
                    decoration: CustomDropdownDecoration(
                      closedFillColor:
                          Theme.of(context).colorScheme.primaryContainer,
                      expandedFillColor:
                          Theme.of(context).colorScheme.primaryContainer,
                      closedBorderRadius:
                          const BorderRadius.all(Radius.circular(8)),
                    ),
                    closedHeaderPadding: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 8.0),
                    itemsListPadding:
                        const EdgeInsets.symmetric(horizontal: 4.0),
                    listItemPadding:
                        const EdgeInsets.symmetric(horizontal: 8.0),
                    hintBuilder: (context, _, select) => FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        eventCtrl.calenderMonth.value.getLongMonthName().tr,
                        style: TextStyle(
                          color: Get.theme.colorScheme.inversePrimary,
                          fontSize: 16,
                          fontFamily: 'kufi',
                        ),
                      ),
                    ),
                    maxlines: 1,
                    items: List.generate(12, (index) {
                      var hijri = HijriCalendarConfig();
                      hijri.hYear = eventCtrl.selectedDate.hYear;
                      hijri.hMonth = index + 1;
                      hijri.hDay = 1;
                      return hijri;
                    }),
                    listItemBuilder: (context, months, select, _) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        color: months.getLongMonthName().tr ==
                                eventCtrl.hijriNow.getLongMonthName().tr
                            ? Get.theme.colorScheme.surface
                                .withValues(alpha: .2)
                            : eventCtrl.selectedDate.getLongMonthName().tr ==
                                    months.getLongMonthName().tr
                                ? Get.theme.colorScheme.primary
                                    .withValues(alpha: .2)
                                : Colors.transparent,
                      ),
                      child: SizedBox(
                        width: 80,
                        child: Text(
                          months.getLongMonthName().tr,
                          style: TextStyle(
                            color: Get.theme.colorScheme.inversePrimary,
                            fontSize: 16,
                            fontFamily: 'naskh',
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    headerBuilder: (context, calendar, bool) => FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        eventCtrl.calenderMonth.value.getLongMonthName().tr,
                        style: TextStyle(
                          color: Get.theme.colorScheme.inversePrimary,
                          fontSize: 16,
                          fontFamily: 'kufi',
                        ),
                      ),
                    ),
                    initialItem: null,
                    onChanged: (value) {
                      log('changing value to: $value');
                      eventCtrl.pageController.animateToPage(
                        value!.hMonth - 1,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                      eventCtrl.calenderMonth.value = value;
                    },
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_right,
                    size: 30,
                    color: Theme.of(context).hintColor,
                  ),
                  onPressed: () {
                    if (eventCtrl.pageController.page! < 11) {
                      eventCtrl.pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
