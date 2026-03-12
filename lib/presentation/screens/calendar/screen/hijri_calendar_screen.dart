part of '../events.dart';

class HijriCalendarScreen extends StatelessWidget {
  HijriCalendarScreen({super.key});

  final eventsCtrl = EventController.instance;

  @override
  Widget build(BuildContext context) {
    eventsCtrl.resetDate();
    return GetBuilder<EventController>(
      builder: (eventCtrl) => Scaffold(
        backgroundColor: Get.theme.colorScheme.primary,
        body: SafeArea(
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              context.customOrientation(
                const SizedBox.shrink(),
                _pageViewBuild(eventCtrl),
              ),
              ValueListenableBuilder(
                valueListenable: eventCtrl.controller,
                builder: (context, offset, child) {
                  final isSheetOpen =
                      offset != null && offset > Get.height * .5;
                  return Column(
                    children: [
                      if (isSheetOpen) ...[
                        const Gap(80),
                        context.customOrientation(
                          HijriWidget(isInCalendar: true),
                          const SizedBox.shrink(),
                        ),
                      ],
                      if (!isSheetOpen) ...[
                        const Gap(16.0),
                        context.customOrientation(
                          _pageViewBuild(eventCtrl),
                          const SizedBox.shrink(),
                        ),
                      ],
                    ],
                  );
                },
              ),
              context.customOrientation(
                CustomSheetWidget(
                  controller: eventCtrl.controller,
                  minSheetOffset: 0.2,
                  maxSheetOffset: 0.65,
                  child: AllCalculatingEventsWidget(),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    height: Get.height,
                    width: Get.width * .5,
                    decoration: BoxDecoration(
                      color: context.theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: AllCalculatingEventsWidget(),
                  ),
                ),
              ),
              TopBarWidget(
                isHomeChild: true,
                isQuranSetting: false,
                isNotification: false,
                isCalendarSetting: true,
                squareColor: context.theme.primaryColorLight,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pageViewBuild(EventController eventCtrl) {
    return Align(
      alignment: Get.context!.customOrientation(
        Alignment.center,
        Alignment.centerLeft,
      ),
      child: SizedBox(
        height: Get.height * .8,
        width: Get.context!.customOrientation(Get.width, Get.width * .4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Get.context!.customOrientation(
              const SizedBox.shrink(),
              const Gap(80),
            ),
            Expanded(
              child: PageView.builder(
                padEnds: true,
                scrollDirection: Axis.vertical,
                controller: eventCtrl.pageController,
                onPageChanged: eventCtrl.onMonthChanged,
                physics: const ClampingScrollPhysics(),
                itemCount: 12,
                itemBuilder: (context, monthIndex) {
                  eventCtrl.calenderMonth.value = eventCtrl.months[monthIndex];
                  final daysInMonth = eventCtrl.getDaysInMonth(
                    eventCtrl.calenderMonth.value,
                    eventCtrl.calenderMonth.value.hYear,
                    eventCtrl.calenderMonth.value.hMonth,
                  );
                  final firstDayWeekday = eventCtrl.calculateFirstDayOfMonth(
                    eventCtrl.calenderMonth.value.hMonth,
                    eventCtrl.calenderMonth.value.hYear,
                  );
                  return Opacity(
                    opacity:
                        monthIndex == eventCtrl.pageController.page?.round()
                        ? 1.0
                        : 0.5,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              customSvgWithColor(
                                'assets/svg/hijri/${eventCtrl.calenderMonth.value.hMonth}.svg',
                                color: context.theme.canvasColor,
                                height: 40,
                              ),
                              Text(
                                eventCtrl.calenderMonth.value.hYear
                                    .toString()
                                    .convertNumbersToCurrentLang(),
                                style: AppTextStyles.titleLarge().copyWith(
                                  color: context.theme.canvasColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        DaysName(),
                        const Gap(8),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: CalendarBuild(
                              daysInMonth: daysInMonth,
                              firstDayWeekday: firstDayWeekday,
                              month: eventCtrl.calenderMonth.value,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
