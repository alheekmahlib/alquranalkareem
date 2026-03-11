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
            children: [
              SlidingBox(
                collapsed: false,
                style: BoxStyle.none,
                minHeight: 65.0,
                maxHeight: Get.height * .63,
                draggableIconVisible: false,
                color: Colors.transparent,
                animationCurve: Curves.easeInOut,
                physics: const NeverScrollableScrollPhysics(),
                controller: eventCtrl.boxController.value,
                animationDuration: const Duration(milliseconds: 250),
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                onBoxSlide: (_) => eventCtrl.update(['slider_changed']),
                backdrop: Backdrop(
                  fading: false,
                  overlay: false,
                  body: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: GetBuilder<EventController>(
                      id: 'slider_changed',
                      builder: (eventCtrl) => Column(
                        children: [
                          if (eventCtrl.boxController.value.isAttached &&
                              eventCtrl.boxController.value.isBoxOpen) ...[
                            const Gap(180),
                            HijriWidget(isInCalendar: true),
                          ],
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: [
                          //     YearSelection(),
                          //     const Gap(8),
                          //     MonthSelection(),
                          //   ],
                          // ),
                          // const Gap(16),
                          if (!eventCtrl.boxController.value.isAttached ||
                              eventCtrl.boxController.value.isBoxClosed) ...[
                            const Gap(16.0),
                            Expanded(
                              child: PageView.builder(
                                padEnds: true,
                                scrollDirection: Axis.vertical,
                                controller: eventCtrl.pageController,
                                onPageChanged: eventCtrl.onMonthChanged,
                                physics: const ClampingScrollPhysics(),
                                itemCount: 12,
                                itemBuilder: (context, monthIndex) {
                                  eventCtrl.calenderMonth.value =
                                      eventCtrl.months[monthIndex];
                                  final daysInMonth = eventCtrl.getDaysInMonth(
                                    eventCtrl.calenderMonth.value,
                                    eventCtrl.calenderMonth.value.hYear,
                                    eventCtrl.calenderMonth.value.hMonth,
                                  );
                                  final firstDayWeekday = eventCtrl
                                      .calculateFirstDayOfMonth(
                                        eventCtrl.calenderMonth.value.hMonth,
                                        eventCtrl.calenderMonth.value.hYear,
                                      );
                                  return SizedBox(
                                    height: 320,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              customSvgWithColor(
                                                'assets/svg/hijri/${eventCtrl.calenderMonth.value.hMonth}.svg',
                                                color:
                                                    context.theme.canvasColor,
                                                height: 40,
                                              ),
                                              Text(
                                                eventCtrl
                                                    .calenderMonth
                                                    .value
                                                    .hYear
                                                    .toString()
                                                    .convertNumbersToCurrentLang(),
                                                style:
                                                    AppTextStyles.titleLarge()
                                                        .copyWith(
                                                          color: context
                                                              .theme
                                                              .canvasColor,
                                                        ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        DaysName(),
                                        const Gap(8),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0,
                                          ),
                                          child: CalendarBuild(
                                            daysInMonth: daysInMonth,
                                            firstDayWeekday: firstDayWeekday,
                                            month:
                                                eventCtrl.calenderMonth.value,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
                body: Align(
                  alignment: AlignmentDirectional.bottomEnd,
                  child: Column(
                    children: [
                      Container(
                        height: 8,
                        width: Get.width,
                        margin: const EdgeInsets.symmetric(horizontal: 62.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: context.theme.primaryColorLight,
                        ),
                      ),
                      const Gap(8.0),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16.0),
                        decoration: BoxDecoration(
                          color: Get.theme.colorScheme.primaryContainer,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                        ),
                        child: AllCalculatingEventsWidget(),
                      ),
                    ],
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
}
